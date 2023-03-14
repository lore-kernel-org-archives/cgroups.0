From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] memcg: page_cgroup_ino() get memcg from
 compound_head(page)
Date: Tue, 14 Mar 2023 11:00:50 +0100
Message-ID: <ZBBF0oHa0eArw9kb@dhcp22.suse.cz>
References: <20230313083452.1319968-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1678788051; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zrFNQAV0l1CaW8TiDEGT9ogtnBdqHaF4d1lnbt/UKwY=;
        b=l+Fl+tiItkB9IMHG6s9GklHI70NVKfCAJfb6sfkphrk2E7mPyQOCeEiWSD8eyevzEzkdqn
        2VRh7BF+1HEEd8eBMot1x1G2D63yCHyVb2N06OPgbH2WYNjRhEw8pzpVBhbaTzsJ7ctXn9
        XM7+9tyRhSczLagEMuGgH8UPKCwP72o=
Content-Disposition: inline
In-Reply-To: <20230313083452.1319968-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Naoya Horiguchi <naoya.horiguchi-YMj9X0ASwKA@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 13-03-23 08:34:52, Yosry Ahmed wrote:
> From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> In a kernel with added WARN_ON_ONCE(PageTail) in page_memcg_check(), we
> observed a warning from page_cgroup_ino() when reading
> /proc/kpagecgroup. This warning was added to catch fragile reads of
> a page memcg. Make page_cgroup_ino() get memcg from compound_head(page):
> that gives it the correct memcg for each subpage of a compound page,
> so is the right fix.
> 
> I dithered between the right fix and the safer "fix": it's unlikely but
> conceivable that some userspace has learnt that /proc/kpagecgroup gives
> no memcg on tail pages, and compensates for that in some (racy) way: so
> continuing to give no memcg on tails, without warning, might be safer.
> 
> But hwpoison_filter_task(), the only other user of page_cgroup_ino(),
> persuaded me.  It looks as if it currently leaves out tail pages of the
> selected memcg, by mistake: whereas hwpoison_inject() uses compound_head()
> and expects the tails to be included.  So hwpoison testing coverage has
> probably been restricted by the wrong output from page_cgroup_ino() (if
> that memcg filter is used at all): in the short term, it might be safer
> not to enable wider coverage there, but long term we would regret that.
> 
> Signed-off-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Thanks!

> ---
> 
> (Yosry: Alternatively, we could modify page_memcg_check() to do
>  page_folio() like its sibling page_memcg(), as page_cgroup_ino() is the
>  only remaining caller other than print_page_owner_memcg(); and it already
>  excludes pages that have page->memcg_data = 0)
> 
> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 5abffe6f8389..e3a55295725e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -395,7 +395,7 @@ ino_t page_cgroup_ino(struct page *page)
>  	unsigned long ino = 0;
>  
>  	rcu_read_lock();
> -	memcg = page_memcg_check(page);
> +	memcg = page_memcg_check(compound_head(page));
>  
>  	while (memcg && !(memcg->css.flags & CSS_ONLINE))
>  		memcg = parent_mem_cgroup(memcg);
> -- 
> 2.40.0.rc1.284.g88254d51c5-goog

-- 
Michal Hocko
SUSE Labs
