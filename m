From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH -mm -v10 1/3] mm, THP, swap: Delay splitting THP during
 swap out
Date: Thu, 11 May 2017 06:40:58 -0400
Message-ID: <20170511104058.GD6244@cmpxchg.org>
References: <20170425125658.28684-1-ying.huang@intel.com>
 <20170425125658.28684-2-ying.huang@intel.com>
 <20170427053141.GA1925@bbox>
 <87mvb21fz1.fsf@yhuang-dev.intel.com>
 <20170428084044.GB19510@bbox>
 <20170501104430.GA16306@cmpxchg.org>
 <20170501235332.GA4411@bbox>
 <20170510135654.GD17121@cmpxchg.org>
 <20170510232556.GA26521@bbox>
 <20170511012213.GA27659@bbox>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zLVY0Fk9EQ5chwzdM06TGjaKU5hsX7C3UvtUthehQk0=; b=se/2XSHlpkLgZSE/KACyehkkbC
	8GsH0J1/mLTq6ZChOF8M38MOzr4I2jsWbiGxbEMmBEC1h5wcdRJf5LgptTQfJO8W/HdRccnzy3Da3
	Qy+e51rd5Noc8DO1uHpyxkBAm8/VhvXvd93KUqudMc4L1EqwjKp0a0WGrTtwSbunb6MQ=;
Content-Disposition: inline
In-Reply-To: <20170511012213.GA27659@bbox>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Minchan Kim <minchan@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>, Ebru Akagunduz <ebru.akagunduz@gmail.com>, Michal Hocko <mhocko@kernel.org>, Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>, Shaohua Li <shli@kernel.org>, Rik van Riel <riel@redhat.com>, cgroups@vger.kernel.org

On Thu, May 11, 2017 at 10:22:13AM +0900, Minchan Kim wrote:
> On Thu, May 11, 2017 at 08:25:56AM +0900, Minchan Kim wrote:
> > On Wed, May 10, 2017 at 09:56:54AM -0400, Johannes Weiner wrote:
> > > Hi Michan,
> > > 
> > > On Tue, May 02, 2017 at 08:53:32AM +0900, Minchan Kim wrote:
> > > > @@ -1144,7 +1144,7 @@ void swap_free(swp_entry_t entry)
> > > >  /*
> > > >   * Called after dropping swapcache to decrease refcnt to swap entries.
> > > >   */
> > > > -void swapcache_free(swp_entry_t entry)
> > > > +void __swapcache_free(swp_entry_t entry)
> > > >  {
> > > >  	struct swap_info_struct *p;
> > > >  
> > > > @@ -1156,7 +1156,7 @@ void swapcache_free(swp_entry_t entry)
> > > >  }
> > > >  
> > > >  #ifdef CONFIG_THP_SWAP
> > > > -void swapcache_free_cluster(swp_entry_t entry)
> > > > +void __swapcache_free_cluster(swp_entry_t entry)
> > > >  {
> > > >  	unsigned long offset = swp_offset(entry);
> > > >  	unsigned long idx = offset / SWAPFILE_CLUSTER;
> > > > @@ -1182,6 +1182,14 @@ void swapcache_free_cluster(swp_entry_t entry)
> > > >  }
> > > >  #endif /* CONFIG_THP_SWAP */
> > > >  
> > > > +void swapcache_free(struct page *page, swp_entry_t entry)
> > > > +{
> > > > +	if (!PageTransHuge(page))
> > > > +		__swapcache_free(entry);
> > > > +	else
> > > > +		__swapcache_free_cluster(entry);
> > > > +}
> > > 
> > > I don't think this is cleaner :/
> 
> Let's see a example add_to_swap. Without it, it looks like that.
> 
> int add_to_swap(struct page *page)
> {
>         entry = get_swap_page(page);
>         ..
>         ..
> fail:
>         if (PageTransHuge(page))
>                 swapcache_free_cluster(entry);
>         else
>                 swapcache_free(entry);
> }
> 
> It doesn't looks good to me because get_swap_page hides
> where entry allocation is from cluster or slot but when
> we free the entry allocated, we should be aware of the
> internal and call right function. :(

This could be nicer indeed. I just don't like the underscore versions
much, but symmetry with get_swap_page() would be nice.

How about put_swap_page()? :)

That can call the appropriate swapcache_free function then.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
