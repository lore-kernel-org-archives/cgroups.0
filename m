From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v5 00/31] kmemcg shrinkers
Date: Thu, 9 May 2013 15:34:25 +0400
Message-ID: <518B89C1.8090304@parallels.com>
References: <1368079608-5611-1-git-send-email-glommer@openvz.org> <20130509105519.GQ11497@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130509105519.GQ11497-l3A5Bk7waGM@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Cc: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 05/09/2013 02:55 PM, Mel Gorman wrote:
> On Thu, May 09, 2013 at 10:06:17AM +0400, Glauber Costa wrote:
>> [ Sending again, forgot to CC fsdevel. Shame on me ]
>> To Mel
>> ======
>>
> 
> I'm surprised Dave Chinner is not on the cc. He may or may not see it
> on fsdevel.
> 

Yeah, I have been screwing up CC's =( Included one, forgot the other.
Still, I would expect Dave to be seeing most patches here, since he will
be automatically on the CC for most of the individual patches.

>> Mel, I have identified the overly aggressive behavior you noticed to be a bug
>> in the at-least-one-pass patch, that would ask the shrinkers to scan the full
>> batch even when total_scan < batch. They would do their best for it, and
>> eventually succeed. I also went further, and made that the behavior of direct
>> reclaim only - The only case that really matter for memcg, and one in which
>> we could argue that we are more or less desperate for small squeezes in memory.
>> Thank you very much for spotting this.
>>
> 
> I haven't seen the relevant code yet but in general I do not think it is
> a good idea for direct reclaim to potentially reclaim all of slabs like
> this. Direct reclaim does not necessarily mean the system is desperate
> for small amounts of memory. Lets take a few examples where it would be
> a poor decision to reclaim all the slab pages within direct reclaim.
> 
> 1. Direct reclaim triggers because kswapd is stalled writing pages for
>    memcg (see code near comment "memcg doesn't have any dirty pages
>    throttling"). A memcg dirtying its limit of pages may cause a lot of
>    direct reclaim and dumping all the slab pages
> 
> 2. Direct reclaim triggers because kswapd is writing pages out to swap.
>    Similar to memcg above, kswapd failing to make forward progress triggers
>    direct reclaim which then potentially reclaims all slab
> 
> 3. Direct reclaim triggers because kswapd waits on congestion as there
>    are too many pages under writeback. In this case, a large amounts of
>    writes to slow storage like USB could result in all slab being reclaimed
> 
> 4. The system has been up a long time, memory is fragmented and the page
>    allocator enters direct reclaim/compaction to allocate THPs. It would
>    be very unfortunate if allocating a THP reclaimed all the slabs
> 

For the record: We are no longer reclaiming *all the slabs*, that was
the bug, and is fixed here. We are scanning a bit more, but my
preliminary tests indicate that this is not the reason. Today is a
holiday here, so I am half in the office, half outside. I plan to have
news soon.

That said, this is a minor part of the patchset, and I don't intend to
make a case for it. I am totally fine with the conservative route of
making it memcg specific + a comment explaining why this is happening.


> All that is potentially bad and likely to make Dave put in his cranky
> pants. I would much prefer if direct reclaim and kswapd treated slab
> similarly and not ask the shrinkers to do a full scan unless the alternative
> is OOM kill.
> 
>> Running postmark on the final result (at least on my 2-node box) show something
>> a lot saner. We are still stealing more inodes than before, but by a factor of
>> around 15 %. Since the correct balance is somewhat heuristic anyway - I
>> personally think this is acceptable. But I am waiting to hear from you on this
>> matter. Meanwhile, I am investigating further to try to pinpoint where exactly
>> this comes from. It might either be because of the new node-aware behavior, or
>> because of the increased calculation precision in the first patch.
>>
> 
> I'm going to defer to Dave as to whether that increased level of slab
> reclaim is acceptable or not.
> 
Dave?

In any case, it is probably sleep time for Dave, so I hope to be able to
by the time he sees this, provide a more definite explanation about why
we are seeing this increase.

>> In particular, I haven't done anything about your comment regarding MAX_NODES
>> array. After the memcg patches are applying, fixing this is a lot easier,
>> because memcg already departs from a static MAX_NODES array to a dynamic one.
>> I wanted, however, to keep the noise introduction down in something that I
>> expect to be merged soon. I would suggest merging a patch that fixes that
>> on top of the series, instead of the middle, if you really think it matters.
>> I, of course, commit to doing this in that case.
>>
> 
> I think fixing it on top would be reasonable assuming the other memcg people
> are happy with the memcg parts of the series. I didn't get a chance to look
> at them the last time and focused more on the API and per-node list changes.
> 

Great, thanks
