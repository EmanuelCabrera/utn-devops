class jenkins {

    # get key
    exec { 'install_jenkins_key':
        command => '/usr/bin/wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -',
    }

        # source file
    file { '/etc/apt/sources.list.d/jenkins.list':
        content => "deb https://pkg.jenkins.io/debian-stable binary/\n",
        ensure => present,
        mode    => '0644',
        owner   => root,
        group   => root,
        require => Exec['install_jenkins_key'],
    } -> #ordeno la secuencia de pasos en el tiempo mediante el operador "->".
    # se utiliza para encadenar semanticamente distintas declaraciones
    # update
    exec { 'apt-get update':
        command => '/usr/bin/apt-get update',
    }

    #install jenkins
    $enhancers = [ 'openjdk-11-jre', 'jenkins' ]

    package { $enhancers:
        ensure => 'installed',
    } ->
    #Reemplazo el puerto de jenkins para que este escuchando en el 8082
    exec { 'replace_jenkins_port':
        command => "/bin/sed -i -- 's/JENKINS_PORT=8080/JENKINS_PORT=8082/g' /lib/systemd/system/jenkins.service",
    } -> exec { 'reload-systemctl':
        command => '/bin/systemctl daemon-reload',
        notify  => Service['jenkins'],
    }

    # aseguro que el servicio de jenkins este activo
    service { 'jenkins':
        ensure  => running,
    }
}
