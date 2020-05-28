From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: reclaim more aggressively before high
 allocator throttling
Date: Thu, 28 May 2020 18:31:01 +0200
Message-ID: <20200528163101.GJ27484@dhcp22.suse.cz>
References: <20200520160756.GE6462@dhcp22.suse.cz>
 <20200520165131.GB630613@cmpxchg.org>
 <20200520170430.GG6462@dhcp22.suse.cz>
 <20200520175135.GA793901@cmpxchg.org>
 <20200521073245.GI6462@dhcp22.suse.cz>
 <20200521135152.GA810429@cmpxchg.org>
 <20200521143515.GU6462@dhcp22.suse.cz>
 <20200521163833.GA813446@cmpxchg.org>
 <20200521173701.GX6462@dhcp22.suse.cz>
 <20200521184505.GA815980@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200521184505.GA815980-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu 21-05-20 14:45:05, Johannes Weiner wrote:
> On Thu, May 21, 2020 at 07:37:01PM +0200, Michal Hocko wrote:
> > On Thu 21-05-20 12:38:33, Johannes Weiner wrote:
> > > On Thu, May 21, 2020 at 04:35:15PM +0200, Michal Hocko wrote:
> > > > On Thu 21-05-20 09:51:52, Johannes Weiner wrote:
> > > > > On Thu, May 21, 2020 at 09:32:45AM +0200, Michal Hocko wrote:
> > > > [...]
> > > > > > I am not saying the looping over try_to_free_pages is wrong. I do care
> > > > > > about the final reclaim target. That shouldn't be arbitrary. We have
> > > > > > established a target which is proportional to the requested amount of
> > > > > > memory. And there is a good reason for that. If any task tries to
> > > > > > reclaim down to the high limit then this might lead to a large
> > > > > > unfairness when heavy producers piggy back on the active reclaimer(s).
> > > > > 
> > > > > Why is that different than any other form of reclaim?
> > > > 
> > > > Because the high limit reclaim is a best effort rather than must to
> > > > either get over reclaim watermarks and continue allocation or meet the
> > > > hard limit requirement to continue.
> > > 
> > > It's not best effort. It's a must-meet or get put to sleep. You are
> > > mistaken about what memory.high is.
> > 
> > I do not see anything like that being documented. Let me remind you what
> > the documentation says:
> >   memory.high
> >         A read-write single value file which exists on non-root
> >         cgroups.  The default is "max".
> > 
> >         Memory usage throttle limit.  This is the main mechanism to
> >         control memory usage of a cgroup.  If a cgroup's usage goes
> >         over the high boundary, the processes of the cgroup are
> >         throttled and put under heavy reclaim pressure.
> > 
> >         Going over the high limit never invokes the OOM killer and
> >         under extreme conditions the limit may be breached.
> > 
> > My understanding is that breaching the limit is acceptable if the memory
> > is not reclaimable after placing a heavy reclaim pressure. We can
> > discuss what the heavy reclaim means but the underlying fact is that the
> > keeping the consumption under the limit is a best effort.
> 
> It says it's the main mechanism to control memory usage, and that
> "under extreme conditions the limit may be breached". This doesn't
> sound like "let's try some reclaim and see how it goes" to me.
> 
> As the person who designed and implemented this feature, it certainly
> wasn't the intention.
> 
> > Please also let me remind you that the best effort implementation has
> > been there since the beginning when the memory.high has been introduced.
> > Now you seem to be convinced that the semantic is _obviously_ different.
> >
> > It is not the first time when the high limit behavior has changed.
> > Mostly based on "what is currently happening in your fleet". And can see
> > why it is reasonable to adopt to a real life usage. That is OK most of
> > the time. But I haven't heard why keeping the existing approach and
> > enforcing the reclaim target is not working properly so far. All I can
> > hear is a generic statement that consistency matters much more than all
> > potential problem it might introduce.
> 
> The assumption when writing the first implementation was that the full
> reclaim cycle that we impose on every subsequent allocation was enough
> to 1) mount a significant effort to push back allocations or 2) if it
> fails, at least hold up allocations enough to curb further growth.
> 
> As it turned out when deploying this code at scale, reclaim is not
> sufficient to achieve #2, because it simply may fail with not that
> many pages to scan - especially on systems without swap. So after
> observing a violation of the promised behavior, we added the sleeps
> for situations where reclaim fails to contain the workload as stated.
> 
> After adding the sleeps, we noticed - again after deploying at scale -
> that in certain situations reclaim isn't failing but simply returning
> early, and we go to sleep and get OOM killed on full file LRUs.
> 
> After analyzing this problem, it's clear that we had an oversight
> here: all other reclaimers are already familiar with the fact that
> reclaim may not be able to complete the reclaim target in one call, or
> that page reclaim is inherently racy and reclaim work can be stolen.

There is no disagreement here.

> We send a simple bug fix: bring this instance of reclaim in line with
> how everybody else is using the reclaim API, to meet the semantics as
> they are intendend and documented.

Here is where we are not on the same page though. Once you have identified
that the main problem is that the reclaim fails too early to meet the
target then the fix would be to enforce that target. I have asked why
this hasn't been done and haven't got any real answer for that. Instead
what you call "a simple bug fix" has larger consequences which are not
really explained in the changelog and they are also not really trivial
to see. If the changelog explicitly stated that the proportional memory
reclaim is not sufficient because XYZ and the implementation has been
changed to instead meet the high limit target then this would be a
completely different story and I believe we could have saved some
discussion.

> And somehow this is controversial, and we're just changing around user
> promises as we see fit for our particular usecase?
> 
> I don't even understand how the supposed alternate semantics you read
> between the lines in the documentation would make for a useful
> feature: It may fail to contain a group of offending tasks to the
> configured limit, but it will be fair to those tasks while doing so?
> 
> > But if your really want to push this through then let's do it
> > properly at least. memcg->memcg_nr_pages_over_high has only very
> > vague meaning if the reclaim target is the high limit.
> 
> task->memcg_nr_pages_over_high is not vague, it's a best-effort
> mechanism to distribute fairness. It's the current task's share of the
> cgroup's overage, and it allows us in the majority of situations to
> distribute reclaim work and sleeps in proportion to how much the task
> is actually at fault.

Agreed. But this stops being the case as soon as the reclaim target has
been reached and new reclaim attempts are enforced because the memcg is
still above the high limit. Because then you have a completely different
reclaim target - get down to the limit. This would be especially visible
with a large memcg_nr_pages_over_high which could even lead to an over
reclaim.
-- 
Michal Hocko
SUSE Labs
