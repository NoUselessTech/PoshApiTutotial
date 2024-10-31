try {
    # Init the TCP Client
    $Client = New-Object System.Net.Sockets.TcpClient( "localhost", 6942)
    $ClientStream = $Client.GetStream()
    $data = [System.Byte[]]::CreateInstance([System.Byte],256)
    $StayConnected = $true

    While($StayConnected) {
        $bytes = $ClientStream.Read($data, 0, $data.Length)
        $response = [System.Text.Encoding]::UTF8.GetString($data, 0, $bytes)
        Write-Output $Response

        $StayConnected = $False
    }


} catch {
    Write-Error "Server Error. $_"

} finally {
    $Client.Close()
    $Client.Dispose()
}