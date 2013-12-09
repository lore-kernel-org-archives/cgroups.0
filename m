From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
Date: Mon, 9 Dec 2013 18:05:27 -0500
Message-ID: <20131209230527.GL21724@cmpxchg.org>
References: <alpine.DEB.2.02.1311261648570.21003@chino.kir.corp.google.com>
 <20131127163435.GA3556@cmpxchg.org>
 <20131202200221.GC5524@dhcp22.suse.cz>
 <20131202212500.GN22729@cmpxchg.org>
 <20131203120454.GA12758@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312031544530.5946@chino.kir.corp.google.com>
 <20131204111318.GE8410@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312041606260.6329@chino.kir.corp.google.com>
 <20131209124840.GC3597@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312091328550.11026@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=r1O+pUEHUf/bInL0k0jBqinyo3ksGHAcjY4BqUqVs7k=;
	b=maWDzsqVZiy68Zu9NrK5jsBAkNge52zE9imTLmxTkfKHkv2vS7d7xoT0In3qBFsTx+AI4NPtBXplMKjawckg9Px3L2zBRsjTlTidQfs5htSSTyd89dwnOuSnx5r63/bzEe7uShODV2NMoxDDM8isOWaUIPvp/5ZcjSIwjfXvVfE=;
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1312091328550.11026@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On Mon, Dec 09, 2013 at 01:46:16PM -0800, David Rientjes wrote:
> On Mon, 9 Dec 2013, Michal Hocko wrote:
> 
> > > Google depends on getting memory.oom_control notifications only when they 
> > > are actionable, which is exactly how Documentation/cgroups/memory.txt 
> > > describes how userspace should respond to such a notification.
> > > 
> > > "Actionable" here means that the kernel has exhausted its capabilities of 
> > > allowing for future memory freeing, which is the entire premise of any oom 
> > > killer.
> > > 
> > > Giving a dying process or a process that is going to subsequently die 
> > > access to memory reserves is a capability the kernel users to ensure 
> > > progress is made in oom conditions.  It is not an exhaustion of 
> > > capabilities.
> > > 
> > > Yes, we all know that subsequent to the userspace notification that memory 
> > > may be freed and the kill no longer becomes required.  There is nothing 
> > > that can be done about that, and it has never been implied that a memcg is 
> > > guaranteed to still be oom when the process wakes up.
> > > 
> > > I'm referring to a siutation that can manifest in a number of ways: 
> > > coincidental process exit, coincidental process being killed, 
> > > VMPRESSURE_CRITICAL notification that results in a process being killed, 
> > > or memory threshold notification that results in a process being killed.  
> > > Regardless, we're talking about a situation where something is already 
> > > in the exit path or has been killed and is simply attempting to free its 
> > > memory.
> > 
> > You have already mentioned that. Several times in fact. And I do
> > understand what you are saying. You are just not backing your claims
> > with anything that would convince us that what you are trying to solve
> > is an issue in the real life. So show us it is real, please.
> > 
> 
> What exactly would you like to see?  It's obvious that the kernel has not 
> exhausted its capabilities of allowing for future memory freeing if the 
> notification happens before the check for current->flags & PF_EXITING or 
> fatal_signal_pending(current).  Does that conditional get triggered?  ALL 
> THE TIME.

We check for fatal signals during the repeated charge attempts and
reclaim.  Should we be checking for PF_EXITING too?

> We know it happens because I had to introduce it into both the 
> system oom killer and the memcg oom killer to fix mm->mmap_sem issues for 
> threads that were killed as part of the oom killer SIGKILL but weren't the 
> thread lucky enough to get TIF_MEMDIE set and they were in the allocation 
> path.
>
> Are you asking me to patch our kernel, get it rolled out, and plot a graph 
> to show how often it gets triggered over time in our datacenters and that 
> it causes us to get unnecessary oom kill notifications?

I asked this because you were talking about all this nonsense of
last-second checks and the probability of unnecessary kills.

You kept insisting that this check has to be the last action before
the OOM kill, which was an entirely different motivation for this
change and I questioned the validity of this claim repeatedly during
this thread, to which you never answered.

You even re-inforced this motivation by suggesting the separate memcg
margin check right before the OOM kill, so don't blame us for
misunderstanding the exact placement of this check as your main
argument when you repeated it over and over.

All I object to is that the OOM killer is riddled with last-second
checks of whether the OOM situation is still existant.  We establish
that the context is OOM and once we are certain we are executing,
period.

Not catching PF_EXITING in the long window between the first reclaim
and going OOM is a separate issue and I can see that this should be
fixed but it should be checked before we start invoking OOM.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
