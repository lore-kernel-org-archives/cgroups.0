From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v2 3/6] cgroup: cgroup v2 freezer
Date: Wed, 14 Nov 2018 17:06:06 +0000
Message-ID: <20181114170558.GA24889@castle.DHCP.thefacebook.com>
References: <20181112230422.5911-1-guro@fb.com>
 <20181112230422.5911-5-guro@fb.com> <20181113154825.GC30990@redhat.com>
 <20181113215919.GC15590@tower.DHCP.thefacebook.com>
 <20181114165631.GE13885@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=SBHOXh5Ab4jAaZVCCtf4yqFFqUucT5F2vw11c/BFXcc=;
 b=bOY6aza3IW2XZZ+5QhcSHnVpX3In/6buEZNPs+ftP1GUcF+Heoq3+QhFxkGqZEEPuWPK
 0DmEWhNsFnK0wGOykW4fIIV5jVbiA2qwNn+MK0+a04tUUTji+xZf5dSwNqRdcFOqbr6j
 U5CIR194LoLr8il9YEqtXBSpny/qCKJXcck= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SBHOXh5Ab4jAaZVCCtf4yqFFqUucT5F2vw11c/BFXcc=;
 b=XWv/w9NPskVK+M0xuq/MuNhFq2osDCY22XWdRUmWzxPI2+J/9gTdo+NP1Vnrd25KprnSqceeEQrBzYr/QcmEf0h00Bhwuh6vv+L4F7vNnlRdGW/Rk8IHwOtVqUjC2fL4A5jRivgZnHV7mw9OC3VFcSJDtMjHuE+APSg7eJhvQAg=
In-Reply-To: <20181114165631.GE13885@redhat.com>
Content-Language: en-US
Content-ID: <2E7132A9E2449141A195A12CE298CFE0@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

On Wed, Nov 14, 2018 at 05:56:32PM +0100, Oleg Nesterov wrote:
> Hi Roman,
>=20
> On 11/13, Roman Gushchin wrote:
> >
> > > > +#define TASK_FROZEN			0x1000
> > > > +#define TASK_STATE_MAX			0x2000
> > >
> > > Just noticed the new task state... Why? Can't we avoid it?
> >
> > We can, but it's nice to show to userspace that tasks are frozen,
> > rather than just stuck somewhere in the kernel...
>=20
> But then you need to change get_task_state() too. Which iiuc could
> probably check ->frozen along with ->state.
>=20
> I do not think the new task state is a good idea, at least I would like
> to ask you to make a separate patch which we can discuss separately.

Yeah, I have separated it in v3.

>=20
>=20
> > > > +	set_current_state(TASK_WAKEKILL | TASK_INTERRUPTIBLE | TASK_FROZE=
N);
> > >
> > > Why not __set_current_state() ?
> >
> > Hm, it's not a hot path at all, so set_current_state() is good enough.
> > Not a strong preference, of course.
>=20
> It is not about performance, to me set_current_state() looks as if we nee=
d
> a memory barrier for some obscure/undocumented reason and this doesn't he=
lp
> to understand the code.
>=20
> > > If ->state include TASK_INTERRUPTIBLE, why do we need TASK_WAKEKILL?
> > >
> > > And again, why TASK_FROZEN?
> >
> > So, should it be just TASK_INTERRUPTIBLE | TASK_FROZEN ?
>=20
> Again, TASK_FROZEN is pointless at least until you change fs/proc or unti=
l
> you have wake_up_state(TASK_FROZEN). May be cgroup_do_freeze() and/or
> ptrace_attach() could use it, but see above, I'd suggest to make another
> patch.
>=20
> Looks like you need TASK_KILLABLE, see below.
>=20
> > > > +	clear_thread_flag(TIF_SIGPENDING);
> > > > +	schedule();
> > > > +	recalc_sigpending();
> > >
> > > I simply can't understand these 3 lines above but I bet this is not c=
orrect ;)
> >
> > So, yeah, the problem is that if there is TIF_SIGPENDING bit set, sched=
ule()
> > will return immediately, so we're getting pretty much a busy loop here.
>=20
> I suspected this answer ;)
>=20
> > This is a nasty workaround.
>=20
> No, this is very wrong. Just suppose the caller is killed right before
> clear_thread_flag(TIF_SIGPENDING).

So, I had TASK_KILLABLE before, but had some issues with ptrace/gdb.
I'll revisit this option.

>=20
> > I believe we can clear and not call recalc_sigpending() at all. Does th=
is seem
> > to be correct?
>=20
> I think you need to simply remove both clear_thread_flag() and recalc_sig=
pending().
> If schedule() is called in TASK_KILLABLE state it will return only if
> fatal_signal_pending() is true, and this is what we want, right?
>=20
> OK, it seems you are going to make the new version anyway, so I can wait =
for it
> and not read this series ;)

Sure! I'm about to post it.

Thanks!
