From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 05/18] mm: memcontrol: convert page cache to a new
 mem_cgroup_charge() API
Date: Mon, 11 May 2020 11:44:21 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.2005111132450.4088@eggly.anvils>
References: <20200420221126.341272-1-hannes@cmpxchg.org> <20200420221126.341272-6-hannes@cmpxchg.org> <20200422064041.GE6780@js1304-desktop> <20200422120946.GA358439@cmpxchg.org> <20200423052450.GA12538@js1304-desktop> <20200508160122.GB181181@cmpxchg.org>
 <alpine.LSU.2.11.2005102350360.2769@eggly.anvils> <20200511150648.GA306292@cmpxchg.org> <alpine.LSU.2.11.2005110912180.3431@eggly.anvils> <20200511181056.GA339505@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=fUrEOO+y3D6qyRoObBtBb6IstX2hI5RkiWjny9eyf2g=;
        b=ewA66SNz/mrr0YGX9ELb06rzKDiBYl/PL2esub6hnYZ+6TALexrmZPMIB8qJFeEFQd
         IF0LVoeS9dsVfQZcUMGsaoh15m09m9CjX4NdAExvYiE0/lfPlterADU+Q/Hnf8H2j6c5
         YKeM8EpuneuojhKYM0ZC9hT2FBdlQ0DPTdwuXwbmSzlYmwFGpW99Hw0ERgZfBzHvgWvh
         emK8fLJefimnuGZ8BKEF6tl1HinCTmvsETP8ybYotG3S58k+VHH1hK7AmoIPB3ysRIyz
         OYi/+MGYuIcNxIdA/1tjfRm8BlMts+W7Bxv3mcHAWEwsHl934fFKXGUdEH3AwIy91tW2
         szyw==
In-Reply-To: <20200511181056.GA339505-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Mon, 11 May 2020, Johannes Weiner wrote:
> 
> Since commit b56a2d8af914 ("mm: rid swapoff of quadratic complexity"),
> shmem_unuse_inode() doesn't have its own copy anymore - it uses
> shmem_swapin_page().
> 
> However, that commit appears to have made shmem's private call to
> delete_from_swap_cache() obsolete as well. Whereas before this change
> we fully relied on shmem_unuse() to find and clear a shmem swap entry
> and its swapcache page, we now only need it to clean out shmem's
> private state in the inode, as it's followed by a loop over all
> remaining swap slots, calling try_to_free_swap() on stragglers.

Great, you've looked deeper into the current situation than I had.

> 
> Unless I missed something, it's still merely an optimization, and we
> can delete it for simplicity:

Yes, nice ---s, simpler code, and a good idea to separate it out
as a precursor: thanks, Hannes.

> 
> ---
> 
> From fc9dcaf68c8b54baf365cd670fb5780c7f0d243f Mon Sep 17 00:00:00 2001
> From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Date: Mon, 11 May 2020 12:59:08 -0400
> Subject: [PATCH] mm: shmem: remove rare optimization when swapin races with
>  hole punching
> 
> Commit 215c02bc33bb ("tmpfs: fix shmem_getpage_gfp() VM_BUG_ON")
> recognized that hole punching can race with swapin and removed the
> BUG_ON() for a truncated entry from the swapin path.
> 
> The patch also added a swapcache deletion to optimize this rare case:
> Since swapin has the page locked, and free_swap_and_cache() merely
> trylocks, this situation can leave the page stranded in
> swapcache. Usually, page reclaim picks up stale swapcache pages, and
> the race can happen at any other time when the page is locked. (The
> same happens for non-shmem swapin racing with page table zapping.) The
> thinking here was: we already observed the race and we have the page
> locked, we may as well do the cleanup instead of waiting for reclaim.
> 
> However, this optimization complicates the next patch which moves the
> cgroup charging code around. As this is just a minor speedup for a
> race condition that is so rare that it required a fuzzer to trigger
> the original BUG_ON(), it's no longer worth the complications.
> 
> Suggested-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
(if one is allowed to suggest and to ack)

> ---
>  mm/shmem.c | 25 +++++++------------------
>  1 file changed, 7 insertions(+), 18 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index d505b6cce4ab..729bbb3513cd 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1665,27 +1665,16 @@ static int shmem_swapin_page(struct inode *inode, pgoff_t index,
>  	}
>  
>  	error = mem_cgroup_try_charge_delay(page, charge_mm, gfp, &memcg);
> -	if (!error) {
> -		error = shmem_add_to_page_cache(page, mapping, index,
> -						swp_to_radix_entry(swap), gfp);
> -		/*
> -		 * We already confirmed swap under page lock, and make
> -		 * no memory allocation here, so usually no possibility
> -		 * of error; but free_swap_and_cache() only trylocks a
> -		 * page, so it is just possible that the entry has been
> -		 * truncated or holepunched since swap was confirmed.
> -		 * shmem_undo_range() will have done some of the
> -		 * unaccounting, now delete_from_swap_cache() will do
> -		 * the rest.
> -		 */
> -		if (error) {
> -			mem_cgroup_cancel_charge(page, memcg);
> -			delete_from_swap_cache(page);
> -		}
> -	}
>  	if (error)
>  		goto failed;
>  
> +	error = shmem_add_to_page_cache(page, mapping, index,
> +					swp_to_radix_entry(swap), gfp);
> +	if (error) {
> +		mem_cgroup_cancel_charge(page, memcg);
> +		goto failed;
> +	}
> +
>  	mem_cgroup_commit_charge(page, memcg, true);
>  
>  	spin_lock_irq(&info->lock);
> -- 
> 2.26.2
> 
> 
