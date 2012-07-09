From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 03/11] mm: shmem: do not try to uncharge known swapcache
 pages
Date: Mon, 9 Jul 2012 13:11:16 -0700 (PDT)
Message-ID: <alpine.LSU.2.00.1207091256540.1842@eggly.anvils>
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org> <1341449103-1986-4-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=tGLavIZ/SpJ3Zngf1mVeenUK49ShGa8g2lEhbaXVLgk=;
        b=VvtgpW2IMRekBKXSLmDqUOYycd6IpZrl4pdqP63B+8cHIKnetaKqv1wzihVlnD8iqk
         K7j/hHgXMMbwY+Dlik7rVmh7yiHHn3UCih19kZs7akkNrQrD97xO7zHK57mNSWeY0Qc9
         WSEaCsWU2Yd/Qe4D29t75ZzNPIOxPeGVAQQiC+KwIhpJpJsvbxc5+PVsi9rDt+BtCIIY
         Csm8dhjZyOg/OGaErXmKiz2hOzt+/9YUV9m8hg/at+GkNhqdmF3L7auV2KwVd6xzu722
         LboXw2HmXn2RUeLYYgsfWoyVig+FZeNeSrMVEevsSWKJnSYsAuIkbgTUmKMwLqN7g35A
         1oQQ==
In-Reply-To: <1341449103-1986-4-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 5 Jul 2012, Johannes Weiner wrote:
> Once charged, swapcache pages can only be uncharged after they are
> removed from swapcache again.
> 
> Do not try to uncharge pages that are known to be in the swapcache, to
> allow future patches to remove checks for that in the uncharge code.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> ---
>  mm/shmem.c |   11 ++++++-----
>  1 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index ee1c5a2..d12b705 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -302,8 +302,6 @@ static int shmem_add_to_page_cache(struct page *page,
>  		if (!expected)
>  			radix_tree_preload_end();
>  	}
> -	if (error)
> -		mem_cgroup_uncharge_cache_page(page);
>  	return error;
>  }
>  
> @@ -1184,11 +1182,14 @@ static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
>  		__set_page_locked(page);
>  		error = mem_cgroup_cache_charge(page, current->mm,
>  						gfp & GFP_RECLAIM_MASK);
> -		if (!error)
> -			error = shmem_add_to_page_cache(page, mapping, index,
> -						gfp, NULL);
>  		if (error)
>  			goto decused;
> +		error = shmem_add_to_page_cache(page, mapping, index,
> +						gfp, NULL);
> +		if (error) {
> +			mem_cgroup_uncharge_cache_page(page);
> +			goto decused;
> +		}
>  		lru_cache_add_anon(page);
>  
>  		spin_lock(&info->lock);
> -- 

I wanted to try this series out on mmotm before replying, and that
took a while; but the problems (some experimental RCU stuff, since
reverted; and Michal's wait_on_page_writeback in vmscan.c, I'll have
to investigate that later) were in mmotm rather than your series:
seems to be running fine under load now.

I've not reviewed, but definitely approve avoiding the temporary
extra charge in migration, and your other simplifications.

And I do approve this change, but selfishly withhold my Ack because
it's a subset of small shmem.c changes I was already lining up to
post, hoping still to sneak into 3.5.  We have a real bug in there
(charging to wrong memcg), and this cleanup comes along with that.
I'll post my version in an hour or two.

Hugh
