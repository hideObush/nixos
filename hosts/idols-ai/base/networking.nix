{
  # Network discovery, mDNS
  # With this enabled, you can access your machine at <hostname>.local
  # it's more convenient than using the IP address.
  # https://avahi.org/
  # Use an NTP server located in the mainland of China to synchronize the system time
  time.hardwareClockInLocalTime = true;
  networking.timeServers = [
    "kr.pool.ntp.org" # Aliyun NTP Server
    "time.kriss.re.kr"
  ];
}
