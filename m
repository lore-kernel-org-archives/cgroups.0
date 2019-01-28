From: Roman Gushchin <guroan@gmail.com>
Subject: Re: [PATCH v6 4/7] cgroup: cgroup v2 freezer
Date: Mon, 28 Jan 2019 11:59:04 -0800
Message-ID: <CALo0P13XnGiFykMXY3ZKu158ZqnBwHru0gyhQUrJSHEprnmiHQ@mail.gmail.com>
References: <20181222000307.28231-1-guro@fb.com> <20181222000307.28231-5-guro@fb.com>
 <20190125122713.GA18218@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AuhZ4nkiEDArVvQU3rV7Yh+iRv6mQz94hxBQ34e6aH0=;
        b=N/P2roVgs1rrW87Ke9jv6Q8iLUSpGqN+Z2m5WDrbvRLmm8ebnfYw+X9kikx4eeTxEg
         hz1+To30FDx1mZssksSz+qS2aIM/aoIR4Tm+4y1QZdrciVdpzJ+azGdiUVZU+l7z1UFF
         wT9vYWlXNMoQMzwnANa0dYe0T78EWfX++vhXoM6+Ph5QmOkf9/lFH+5WhfJLAO/yE50h
         U7kbx9urRpsgswlzoUah5/Q7ssx+XrxHDbMhssgs6PAGequbRBP5xtlDYMXmXWhYqsgf
         jyC6LxJonJK9xDDxo9miZnWMcA9g7MwUELpiyx3pVFwiSXRn0CcpEabZrQ5ee7tQXbNP
         KVIQ==
In-Reply-To: <20190125122713.GA18218@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>

Hi Oleg!

Thank you for looking into the patchset!

Yes, I think you're right: cgroup_exit() should check CGRP_FREEZE bit,
not CGRP_FROZEN. Like cgroup_post_fork() does (a one-liner change below).

About spurious transitions (like frozen->non frozen->frozen on a task
being SIGKILLed):
in early versions of the patchset I've tried to avoid them, but then
following the Tejun's advice
switched over to expose them to a user. The logic behind is simple: if
the state of the cgroup has been changed (a task is gone, for
example), let's notify a user.

nr_tasks_to_freeze is simple a number of non-kthead tasks in the
cgroup, which we do
keep actual only for freezing cgroups (to avoid an unnecessary overhead).

Thanks!

--

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 3e6a7c19bfaf..08c84d2145eb 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5832,7 +5832,7 @@ void cgroup_exit(struct task_struct *tsk)
                css_set_move_task(tsk, cset, NULL, false);
                cset->nr_tasks--;

-               if (unlikely(test_bit(CGRP_FROZEN, &cset->dfl_cgrp->flags))=
) {
+               if (unlikely(cgroup_task_freeze(tsk))) {
                        /*
                         * Task frozen bit should be cleared at this moment=
,
                         * and nr_frozen_task should be decreased.

=D0=BF=D1=82, 25 =D1=8F=D0=BD=D0=B2. 2019 =D0=B3. =D0=B2 04:27, Oleg Nester=
ov <oleg@redhat.com>:
>
> Sorry, this version raced with my vacation, I missed it.
>
> I'll try to read this code carefully but after a quick glance I have some
> concerns,
>
> On 12/21, Roman Gushchin wrote:
> >
> > +static void cgroup_update_frozen(struct cgroup *cgrp)
> > +{
> > +     bool frozen;
> > +
> > +     lockdep_assert_held(&css_set_lock);
> > +
> > +     /*
> > +      * If the cgroup has to be frozen (CGRP_FREEZE bit set),
> > +      * and all tasks are frozen or stopped, let's consider
> > +      * the cgroup frozen. Otherwise it's not frozen.
> > +      */
> > +     frozen =3D test_bit(CGRP_FREEZE, &cgrp->flags) &&
> > +             cgrp->freezer.nr_frozen_tasks +
> > +             cgrp->freezer.nr_stopped_tasks =3D=3D
> > +             cgrp->freezer.nr_tasks_to_freeze;
>
> OK. Suppose that cgroup is frozen, CGRP_FROZEN is set, stopped =3D=3D 0,
> to_freeze =3D frozen.
>
> One of the task is killed, it calls leave_frozen(). If I read this code p=
ath
> correctly, only ->nr_frozen_tasks will be decremented, so "frozen" will b=
e
> "false" when cgroup_update_frozen() is called.
>
> Doesn't this mean that this cgroup will no longer be CGRP_FROZEN even aft=
er
> the killed task goes away completely?
>
>
> Or. Suppose that another process picks a task from the CGRP_FROZEN cgroup=
 and
> does PTRACE_ATTACH + PTRACE_INTERRUPT. IIUC, the tracee will only increme=
nt
> ->nr_stopped_tasks, it won't touch other counters. Again, cgroup won't be=
 FROZEN
> until PTRACE_CONT'ed tracee does cgroup_leave_stopped() ? This looks stra=
nge at
> least.
>
>
>
> SIGSTOP. IIUC, a frozen task sleeping in do_freezer_trap() won't stop. Ho=
wever if
> another thread has already called do_signal_stop(), the woken frozen task=
 will
> react to JOBCTL_STOP_PENDING and stop. And do_signal_stop()->cgroup_enter=
_stopped()
> will "destroy" CGRP_FROZEN too, or I am totally confused.
>
> OTOH, if you freeze a TASK_STOPPED task's cgroup, this task can react to =
SIGCONT,
> notify its parent, then freeze again. This is fine, but iiuc this cgroup =
won't be
> FROZEN in between, cgroup_file_notify() will be called twice...
>
> Oleg.
>
