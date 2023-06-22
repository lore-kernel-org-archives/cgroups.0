From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH][next] cgroup: Avoid -Wstringop-overflow warnings
Date: Thu, 22 Jun 2023 08:09:40 -0600
Message-ID: <9b1f62bd-47b2-be64-4d09-7f6f2d52b3bc@embeddedor.com>
References: <ZIpm3pcs3iCP9UaR@work>
 <361c2f87-1424-f452-912f-0e4a339f5c46@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=n5PserBqTU9pJTim+3fzKOkxgVhX1AauMCTNazI9mVQ=; b=zSpGVT94xBstFCH5TMotptKujm
        y0iNyfoq26cvln04rn7FAjKDEYBf6jdPRFsSg0cuzAuOH16bH3Z6/RriMMHFPDLIV5g/Z/BAiMj5e
        0K8J3A08o4WCBdzGlyd5yr4fE93DfJkrgsI5j4KxGemUlXq9fTwMpIpx2CaxOWVW/aIyZ/tvTyUAf
        oNsuM8ZpFmX5HiHpcloOfGOKth6htgyfL/oJMsybny36hnYzhfrb41B4sAD212ThMZjlWGbUMRxCp
        cLCMPzOPnxL6hjo76hk4b7fygRJFluBDnaU0E6Dt+0UqsL0efJJe3Z4GIIEO6lz8cAfVRmN6RTXx7
        lJp5 
Content-Language: en-US
In-Reply-To: <361c2f87-1424-f452-912f-0e4a339f5c46@kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Krzysztof Kozlowski <krzk@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, Linux Next Mailing List <linux-next@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "linux-samsung-soc@vger.kernel.org" <linux-samsung-soc@vger.kernel.org>

Hi!

On 6/22/23 04:20, Krzysztof Kozlowski wrote:
> On 15/06/2023 03:18, Gustavo A. R. Silva wrote:
>> Address the following -Wstringop-overflow warnings seen when
>> built with ARM architecture and aspeed_g4_defconfig configuration
>> (notice that under this configuration CGROUP_SUBSYS_COUNT == 0):
>> kernel/cgroup/cgroup.c:1208:16: warning: 'find_existing_css_set' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
>> kernel/cgroup/cgroup.c:1258:15: warning: 'css_set_hash' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
>> kernel/cgroup/cgroup.c:6089:18: warning: 'css_set_hash' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
>> kernel/cgroup/cgroup.c:6153:18: warning: 'css_set_hash' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
>>
> 
> Hi,
> 
> This patch landed in next but causes boot failures on
> Exynos ARMv7 board (32 bit) with systemd (exynos_defconfig):
> 
> NFS-Mount: 192.168.1.10:/srv/nfs/odroidhc1
> Waiting 10 seconds for device /dev/nfs ...
> ERROR: device '/dev/nfs' not found. Skipping fsck.
> Mount cmd:
> mount.nfs4 -o vers=4,nolock 192.168.1.10:/srv/nfs/odroidhc1 /new_root
> :: running cleanup hook [udev]
> [   23.752917] systemd[1]: System time before build time, advancing clock.
> [   23.851828] systemd[1]: Failed to mount tmpfs at /sys/fs/cgroup: No such file or directory
> [   23.868459] systemd[1]: Failed to mount cgroup at /sys/fs/cgroup/systemd: No such file or directory
> [!!!!!!] Failed to mount API filesystems.
> [   23.914562] systemd[1]: Freezing execution.
> 
> Full log:
> https://krzk.eu/#/builders/21/builds/4110/steps/15/logs/serial0

Thanks for reporting this issue. I'll take a look.
