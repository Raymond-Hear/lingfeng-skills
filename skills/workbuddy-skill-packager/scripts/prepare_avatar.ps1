[CmdletBinding()]
param(
    [Parameter(Mandatory)] [string]$InputPath,
    [Parameter(Mandatory)] [string]$OutputDirectory,
    [ValidateSet('Fit', 'Crop')] [string]$Mode = 'Fit',
    [ValidateRange(1, 10000000)] [int]$MaxBytes = 500000,
    [switch]$KeepTransparency
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$source = Get-Item -LiteralPath $InputPath
if ($source.PSIsContainer) { throw '请选择一个图片文件。' }
$size = 512
$orientationOperations = @{
    2 = 'RotateNoneFlipX'
    3 = 'Rotate180FlipNone'
    4 = 'Rotate180FlipX'
    5 = 'Rotate90FlipX'
    6 = 'Rotate90FlipNone'
    7 = 'Rotate270FlipX'
    8 = 'Rotate270FlipNone'
}
$image = [System.Drawing.Image]::FromFile($source.FullName, $true)
$canvas = [System.Drawing.Bitmap]::new($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$graphics = [System.Drawing.Graphics]::FromImage($canvas)
$attributes = [System.Drawing.Imaging.ImageAttributes]::new()
$stream = [IO.MemoryStream]::new()

try {
    if ($image.PropertyIdList -contains 274) {
        $orientation = $image.GetPropertyItem(274).Value
        if ($orientation.Length -ge 2) {
            $rotation = $orientationOperations[[int][BitConverter]::ToUInt16($orientation, 0)]
            if ($rotation) { $image.RotateFlip([System.Drawing.RotateFlipType]$rotation) }
        }
    }
    $graphics.Clear([System.Drawing.Color]::Transparent)
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $attributes.SetWrapMode([System.Drawing.Drawing2D.WrapMode]::TileFlipXY)

    $x = 0
    $y = 0
    $width = $image.Width
    $height = $image.Height
    if ($Mode -eq 'Crop') {
        $side = [Math]::Min($width, $height)
        $x = [int][Math]::Floor(($width - $side) / 2)
        $y = [int][Math]::Floor(($height - $side) / 2)
        $width = $side
        $height = $side
        $destination = [System.Drawing.Rectangle]::new(0, 0, $size, $size)
    } else {
        $scale = $size / [Math]::Max($width, $height)
        $scaledWidth = [Math]::Max(1, [int][Math]::Round($width * $scale))
        $scaledHeight = [Math]::Max(1, [int][Math]::Round($height * $scale))
        $left = [int][Math]::Floor(($size - $scaledWidth) / 2)
        $top = [int][Math]::Floor(($size - $scaledHeight) / 2)
        $destination = [System.Drawing.Rectangle]::new($left, $top, $scaledWidth, $scaledHeight)
    }
    $graphics.DrawImage($image, $destination, $x, $y, $width, $height, [System.Drawing.GraphicsUnit]::Pixel, $attributes)
    $graphics.Flush()

    $extension = 'png'
    $whiteBackground = $false
    $canvas.Save($stream, [System.Drawing.Imaging.ImageFormat]::Png)
    if ($stream.Length -gt $MaxBytes) {
        if ($KeepTransparency) { throw 'PNG 超过指定大小。请使用保留透明度的 PNG 压缩工具后重新检查。' }
        $extension = 'jpg'
        $whiteBackground = $true
        $jpeg = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object MimeType -eq 'image/jpeg'
        $flattened = [System.Drawing.Bitmap]::new($size, $size, [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
        $flatGraphics = [System.Drawing.Graphics]::FromImage($flattened)
        $encoder = [System.Drawing.Imaging.EncoderParameters]::new(1)
        try {
            $flatGraphics.Clear([System.Drawing.Color]::White)
            $flatGraphics.DrawImageUnscaled($canvas, 0, 0)
            $flatGraphics.Flush()
            foreach ($quality in @(94, 88, 80, 70, 60, 45, 30, 15, 5)) {
                $stream.SetLength(0)
                $stream.Position = 0
                $parameter = [System.Drawing.Imaging.EncoderParameter]::new([System.Drawing.Imaging.Encoder]::Quality, [long]$quality)
                try {
                    $encoder.Param[0] = $parameter
                    $flattened.Save($stream, $jpeg, $encoder)
                } finally {
                    $parameter.Dispose()
                }
                if ($stream.Length -le $MaxBytes) { break }
            }
        } finally {
            $encoder.Dispose()
            $flatGraphics.Dispose()
            $flattened.Dispose()
        }
    }
    if ($stream.Length -gt $MaxBytes) { throw '图片无法压缩至指定大小。' }

    $stream.Position = 0
    $result = [System.Drawing.Image]::FromStream($stream, $false, $true)
    try {
        $expectedFormat = if ($extension -eq 'png') { [System.Drawing.Imaging.ImageFormat]::Png } else { [System.Drawing.Imaging.ImageFormat]::Jpeg }
        if ($result.Width -ne $size -or $result.Height -ne $size -or $result.RawFormat.Guid -ne $expectedFormat.Guid) {
            throw '头像尺寸或格式校验失败。'
        }
        $bytes = $stream.ToArray()
    } finally {
        $result.Dispose()
    }
} finally {
    $stream.Dispose()
    $attributes.Dispose()
    $graphics.Dispose()
    $canvas.Dispose()
    $image.Dispose()
}

$directory = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputDirectory)
[void][IO.Directory]::CreateDirectory($directory)
$path = Join-Path $directory "$($source.BaseName)-workbuddy-avatar-512.$extension"
[IO.File]::WriteAllBytes($path, $bytes)
[ordered]@{path=$path; width=$size; height=$size; format=$extension; bytes=$bytes.Length; whiteBackground=$whiteBackground} | ConvertTo-Json -Compress
