From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3 cgroup/for-5.2-fixes] cgroup: Include dying leaders
 with live threads in PROCS iterations
Date: Fri, 10 Jan 2020 16:00:26 -0800
Message-ID: <CAJuCfpG-sn0wPM9GRnCjrmytf=mDC3smsRRd=XQBLAK6ZKoAUA@mail.gmail.com>
References: <87zhn6923n.fsf@xmission.com> <e407a8e7-7780-f08f-320a-a0f2c954d253@gmail.com>
 <20190529003601.GN374014@devbig004.ftw2.facebook.com> <e45d974b-5eff-f781-291f-ddf5e9679e4c@gmail.com>
 <20190530183556.GR374014@devbig004.ftw2.facebook.com> <20190530183637.GS374014@devbig004.ftw2.facebook.com>
 <20190530183700.GT374014@devbig004.ftw2.facebook.com> <20190607170952.GE30727@blackbody.suse.cz>
 <20190611185742.GH3341036@devbig004.ftw2.facebook.com> <CAJuCfpGkAsmp5B=fNz38fLE8pYaMCG=uLDSSBFByNOtWD20zVQ@mail.gmail.com>
 <20200110231624.GA6557@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6b10KFr2b/SXa8SjpLJKq2FHzb01RuYd99JphLV4XKQ=;
        b=o9BPH+5nyRj/6E2mBd7VSBEMrlEx+FdEVc96Sqa6RXkhKYdQx3YPUZhfXa30IGI4il
         TwfsOu6bKusT7rQAOfAxHdc3QOJmVRinuqX742vwsoD3tFU21+E+grsqbfYCC+cDmfCO
         c0O914zDiakaFxj+Lo3yCMz9X1pkVGRJHhTuTAsFW7cPBatuNZgXeRtAodD53xfZH9pj
         5d9Ks7GDE1NrFC33ZMh/9yFb/NH3cxX2jA+vVcITaNKUy00XigzJ8KsIF13TmkDgs3/f
         nOt4qcqc9pwvlCHjQS4AmxyqTvbZQExe4G6GkwpecGfB/ai15S6/h/KULtIJH04ra6uY
         8A+Q==
In-Reply-To: <20200110231624.GA6557@blackbook>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, security-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org, Security Officers <security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, james.hsu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, linger.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, Tom Cherry <tomcherry-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

 H Michal,

On Fri, Jan 10, 2020 at 3:16 PM Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org> wrote=
:
>
> Hello Suren.
>
> On Fri, Jan 10, 2020 at 01:47:19PM -0800, Suren Baghdasaryan <surenb@goog=
le.com> wrote:
> > > On Fri, Jun 07, 2019 at 07:09:53PM +0200, Michal Koutn=C3=BD wrote:
> > > > Wouldn't it make more sense to call
> > > >       css_set_move_task(tsk, cset, NULL, false);
> > > > in cgroup_release instead of cgroup_exit then?
> > > >
> > > > css_set_move_task triggers the cgroup emptiness notification so if =
we
> > > > list group leaders with running siblings as members of the cgroup (=
IMO
> > > > correct), is it consistent to deliver the (un)populated event
> > > > that early?
> > > > By moving to cgroup_release we would also make this notification
> > > > analogous to SIGCHLD delivery.
> > >
> > > So, the current behavior is mostly historical and I don't think this
> > > is a better behavior.  That said, I'm not sure about the cost benefit
> > > ratio of changing the behavior at this point given how long the code
> > > has been this way.  Another aspect is that it'd expose zombie tasks
> > > and possibly migrations of them to each controller.
> >
> > Sorry for reviving an old discussion
> Since you reply to my remark, I have to share that I found myself wrong
> later wrt the emptiness notifications. Moving the task in cgroup_exit
> doesn't matter if thread group contains other live tasks, the unpopulated
> notification will be raised when the last task of thread group calls
> group_exit, i.e. it is similar to SIGHLD.
>
> Now to your issue.
>
> > but I got a bug report from a customer about Android
> What kernel version is that? Can be it considered equal to the current
> Linux?

I reproduced this with 4.19 kernel that had Tejun's patches backported
but I believe the same behavior will happen with any kernel that
contains c03cd7738a83 ("cgroup: Include dying leaders with live
threads in PROCS iterations") including the latest. I'll try to
confirm this on 5.4 next week.

>
> > In my testing I was able to reproduce the failure in
> > which case rmdir() fails with EBUSY from cgroup_destroy_locked()
> > because cgroup_is_populated() returns true.
> That'd mean that not all tasks in the cgroup did exit() (cgroup_exit()),
> i.e. they're still running. Can you see them in cgroup.threads/tasks?

Correct, I confirmed that there are still tasks in cset->tasks list
when this happens. Actually when I reproduced this I logged one task
in cset->dying_tasks which was the group leader and another one in
cset->tasks. So the last task to reach cgroup_exit() was not the group
leader.
However these tasks will be ignored when we enumerate them using
css_task_iter_start()/css_task_iter_next() loop because
css_task_iter_advance() ignores tasks with PF_EXITING flag set or
group leaders with task->signal->live=3D=3D0 (see the code lines I posted
in my first email). So threads are there, they are PF_EXITING but at
least one of them did not reach cgroup_exit() yet. When user space
reads cgroup.procs/tasks they are skipped. This is the change in
behavior which is different from what it used to be before this patch.
Prior to it these tasks would be visible even if they are exiting.

>
> > cgroup_is_populated() depends on cgrp->nr_populated_xxx counters which
> > IIUC will not be updated until cgroup_update_populated() is called
> > from cgroup_exit() and that might get delayed...
> Why do you think it's delayed?

I think exit_mm() can be one of the contributors if the process owns a
considerable amount of memory but there might be other possible
reasons.

> > So from user space's point of view the cgroup is empty and can be
> > removed but rmdir() fails to do so.
> As Tejun says, cgroup with only dead _tasks_ should be removable (and if
> I'm not mistaken it is in the current kernel). Unless you do individual
> threads migration when a thread would be separated from its (dead)
> leader. Does your case include such migrations?
>
> Michal

Thanks,
Suren.
