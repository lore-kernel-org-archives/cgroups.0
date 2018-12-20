From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v5 4/7] cgroup: cgroup v2 freezer
Date: Thu, 20 Dec 2018 17:16:50 +0100
Message-ID: <20181220161649.GA31865@redhat.com>
References: <20181207201531.1665-1-guro@fb.com>
 <20181207201531.1665-5-guro@fb.com>
 <20181211162632.GB8504@redhat.com>
 <20181211184033.GA8971@tower.DHCP.thefacebook.com>
 <20181212174902.GA30309@redhat.com>
 <20181218012800.GA29563@tower.DHCP.thefacebook.com>
 <20181218171230.GA11319@redhat.com>
 <20181218202701.GA12730@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181218202701.GA12730@castle.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, Dan Carpenter <dan.carpenter@oracle.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

On 12/18, Roman Gushchin wrote:
>
> > > > > --- a/kernel/freezer.c
> > > > > +++ b/kernel/freezer.c
> > > > > @@ -134,7 +134,7 @@ bool freeze_task(struct task_struct *p)
> > > > >                 return false;
> > > > >
> > > > >         spin_lock_irqsave(&freezer_lock, flags);
> > > > > -       if (!freezing(p) || frozen(p)) {
> > > > > +       if (!freezing(p) || frozen(p) || cgroup_task_frozen()) {
> > > > >                 spin_unlock_irqrestore(&freezer_lock, flags);
> > > > >                 return false;
> > > > >         }
> > > > >
> > > > > --
> > > > >
> > > > > If the task is already frozen by the cgroup freezer, we don't have to do
> > > > > anything additionally.
> > > >
> > > > I don't think so. A cgroup_task_frozen() task can be killed after
> > > > try_to_freeze_tasks() succeeds, and the exiting task can close files,
> > > > do IO, etc. Or it can be thawed by cgroup_freeze_task(false).
> > > >
> > > > In short, if try_to_freeze_tasks() succeeds, the caller has all rights
> > > > to assume that nobody can escape from __refrigerator().
> > >
> > > But this is what we do with stopped and ptraced tasks, isn't it?
> >
> > No,
> >
> > > We do use freezable_schedule() and the system freezer just ignores such tasks.
> >
> > 	static inline void freezable_schedule(void)
> > 	{
> > 		freezer_do_not_count();
> > 		schedule();
> > 		freezer_count();
> > 	}
> >
> > and note that freezer_count() calls try_to_freeze().
> >
> > IOW, the task sleeping in freezable_schedule() doesn't really differ from the
> > task sleeping in __refrigerator(). It is not that "the system freezer just
> > ignores such tasks", it ignores them because it can safely count them as frozen.
>
> Right, so the task is sleeping peacefully, and we know, that it won't get
> anywhere, because we'll catch it in freezer_count(). We allow it to sleep
> there, we don't force it to __refrigerator(), and we treat it as frozen.
>
> How's that different to cgroup v2 freezer? If the task is frozen by cgroup v2
> freezer, let it sleep there, and catch if it tries to escape. Exactly as it
> works for SIGSTOP.
>
> Am I missing something?

Roman, perhaps we misunderstood each other...

I still think that the cgroup_task_frozen() check in freeze_task() you proposed
a) is not right, and b) it is not what we do with the STOPPED/TRACED tasks which
call freezable_schedule(). This is what I tried to say.

If you meant that freezer v2 can too use freezable_schedule() - I agree.

> So, you think that v2 freezer should follow the same approach, and allow tasks
> sleeping on SIGSTOP, for instance, to be treated as frozen?
> Hm, maybe. I have to think more here.

I think this would be nice. Otherwise, say, CGRP_FREEZE can be never reported
if I read this code correctly. And this looks "symmetrical" with the fact that
a ->frozen task reacts to SIGSTOP and it is still treated as frozen after that.

Oleg.

