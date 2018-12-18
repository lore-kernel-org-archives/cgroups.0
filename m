From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v5 4/7] cgroup: cgroup v2 freezer
Date: Tue, 18 Dec 2018 18:12:30 +0100
Message-ID: <20181218171230.GA11319@redhat.com>
References: <20181207201531.1665-1-guro@fb.com>
 <20181207201531.1665-5-guro@fb.com>
 <20181211162632.GB8504@redhat.com>
 <20181211184033.GA8971@tower.DHCP.thefacebook.com>
 <20181212174902.GA30309@redhat.com>
 <20181218012800.GA29563@tower.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181218012800.GA29563@tower.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, Dan Carpenter <dan.carpenter@oracle.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

On 12/18, Roman Gushchin wrote:
>
> On Wed, Dec 12, 2018 at 06:49:02PM +0100, Oleg Nesterov wrote:
> > > > and btw.... what about suspend? try_to_freeze_tasks() will obviously fail
> > > > if there is a ->frozen thread?
> > >
> > > I have to think a bit more here, but something like this will probably work:
> > >
> > > diff --git a/kernel/freezer.c b/kernel/freezer.c
> > > index b162b74611e4..590ac4d10b02 100644
> > > --- a/kernel/freezer.c
> > > +++ b/kernel/freezer.c
> > > @@ -134,7 +134,7 @@ bool freeze_task(struct task_struct *p)
> > >                 return false;
> > >
> > >         spin_lock_irqsave(&freezer_lock, flags);
> > > -       if (!freezing(p) || frozen(p)) {
> > > +       if (!freezing(p) || frozen(p) || cgroup_task_frozen()) {
> > >                 spin_unlock_irqrestore(&freezer_lock, flags);
> > >                 return false;
> > >         }
> > >
> > > --
> > >
> > > If the task is already frozen by the cgroup freezer, we don't have to do
> > > anything additionally.
> >
> > I don't think so. A cgroup_task_frozen() task can be killed after
> > try_to_freeze_tasks() succeeds, and the exiting task can close files,
> > do IO, etc. Or it can be thawed by cgroup_freeze_task(false).
> >
> > In short, if try_to_freeze_tasks() succeeds, the caller has all rights
> > to assume that nobody can escape from __refrigerator().
>
> But this is what we do with stopped and ptraced tasks, isn't it?

No,

> We do use freezable_schedule() and the system freezer just ignores such tasks.

	static inline void freezable_schedule(void)
	{
		freezer_do_not_count();
		schedule();
		freezer_count();
	}

and note that freezer_count() calls try_to_freeze().

IOW, the task sleeping in freezable_schedule() doesn't really differ from the
task sleeping in __refrigerator(). It is not that "the system freezer just
ignores such tasks", it ignores them because it can safely count them as frozen.

> > And what about TASK_STOPPED/TASK_TRACED tasks? They can not be frozen
> > or thawed, right? This doesn't look good, and this differs from the
> > current freezer controller...
>
> Good question!
>
> It looks like cgroup v1 freezer just ignores them treating as already frozen,
> which doesn't look nice.

Not sure I understand you, but see above... cgroup v1 freezer looks fine wrt
stopped/traced tasks.

Oleg.

