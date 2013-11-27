From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
Date: Wed, 27 Nov 2013 11:34:36 -0500
Message-ID: <20131127163435.GA3556@cmpxchg.org>
References: <alpine.DEB.2.02.1311131416460.23211@chino.kir.corp.google.com>
 <20131113233419.GJ707@cmpxchg.org>
 <alpine.DEB.2.02.1311131649110.6735@chino.kir.corp.google.com>
 <20131114032508.GL707@cmpxchg.org>
 <alpine.DEB.2.02.1311141447160.21413@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1311141525440.30112@chino.kir.corp.google.com>
 <20131118154115.GA3556@cmpxchg.org>
 <20131118165110.GE32623@dhcp22.suse.cz>
 <20131122165100.GN3556@cmpxchg.org>
 <alpine.DEB.2.02.1311261648570.21003@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=BEalJQVtS6VUucnUUKHFy27j1c2mF0GPQs4+FZVRfvI=;
	b=hpxriSMQbPKJpC9dDfzywIosKSqX9cSayU04Lbml8Pfoo+3IrO6TyTLX6qq6Vdqw8nbWSIMLMkKgmExrn8//i/g6N6HqYpac9QjUzfVvkCKrKwvpUOsL0krLONWUvNyQO8gzlqyBbIAVwIxfVznKJyhGUyAmv7cHo5Llysb8028=;
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311261648570.21003-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Nov 26, 2013 at 04:53:47PM -0800, David Rientjes wrote:
> On Fri, 22 Nov 2013, Johannes Weiner wrote:
> 
> > But userspace in all likeliness DOES need to take action.
> > 
> > Reclaim is a really long process.  If 5 times doing 12 priority cycles
> > and scanning thousands of pages is not enough to reclaim a single
> > page, what does that say about the health of the memcg?
> > 
> > But more importantly, OOM handling is just inherently racy.  A task
> > might receive the kill signal a split second *after* userspace was
> > notified.  Or a task may exit voluntarily a split second after a
> > victim was chosen and killed.
> > 
> 
> That's not true even today without the userspace oom handling proposal 
> currently being discussed if you have a memcg oom handler attached to a 
> parent memcg with access to more memory than an oom child memcg.  The oom 
> handler can disable the child memcg's oom killer with memory.oom_control 
> and implement its own policy to deal with any notification of oom.

I was never implying the kernel handler.  All the races exist with
userspace handling as well.

> This patch is required to ensure that in such a scenario that the oom 
> handler sitting in the parent memcg only wakes up when it's required to 
> intervene.

A task could receive an unrelated kill between the OOM notification
and going to sleep to wait for userspace OOM handling.  Or another
task could exit voluntarily between the notification and waitqueue
entry, which would again be short-cut by the oom_recover of the exit
uncharges.

oom:                           other tasks:
check signal/exiting
                               could exit or get killed here
mem_cgroup_oom_trylock()
                               could exit or get killed here
mem_cgroup_oom_notify()
                               could exit or get killed here
if (userspace_handler)
  sleep()                      could exit or get killed here
else
  oom_kill()
                               could exit or get killed here

It does not matter where your signal/exiting check is, OOM
notification can never be race free because OOM is just an arbitrary
line we draw.  We have no idea what all the tasks are up to and how
close they are to releasing memory.  Even if we freeze the whole group
to handle tasks, it does not change the fact that the userspace OOM
handler might kill one task and after the unfreeze another task
immediately exits voluntarily or got a kill signal a split second
after it was frozen.

You can't fix this.  We just have to draw the line somewhere and
accept that in rare situations the OOM kill was unnecessary.  So
again, I don't see this patch is doing anything but blur the current
line and make notification less predictable.  And, as someone else in
this thread already said, it's a uservisible change in behavior and
would break known tuning usecases.
