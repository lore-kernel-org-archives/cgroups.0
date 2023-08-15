From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH][next] cgroup: Avoid -Wstringop-overflow warnings
Date: Tue, 15 Aug 2023 13:04:32 -0600
Message-ID: <e1c07dd0-e6bf-ca9c-107a-97c5043b1bc7@embeddedor.com>
References: <ZIpm3pcs3iCP9UaR@work>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=oDTpbnZtb5YY58cxQ1+wqrLvX74qH9kX1x/86gt1r6c=; b=GYqk+IEZHDNl4F1KNkrjKQ4GCv
        A8WuEZWAoPnmMiy5LJ5rLCvLrfBUjja3movkQMpr/X3RBuLXmLXSa2djw6dKXzKucDKJi/n0OzHsC
        lgCkFhGiIVfQpofwfVRHtXlcHDGmrQXJIlLN2PSiVfQxmdIM0765db6fe82HYihlPM2Wgwn0/D8eP
        i5nCbb2biNKRb53PVBwCZRjEqtmn5+EFTXARPbPFiG9+6QkFJxpCavWSSp4tRVGiuoVBC2TDajzeg
        upx233SUSeGEbPUt3NXjHVv7jeWCyXSBmlaN+7ngIYg5E/XAJLYVujq0sfutwtvAhpl2ITu/tH/74
        MUNz 
Content-Language: en-US
In-Reply-To: <ZIpm3pcs3iCP9UaR@work>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org

Hi all,

I wonder if you have any suggestions on how to address this issue. As it seems that
my last attempt caused some boot failures[1][2].

At first, I thought that the right way to fix this was through a similar fix as this
one[3]. But it seems I'm missing something else that I cannot determine yet.

These -Wstringop-overflow warnings are mostly the last ones remaining before we can
finally enable this compiler option, globally.

Any help or advice on how to properly address this is greatly appreciated. :)

Thanks!
--
Gustavo

[1] https://lore.kernel.org/linux-hardening/726aae97-755d-9806-11d4-2fb21aa93428@arm.com/
[2] https://lore.kernel.org/linux-hardening/361c2f87-1424-f452-912f-0e4a339f5c46@kernel.org/
[3] https://git.kernel.org/linus/d20d30ebb199


On 6/14/23 19:18, Gustavo A. R. Silva wrote:
> Address the following -Wstringop-overflow warnings seen when
> built with ARM architecture and aspeed_g4_defconfig configuration
> (notice that under this configuration CGROUP_SUBSYS_COUNT == 0):
> kernel/cgroup/cgroup.c:1208:16: warning: 'find_existing_css_set' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
> kernel/cgroup/cgroup.c:1258:15: warning: 'css_set_hash' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
> kernel/cgroup/cgroup.c:6089:18: warning: 'css_set_hash' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
> kernel/cgroup/cgroup.c:6153:18: warning: 'css_set_hash' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
> 
> These changes are based on commit d20d30ebb199 ("cgroup: Avoid compiler
> warnings with no subsystems").
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>   kernel/cgroup/cgroup.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index cd497b90e11a..1ee76e62eb98 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -1200,6 +1200,9 @@ static struct css_set *find_css_set(struct css_set *old_cset,
>   	unsigned long key;
>   	int ssid;
>   
> +	if (!CGROUP_HAS_SUBSYS_CONFIG)
> +		return NULL;
> +
>   	lockdep_assert_held(&cgroup_mutex);
>   
>   	/* First see if we already have a cgroup group that matches
> @@ -6045,6 +6048,9 @@ int __init cgroup_init(void)
>   	struct cgroup_subsys *ss;
>   	int ssid;
>   
> +	if (!CGROUP_HAS_SUBSYS_CONFIG)
> +		return -EINVAL;
> +
>   	BUILD_BUG_ON(CGROUP_SUBSYS_COUNT > 16);
>   	BUG_ON(cgroup_init_cftypes(NULL, cgroup_base_files));
>   	BUG_ON(cgroup_init_cftypes(NULL, cgroup_psi_files));
