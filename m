From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/7] cgroup: cgroup_subsys->fork() should be called after
 the task is added to css_set
Date: Thu, 18 Oct 2012 09:25:21 +0800
Message-ID: <507F5A81.7010007@huawei.com>
References: <1350426526-14254-1-git-send-email-tj@kernel.org> <1350426526-14254-2-git-send-email-tj@kernel.org> <507E6C4B.6000704@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <507E6C4B.6000704-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: rjw-KKrjLPT3xs0@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

=D3=DA 2012/10/17 16:28, Li Zefan =D0=B4=B5=C0:
> On 2012/10/17 6:28, Tejun Heo wrote:
>> cgroup core has a bug which violates a basic rule about event
>> notifications - when a new entity needs to be added, you add that to
>> the notification list first and then make the new entity conform to
>> the current state.  If done in the reverse order, an event happening
>> inbetween will be lost.
>>
>> cgroup_subsys->fork() is invoked way before the new task is added to
>> the css_set.  Currently, cgroup_freezer is the only user of ->fork()
>> and uses it to make new tasks conform to the current state of the
>> freezer.  If FROZEN state is requested while fork is in progress
>> between cgroup_fork_callbacks() and cgroup_post_fork(), the child
>> could escape freezing - the cgroup isn't frozen when ->fork() is
>> called and the freezer couldn't see the new task on the css_set.
>>
>> This patch moves cgroup_subsys->fork() invocation to
>> cgroup_post_fork() after the new task is added to the css_set.
>> cgroup_fork_callbacks() is removed.
>>
>> Because now a task may be migrated during cgroup_subsys->fork(),
>> freezer_fork() is updated so that it adheres to the usual RCU lockin=
g
>> and the rather pointless comment on why locking can be different the=
re
>> is removed (if it doesn't make anything simpler, why even bother?).
>>
>=20
> I don't think rcu read section is sufficient. It guarantees the data =
you're
> accessing is valid, but the data can be new or can be old.
>=20
> So a case below is possible:
>=20
> in freezer_fork():
> rcu_read_lock();
> freezer =3D task_freezer(task);
>                                   move task from freezer to freezer2
>                                   which is in FREEZING/FROZEN state
> freezer is in THAWED state,
> nothing to do.
> rcu_read_unlock();
>=20

forget about it. The task will be correctly frozen when moving to
another cgroup, so nothing unexpected will happen.

for this patch:

Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
