From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] memcg: change behavior of moving charges at task move
Date: Thu, 22 Mar 2012 14:36:10 -0700
Message-ID: <20120322143610.e4df49c9.akpm@linux-foundation.org>
References: <4F69A4C4.4080602@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F69A4C4.4080602-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org" <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

On Wed, 21 Mar 2012 18:52:04 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:

>  static struct page *mc_handle_swap_pte(struct vm_area_struct *vma,
>  			unsigned long addr, pte_t ptent, swp_entry_t *entry)
>  {
> -	int usage_count;
>  	struct page *page = NULL;
>  	swp_entry_t ent = pte_to_swp_entry(ptent);
>  
>  	if (!move_anon() || non_swap_entry(ent))
>  		return NULL;
> -	usage_count = mem_cgroup_count_swap_user(ent, &page);
> -	if (usage_count > 1) { /* we don't move shared anon */
> -		if (page)
> -			put_page(page);
> -		return NULL;
> -	}
> +#ifdef CONFIG_SWAP
> +	/*
> +	 * Avoid lookup_swap_cache() not to update statistics.
> +	 */

I don't understand this comment - what is it trying to tell us?

> +	page = find_get_page(&swapper_space, ent.val);

The code won't even compile if CONFIG_SWAP=n?

> +#endif
>  	if (do_swap_account)
>  		entry->val = ent.val;
>  
