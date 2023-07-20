From: Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 7/8] memcg: add sysctl and config option to control
 memory recharging
Date: Thu, 20 Jul 2023 11:13:48 -0700
Message-ID: <ZLl5XA25BIlYyngD@bombadil.infradead.org>
References: <20230720070825.992023-1-yosryahmed@google.com>
 <20230720070825.992023-8-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5FoFqUFeB/KEI6d1Tdr/d4rFzeHsyUVBldPSTkCumKk=; b=ZKZ8VZNv84DJ7jUh969Evun8Hv
        vtentQJqqmy7CFnHE/mCKPLkm7+6yrD7+2vH9Hprzn8A1LzrVC0Uir/ZZUou7WUHY5cKVIcvHQuw4
        nAVFY/x/GaSYvJI1hHSRpd06nEXGFbBM5LidTsWAf4faM/piE7H4veZ8Z1mRQbHlq4pPwjf2ylEjY
        NdLDeWR8xjGPaVUZ1HheMUzCfdfAxRpsFcykjriOLz+zQG+/a3rwQlA981jgIxGZQ5DXpHC622ZEu
        HkXQhyT7saFUTk2sJl21OJF16Q2suGMXk4YO/JBErbuApW/ewFBZylx3O14A+lS+++XEBjnRf06qx
        vpWIXnnA==;
Content-Disposition: inline
In-Reply-To: <20230720070825.992023-8-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: Luis Chamberlain <mcgrof-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Iurii Zaikin <yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jul 20, 2023 at 07:08:24AM +0000, Yosry Ahmed wrote:
> Add a sysctl to enable/disable memory recharging for offline memcgs. Add
> a config option to control whether or not it is enabled by default.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  include/linux/memcontrol.h |  2 ++
>  kernel/sysctl.c            | 11 +++++++++++
>  mm/Kconfig                 | 12 ++++++++++++
>  mm/memcontrol.c            |  9 ++++++++-
>  4 files changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 59b653d4a76e..ae9f09ee90cb 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -60,6 +60,8 @@ struct mem_cgroup_reclaim_cookie {
>  
>  #ifdef CONFIG_MEMCG
>  
> +extern int sysctl_recharge_offline_memcgs;
> +
>  #define MEM_CGROUP_ID_SHIFT	16
>  #define MEM_CGROUP_ID_MAX	USHRT_MAX
>  
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 354a2d294f52..1735d1d95652 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -2249,6 +2249,17 @@ static struct ctl_table vm_table[] = {
>  		.extra2		= (void *)&mmap_rnd_compat_bits_max,
>  	},
>  #endif
> +#ifdef CONFIG_MEMCG
> +	{
> +		.procname	= "recharge_offline_memcgs",
> +		.data		= &sysctl_recharge_offline_memcgs,
> +		.maxlen		= sizeof(sysctl_recharge_offline_memcgs),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec_minmax,
> +		.extra1		= SYSCTL_ZERO,
> +		.extra2		= SYSCTL_ONE,
> +	},
> +#endif /* CONFIG_MEMCG */
>  	{ }
>  };

Please don't add any more sysctls to kernel/sysctl.c, git log that file
for a series of cleanups which show how to use your own and why we have
been doing that cleanup.

  Luis
