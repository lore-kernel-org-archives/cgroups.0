From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v5 4/7] cgroup: cgroup v2 freezer
Date: Tue, 11 Dec 2018 18:40:39 +0000
Message-ID: <20181211184033.GA8971@tower.DHCP.thefacebook.com>
References: <20181207201531.1665-1-guro@fb.com>
 <20181207201531.1665-5-guro@fb.com> <20181211162632.GB8504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=PpWQbWMTDJn8Dhs/5lI36chAw7QFMQc+Ii/W6sMeU/g=;
 b=cHA7ygEVyGuJhCeEYRYLdGAR+MpbJ244XoZ4Ut90aZMXBsfNUyweXFdFMBPYcR1Hme6i
 7x8siT0izetQqvvHv5L8PwZXQtoB1rBZNQD5WnRdZycJ/2WcxmQEaJCH4E87WQ3Ho1gK
 j1lYpWbXdm8sn0OxPrhQ00GHe74Tyt+yjNU= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PpWQbWMTDJn8Dhs/5lI36chAw7QFMQc+Ii/W6sMeU/g=;
 b=kKFAZWhZcIw7qpLPF6pnKAr3tGmETMhLbCImoWCyna0lO/VP/0d/jCM5MKrCKzUw6j6WcG3y6TvabpO5L2l4c5BsM7ZyPjA1TOzWJIGqh++6XXAJ474K2c3acPZRGHvqEPXvJDTzx7QfuKVtkgrhc8SrXqtHixtQWOKA1IFRx/c=
In-Reply-To: <20181211162632.GB8504@redhat.com>
Content-Language: en-US
Content-ID: <3E1A5BC97A871243831DD0A6C3D02A1F@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, Dan Carpenter <dan.carpenter@oracle.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

On Tue, Dec 11, 2018 at 05:26:32PM +0100, Oleg Nesterov wrote:
> On 12/07, Roman Gushchin wrote:
> >
> > Cgroup v2 freezer tries to put tasks into a state similar to jobctl
> > stop. This means that tasks can be killed, ptraced (using
> > PTRACE_SEIZE*), and interrupted. It is possible to attach to
> > a frozen task, get some information (e.g. read registers) and detach.
>=20
> I fail to understand how this all supposed to work.
>=20
> > @@ -368,6 +369,8 @@ static inline int signal_pending_state(long state, =
struct task_struct *p)
> >  		return 0;
> >  	if (!signal_pending(p))
> >  		return 0;
> > +	if (unlikely(cgroup_task_frozen(p) && p->jobctl =3D=3D JOBCTL_TRAP_FR=
EEZE))
> > +		return __fatal_signal_pending(p);
>=20
> I think I will never agree with this change ;) and I don't think it actua=
lly helps.

See below.

>=20
> > +void cgroup_enter_frozen(void)
> > +{
> > +	if (!current->frozen) {
> > +		spin_lock_irq(&css_set_lock);
> > +		current->frozen =3D true;
> > +		cgroup_inc_frozen_cnt(task_dfl_cgroup(current), false, true);
> > +		spin_unlock_irq(&css_set_lock);
> > +	}
> > +
> > +	__set_current_state(TASK_INTERRUPTIBLE);
> > +	schedule();
>=20
> So once again, suppose it races with PTRACE_INTERRUPT, or SIGSTOP, or som=
ething
> else which should be handled by get_signal() before do_freezer_trap().
>=20
> If (say) PTRACE_INTERRUPT comes before schedule it will be lost. Otherwis=
e
> the frozen task will react. This can't be right. Or I am totally confused=
.

Why?
PTRACE_INTERRUPT will set JOBCTL_TRAP_STOP, so signal_pending_state()
will return true, schedule() will return immediately, and we'll handle the =
trap.

>=20
> Perhaps you can split this patch? start with cgroup_enter_frozen() using
> TASK_KILLABLE, then teach it to handle ptrace/stop/etc? I think this way =
it
> would be simpler to discuss the necessary changes and document what exact=
ly
> are you trying to do.
>=20
> and btw.... what about suspend? try_to_freeze_tasks() will obviously fail
> if there is a ->frozen thread?

I have to think a bit more here, but something like this will probably work=
:

diff --git a/kernel/freezer.c b/kernel/freezer.c
index b162b74611e4..590ac4d10b02 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -134,7 +134,7 @@ bool freeze_task(struct task_struct *p)
                return false;
=20
        spin_lock_irqsave(&freezer_lock, flags);
-       if (!freezing(p) || frozen(p)) {
+       if (!freezing(p) || frozen(p) || cgroup_task_frozen()) {
                spin_unlock_irqrestore(&freezer_lock, flags);
                return false;
        }

--

If the task is already frozen by the cgroup freezer, we don't have to do
anything additionally.

Thanks!
