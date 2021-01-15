From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: prevent starvation when writing
 memory.high
Date: Fri, 15 Jan 2021 13:27:23 -0800
Message-ID: <20210115212723.GB631549@carbon.dhcp.thefacebook.com>
References: <20210112163011.127833-1-hannes@cmpxchg.org>
 <20210113144654.GD22493@dhcp22.suse.cz>
 <YAHA4uBSLlnxxAbu@cmpxchg.org>
 <20210115170341.GA631549@carbon.dhcp.thefacebook.com>
 <YAIBSJg3btQ+2CNZ@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=TGv8+tiQluOxzdEi4rn/IaPCPnwCDLYSKoUBMnhCqWk=;
 b=c7nrVyZzd6AsEEa8dMcPTP5vfnYe8/RiKLPaQhlY9ewRu+VYrOMZ/R5yVXXsCV9wFjxO
 gKbbIEe4pGHRTwTmYlFUOvIEoCka8VYIl9dVnrAhANJ4yt/EmXVL68salzwBsxOVnO0d
 2SZd6e/NMKJzu6NSR7rDK7Slg+ByyfWDZ+k= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TGv8+tiQluOxzdEi4rn/IaPCPnwCDLYSKoUBMnhCqWk=;
 b=SuXu61Ca4l/o/JavP/pkxQi30TktAvw51In7wnrliFtdTJj8NEGqrMDfqVZxp2F1qBaGDgMFS3BkiBppgO0E7KBZFiqweESmP/BLBHw5qpQyORLc9dF8OPCkp1eG9H8MwgBjr1WflPN7nisLkr3pmC2zR6IbkMObrRCPIOfXmEI=
Content-Disposition: inline
In-Reply-To: <YAIBSJg3btQ+2CNZ-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, Jan 15, 2021 at 03:55:36PM -0500, Johannes Weiner wrote:
> On Fri, Jan 15, 2021 at 09:03:41AM -0800, Roman Gushchin wrote:
> > On Fri, Jan 15, 2021 at 11:20:50AM -0500, Johannes Weiner wrote:
> > > On Wed, Jan 13, 2021 at 03:46:54PM +0100, Michal Hocko wrote:
> > > > On Tue 12-01-21 11:30:11, Johannes Weiner wrote:
> > > > > When a value is written to a cgroup's memory.high control file, the
> > > > > write() context first tries to reclaim the cgroup to size before
> > > > > putting the limit in place for the workload. Concurrent charges from
> > > > > the workload can keep such a write() looping in reclaim indefinitely.
> > > > > 
> > > > > In the past, a write to memory.high would first put the limit in place
> > > > > for the workload, then do targeted reclaim until the new limit has
> > > > > been met - similar to how we do it for memory.max. This wasn't prone
> > > > > to the described starvation issue. However, this sequence could cause
> > > > > excessive latencies in the workload, when allocating threads could be
> > > > > put into long penalty sleeps on the sudden memory.high overage created
> > > > > by the write(), before that had a chance to work it off.
> > > > > 
> > > > > Now that memory_high_write() performs reclaim before enforcing the new
> > > > > limit, reflect that the cgroup may well fail to converge due to
> > > > > concurrent workload activity. Bail out of the loop after a few tries.
> > > > 
> > > > I can see that you have provided some more details in follow up replies
> > > > but I do not see any explicit argument why an excessive time for writer
> > > > is an actual problem. Could you be more specific?
> > > 
> > > Our writer isn't necessarily time sensitive, but there is a difference
> > > between a) the write taking a few seconds to reclaim down the
> > > requested delta and b) the writer essentially turning into kswapd for
> > > the workload and busy-spinning inside the kernel indefinitely.
> > > 
> > > We've seen the writer stuck in this function for minutes, long after
> > > the requested delta has been reclaimed, consuming alarming amounts of
> > > CPU cycles - CPU time that should really be accounted to the workload,
> > > not the system software performing the write.
> > > 
> > > Obviously, we could work around it using timeouts and signals. In
> > > fact, we may have to until the new kernel is deployed everywhere. But
> > > this is the definition of an interface change breaking userspace, so
> > > I'm a bit surprised by your laid-back response.
> > > 
> > > > > Fixes: 536d3bf261a2 ("mm: memcontrol: avoid workload stalls when lowering memory.high")
> > > > > Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 5.8+
> > > > 
> > > > Why is this worth backporting to stable? The behavior is different but I
> > > > do not think any of them is harmful.
> > > 
> > > The referenced patch changed user-visible behavior in a way that is
> > > causing real production problems for us. From stable-kernel-rules:
> > > 
> > >  - It must fix a real bug that bothers people (not a, "This could be a
> > >    problem..." type thing).
> > > 
> > > > > Reported-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > > > > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > > > 
> > > > I am not against the patch. The existing interface doesn't provide any
> > > > meaningful feedback to the userspace anyway. User would have to re check
> > > > to see the result of the operation. So how hard we try is really an
> > > > implementation detail.
> > > 
> > > Yeah, I wish it was a bit more consistent from an interface POV.
> > > 
> > > Btw, if you have noticed, Roman's patch to enforce memcg->high *after*
> > > trying to reclaim went into the tree at the same exact time as Chris's
> > > series "mm, memcg: reclaim harder before high throttling" (commit
> > > b3ff92916af3b458712110bb83976a23471c12fa). It's likely they overlap.
> > > 
> > > Chris's patch changes memory.high reclaim on the allocation side from
> > > 
> > > 	reclaim once, sleep if there is still overage
> > > 
> > > to
> > > 
> > > 	reclaim the overage as long as you make forward progress;
> > > 	sleep after 16 no-progress loops if there is still overage
> > > 
> > > Roman's patch describes a problem where allocating threads go to sleep
> > > when memory.high is lowered by a wider step. This is exceedingly
> > > unlikely after Chris's change.
> > > 
> > > Because after Chris's change, memory.high is reclaimed on the
> > > allocation side as aggressively as memory.max. The only difference is
> > > that upon failure, one sleeps and the other OOMs.
> > > 
> > > If Roman's issue were present after Chris's change, then we'd also see
> > > premature OOM kills when memory.max is lowered by a large step. And I
> > > have never seen that happening.
> > > 
> > > So I suggest instead of my fix here, we revert Roman's patch instead,
> > > as it should no longer be needed. Thoughts?
> > 
> > Chris's patch was merged way earlier than mine into the kernel tree which
> > was used when I observed the problem in the production. So likely it was there.
> 
> Chris's patch was in the tree earlier, but the first release
> containing it was tagged a day before you put in your change, so I
> doubt it was on the production system where you observed the issue.
> 
> As per above, it'd be very surprising to see premature sleeps when
> lowering memory.high, when allocation-side reclaim keeps going until
> the cgroup meets the definition of OOM.
> 
> > I think it makes sense to try to reclaim memory first before putting
> > all processes in the cgroup into reclaim mode. Even without artificial delays
> > it creates some latency and btw doesn't make the reclaim process more efficient.
> 
> It's not obvious that this is a practical problem. It certainly isn't
> for memory.max,

Because memory.max is usually not adjusted dynamically?

> and there should be a good reason why the two should
> be different aside from the documented OOM vs sleep behavior.

Maybe we have different examples in our heads, but mine is a cgroup
with a significant amount of relatively cold pagecache and a multi-threaded
workload. Now somebody wants to tighten memory.high. Why would we put all
threads into a direct reclaim? I don't see a good reason.

Memory.max is different because nobody (hopefully) is adjusting it dynamically
to be just a little bit bigger than the workingset. Most likely it's set
once that after the creation of a cgroup. So such a problem just doesn't exist.
