function New-Log {
    param(
        $Message
    )
    Write-Output "$(Get-DAte -Format "yyyyMMdd HH:mm:ss.ffff"): $Message"
}

function Send-Response {
    param(
        $Stream,
        $Message
    )

    try {
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($Message)
        $Stream.Write($bytes,0,$bytes.Length)
    } catch {
        throw "Unable to send response to game client. $_"
    }
}

class OpponentOne {
    $Response = 'attack'
}

class OpponentTwo {
    $PreviousHumanAction = "" # attack, peace
    $Response = if ( $PreviousHumanAction -eq $Attack ) { 'attack'} else { 'peace' }
}

try {
    # Open listener
    New-Log -Message "Opening the socket"
    $Listener = [System.Net.Sockets.TcpListener]6942;

    New-Log -Message "Socket openned"
    $Listener.Start()

    $Run = $true
    while ($Run) {
        $Session = $Listener.AcceptTcpClient()
        New-Log -Message "New Session Started"

        $SessionStream = $Session.GetStream()
        New-Log -Message "Connecting to Stream"

        # Welcome Connection
        Send-Response `
            -Message "Welcome to game theory 101." `
            -Stream $SessionStream

        # Terminate Connectoin
        $Run = $False
    }

} catch {
    Write-Warning "Server failed. $_"

} finally {
    New-Log "Closing the server."
    $Listener.Stop()
}