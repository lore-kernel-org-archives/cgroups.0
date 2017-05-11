From: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -mm -v10 1/3] mm, THP, swap: Delay splitting THP during
 swap out
Date: Thu, 11 May 2017 13:31:11 +0900
Message-ID: <20170511043111.GA6351@bbox>
References: <20170425125658.28684-1-ying.huang@intel.com>
 <20170425125658.28684-2-ying.huang@intel.com>
 <20170427053141.GA1925@bbox>
 <87mvb21fz1.fsf@yhuang-dev.intel.com>
 <20170428084044.GB19510@bbox>
 <20170501104430.GA16306@cmpxchg.org>
 <20170501235332.GA4411@bbox>
 <20170510135654.GD17121@cmpxchg.org>
 <20170510232556.GA26521@bbox>
 <87h90sb4jq.fsf@yhuang-dev.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87h90sb4jq.fsf-5/hDr2MS57EDqwDYnZuMFFaTQe2KTcn/@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ebru Akagunduz <ebru.akagunduz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, May 11, 2017 at 08:50:01AM +0800, Huang, Ying wrote:
< snip >

> >> > @@ -1125,8 +1125,28 @@ static unsigned long shrink_page_list(struct list_head *page_list,
> >> >  		    !PageSwapCache(page)) {
> >> >  			if (!(sc->gfp_mask & __GFP_IO))
> >> >  				goto keep_locked;
> >> > -			if (!add_to_swap(page, page_list))
> >> > +swap_retry:
> >> > +			/*
> >> > +			 * Retry after split if we fail to allocate
> >> > +			 * swap space of a THP.
> >> > +			 */
> >> > +			if (!add_to_swap(page)) {
> >> > +				if (!PageTransHuge(page) ||
> >> > +				    split_huge_page_to_list(page, page_list))
> >> > +					goto activate_locked;
> >> > +				goto swap_retry;
> >> > +			}
> >> 
> >> This is definitely better.
> >
> > Thanks.
> >
> >> 
> >> However, I think it'd be cleaner without the label here:
> >> 
> >> 			if (!add_to_swap(page)) {
> >> 				if (!PageTransHuge(page))
> >> 					goto activate_locked;
> >> 				/* Split THP and swap individual base pages */
> >> 				if (split_huge_page_to_list(page, page_list))
> >> 					goto activate_locked;
> >> 				if (!add_to_swap(page))
> >> 					goto activate_locked;
> >
> > Yes.
> >
> >> 			}
> >> 
> >> > +			/*
> >> > +			 * Got swap space successfully. But unfortunately,
> >> > +			 * we don't support a THP page writeout so split it.
> >> > +			 */
> >> > +			if (PageTransHuge(page) &&
> >> > +				  split_huge_page_to_list(page, page_list)) {
> >> > +				delete_from_swap_cache(page);
> >> >  				goto activate_locked;
> >> > +			}
> >> 
> >> Pulling this out of add_to_swap() is an improvement for sure. Add an
> >> XXX: before that "we don't support THP writes" comment for good
> >> measure :)
> >
> > Sure.
> >
> > It could be a separate patch which makes add_to_swap clean via
> > removing page_list argument but I hope Huang take/fold it when he
> > resend it because it would be more important with THP swap.
> 
> Sure.  I will take this patch as one patch of the THP swap series.
> Because the first patch of the THP swap series is a little big, I don't
> think it is a good idea to fold this patch into it.  Could you update
> the patch according to Johannes' comments and resend it?

Okay, I will resend this clean-up patch against on yours patch
after finishing this discussion.

Thanks.
