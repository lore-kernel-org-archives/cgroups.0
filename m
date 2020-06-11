From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 16/19] mm: memcontrol: charge swapin pages on
 instantiation
Date: Thu, 11 Jun 2020 11:35:23 +0200
Message-ID: <20200611093523.GB20450@dhcp22.suse.cz>
References: <20200508183105.225460-1-hannes@cmpxchg.org>
 <20200508183105.225460-17-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200508183105.225460-17-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri 08-05-20 14:31:03, Johannes Weiner wrote:
[...]
> diff --git a/mm/memory.c b/mm/memory.c
> index 832ee914cbcf..93900b121b6e 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3125,9 +3125,20 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  			page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma,
>  							vmf->address);
>  			if (page) {
> +				int err;
> +
>  				__SetPageLocked(page);
>  				__SetPageSwapBacked(page);
>  				set_page_private(page, entry.val);
> +
> +				/* Tell memcg to use swap ownership records */
> +				SetPageSwapCache(page);
> +				err = mem_cgroup_charge(page, vma->vm_mm,
> +							GFP_KERNEL, false);
> +				ClearPageSwapCache(page);
> +				if (err)
> +					goto out_page;

err would be a return value from try_charge and that can be -ENOMEM. Now
we almost never return ENOMEM for GFP_KERNEL single page charge. Except
for async OOM handling (oom_disabled v1). So this needs translation to
VM_FAULT_OOM.

I am not an expert on the swap code so I might have missed some subtle
issues but the rest of the patch seems reasonable to me.
-- 
Michal Hocko
SUSE Labs
