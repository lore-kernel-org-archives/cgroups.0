From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: reclaim more aggressively before high
 allocator throttling
Date: Thu, 21 May 2020 14:04:55 +0200
Message-ID: <20200521120455.GM6462@dhcp22.suse.cz>
References: <20200520143712.GA749486@chrisdown.name>
 <20200520160756.GE6462@dhcp22.suse.cz>
 <20200520202650.GB558281@chrisdown.name>
 <20200521071929.GH6462@dhcp22.suse.cz>
 <20200521112711.GA990580@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200521112711.GA990580-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu 21-05-20 12:27:11, Chris Down wrote:
> Michal Hocko writes:
> > On Wed 20-05-20 21:26:50, Chris Down wrote:
> > > Michal Hocko writes:
> > > > Let me try to understand the actual problem. The high memory reclaim has
> > > > a target which is proportional to the amount of charged memory. For most
> > > > requests that would be SWAP_CLUSTER_MAX though (resp. N times that where
> > > > N is the number of memcgs in excess up the hierarchy). I can see to be
> > > > insufficient if the memcg is already in a large excess but if the
> > > > reclaim can make a forward progress this should just work fine because
> > > > each charging context should reclaim at least the contributed amount.
> > > >
> > > > Do you have any insight on why this doesn't work in your situation?
> > > > Especially with such a large inactive file list I would be really
> > > > surprised if the reclaim was not able to make a forward progress.
> > > 
> > > Reclaim can fail for any number of reasons, which is why we have retries
> > > sprinkled all over for it already. It doesn't seem hard to believe that it
> > > might just fail for transient reasons and drive us deeper into the hole as a
> > > result.
> > 
> > Reclaim can certainly fail. It is however surprising to see it fail with
> > such a large inactive lru list and reasonably small reclaim target.
> 
> Why do you think the reclaim target is small? In the case of generating tons
> of dirty pages, current->memcg_nr_pages_over_high can grow to be huge (on
> the order of several tens of megabytes or more).

Because from my experience there are not tons of charges inside one
syscall usually. Yeah, some syscalls can generate a lot of them but that
shouldn't be a majority.

> > Having the full LRU of dirty pages sounds a bit unusual, IO throttling
> > for v2 and explicit throttling during the reclaim for v1 should prevent
> > from that. If the reclaim gives up too easily then this should be
> > addressed at the reclaim level.
> 
> I'm not sure I agree. Reclaim knows what you asked it to do: reclaim N
> pages, but what to do about the situation when it fails to satisfy that is a
> job for the caller. In this case, we are willing to even tolerate a little
> bit of overage up to the 10ms throttle threshold. In other cases, we want to
> do other checks first before retrying, because the tradeoffs are different.
> Putting all of this inside the reclaim logic seems unwieldy.

That is not what I meant. We do have some throttling inside the reclaim
because failing reclaim too quickly can easily lead to pre mature OOMs.
If that doesn't work then we should have a look why. E.g. it is quite
unexpected to have large LRU full of dirty pages because this suggests
that dirty throttling doesn't work properly.

> > The main problem I see with that approach is that the loop could easily
> > lead to reclaim unfairness when a heavy producer which doesn't leave the
> > kernel (e.g. a large read/write call) can keep a different task doing
> > all the reclaim work. The loop is effectivelly unbound when there is a
> > reclaim progress and so the return to the userspace is by no means
> > proportional to the requested memory/charge.
> 
> It's not unbound when there is reclaim progress, it stops when we are within
> the memory.high throttling grace period. Right after reclaim, we check if
> penalty_jiffies is less than 10ms, and abort and further reclaim or
> allocator throttling:

Just imagine that you have parallel producers increasing the high limit
excess while somebody reclaims those. Sure in practice the loop will be
bounded but the reclaimer might perform much more work on behalf of
other tasks.
-- 
Michal Hocko
SUSE Labs
