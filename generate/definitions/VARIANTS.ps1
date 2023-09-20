# Docker image variants' definitions
$local:VARIANTS_MATRIX = @(
    @{
        package = 'chrony'
        package_version = '4.4'
        distro = 'alpine'
        distro_version = 'edge'
        subvariants = @(
            @{ components = @() }
        )
    }
    @{
        package = 'chrony'
        package_version = '4.3'
        distro = 'alpine'
        distro_version = '3.17'
        subvariants = @(
            @{ components = @() }
        )
    }
    @{
        package = 'chrony'
        package_version = '4.2'
        distro = 'alpine'
        distro_version = '3.16'
        subvariants = @(
            @{ components = @() }
        )
    }
    @{
        package = 'chrony'
        package_version = '4.1'
        distro = 'alpine'
        distro_version = '3.14'
        subvariants = @(
            @{ components = @() }
        )
    }
    @{
        package = 'chrony'
        package_version = '4.0'
        distro = 'alpine'
        distro_version = '3.13'
        subvariants = @(
            @{ components = @() }
        )
    }
    @{
        package = 'chrony'
        package_version = '3.5.1'
        distro = 'alpine'
        distro_version = '3.12'
        subvariants = @(
            @{ components = @() }
        )
    }
)

$VARIANTS = @(
    foreach ($variant in $VARIANTS_MATRIX){
        foreach ($subVariant in $variant['subvariants']) {
            @{
                # Metadata object
                _metadata = @{
                    package = $variant['package']
                    package_version = $variant['package_version']
                    distro = $variant['distro']
                    distro_version = $variant['distro_version']
                    platforms = & {
                        if ($variant -in @( '3.3', '3.4', '3.5' ) ) {
                            'linux/amd64'
                        }else {
                            'linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64,linux/s390x'
                        }
                    }
                    components = $subVariant['components']
                }
                # Docker image tag. E.g. '3.8-curl'
                tag = @(
                        $variant['package_version']
                        # $variant['distro']
                        # $variant['distro_version']
                        $subVariant['components'] | ? { $_ }
                ) -join '-'
                tag_as_latest = if ($variant['package_version'] -eq $local:VARIANTS_MATRIX[0]['package_version'] -and $subVariant['components'].Count -eq 0) { $true } else { $false }
            }
        }
    }
)

# Docker image variants' definitions (shared)
$VARIANTS_SHARED = @{
    buildContextFiles = @{
        templates = @{
            'Dockerfile' = @{
                common = $true
                includeHeader = $false
                includeFooter = $false
                passes = @(
                    @{
                        variables = @{}
                    }
                )
            }
            'docker-entrypoint.sh' = @{
                common = $true
                passes = @(
                    @{
                        variables = @{}
                    }
                )
            }
        }
    }
}
