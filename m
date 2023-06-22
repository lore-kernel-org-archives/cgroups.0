From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH][next] cgroup: Avoid -Wstringop-overflow warnings
Date: Thu, 22 Jun 2023 12:20:13 +0200
Message-ID: <361c2f87-1424-f452-912f-0e4a339f5c46@kernel.org>
References: <ZIpm3pcs3iCP9UaR@work>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687429223;
        bh=SYl7L3El4kLgtnTMh7BKKEOpmUvMHtKtirHsySgizNw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=msh7+e24+6Qq8hiSGIlXgZfnJmz/CXyamAAP5FY6G3LrO6XQNaRMxsW7HNqWIzMvn
         XHg3Esi9AHN4l4bhAMYc18e/iTf3yBUvu9eYF19KNZnYfurj1+RX36rwkqwqguCSdZ
         BBSXFsPBwPsjIMj8NbFDKR+Rk5FMvT1aghffwSYbBBN8vZzcf/BnC9TYj/4D2eZVVN
         KMUNB3dhaP76Tf969sdwYzKcf9IEgDtC7WE7I/CDmxaVN0SeRQlgUmSq7fUxJWnEtg
         AxTGbQgqAN74AiFIsXdgFURf6EOJag3g+8/xOdAMxo6TuzluJPB/zpE/7CNFc8bdWH
         /FSDHYe/3jnLQ==
Content-Language: en-US
In-Reply-To: <ZIpm3pcs3iCP9UaR@work>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, Linux Next Mailing List <linux-next@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "linux-samsung-soc@vger.kernel.org" <linux-samsung-soc@vger.kernel.org>

On 15/06/2023 03:18, Gustavo A. R. Silva wrote:
> Address the following -Wstringop-overflow warnings seen when
> built with ARM architecture and aspeed_g4_defconfig configuration
> (notice that under this configuration CGROUP_SUBSYS_COUNT == 0):
> kernel/cgroup/cgroup.c:1208:16: warning: 'find_existing_css_set' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
> kernel/cgroup/cgroup.c:1258:15: warning: 'css_set_hash' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
> kernel/cgroup/cgroup.c:6089:18: warning: 'css_set_hash' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
> kernel/cgroup/cgroup.c:6153:18: warning: 'css_set_hash' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
> 

Hi,

This patch landed in next but causes boot failures on
Exynos ARMv7 board (32 bit) with systemd (exynos_defconfig):

NFS-Mount: 192.168.1.10:/srv/nfs/odroidhc1
Waiting 10 seconds for device /dev/nfs ...
ERROR: device '/dev/nfs' not found. Skipping fsck.
Mount cmd: 
mount.nfs4 -o vers=4,nolock 192.168.1.10:/srv/nfs/odroidhc1 /new_root
:: running cleanup hook [udev]
[   23.752917] systemd[1]: System time before build time, advancing clock.
[   23.851828] systemd[1]: Failed to mount tmpfs at /sys/fs/cgroup: No such file or directory
[   23.868459] systemd[1]: Failed to mount cgroup at /sys/fs/cgroup/systemd: No such file or directory
[!!!!!!] Failed to mount API filesystems.
[   23.914562] systemd[1]: Freezing execution.

Full log:
https://krzk.eu/#/builders/21/builds/4110/steps/15/logs/serial0

Best regards,
Krzysztof

