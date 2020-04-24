From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 16/18] mm: memcontrol: charge swapin pages on
 instantiation
Date: Thu, 23 Apr 2020 22:51:35 -0400
Message-ID: <20200424025135.GB464082@cmpxchg.org>
References: <20200420221126.341272-1-hannes@cmpxchg.org>
 <20200420221126.341272-17-hannes@cmpxchg.org>
 <20200424004441.GF13929@js1304-desktop>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8QJoTXqVG0DZe/mQnKE8SNa8hRGYUaKenWzWiibacQo=;
        b=fWyMKe13DTH0WU39blr8r9fcIdg3WBh/22Qxi2N7/ZMi57uMaMHC/LswPiuSjuDGrM
         zAXBsVSEfj/DS2W4JCdcrTiZVmjoKokQ6z5mvtJNnXt7/kv+EPEP+dsi2RmQXk2NPSuM
         yTmXoyi+hqG1qYalmMWuPITt2paqd8GD9tZLfk7uhJDG1NdivLWI3Q5JJ6kGyMrLUiR4
         rfPqA28+wLh8IkDmjIOb6ygNjMVfna281My/tfr+rwPZoX3nJjW4AVXiJTycMOgdiI37
         bkhzmYKfjeH5tajFE8yKQguK2PGATn1ik7TlViwHPVLmrNN6hvRAjDx6Usw6Su+poqmg
         mPMQ==
Content-Disposition: inline
In-Reply-To: <20200424004441.GF13929@js1304-desktop>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, Apr 24, 2020 at 09:44:42AM +0900, Joonsoo Kim wrote:
> On Mon, Apr 20, 2020 at 06:11:24PM -0400, Johannes Weiner wrote:
> > @@ -412,31 +407,43 @@ struct page *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
> >  			 */
> >  			cond_resched();
> >  			continue;
> > -		} else if (err)		/* swp entry is obsolete ? */
> > -			break;
> > -
> > -		/* May fail (-ENOMEM) if XArray node allocation failed. */
> > -		__SetPageLocked(new_page);
> > -		__SetPageSwapBacked(new_page);
> > -		err = add_to_swap_cache(new_page, entry, gfp_mask & GFP_KERNEL);
> > -		if (likely(!err)) {
> > -			/* Initiate read into locked page */
> > -			SetPageWorkingset(new_page);
> > -			lru_cache_add_anon(new_page);
> > -			*new_page_allocated = true;
> > -			return new_page;
> >  		}
> > -		__ClearPageLocked(new_page);
> > -		/*
> > -		 * add_to_swap_cache() doesn't return -EEXIST, so we can safely
> > -		 * clear SWAP_HAS_CACHE flag.
> > -		 */
> > -		put_swap_page(new_page, entry);
> > -	} while (err != -ENOMEM);
> > +		if (err)		/* swp entry is obsolete ? */
> > +			return NULL;
> 
> "if (err)" is not needed since "!err" is already exiting the loop.

But we don't want to leave the loop, we want to leave the
function. For example, if swapcache_prepare() says the entry is gone
(-ENOENT), we don't want to exit the loop and allocate a page for it.

> > +
> > +	/*
> > +	 * The swap entry is ours to swap in. Prepare a new page.
> > +	 */
> > +
> > +	page = alloc_page_vma(gfp_mask, vma, addr);
> > +	if (!page)
> > +		goto fail_free;
> > +
> > +	__SetPageLocked(page);
> > +	__SetPageSwapBacked(page);
> > +
> > +	/* May fail (-ENOMEM) if XArray node allocation failed. */
> > +	if (add_to_swap_cache(page, entry, gfp_mask & GFP_KERNEL))
> > +		goto fail_unlock;
> > +
> > +	if (mem_cgroup_charge(page, NULL, gfp_mask & GFP_KERNEL, false))
> > +		goto fail_delete;
> > +
> 
> I think that following order of operations is better than yours.
> 
> 1. page alloc
> 2. memcg charge
> 3. swapcache_prepare
> 4. add_to_swap_cache
> 
> Reason is that page allocation and memcg charging could take for a
> long time due to reclaim and other tasks waiting this swapcache page
> could be blocked inbetween swapcache_prepare() and add_to_swap_cache().

I see how that would be preferable, but memcg charging actually needs
the swap(cache) information to figure out the cgroup that owned it at
swapout, then uncharge the swapcache and drop the swap cgroup record.

Maybe it could be done, but I'm not sure that level of surgery would
be worth the benefits? Whoever else would be trying to swap the page
in at the same time is likely in the same memory situation, and would
not necessarily be able to allocate pages any faster.
