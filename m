From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: Skip high limit check in root memcg
Date: Tue, 14 Feb 2023 16:56:52 +0100
Message-ID: <Y+uvRKo7OQ02yB4K@dhcp22.suse.cz>
References: <20230210094550.5125-1-haifeng.xu@shopee.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1676390213; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iAggmlF4GOtadtjvHCG9VGU8bit4Xaqy/p0gnj0OK7A=;
        b=RK+XbcmgSb5r0n5e5pwKRqGg012gVMCB/BgpEJ1uGLd83kk2Qp9m3ltJOqPkP9HdoV71ij
        yD8r+HWyxD3FQY7E1msXK+iv/WfYD+Up/+IJfn6AOg6PMsYPTZNikWOPOYu8mVyvx/r+GO
        7shQ7ft20DZTe/p/FIvp82rBcJfEwGA=
Content-Disposition: inline
In-Reply-To: <20230210094550.5125-1-haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 10-02-23 09:45:50, Haifeng Xu wrote:
> The high limit checks the memory usage from given memcg to root memcg.
> However, there is no limit in root memcg. So this check makes no sense
> and we can ignore it.

Is this check actually addining any benefit? Have you measured aby
performance gains by this change?

> Signed-off-by: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
> ---
>  mm/memcontrol.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 73afff8062f9..a31a56598f29 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2780,6 +2780,10 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	do {
>  		bool mem_high, swap_high;
>  
> +		/* There is no need for root memcg to check high limit */
> +		if (mem_cgroup_is_root(memcg))
> +			break;
> +
>  		mem_high = page_counter_read(&memcg->memory) >
>  			READ_ONCE(memcg->memory.high);
>  		swap_high = page_counter_read(&memcg->swap) >
> -- 
> 2.25.1

-- 
Michal Hocko
SUSE Labs
