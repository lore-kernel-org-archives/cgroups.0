From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v2 3/6] cgroup: cgroup v2 freezer
Date: Tue, 13 Nov 2018 20:55:11 +0000
Message-ID: <20181113205507.GB15590@tower.DHCP.thefacebook.com>
References: <20181112230422.5911-1-guro@fb.com>
 <20181112230422.5911-5-guro@fb.com>
 <20181113020817.GE2509588@devbig004.ftw2.facebook.com>
 <20181113184751.GB21629@tower.DHCP.thefacebook.com>
 <20181113191541.GM2509588@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Vsd1EuUzi0RlRc17NuFaaHAjgP7x7uVz9kVv8XCWFK8=;
 b=f9bO4IC7IMjhZv1iJ5B2w4CbFw7xa3cIjgkssdqEw+zcO2Mo5lyAGPNgCwtn+8INbPNH
 aU+3bf72o433/WJK+tj6QB9ZMhcrE3eZKaRnggjos2s1KrCx7u6m8GeDSWv3X1c3ksts
 7v6ls6T3ERJgz5SkIUtxBwP1YTeRhq7p4kA= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vsd1EuUzi0RlRc17NuFaaHAjgP7x7uVz9kVv8XCWFK8=;
 b=PUzHRzTol3fxnLC02M1NmmS4dndTQRs0Xv0dIagXZjbeoOKasYPMrKAcAcMNRT2tI6RBfkichD6qPLi5erDrWDPzdkEZ+YrMsouqeECeakcfLc0nBYYcGiKCf616GtUMl0VZoH79fgTn74XIzVhM2f4f9bo7igdOB6Knv3NHJDE=
In-Reply-To: <20181113191541.GM2509588@devbig004.ftw2.facebook.com>
Content-Language: en-US
Content-ID: <F7E7478C86CFCE448A3934CD6B7AF5D6@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <guroan@gmail.com>, Oleg Nesterov <oleg@redhat.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>

On Tue, Nov 13, 2018 at 11:15:41AM -0800, Tejun Heo wrote:
> Hello, Roman.
>=20
> On Tue, Nov 13, 2018 at 06:47:55PM +0000, Roman Gushchin wrote:
> > > > +	/* Should the cgroup and its descendants be frozen. */
> > > > +	bool freeze;
> > >=20
> > > Why not have this in freezer too?
> >=20
> > I thought that this variable is just the state of the cgroup.freeze kno=
b,
> > where the freezer field contains the internal state of the freezer, and
> > can in theory be allocated dynamically.
> >=20
> > Not a strong preference, I can move it there too, if you prefer to.
>=20
> Yeah, let's just put it together.
>=20
> > > > +void cgroup_freezer_enter(void);
> > > > +void cgroup_freezer_leave(void);
> > >=20
> > > So, if we use freeze, freezing, frozen instead, the aboves can be
> > > cgroup_frozen_enter() and cgroup_frozen_leave() (or begin/end).
> >=20
> > Idk, maybe cgroup_enter_frozen()/cgroup_leave_frozen() ?
>=20
> Sure.
>=20
> > > > +	/* task is in the cgroup freezer loop */
> > >=20
> > > The above comment isn't strictly true, right?
> >=20
> > Why so?
> >=20
> > It actually means that the task is looping somewhere in the signal deli=
very loop
> > after entering cgroup_freezer_enter() and before cgroup_freezer_leave()=
.
> >=20
> > Maybe simple "task is frozen by the cgroup freezer"?
>=20
> Yeah, sounds good.
>=20
> > > > @@ -5642,6 +5700,23 @@ void cgroup_post_fork(struct task_struct *ch=
ild)
> > > >  			cset->nr_tasks++;
> > > >  			css_set_move_task(child, NULL, cset, false);
> > > >  		}
> > > > +
> > > > +		if (unlikely(cgroup_frozen(child) &&
> > > > +			     (child->flags & ~PF_KTHREAD))) {
> > >=20
> > > I don't think we need explicit PF_KTHREAD test here.  We don't allow
> > > kthreads in non-root cgroups anyway and if we wanna change that there
> > > are a bunch of other things which need updating anyway.
> >=20
> > Don't we? I think we do. I've proposed a patch to fix this some time ag=
o
> > (https://lkml.org/lkml/2017/10/12/556), but was NAKed by Peter.
>=20
> Ah, right, I thought that went in.  Oh well, let's keep the test then.
>=20
> > > > +	/*
> > > > +	 * Did we race with fork() or exit()? Np, everything is still fro=
zen.
> > > > +	 */
> > > > +	if (frozen =3D=3D test_bit(CGRP_FROZEN, &cgrp->flags))
> > > > +		return;
> > > > +
> > > > +	if (frozen)
> > > > +		set_bit(CGRP_FROZEN, &cgrp->flags);
> > > > +	else
> > > > +		clear_bit(CGRP_FROZEN, &cgrp->flags);
> > >=20
> > > I'm not sure this is wrong but it feels a bit weird to tie the actual
> > > state transition to notification.  Wouldn't it be more
> > > straight-forward if CGRP_FROZEN bit is purely determined by whether
> > > the tasks are frozen or not and the notification just checks that
> > > against the last notified state and generate a notification if they'r=
e
> > > different?
> >=20
> > So, maybe cgroup_notify_frozen() is not the best name, maybe
> > cgroup_propagate_frozen() better reflects what's happening here.
> > We need to recalc the state of ancestor cgroups, and we have to do it
> > with cgroup_mutex held, this is why we do it from the delayed work
> > context (on hot paths).
>=20
> Can't we protect that state with css_set_lock too?  That's what task
> states are protected by and the cgroup state is a mere aggregation of
> task states.

See below.

>=20
> > The first pat of the function can be probably separated and called
> > immediately. Is this what you're suggesting?
>=20
> Pretty much.  I think separating out state transitions and
> notifications would make it more straightforward.
>=20
> > > So that all these state transitions are synchronous with the actual
> > > freezing events and we can just queue per-cgroup work items all the
> > > way to the top if the new state is different from the last one
> > > cgroup-by-cgroup?
> >=20
> > Hm, Idk. Why it's better?
>=20
> So, the pieces are - 1. task states, 2. cgroup states and
> 3. notifications.  The current code ties together #2 and #3 together
> which is weird because #2 is a mere aggregation of #1.  Also, that
> way, notifications become a lot more robust because whether to
> generate a notification or not can be solely determined from #2
> flipping.  ie. sth like the following
>=20
> 	change_task_frozen_state()
> 	{
> 		update counters
> 		if (cgroup state needs to change) {
> 			change cgroup state;
> 			queue notification work;
> 			repeat for the parent;
> 		}
> 	}
>=20
> where notification work always notifies should work and trivially
> satisfies the requirement (there should be at least one notification
> since the last state transition) without any further work.  Wouldn't
> this be easier and more robust?  The current code depends on
> annotating each possible transition event, which is kinda fragile.

Ok, it looks like I can additionally synchronize descendant counters
using css_set_lock, and then eliminate the whole thing with delayed
transitions/notifications.

Will do in v3.

>=20
> > > > +	if (lock_task_sighand(task, &flags)) {
> > > > +		if (test_bit(CGRP_FREEZE, &dst->flags))
> > > > +			task->jobctl |=3D JOBCTL_TRAP_FREEZE;
> > > > +		else
> > > > +			task->jobctl &=3D ~JOBCTL_TRAP_FREEZE;
> > >=20
> > > How are these flags synchronized?
> >=20
> > Using the css_set_lock.
>=20
> But other JOBCTL_TRAP bits aren't synchronized by css_set_lock, right?


But if we don't touch this bit anywhere else, should be fine, right?

Thanks!
