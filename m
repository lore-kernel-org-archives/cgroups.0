From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v5 4/7] cgroup: cgroup v2 freezer
Date: Thu, 20 Dec 2018 21:43:47 +0000
Message-ID: <20181220214338.GA16795@tower.DHCP.thefacebook.com>
References: <20181207201531.1665-1-guro@fb.com>
 <20181207201531.1665-5-guro@fb.com> <20181211162632.GB8504@redhat.com>
 <20181211184033.GA8971@tower.DHCP.thefacebook.com>
 <20181212174902.GA30309@redhat.com>
 <20181218012800.GA29563@tower.DHCP.thefacebook.com>
 <20181218171230.GA11319@redhat.com>
 <20181218202701.GA12730@castle.DHCP.thefacebook.com>
 <20181220161649.GA31865@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=0YXgXI7mcWc33l9vb73uIL6NxcZpO2O+MM8onuB+MHU=;
 b=NqjK4j+YyK8rkmDQ3gQnjRI34H5if3lCb1iEintr/diCawadDcjXPn4ZVLlS2H1FvZf1
 llW4yA90exHktqG8JdWO1RABwMYtF8sccA45SdSqhVk0dIIuBGV5h+SPi1avEQYK5oEb
 gqXSbElDWeeJ9TmPJTHQVax86Q/AfehSV1k= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0YXgXI7mcWc33l9vb73uIL6NxcZpO2O+MM8onuB+MHU=;
 b=HLY04jtHPGqBSSNS2ZWxSEDCLZqhFcS0E8cZuKnztwh5oStdcI43P7nUe49oyHWqgjwB9YE6wvulFW2yxznu7oxgkzkzq2hqpfeJrsPSU14BXGX/c9PucXv8d4BwffO3St89yQbAGN5L0BbkaPRAYro1iuWhGAkDXaB4N9O7BW0=
In-Reply-To: <20181220161649.GA31865@redhat.com>
Content-Language: en-US
Content-ID: <833EAB85961EEC41B965B6416EA86CDC@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, Dan Carpenter <dan.carpenter@oracle.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

On Thu, Dec 20, 2018 at 05:16:50PM +0100, Oleg Nesterov wrote:
> On 12/18, Roman Gushchin wrote:
> >
> > > > > > --- a/kernel/freezer.c
> > > > > > +++ b/kernel/freezer.c
> > > > > > @@ -134,7 +134,7 @@ bool freeze_task(struct task_struct *p)
> > > > > >                 return false;
> > > > > >
> > > > > >         spin_lock_irqsave(&freezer_lock, flags);
> > > > > > -       if (!freezing(p) || frozen(p)) {
> > > > > > +       if (!freezing(p) || frozen(p) || cgroup_task_frozen()) =
{
> > > > > >                 spin_unlock_irqrestore(&freezer_lock, flags);
> > > > > >                 return false;
> > > > > >         }
> > > > > >
> > > > > > --
> > > > > >
> > > > > > If the task is already frozen by the cgroup freezer, we don't h=
ave to do
> > > > > > anything additionally.
> > > > >
> > > > > I don't think so. A cgroup_task_frozen() task can be killed after
> > > > > try_to_freeze_tasks() succeeds, and the exiting task can close fi=
les,
> > > > > do IO, etc. Or it can be thawed by cgroup_freeze_task(false).
> > > > >
> > > > > In short, if try_to_freeze_tasks() succeeds, the caller has all r=
ights
> > > > > to assume that nobody can escape from __refrigerator().
> > > >
> > > > But this is what we do with stopped and ptraced tasks, isn't it?
> > >
> > > No,
> > >
> > > > We do use freezable_schedule() and the system freezer just ignores =
such tasks.
> > >
> > > 	static inline void freezable_schedule(void)
> > > 	{
> > > 		freezer_do_not_count();
> > > 		schedule();
> > > 		freezer_count();
> > > 	}
> > >
> > > and note that freezer_count() calls try_to_freeze().
> > >
> > > IOW, the task sleeping in freezable_schedule() doesn't really differ =
from the
> > > task sleeping in __refrigerator(). It is not that "the system freezer=
 just
> > > ignores such tasks", it ignores them because it can safely count them=
 as frozen.
> >
> > Right, so the task is sleeping peacefully, and we know, that it won't g=
et
> > anywhere, because we'll catch it in freezer_count(). We allow it to sle=
ep
> > there, we don't force it to __refrigerator(), and we treat it as frozen=
.
> >
> > How's that different to cgroup v2 freezer? If the task is frozen by cgr=
oup v2
> > freezer, let it sleep there, and catch if it tries to escape. Exactly a=
s it
> > works for SIGSTOP.
> >
> > Am I missing something?
>=20
> Roman, perhaps we misunderstood each other...
>=20
> I still think that the cgroup_task_frozen() check in freeze_task() you pr=
oposed
> a) is not right, and b) it is not what we do with the STOPPED/TRACED task=
s which
> call freezable_schedule(). This is what I tried to say.
>=20
> If you meant that freezer v2 can too use freezable_schedule() - I agree.

Sorry for the confusion. Yeah, what I'm saying, is that freezable_schedule(=
)
will work for v2 as well.

>=20
> > So, you think that v2 freezer should follow the same approach, and allo=
w tasks
> > sleeping on SIGSTOP, for instance, to be treated as frozen?
> > Hm, maybe. I have to think more here.
>=20
> I think this would be nice. Otherwise, say, CGRP_FREEZE can be never repo=
rted
> if I read this code correctly. And this looks "symmetrical" with the fact=
 that
> a ->frozen task reacts to SIGSTOP and it is still treated as frozen after=
 that.

Yeah, looks so. I'll try to implement this in v6.

Thanks!
