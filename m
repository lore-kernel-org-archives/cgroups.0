From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 4/4] mm: memcontrol: fix swap uncharge on cgroup v2
Date: Mon, 15 Feb 2021 10:47:54 +0100
Message-ID: <YCpDSnLSDoE/FHK5@dhcp22.suse.cz>
References: <20210212170159.32153-1-songmuchun@bytedance.com>
 <20210212170159.32153-4-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613382475; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tgPT5P13ZnYUMYX9KeVnDKoSxuQbU0v+VMfCnnxCsVA=;
        b=pg9Nrs5pHfRxhWPI6aAQKx/oWV5710KNxAtTwHE+ZVl/TEwLWu3Sxz0P9TfOgZbEKp2vKt
        HcvlbL5NcNjfrfuAAk5VPnz78+HRCbulwyYvRxNx/Q6VYiKVorHekf3UrdIYjl+pmfVKrO
        M8Fwru0ZPhg8/k5TlqQUm9ez5taN6QM=
Content-Disposition: inline
In-Reply-To: <20210212170159.32153-4-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat 13-02-21 01:01:59, Muchun Song wrote:
> The swap charges the actual number of swap entries on cgroup v2.
> If a swap cache page is charged successful, and then we uncharge
> the swap counter. It is wrong on cgroup v2. Because the swap
> entry is not freed.

Is there any actual problem though? Can you describe the specific
scenario please? Swap cache charge life time is a bit tricky and I have
to confess I have to relearn it every time I need to understand it. The
patch would be much more easier to review if the changelog was much more
specific.

> Fixes: 2d1c498072de ("mm: memcontrol: make swap tracking an integral part of memory control")
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c737c8f05992..be6bc5044150 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6753,7 +6753,7 @@ int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask)
>  	memcg_check_events(memcg, page);
>  	local_irq_enable();
>  
> -	if (PageSwapCache(page)) {
> +	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && PageSwapCache(page)) {
>  		swp_entry_t entry = { .val = page_private(page) };
>  		/*
>  		 * The swap entry might not get freed for a long time,
> -- 
> 2.11.0

-- 
Michal Hocko
SUSE Labs
