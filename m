From: Roman Gushchin <guro@fb.com>
Subject: Re: ptrace warning due to "cgroup: get rid of
 cgroup_freezer_frozen_exit()"
Date: Wed, 8 May 2019 18:03:12 +0000
Message-ID: <20190508180307.GA25433@tower.DHCP.thefacebook.com>
References: <1557259462.6132.20.camel@lca.pw>
 <20190507213752.GA24308@tower.DHCP.thefacebook.com>
 <20190508152536.GA17058@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=5Pvqd9AFIVjCFfG5s63rkla6Tj4DPV/b5/s/sPs/rHY=;
 b=p8DbHIUOazGolxZyeasMMbcaXJtJA0PHW9glC7dJvVSOo5q/F6BMDz090El/VnQj68LZ
 kR/zPxN2e6HNOGu/Tpd1DEm0AYxH9r8sPlgqc4rEBE/gGW1f+u5XV0ZZZTlXmeljoKvt
 gwiycTj7AUS68EGk11F7t8FpPuTiOMNzGkQ= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Pvqd9AFIVjCFfG5s63rkla6Tj4DPV/b5/s/sPs/rHY=;
 b=RUfn8/OzwB3S2QCJ5TcRFeCB31mqe+/dtmhYPkML2gh+R+bgRwYY6mtM4Cu7x5RXo4oz0GkjJZRBZP0SO2PQ7m0Bywr/RNWtp20da7EMQDfoV1wZlqiiuZ6XZfeNtt/a1SMByLzCrN29WVYuLT0cHbfuEkiKKjIzq+Ng60FSbio=
In-Reply-To: <20190508152536.GA17058@redhat.com>
Content-Language: en-US
Content-ID: <4EFE5CF94ED0C649A5834C40271345C7@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Qian Cai <cai@lca.pw>, "tj@kernel.org" <tj@kernel.org>, "lizefan@huawei.com" <lizefan@huawei.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Hello, Oleg!

On Wed, May 08, 2019 at 05:25:36PM +0200, Oleg Nesterov wrote:
> On 05/07, Roman Gushchin wrote:
> >
> > --- a/kernel/signal.c
> > +++ b/kernel/signal.c
> > @@ -2484,9 +2484,6 @@ bool get_signal(struct ksignal *ksig)
> >                 sigdelset(&current->pending.signal, SIGKILL);
> >                 recalc_sigpending();
> >                 current->jobctl &=3D ~JOBCTL_TRAP_FREEZE;
>=20
> just noticed... perhaps it makes more sense to clear JOBCTL_TRAP_FREEZE
> before recalc_sigpending(). Or simply not clear it at all, see below.

Agree, we don't need to clear it, because there is no way back for the task
at this moment, only exiting. I'm dropping this line.

>=20
> > -               spin_unlock_irq(&sighand->siglock);
> > -               if (unlikely(cgroup_task_frozen(current)))
> > -                       cgroup_leave_frozen(true);
> >                 goto fatal;
> >         }
> > =20
> > @@ -2608,8 +2605,10 @@ bool get_signal(struct ksignal *ksig)
> >                         continue;
> >                 }
> > =20
> > -               spin_unlock_irq(&sighand->siglock);
> >         fatal:
> > +               spin_unlock_irq(&sighand->siglock);
> > +               if (unlikely(cgroup_task_frozen(current)))
> > +                       cgroup_leave_frozen(true);
>=20
> Yes, ptrace_signal() can return a fatal signal... and in this case we do =
not
> clear JOBCTL_TRAP_FREEZE. This doesn't look consistent with the code abov=
e.

The same here.

>=20
>=20
>=20
> I can only repeat that somehow we need to cleanup/improve the whole logic=
.
>=20
> Say, a traced task reports syscall-enter. ptrace_stop() does enter_frozen=
().
> The cgroup can become CGRP_FROZEN after that. Now the debugger does PTRAC=
E_CONT,
> the frozen task actually starts the syscall. Obviously not good.
>=20
> Heh, and if this syscall is sys_exit or sys_exit_group we can hit the sam=
e
> warning.

Ok, I totally agree, but let's fix this noisy WARN_ON() for now,
to have some time to think about the rest.

I believe this will fix it for now:
https://github.com/rgushchin/linux/commit/3f65507e407c81d3cdf4a9145f36a8d0f=
755ca04

Please, let me know if you have any concerns here, otherwise I'll ask Tejun=
 to
pull it asap.

Thank you for looking into it!

Roman
