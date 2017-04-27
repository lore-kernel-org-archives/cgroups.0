From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH -mm -v10 1/3] mm, THP, swap: Delay splitting THP during
 swap out
Date: Thu, 27 Apr 2017 09:37:09 -0400
Message-ID: <20170427133709.GA13841@cmpxchg.org>
References: <20170425125658.28684-1-ying.huang@intel.com>
 <20170425125658.28684-2-ying.huang@intel.com>
 <20170427053141.GA1925@bbox>
 <87mvb21fz1.fsf@yhuang-dev.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2LfUXAr3zNohZub1SihKBhvxWHMkbeY1NnibE3riPvA=; b=vnQsg1ibqkIrgSpWp+8YLtkOrO
        X8O/rncLP9QA8XidR5CVFC9lxqXhir+A6mMPM6kqY4mKlWatdzetIo67LwX+c7tRtiACDArT3za0i
        9yFox2HTUmyWWmWXkl5kxu0WQMuYr2SlxhfCz369lhwbNyXy5Z7ZQqamlmUJc9YOtbx8=;
Content-Disposition: inline
In-Reply-To: <87mvb21fz1.fsf-5/hDr2MS57EDqwDYnZuMFFaTQe2KTcn/@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ebru Akagunduz <ebru.akagunduz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Apr 27, 2017 at 03:12:34PM +0800, Huang, Ying wrote:
> Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:
> > On Tue, Apr 25, 2017 at 08:56:56PM +0800, Huang, Ying wrote:
> >> @@ -178,20 +192,12 @@ int add_to_swap(struct page *page, struct list_head *list)
> >>  	VM_BUG_ON_PAGE(!PageLocked(page), page);
> >>  	VM_BUG_ON_PAGE(!PageUptodate(page), page);
> >>  
> >> -	entry = get_swap_page();
> >> +retry:
> >> +	entry = get_swap_page(page);
> >>  	if (!entry.val)
> >> -		return 0;
> >> -
> >> -	if (mem_cgroup_try_charge_swap(page, entry)) {
> >> -		swapcache_free(entry);
> >> -		return 0;
> >> -	}
> >> -
> >> -	if (unlikely(PageTransHuge(page)))
> >> -		if (unlikely(split_huge_page_to_list(page, list))) {
> >> -			swapcache_free(entry);
> >> -			return 0;
> >> -		}
> >> +		goto fail;
> >
> > So, with non-SSD swap, THP page *always* get the fail to get swp_entry_t
> > and retry after split the page. However, it makes unncessary get_swap_pages
> > call which is not trivial. If there is no SSD swap, thp-swap out should
> > be void without adding any performance overhead.
> > Hmm, but I have no good idea to do it simple. :(
> 
> For HDD swap, the device raw throughput is so low (< 100M Bps
> typically), that the added overhead here will not be a big issue.  Do
> you agree?

I fully agree. If you swap to spinning rust, an extra function call
here is the least of your concern.
