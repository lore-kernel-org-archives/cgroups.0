From: "Huang\, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH -mm -v9 1/3] mm, THP, swap: Delay splitting THP during swap out
Date: Sat, 22 Apr 2017 08:07:12 +0800
Message-ID: <87bmrpe24v.fsf@yhuang-dev.intel.com>
References: <20170419070625.19776-1-ying.huang@intel.com>
        <20170419070625.19776-2-ying.huang@intel.com>
        <1492755096.24636.2.camel@gmail.com>
        <20170421140812.GA15918@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170421140812.GA15918-druUgvl0LCNAfugRpC6u6w@public.gmane.org> (Johannes Weiner's message
        of "Fri, 21 Apr 2017 10:08:12 -0400")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ebru Akagunduz <ebru.akagunduz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> writes:

> On Fri, Apr 21, 2017 at 04:11:36PM +1000, Balbir Singh wrote:
>> > In the future of THP swap optimization, some information of the
>> > swapped out THP (such as compound map count) will be recorded in the
>> > swap_cluster_info data structure.
>> > 
>> > The mem cgroup swap accounting functions are enhanced to support
>> > charge or uncharge a swap cluster backing a THP as a whole.
>> 
>> Thanks and in the future it will be good to add stats to indicate
>> the number of THP swapped out for tracking.
>
> Agreed. Huang, can you include stats from your test that show how many
> times we succeed and how many times we fall back to splitting?

Sorry, I don't fully understand your words.  If my understanding were
correct, Balbir is asking some stats in /proc/vmstat.  For now, the
stats we can provide is how many success swap cluster allocations and
swap cache addings, and how many fails for them.  And in the next step
(to split THP after swapping out), we can add stats for how many THP
swapped out (written with 2M IO and reclaimed).  So I suggest to add two
stats, thp_swpout and thp_swpout_fallback in the next step.  What do you
think about that?

>> > With the patch, the swap out throughput improves 11.5% (from about
>> > 3.73GB/s to about 4.16GB/s) in the vm-scalability swap-w-seq test case
>> > with 8 processes.  The test is done on a Xeon E5 v3 system.  The swap
>> > device used is a RAM simulated PMEM (persistent memory) device. 
>> 
>> I am not sure if RAM simulating PMEM is a fair way to test, its just
>> memcpy and no swap out.
>
> It would be good to know exactly what simulating PMEM means. Does it
> add some artificial delay, or is it a simple ramfs that holds a swap
> file?

No artificial delay, just a RAM simulated block device implemented with
memcpy.

> IMO, this patch isn't a pure cycles-optimization anyway in the "reduce
> instructions involved in this path" sense. It's the groundwork to make
> swapping THP-native. So slimming down the cycles is great, but the
> infrastructure work to later do 2MB TLB shootdown and swap with 2MB IO
> holds more weight for me.

Yes.  Performance improvement is not the emphasis of this step, but will
be of the next step.

>> > @@ -326,11 +326,14 @@ PAGEFLAG_FALSE(HighMem)
>> >  #ifdef CONFIG_SWAP
>> >  static __always_inline int PageSwapCache(struct page *page)
>> >  {
>> > +#ifdef CONFIG_THP_SWAP
>> > +	page = compound_head(page);
>> > +#endif
>> 
>> Can we please add a static inline THPSwapPage() that returns page_compound(page)
>> for CONFIG_THP_SWAP and page otherwise?
>
> Where else would it be used?
>
> I think it'd be preferable to leave this #ifdef wart as a reminder
> that we need to revisit this.
>
>> > @@ -5929,25 +5929,26 @@ int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry)
>> >  	memcg = mem_cgroup_id_get_online(memcg);
>> >  
>> >  	if (!mem_cgroup_is_root(memcg) &&
>> > -	    !page_counter_try_charge(&memcg->swap, 1, &counter)) {
>> > +	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
>> >  		mem_cgroup_id_put(memcg);
>> >  		return -ENOMEM;
>> >  	}
>> >  
>> > -	oldid = swap_cgroup_record(entry, mem_cgroup_id(memcg));
>> > +	if (nr_pages > 1)
>> > +		mem_cgroup_id_get_many(memcg, nr_pages - 1);
>> 
>> The nr_pages -1 is not initutive, a comment about mem_cgroup_id_get_online()
>> getting 1 would help.
>
> Agreed. Something like this might help:
>
> 	/* Get references for the tail pages, too */

Good suggestion!  I will add this.

>> > @@ -1066,6 +1155,33 @@ void swapcache_free(swp_entry_t entry)
>> >  	}
>> >  }
>> >  
>> > +#ifdef CONFIG_THP_SWAP
>> > +void swapcache_free_cluster(swp_entry_t entry)
>> > +{
>> > +	unsigned long offset = swp_offset(entry);
>> > +	unsigned long idx = offset / SWAPFILE_CLUSTER;
>> > +	struct swap_cluster_info *ci;
>> > +	struct swap_info_struct *si;
>> > +	unsigned char *map;
>> > +	unsigned int i;
>> > +
>> > +	si = swap_info_get(entry);
>> > +	if (!si)
>> > +		return;
>> > +
>> > +	ci = lock_cluster(si, offset);
>> > +	map = si->swap_map + offset;
>> > +	for (i = 0; i < SWAPFILE_CLUSTER; i++) {
>> > +		VM_BUG_ON(map[i] != SWAP_HAS_CACHE);
>> > +		map[i] = 0;
>> > +	}
>> > +	unlock_cluster(ci);
>> > +	mem_cgroup_uncharge_swap(entry, SWAPFILE_CLUSTER);
>> > +	swap_free_cluster(si, idx);
>> > +	spin_unlock(&si->lock);
>> > +}
>> > +#endif /* CONFIG_THP_SWAP */
>> > +
>> >  static int swp_entry_cmp(const void *ent1, const void *ent2)
>> >  {
>> >  	const swp_entry_t *e1 = ent1, *e2 = ent2;
>> 
>> 
>> This is a massive patch, I presume you've got recommendations to keep it
>> this way?
>
> It used to be split into patches that introduce API and helpers on one
> hand and patches that use these functions on the other hand. That was
> impossible to review, because you had to jump between emails.
>
> If you have ideas about which parts could be split out and be
> stand-alone changes in their own right, I'd be all for that.

Best Regards,
Huang, Ying
