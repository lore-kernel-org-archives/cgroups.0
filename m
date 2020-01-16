From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3 cgroup/for-5.2-fixes] cgroup: Include dying leaders
 with live threads in PROCS iterations
Date: Wed, 15 Jan 2020 20:26:09 -0800
Message-ID: <CAJuCfpGpcadPPXuU_4mNHy7tjPRXDkttWxqv1kUrGzGKOtsUxg@mail.gmail.com>
References: <87zhn6923n.fsf@xmission.com> <e407a8e7-7780-f08f-320a-a0f2c954d253@gmail.com>
 <20190529003601.GN374014@devbig004.ftw2.facebook.com> <e45d974b-5eff-f781-291f-ddf5e9679e4c@gmail.com>
 <20190530183556.GR374014@devbig004.ftw2.facebook.com> <20190530183637.GS374014@devbig004.ftw2.facebook.com>
 <20190530183700.GT374014@devbig004.ftw2.facebook.com> <20190607170952.GE30727@blackbody.suse.cz>
 <20190611185742.GH3341036@devbig004.ftw2.facebook.com> <CAJuCfpGkAsmp5B=fNz38fLE8pYaMCG=uLDSSBFByNOtWD20zVQ@mail.gmail.com>
 <20200110231624.GA6557@blackbook> <CAJuCfpG-sn0wPM9GRnCjrmytf=mDC3smsRRd=XQBLAK6ZKoAUA@mail.gmail.com>
 <CAJuCfpFeiH_8MbX3qeAKCz_z+XXYp9M2KrnkOsBoN5jGoV7=eg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=a5N2u0A3A1Ze4ASuZeJI3+cOqS5XMVlaChKs80y7r2w=;
        b=HXFkBhBfNqMUD6OB6zGklJ6bCwzVK2oBHH+gUOP9lP0MsdXg2KM2JmiexVJSydcni6
         ZeOQSnOCNzP8++MAPz5SbPR2S4BM5AqTZeUUj4NEVmVP+5K9wKb4qD6kzMhXLzXrgXoO
         PHw48OdmAzK5J2L39yEZC0DqtOSh+P4WzHSvQFn2QYoLw4ZmQXxhS8hc0djLgRd8KFDv
         x8MEti7+OyyQ1esvmLsncsiCPf6M3mNgBUetpvKPSTJwUTxfKrAI6Py8z39126cZ+Tb1
         uwmRE9bIRnqKbH2/6A/Su7UqsBKbMMtikPvH6ykX5uFtLKH03mzgCtuo6HFNXhuGY48W
         k6gw==
In-Reply-To: <CAJuCfpFeiH_8MbX3qeAKCz_z+XXYp9M2KrnkOsBoN5jGoV7=eg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, security-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org, Security Officers <security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, james.hsu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, JeiFeng Lee <linger.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, Tom Cherry <tomcherry-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On Fri, Jan 10, 2020 at 4:55 PM Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrot=
e:
>
> On Fri, Jan 10, 2020 at 4:00 PM Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wr=
ote:
> >
> >  H Michal,
> >
> > On Fri, Jan 10, 2020 at 3:16 PM Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org> w=
rote:
> > >
> > > Hello Suren.
> > >
> > > On Fri, Jan 10, 2020 at 01:47:19PM -0800, Suren Baghdasaryan <surenb@=
google.com> wrote:
> > > > > On Fri, Jun 07, 2019 at 07:09:53PM +0200, Michal Koutn=C3=BD wrot=
e:
> > > > > > Wouldn't it make more sense to call
> > > > > >       css_set_move_task(tsk, cset, NULL, false);
> > > > > > in cgroup_release instead of cgroup_exit then?
> > > > > >
> > > > > > css_set_move_task triggers the cgroup emptiness notification so=
 if we
> > > > > > list group leaders with running siblings as members of the cgro=
up (IMO
> > > > > > correct), is it consistent to deliver the (un)populated event
> > > > > > that early?
> > > > > > By moving to cgroup_release we would also make this notificatio=
n
> > > > > > analogous to SIGCHLD delivery.
> > > > >
> > > > > So, the current behavior is mostly historical and I don't think t=
his
> > > > > is a better behavior.  That said, I'm not sure about the cost ben=
efit
> > > > > ratio of changing the behavior at this point given how long the c=
ode
> > > > > has been this way.  Another aspect is that it'd expose zombie tas=
ks
> > > > > and possibly migrations of them to each controller.
> > > >
> > > > Sorry for reviving an old discussion
> > > Since you reply to my remark, I have to share that I found myself wro=
ng
> > > later wrt the emptiness notifications. Moving the task in cgroup_exit
> > > doesn't matter if thread group contains other live tasks, the unpopul=
ated
> > > notification will be raised when the last task of thread group calls
> > > group_exit, i.e. it is similar to SIGHLD.
> > >
> > > Now to your issue.
> > >
> > > > but I got a bug report from a customer about Android
> > > What kernel version is that? Can be it considered equal to the curren=
t
> > > Linux?
> >
> > I reproduced this with 4.19 kernel that had Tejun's patches backported
> > but I believe the same behavior will happen with any kernel that
> > contains c03cd7738a83 ("cgroup: Include dying leaders with live
> > threads in PROCS iterations") including the latest. I'll try to
> > confirm this on 5.4 next week.

Hi Folks,
I confirmed that the issue is happening on 5.4 as well. I did
implement a fix for this and a kselftest to reproduce the problem.
Will send both the fix and the kselftest as a 2-patch series shortly.
Thanks,
Suren.

> >
> > >
> > > > In my testing I was able to reproduce the failure in
> > > > which case rmdir() fails with EBUSY from cgroup_destroy_locked()
> > > > because cgroup_is_populated() returns true.
> > > That'd mean that not all tasks in the cgroup did exit() (cgroup_exit(=
)),
> > > i.e. they're still running. Can you see them in cgroup.threads/tasks?
> >
> > Correct, I confirmed that there are still tasks in cset->tasks list
> > when this happens. Actually when I reproduced this I logged one task
> > in cset->dying_tasks which was the group leader and another one in
> > cset->tasks. So the last task to reach cgroup_exit() was not the group
> > leader.
> > However these tasks will be ignored when we enumerate them using
> > css_task_iter_start()/css_task_iter_next() loop because
> > css_task_iter_advance() ignores tasks with PF_EXITING flag set or
> > group leaders with task->signal->live=3D=3D0 (see the code lines I post=
ed
> > in my first email). So threads are there, they are PF_EXITING but at
> > least one of them did not reach cgroup_exit() yet. When user space
> > reads cgroup.procs/tasks they are skipped. This is the change in
> > behavior which is different from what it used to be before this patch.
> > Prior to it these tasks would be visible even if they are exiting.
> >
> > >
> > > > cgroup_is_populated() depends on cgrp->nr_populated_xxx counters wh=
ich
> > > > IIUC will not be updated until cgroup_update_populated() is called
> > > > from cgroup_exit() and that might get delayed...
> > > Why do you think it's delayed?
> >
> > I think exit_mm() can be one of the contributors if the process owns a
> > considerable amount of memory but there might be other possible
> > reasons.
> >
> > > > So from user space's point of view the cgroup is empty and can be
> > > > removed but rmdir() fails to do so.
> > > As Tejun says, cgroup with only dead _tasks_ should be removable (and=
 if
> > > I'm not mistaken it is in the current kernel).
>
> Sorry, I missed this last part.
> Agree, if all tasks are dead the cgroup should be removable and it
> will be if all tasks reached cgroup_exit(). The issue happens when
> tasks are marked PF_EXITING, userspace reads empty cgroups.procs and
> issues rmdir() before the last killed task reaches cgroup_exit().
>
> > > Unless you do individual
> > > threads migration when a thread would be separated from its (dead)
> > > leader. Does your case include such migrations?
>
> No my case just kills all tasks in the cgroup until cgroup.procs is
> empty and then tries to remove the cgroup itself. No migrations.
>
> > >
> > > Michal
> >
> > Thanks,
> > Suren.
