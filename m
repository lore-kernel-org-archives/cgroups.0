From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: Disable on PREEMPT_RT
Date: Wed, 15 Dec 2021 17:56:03 +0100
Message-ID: <YboeI1aTFdQpN0TI@dhcp22.suse.cz>
References: <20211207155208.eyre5svucpg7krxe@linutronix.de>
 <Ya+SCkLOLBVN/kiY@cmpxchg.org>
 <YbNwmUMPFM/MO0cX@linutronix.de>
 <YbcbmvQk+Sgdsi9G@dhcp22.suse.cz>
 <YbocOh+h3o/Yc5Ag@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1639587364; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q0eq0yhnqn4qP+5Put1jaNb43h1kXvYVfgQCKuv1gGo=;
        b=UoqQWEvUVAgsq4G3d+FzDQ5TN0pSY3bRspcf0bKjmFBlRM034GhgR/vmdOWfOhyXO0zMRj
        6NiTJv4p4y17sKT3cSDQhtQ36uk5nVhCLUnZ92dNBeeH3iQM54FlPpZ8l/MnKMMQ0xS1sO
        Jjf9LBJ1qOetguaus5cwE4HcSLvcjvw=
Content-Disposition: inline
In-Reply-To: <YbocOh+h3o/Yc5Ag-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Wed 15-12-21 17:47:54, Sebastian Andrzej Siewior wrote:
> On 2021-12-13 11:08:26 [+0100], Michal Hocko wrote:
> > On Fri 10-12-21 16:22:01, Sebastian Andrzej Siewior wrote:
> > [...]
> > I am sorry but I didn't get to read and digest the rest of the message
> > yet. Let me just point out this
> > 
> > > The problematic part here is mem_cgroup_tree_per_node::lock which can
> > > not be acquired with disabled interrupts on PREEMPT_RT.  The "locking
> > > scope" is not always clear to me.  Also, if it is _just_ the counter,
> > > then we might solve this differently.
> > 
> > I do not think you should be losing sleep over soft limit reclaim. This
> > is certainly not something to be used for RT workloads and rather than
> > touching that code I think it makes some sense to simply disallow soft
> > limit with RT enabled (i.e. do not allow to set any soft limit).
> 
> Okay. So instead of disabling it entirely you suggest I should take
> another stab at it? Okay. Disabling softlimit, where should I start with
> it? Should mem_cgroup_write() for RES_SOFT_LIMIT always return an error
> or something else?

Yeah, I would just return an error for RT configuration. If we ever need
to implement that behavior for RT then we can look at specific fixes.

Thanks!
-- 
Michal Hocko
SUSE Labs
