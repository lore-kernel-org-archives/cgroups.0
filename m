From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [v5 2/4] mm, oom: cgroup-aware OOM killer
Date: Tue, 15 Aug 2017 14:47:10 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1708151435290.104516@chino.kir.corp.google.com>
References: <20170814183213.12319-1-guro@fb.com> <20170814183213.12319-3-guro@fb.com> <alpine.DEB.2.10.1708141532300.63207@chino.kir.corp.google.com> <20170815121558.GA15892@castle.dhcp.TheFacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=EVR3LGu21MTtJtR3GCyjiymz1uqvsvqfcK+PaGviN40=;
        b=EjXwJq54r+2lrbU7K9A8jNqZntgEzYgTNYKWzyxr5gsy/VWWLFTv2ul8y31+PfLoQF
         6U6o5vV+ETM8ZKQoyRfj8D+Xj81t6ZUDWpRnH11dLEoXtsJIj2wS/KWpnlCq+qy82sDq
         XW2DaaQk880GAIPomCZE43C0MHICDC5X16RVntT5zjJw2vGruVOLuV0Y8JkxrL1n/zHo
         0aY2m5K8xWoKw1B2mqK8HgzCBGdtTkMr5Z8If3p6JHIAH+XYAMK72ntS+Bt+ngUYJY5W
         z4F5EFBmGjPAm0IDdXHi9qat8LlGGHPlqa+8yr+2MSEnRqIzBaz9ZoqQ5E09zX9//qSU
         Zm9g==
In-Reply-To: <20170815121558.GA15892-2xczL/1GIl5a1dPMsufgnw2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 15 Aug 2017, Roman Gushchin wrote:

> > I'm curious about the decision made in this conditional and how 
> > oom_kill_memcg_member() ignores task->signal->oom_score_adj.  It means 
> > that memory.oom_kill_all_tasks overrides /proc/pid/oom_score_adj if it 
> > should otherwise be disabled.
> > 
> > It's undocumented in the changelog, but I'm questioning whether it's the 
> > right decision.  Doesn't it make sense to kill all tasks that are not oom 
> > disabled, and allow the user to still protect certain processes by their 
> > /proc/pid/oom_score_adj setting?  Otherwise, there's no way to do that 
> > protection without a sibling memcg and its own reservation of memory.  I'm 
> > thinking about a process that governs jobs inside the memcg and if there 
> > is an oom kill, it wants to do logging and any cleanup necessary before 
> > exiting itself.  It seems like a powerful combination if coupled with oom 
> > notification.
> 
> Good question!
> I think, that an ability to override any oom_score_adj value and get all tasks
> killed is more important, than an ability to kill all processes with some
> exceptions.
> 

I'm disagreeing because getting all tasks killed is not necessarily 
something that only the kernel can do.  If all processes are oom disabled, 
that's a configuration issue done by sysadmin and the kernel should decide 
to kill the next largest memory cgroup or lower priority memory cgroup.  
It's not killing things like sshd that intentionally oom disable 
themselves.

You could argue that having an oom disabled process attached to these 
memcgs in the first place is also a configuration issue, but the problem 
is that in cgroup v2 with a restriction on processes only being attached 
at the leaf cgroups that there is no competition for memory in this case.  
I must assign memory resources to that sshd, or "Activity Manager" 
described by the cgroup v1 documentation, just to prevent it from being 
killed.

I think the latter of what you describe, killing all processes with some 
exceptions, is actually quite powerful.  I can guarantee that processes 
that set themselves to oom disabled are really oom disabled and I don't 
need to work around that in the cgroup hierarchy only because of this 
caveat.  I can also oom disable my Activity Manger that wants to wait on 
oom notification and collect the oom kill logs, raise notifications, and 
perhaps restart the process that it manages.

> In your example someone still needs to look after the remaining process,
> and kill it after some timeout, if it will not quit by itself, right?
> 

No, it can restart the process that was oom killed; or it can be sshd and 
I can still ssh into my machine.

> The special treatment of the -1000 value (without oom_kill_all_tasks)
> is required only to not to break the existing setups.
> 

I think as a general principle that allowing an oom disabled process to be 
oom killed is incorrect and if you really do want these to be killed, then 
(1) either your oom_score_adj is already wrong or (2) you can wait on oom 
notification and exit.
