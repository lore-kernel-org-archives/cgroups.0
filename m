From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v2 3/6] cgroup: cgroup v2 freezer
Date: Tue, 13 Nov 2018 21:59:23 +0000
Message-ID: <20181113215919.GC15590@tower.DHCP.thefacebook.com>
References: <20181112230422.5911-1-guro@fb.com>
 <20181112230422.5911-5-guro@fb.com> <20181113154825.GC30990@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=BI5sKWfHNi89UzPilsd17pYMNcKueVRYVALJ7m46zIo=;
 b=KR/iEmo56N37WsPi5a13VWSNqk2gb6AYKHj51E+Tsa3J4jZbXTpa8wK5uPMdgDAhwa6e
 FN8ojExWn/PXXDsiHF9u8medKKfBnkGyJRGju9kIxT6eEW+ehLSsq/pM4WzFgS3ygWfS
 4dGRC2kAz8UmoeRwmbVnBU+V4OHg7DadiLU= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BI5sKWfHNi89UzPilsd17pYMNcKueVRYVALJ7m46zIo=;
 b=hDs+A1UMem1elTkYaJbjlxBmR21KwFaAkrFeP/oEtCSctMctmw+rASrLJOjYlXgwHAsE45V0y8h2fxdPzm+XMb1gWWhJesJHlXGpvUX5DjrerSVZsCXMa+Ieln6HbQwcCxU1n3vYRxC4pe8Pmxqn38/bQ1fuEUtTL2aXWCKdnEg=
In-Reply-To: <20181113154825.GC30990@redhat.com>
Content-Language: en-US
Content-ID: <6F48ABCFBF9C6F4591F8F42FAB296F0D@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

Hi Oleg!

On Tue, Nov 13, 2018 at 04:48:25PM +0100, Oleg Nesterov wrote:
> On 11/12, Roman Gushchin wrote:
> >
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -83,7 +83,8 @@ struct task_group;
> >  #define TASK_WAKING			0x0200
> >  #define TASK_NOLOAD			0x0400
> >  #define TASK_NEW			0x0800
> > -#define TASK_STATE_MAX			0x1000
> > +#define TASK_FROZEN			0x1000
> > +#define TASK_STATE_MAX			0x2000
>=20
> Just noticed the new task state... Why? Can't we avoid it?

We can, but it's nice to show to userspace that tasks are frozen,
rather than just stuck somewhere in the kernel...

>=20
> ...
>=20
> > +void cgroup_freezer_enter(void)
> > +{
> > +	long state =3D current->state;
>=20
> Why? it must be TASK_RUNNING?
>=20
> If not set_current_state() at the end is simply wrong... Yes, __refrigera=
tor()
> does this, but at least it has a reason although it is wrong too.
>=20
> > +	struct cgroup *cgrp;
> > +
> > +	if (!current->frozen) {
> > +		spin_lock_irq(&css_set_lock);
> > +		current->frozen =3D true;
> > +		cgrp =3D task_dfl_cgroup(current);
> > +		cgrp->freezer.nr_frozen_tasks++;
> > +
> > +		WARN_ON_ONCE(cgrp->freezer.nr_tasks_to_freeze <
> > +			     cgrp->freezer.nr_frozen_tasks);
> > +
> > +		if (cgrp->freezer.nr_tasks_to_freeze =3D=3D
> > +		    cgrp->freezer.nr_frozen_tasks)
> > +			cgroup_queue_notify_frozen(cgrp);
> > +		spin_unlock_irq(&css_set_lock);
> > +	}
> > +
> > +	/* refrigerator */
> > +	set_current_state(TASK_WAKEKILL | TASK_INTERRUPTIBLE | TASK_FROZEN);
>=20
> Why not __set_current_state() ?

Hm, it's not a hot path at all, so set_current_state() is good enough.
Not a strong preference, of course.

>=20
> If ->state include TASK_INTERRUPTIBLE, why do we need TASK_WAKEKILL?
>=20
> And again, why TASK_FROZEN?

So, should it be just TASK_INTERRUPTIBLE | TASK_FROZEN ?

>=20
> > +	clear_thread_flag(TIF_SIGPENDING);
> > +	schedule();
> > +	recalc_sigpending();
>=20
> I simply can't understand these 3 lines above but I bet this is not corre=
ct ;)

So, yeah, the problem is that if there is TIF_SIGPENDING bit set, schedule(=
)
will return immediately, so we're getting pretty much a busy loop here.
This is a nasty workaround.

I believe we can clear and not call recalc_sigpending() at all. Does this s=
eem
to be correct?

>=20
> if nothing else recalc_sigpending() without ->siglock is wrong, it can ra=
ce
> with signal_wakeup/etc.
>=20
> > +	set_current_state(state);
>=20
> see above...

Thank you for the review!
And looking forward for more comments from you!
