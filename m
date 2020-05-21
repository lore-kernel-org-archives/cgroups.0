From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: reclaim more aggressively before high
 allocator throttling
Date: Thu, 21 May 2020 09:51:52 -0400
Message-ID: <20200521135152.GA810429@cmpxchg.org>
References: <20200520143712.GA749486@chrisdown.name>
 <20200520160756.GE6462@dhcp22.suse.cz>
 <20200520165131.GB630613@cmpxchg.org>
 <20200520170430.GG6462@dhcp22.suse.cz>
 <20200520175135.GA793901@cmpxchg.org>
 <20200521073245.GI6462@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XwCSng/94legV1mcHYyPkc3NygJbqYU/Ybm4UW2cFnc=;
        b=OHZQyvdYSZ6JRp9IbgeegeKt0MAL0uQ1xMZdiu/W8+t2rBCnbPXPXeTTd6rilgPfeI
         6MitxnuvJgQJHL0nZc02kTWc2y1Y3tKgAo/byzu8pyxRj/1TmdU5576IBsGeaL+pj6Zo
         XgiwudgEWu5tuuF52f01EunkA5dwtvf01Bk7KQiqCzT1qokaRUbJeaOvAe5zS1d+sAsR
         pm77/NdnmnVcp0gUSp8W9UEZCiTlldMxQ2X6x4bdSWooaxYbIQDzkHtxMc/amYKqmM2J
         sq/OlTO/bYu8sGELaQLBGs+PXgNZt7ZLTWKlJG3h2IF5rrHwziwPwj2FgJvVc54GUO/X
         O8eQ==
Content-Disposition: inline
In-Reply-To: <20200521073245.GI6462-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu, May 21, 2020 at 09:32:45AM +0200, Michal Hocko wrote:
> On Wed 20-05-20 13:51:35, Johannes Weiner wrote:
> > On Wed, May 20, 2020 at 07:04:30PM +0200, Michal Hocko wrote:
> > > On Wed 20-05-20 12:51:31, Johannes Weiner wrote:
> > > > On Wed, May 20, 2020 at 06:07:56PM +0200, Michal Hocko wrote:
> > > > > On Wed 20-05-20 15:37:12, Chris Down wrote:
> > > > > > In Facebook production, we've seen cases where cgroups have been put
> > > > > > into allocator throttling even when they appear to have a lot of slack
> > > > > > file caches which should be trivially reclaimable.
> > > > > > 
> > > > > > Looking more closely, the problem is that we only try a single cgroup
> > > > > > reclaim walk for each return to usermode before calculating whether or
> > > > > > not we should throttle. This single attempt doesn't produce enough
> > > > > > pressure to shrink for cgroups with a rapidly growing amount of file
> > > > > > caches prior to entering allocator throttling.
> > > > > > 
> > > > > > As an example, we see that threads in an affected cgroup are stuck in
> > > > > > allocator throttling:
> > > > > > 
> > > > > >     # for i in $(cat cgroup.threads); do
> > > > > >     >     grep over_high "/proc/$i/stack"
> > > > > >     > done
> > > > > >     [<0>] mem_cgroup_handle_over_high+0x10b/0x150
> > > > > >     [<0>] mem_cgroup_handle_over_high+0x10b/0x150
> > > > > >     [<0>] mem_cgroup_handle_over_high+0x10b/0x150
> > > > > > 
> > > > > > ...however, there is no I/O pressure reported by PSI, despite a lot of
> > > > > > slack file pages:
> > > > > > 
> > > > > >     # cat memory.pressure
> > > > > >     some avg10=78.50 avg60=84.99 avg300=84.53 total=5702440903
> > > > > >     full avg10=78.50 avg60=84.99 avg300=84.53 total=5702116959
> > > > > >     # cat io.pressure
> > > > > >     some avg10=0.00 avg60=0.00 avg300=0.00 total=78051391
> > > > > >     full avg10=0.00 avg60=0.00 avg300=0.00 total=78049640
> > > > > >     # grep _file memory.stat
> > > > > >     inactive_file 1370939392
> > > > > >     active_file 661635072
> > > > > > 
> > > > > > This patch changes the behaviour to retry reclaim either until the
> > > > > > current task goes below the 10ms grace period, or we are making no
> > > > > > reclaim progress at all. In the latter case, we enter reclaim throttling
> > > > > > as before.
> > > > > 
> > > > > Let me try to understand the actual problem. The high memory reclaim has
> > > > > a target which is proportional to the amount of charged memory. For most
> > > > > requests that would be SWAP_CLUSTER_MAX though (resp. N times that where
> > > > > N is the number of memcgs in excess up the hierarchy). I can see to be
> > > > > insufficient if the memcg is already in a large excess but if the
> > > > > reclaim can make a forward progress this should just work fine because
> > > > > each charging context should reclaim at least the contributed amount.
> > > > > 
> > > > > Do you have any insight on why this doesn't work in your situation?
> > > > > Especially with such a large inactive file list I would be really
> > > > > surprised if the reclaim was not able to make a forward progress.
> > > > 
> > > > The workload we observed this in was downloading a large file and
> > > > writing it to disk, which means that a good chunk of that memory was
> > > > dirty. The first reclaim pass appears to make little progress because
> > > > it runs into dirty pages.
> > > 
> > > OK, I see but why does the subsequent reclaim attempt makes a forward
> > > progress? Is this just because dirty pages are flushed in the mean time?
> > > Because if this is the case then the underlying problem seems to be that
> > > the reclaim should be throttled on dirty data.
> > 
> > That's what I assume. Chris wanted to do more reclaim tracing. But is
> > this actually important beyond maybe curiosity?
> 
> Yes, because it might show that there is a deeper problem. Having an
> extremely large file list full of dirty data and pre-mature failure for
> the reclaim sounds like a problem that is worth looking into closely.
> 
> > We retry every other reclaim invocation on forward progress. There is
> > not a single naked call to try_to_free_pages(), and this here is the
> > only exception where we don't loop on try_to_free_mem_cgroup_pages().
> 
> I am not saying the looping over try_to_free_pages is wrong. I do care
> about the final reclaim target. That shouldn't be arbitrary. We have
> established a target which is proportional to the requested amount of
> memory. And there is a good reason for that. If any task tries to
> reclaim down to the high limit then this might lead to a large
> unfairness when heavy producers piggy back on the active reclaimer(s).

Why is that different than any other form of reclaim?

> I wouldn't mind to loop over try_to_free_pages to meet the requested
> memcg_nr_pages_over_high target.

Should we do the same for global reclaim? Move reclaim to userspace
resume where there are no GFP_FS, GFP_NOWAIT etc. restrictions and
then have everybody just reclaim exactly what they asked for, and punt
interrupts / kthread allocations to a worker/kswapd?

> > > > > Also if the current high reclaim scaling is insufficient then we should
> > > > > be handling that via memcg_nr_pages_over_high rather than effectivelly
> > > > > unbound number of reclaim retries.
> > > > 
> > > > ???
> > > 
> > > I am not sure what you are asking here.
> > 
> > You expressed that some alternate solution B would be preferable,
> > without any detail on why you think that is the case.
> > 
> > And it's certainly not obvious or self-explanatory - in particular
> > because Chris's proposal *is* obvious and self-explanatory, given how
> > everybody else is already doing loops around page reclaim.
> 
> Sorry, I could have been less cryptic. I hope the above and my response
> to Chris goes into more details why I do not like this proposal and what
> is the alternative. But let me summarize. I propose to use memcg_nr_pages_over_high
> target. If the current calculation of the target is unsufficient - e.g.
> in situations where the high limit excess is very large then this should
> be reflected in memcg_nr_pages_over_high.
> 
> Is it more clear?

Well you haven't made a good argument why memory.high is actually
different than any other form of reclaim, and why it should be the
only implementation of page reclaim that has special-cased handling
for the inherent "unfairness" or rather raciness of that operation.

You cut these lines from the quote:

  Under pressure, page reclaim can struggle to satisfy the reclaim
  goal and may return with less pages reclaimed than asked to.

  Under concurrency, a parallel allocation can invalidate the reclaim
  progress made by a thread.

Even if we *could* invest more into trying to avoid any unfairness,
you haven't made a point why we actually should do that here
specifically, yet not everywhere else.

(And people have tried to do it for global reclaim[1], but clearly
this isn't a meaningful problem in practice.)

I have a good reason why we shouldn't: because it's special casing
memory.high from other forms of reclaim, and that is a maintainability
problem. We've recently been discussing ways to make the memory.high
implementation stand out less, not make it stand out even more. There
is no solid reason it should be different from memory.max reclaim,
except that it should sleep instead of invoke OOM at the end. It's
already a mess we're trying to get on top of and straighten out, and
you're proposing to add more kinks that will make this work harder.

I have to admit, I'm baffled by this conversation. I consider this a
fairly obvious, idiomatic change, and I cannot relate to the
objections or counter-proposals in the slightest.

[1] http://lkml.iu.edu/hypermail//linux/kernel/0810.0/0169.html
