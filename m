From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
Date: Fri, 22 Nov 2013 11:51:00 -0500
Message-ID: <20131122165100.GN3556@cmpxchg.org>
References: <alpine.DEB.2.02.1310301838300.13556@chino.kir.corp.google.com>
 <20131031054942.GA26301@cmpxchg.org>
 <alpine.DEB.2.02.1311131416460.23211@chino.kir.corp.google.com>
 <20131113233419.GJ707@cmpxchg.org>
 <alpine.DEB.2.02.1311131649110.6735@chino.kir.corp.google.com>
 <20131114032508.GL707@cmpxchg.org>
 <alpine.DEB.2.02.1311141447160.21413@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1311141525440.30112@chino.kir.corp.google.com>
 <20131118154115.GA3556@cmpxchg.org>
 <20131118165110.GE32623@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=oWXLXc5CYk189Cq7urloKeMv0kkxpEG7wuHPJC6EMd8=;
	b=I3gO/AM/D72ONMyC/skVLl7aePRLOWFYUJ0ucM3vhw4dyVrs0lT06BSLQjRglJpUPgQw90CNLO3to3RPqZrfdACpRbu9SyLo29gB/2mz+QACNlvU0scjleikELcl3+y4GzxzG0oI9CELdwSpjl6MY/H7Vh9BKlpQmd5uIHSIp7M=;
Content-Disposition: inline
In-Reply-To: <20131118165110.GE32623-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Nov 18, 2013 at 05:51:10PM +0100, Michal Hocko wrote:
> On Mon 18-11-13 10:41:15, Johannes Weiner wrote:
> > On Thu, Nov 14, 2013 at 03:26:51PM -0800, David Rientjes wrote:
> > > When current has a pending SIGKILL or is already in the exit path, it
> > > only needs access to memory reserves to fully exit.  In that sense, the
> > > memcg is not actually oom for current, it simply needs to bypass memory
> > > charges to exit and free its memory, which is guarantee itself that
> > > memory will be freed.
> > > 
> > > We only want to notify userspace for actionable oom conditions where
> > > something needs to be done (and all oom handling can already be deferred
> > > to userspace through this method by disabling the memcg oom killer with
> > > memory.oom_control), not simply when a memcg has reached its limit, which
> > > would actually have to happen before memcg reclaim actually frees memory
> > > for charges.
> > 
> > Even though the situation may not require a kill, the user still wants
> > to know that the memory hard limit was breached and the isolation
> > broken in order to prevent a kill.  We just came really close and the
> 
> You can observe that you are getting into troubles from fail counter
> already. The usability without more reclaim statistics is a bit
> questionable but you get a rough impression that something is wrong at
> least.
> 
> > fact that current is exiting is coincidental.  Not everybody is having
> > OOM situations on a frequent basis and they might want to know when
> > they are redlining the system and that the same workload might blow up
> > the next time it's run.
> 
> I am just concerned that signaling temporal OOM conditions which do not
> require any OOM killer action (user or kernel space) might be confusing.
> Userspace would have harder times to tell whether any action is required
> or not.

But userspace in all likeliness DOES need to take action.

Reclaim is a really long process.  If 5 times doing 12 priority cycles
and scanning thousands of pages is not enough to reclaim a single
page, what does that say about the health of the memcg?

But more importantly, OOM handling is just inherently racy.  A task
might receive the kill signal a split second *after* userspace was
notified.  Or a task may exit voluntarily a split second after a
victim was chosen and killed.

We have to draw a line somewhere, right now this is "reclaim failed".
This patch doesn't fix a problem, it just blurs that line and makes
OOM notifications less predictable.
