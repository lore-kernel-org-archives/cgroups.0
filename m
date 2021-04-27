From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup: add cgroup.signal
Date: Tue, 27 Apr 2021 11:36:06 +0200
Message-ID: <20210427093606.kygcgb74otakofes@wittgenstein>
References: <20210423171351.3614430-1-brauner@kernel.org>
 <YIcOZEbvky7hGbR1@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YIcOZEbvky7hGbR1@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Apr 26, 2021 at 09:03:00PM +0200, Michal Koutn=C3=BD wrote:
> On Fri, Apr 23, 2021 at 07:13:51PM +0200, Christian Brauner <brauner-DgEj=
T+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > +static void __cgroup_signal(struct cgroup *cgrp, int signr)
> > +{
> > +	struct css_task_iter it;
> > +	struct task_struct *task;
> > +
> > +	lockdep_assert_held(&cgroup_mutex);
> > +
> > +	css_task_iter_start(&cgrp->self, 0, &it);
>=20
> I think here you'd need CSS_TASK_ITER_PROCS here to avoid signalling
> multithreaded processes multiple times? (OTOH, with commiting just to
> SIGKILL this may be irrelevant.)

I thought about this optimization but (see below) given that it should
work with threaded cgroups we can't only walk thread-group leaders,
afaiu.
Instead I tried to rely on __fatal_signal_pending(). If any thread in a
thread-group leader catches SIGKILL it'll set the signal as pending for
each thread in the thread-group and __fatal_signal_pending() should
therefore be enough to skip useless send_sig() calls.

>=20
> > +static void cgroup_signal(struct cgroup *cgrp, int signr)
> > [...]
> > +	read_lock(&tasklist_lock);
>=20
> (Thinking loudly.)
> I wonder if it's possible to get rid of this? A similar check that
> freezer does in cgroup_post_fork() but perhaps in cgroup_can_fork(). The
> fork/clone would apparently fail for the soon-to-die parent but there's
> already similar error path returning ENODEV (heh, the macabrous name
> cgroup_is_dead() is already occupied).
>=20
> This way the cgroup-killer wouldn't unncessarily preempt tasklist_lock
> exclusive requestors system-wide.

Good point. I've been playing with revamping this whole thing. We should
definitely do a post_fork() check too though but that's fairly cheap if
we simply introduce a simple CGRP_KILL flag and set it prior to killing
the cgroup.

>=20
>=20
> > @@ -4846,6 +4916,11 @@ static struct cftype cgroup_base_files[] =3D {
> > +	{
> > +		.name =3D "cgroup.signal",
> > +		.flags =3D CFTYPE_NOT_ON_ROOT,
> > +		.write =3D cgroup_signal_write,
>=20
> I think this shouldn't be visible in threaded cgroups (or return an
> error when attempting to kill those).

I've been wondering about this too but then decided to follow freezer in
that regard. I think it should also be fine because a kill to a thread
will cause the whole thread-group to be taken down which arguably is the
semantics we want anyway.
