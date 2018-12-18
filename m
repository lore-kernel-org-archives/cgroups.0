From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v5 4/7] cgroup: cgroup v2 freezer
Date: Tue, 18 Dec 2018 20:27:19 +0000
Message-ID: <20181218202701.GA12730@castle.DHCP.thefacebook.com>
References: <20181207201531.1665-1-guro@fb.com>
 <20181207201531.1665-5-guro@fb.com> <20181211162632.GB8504@redhat.com>
 <20181211184033.GA8971@tower.DHCP.thefacebook.com>
 <20181212174902.GA30309@redhat.com>
 <20181218012800.GA29563@tower.DHCP.thefacebook.com>
 <20181218171230.GA11319@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=XEy3tvj3ZOieOBrka54F1q8VdxyLqmFVK1Dvngj0DtU=;
 b=rWPvZC9NSTnPQoo60EKrofnNAnA4ql9rlDe14L4wVRhtAaQ+beAbXGsyXS70q7KAK+Vx
 FicbjCgRIQQzhhfUIKABUZwrIiYQ+n8gq1PT+VAupLCruV+PoZlV/iY6Ri8RVvJ10tHP
 qg8eaPFXRtpTf7J8B3oV0tqjPSg9WqiVh5U= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XEy3tvj3ZOieOBrka54F1q8VdxyLqmFVK1Dvngj0DtU=;
 b=ew/yEjb3ZxOQr462+oeuHVCRo9w2o2j1zkNd/Crl6hVt2vpb0gmR0EZSsjJz3zZBPecp6940qqavN/71Mg8THVJjWwM7lNriPRPY42lSqxr7uR/2mYrFjvzTFXyjLMJtEzSrJ/aNM59zMSTvp5d0ZQEE0GoONpWy3x/PH2kQh68=
In-Reply-To: <20181218171230.GA11319@redhat.com>
Content-Language: en-US
Content-ID: <4FC50AD7A466F54C8135E833F88C1930@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, Dan Carpenter <dan.carpenter@oracle.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

On Tue, Dec 18, 2018 at 06:12:30PM +0100, Oleg Nesterov wrote:
> On 12/18, Roman Gushchin wrote:
> >
> > On Wed, Dec 12, 2018 at 06:49:02PM +0100, Oleg Nesterov wrote:
> > > > > and btw.... what about suspend? try_to_freeze_tasks() will obviou=
sly fail
> > > > > if there is a ->frozen thread?
> > > >
> > > > I have to think a bit more here, but something like this will proba=
bly work:
> > > >
> > > > diff --git a/kernel/freezer.c b/kernel/freezer.c
> > > > index b162b74611e4..590ac4d10b02 100644
> > > > --- a/kernel/freezer.c
> > > > +++ b/kernel/freezer.c
> > > > @@ -134,7 +134,7 @@ bool freeze_task(struct task_struct *p)
> > > >                 return false;
> > > >
> > > >         spin_lock_irqsave(&freezer_lock, flags);
> > > > -       if (!freezing(p) || frozen(p)) {
> > > > +       if (!freezing(p) || frozen(p) || cgroup_task_frozen()) {
> > > >                 spin_unlock_irqrestore(&freezer_lock, flags);
> > > >                 return false;
> > > >         }
> > > >
> > > > --
> > > >
> > > > If the task is already frozen by the cgroup freezer, we don't have =
to do
> > > > anything additionally.
> > >
> > > I don't think so. A cgroup_task_frozen() task can be killed after
> > > try_to_freeze_tasks() succeeds, and the exiting task can close files,
> > > do IO, etc. Or it can be thawed by cgroup_freeze_task(false).
> > >
> > > In short, if try_to_freeze_tasks() succeeds, the caller has all right=
s
> > > to assume that nobody can escape from __refrigerator().
> >
> > But this is what we do with stopped and ptraced tasks, isn't it?
>=20
> No,
>=20
> > We do use freezable_schedule() and the system freezer just ignores such=
 tasks.
>=20
> 	static inline void freezable_schedule(void)
> 	{
> 		freezer_do_not_count();
> 		schedule();
> 		freezer_count();
> 	}
>=20
> and note that freezer_count() calls try_to_freeze().
>=20
> IOW, the task sleeping in freezable_schedule() doesn't really differ from=
 the
> task sleeping in __refrigerator(). It is not that "the system freezer jus=
t
> ignores such tasks", it ignores them because it can safely count them as =
frozen.

Right, so the task is sleeping peacefully, and we know, that it won't get
anywhere, because we'll catch it in freezer_count(). We allow it to sleep
there, we don't force it to __refrigerator(), and we treat it as frozen.

How's that different to cgroup v2 freezer? If the task is frozen by cgroup =
v2
freezer, let it sleep there, and catch if it tries to escape. Exactly as it
works for SIGSTOP.

Am I missing something?

>=20
> > > And what about TASK_STOPPED/TASK_TRACED tasks? They can not be frozen
> > > or thawed, right? This doesn't look good, and this differs from the
> > > current freezer controller...
> >
> > Good question!
> >
> > It looks like cgroup v1 freezer just ignores them treating as already f=
rozen,
> > which doesn't look nice.
>=20
> Not sure I understand you, but see above... cgroup v1 freezer looks fine =
wrt
> stopped/traced tasks.

So, you think that v2 freezer should follow the same approach, and allow ta=
sks
sleeping on SIGSTOP, for instance, to be treated as frozen?
Hm, maybe. I have to think more here.

Thank you!
