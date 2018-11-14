From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2 3/6] cgroup: cgroup v2 freezer
Date: Wed, 14 Nov 2018 17:56:32 +0100
Message-ID: <20181114165631.GE13885@redhat.com>
References: <20181112230422.5911-1-guro@fb.com>
 <20181112230422.5911-5-guro@fb.com>
 <20181113154825.GC30990@redhat.com>
 <20181113215919.GC15590@tower.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181113215919.GC15590@tower.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

Hi Roman,

On 11/13, Roman Gushchin wrote:
>
> > > +#define TASK_FROZEN			0x1000
> > > +#define TASK_STATE_MAX			0x2000
> >
> > Just noticed the new task state... Why? Can't we avoid it?
>
> We can, but it's nice to show to userspace that tasks are frozen,
> rather than just stuck somewhere in the kernel...

But then you need to change get_task_state() too. Which iiuc could
probably check ->frozen along with ->state.

I do not think the new task state is a good idea, at least I would like
to ask you to make a separate patch which we can discuss separately.


> > > +	set_current_state(TASK_WAKEKILL | TASK_INTERRUPTIBLE | TASK_FROZEN);
> >
> > Why not __set_current_state() ?
>
> Hm, it's not a hot path at all, so set_current_state() is good enough.
> Not a strong preference, of course.

It is not about performance, to me set_current_state() looks as if we need
a memory barrier for some obscure/undocumented reason and this doesn't help
to understand the code.

> > If ->state include TASK_INTERRUPTIBLE, why do we need TASK_WAKEKILL?
> >
> > And again, why TASK_FROZEN?
>
> So, should it be just TASK_INTERRUPTIBLE | TASK_FROZEN ?

Again, TASK_FROZEN is pointless at least until you change fs/proc or until
you have wake_up_state(TASK_FROZEN). May be cgroup_do_freeze() and/or
ptrace_attach() could use it, but see above, I'd suggest to make another
patch.

Looks like you need TASK_KILLABLE, see below.

> > > +	clear_thread_flag(TIF_SIGPENDING);
> > > +	schedule();
> > > +	recalc_sigpending();
> >
> > I simply can't understand these 3 lines above but I bet this is not correct ;)
>
> So, yeah, the problem is that if there is TIF_SIGPENDING bit set, schedule()
> will return immediately, so we're getting pretty much a busy loop here.

I suspected this answer ;)

> This is a nasty workaround.

No, this is very wrong. Just suppose the caller is killed right before
clear_thread_flag(TIF_SIGPENDING).

> I believe we can clear and not call recalc_sigpending() at all. Does this seem
> to be correct?

I think you need to simply remove both clear_thread_flag() and recalc_sigpending().
If schedule() is called in TASK_KILLABLE state it will return only if
fatal_signal_pending() is true, and this is what we want, right?

OK, it seems you are going to make the new version anyway, so I can wait for it
and not read this series ;)

Oleg.

