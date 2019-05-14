From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] signal: don't always leave task frozen after
 ptrace_stop()
Date: Tue, 14 May 2019 17:46:07 +0000
Message-ID: <20190514174603.GB12629@tower.DHCP.thefacebook.com>
References: <20190513195517.2289671-1-guro@fb.com>
 <20190514160158.GB32459@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=iFTJ0SqketpKa3Ua/Wo7Oc5guTdLd4V8cmejc+ytmug=;
 b=lukHVSqqVLpq/Gt+ZszLWxFY6MEWOlHIp0DoS3rW9X+JDMD9I8ipHev2goAdWseEwUQB
 RnTOMqHXcu41mbxqPh1Eb7Pikyo1wQZUPb4rjCI8AqUp0tZwL+kNuI8RXVQv6HqRs2Se
 Rp5EROZr7k9B86QcHfDBq9JjvLiSz1gEwzg= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iFTJ0SqketpKa3Ua/Wo7Oc5guTdLd4V8cmejc+ytmug=;
 b=GukmpHwaZrU4SLgX/I8WijkXNZveGAuFz+tDhn/Sjs1/AqDGVT+eR1zJf4FCN8xcN8hjz+1aj2tNwkkvW17jYBz7mQamSer4MHNPcmFUnIjHDAi9xjjJ6ND8E0ypVqjhfbR0oDZ701U3bvv+aFAdmb3Kd14gmZoeX8lbT7DZFWw=
In-Reply-To: <20190514160158.GB32459@redhat.com>
Content-Language: en-US
Content-ID: <C22CEF3A0D495548B30C6E790ADAA0FC@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Alex Xu <alex_y_xu@yahoo.ca>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Tue, May 14, 2019 at 06:01:59PM +0200, Oleg Nesterov wrote:
> Roman,
>=20
> Sorry, I can't agree with this patch. And even the changelog doesn't
> look right.
>=20
> On 05/13, Roman Gushchin wrote:
> >
> > The ptrace_stop() function contains the cgroup_enter_frozen() call,
> > but no cgroup_leave_frozen(). When ptrace_stop() is called from the
> > do_jobctl_trap() path, it's correct, because corresponding
> > cgroup_leave_frozen() calls in get_signal() will guarantee that
> > the task won't leave the signal handler loop frozen.
> >
> > However, if ptrace_stop() is called from ptrace_signal() or
> > ptrace_notify(), there is no such guarantee, and the task may leave
> > with the frozen bit set.
>=20
> ptrace_signal() looks fine in that the task can't return to user-mode,
> get_signal() will be called again exactly because ->frozen =3D=3D 1 means
> TIF_SIGPENDING. So I an not surre I understand why ptrace_signal() does
> ptrace_stop(false) with your patch. But this is minor.
>=20
> > It leads to the regression, reported by Alex Xu. Write system call
> > gets mistakenly interrupted by fake TIF_SIGPENDING, which is set
> > by recalc_sigpending_tsk() because of the set frozen bit.
>=20
> IMHO, the real problem is not that syscall was interrupted. The problem
> is that a frozen task must never start the syscall.
>=20
>=20
> -------------------------------------------------------------------------=
--
>=20
> Can't we add the unconditional leave_frozen() into ptrace_stop() for now =
?
>=20
> Sure, this is not what we want. Debugger can disturb CGRP_FROZEN.
>=20
> But. The "may_remain_frozen" argument uglifies this code too much (imo) a=
nd
> at the same time it doesn't solve the problem above: CGRP_FROZEN can be c=
leared
> "for no reason".
>=20
> Say, why ptrace_event_pid() should do leave_frozen(true) ? And if there i=
s any
> reason, then why wait_for_vfork_done() can do leave_frozen(false) ?
>=20
> Or syscall-exit path. It can't miss get_signal(), it doesn't need leave_f=
rozen().
>=20
>=20
> In short, I believe that compared to the unconditional leave_frozen() in =
ptrace_stop()
> this patch buys almost nothing, but makes the code and the whole logic mu=
ch uglier.
>=20
> Oleg.
>=20

Hi Oleg!

I agree that "may_remain_frozen" adds a lot of ugliness, so let's fix
the regression with the unconditional leave_frozen(true). The patch below.
Please, let me know if it's not what you meant.

The problem is that it makes the ptrace freezer kselftest to flap,
so it's good only as a temporarily solution. But it looks like we agree her=
e.

Thank you!


--

From 2602261b066a06f6884057d2cd7369951768b9ed Mon Sep 17 00:00:00 2001
From: Roman Gushchin <guro@fb.com>
Date: Tue, 14 May 2019 10:13:19 -0700
Subject: [PATCH] signal: unconditionally leave the frozen state in
 ptrace_stop()

Alex Xu reported a regression in strace, caused by the introduction of
the cgroup v2 freezer. The regression can be reproduced by stracing
the following simple program:

  #include <unistd.h>

  int main() {
      write(1, "a", 1);
      return 0;
  }

An attempt to run strace ./a.out leads to the infinite loop:
  [ pre-main omitted ]
  write(1, "a", 1)                        =3D ? ERESTARTSYS (To be restarte=
d if SA_RESTART is set)
  write(1, "a", 1)                        =3D ? ERESTARTSYS (To be restarte=
d if SA_RESTART is set)
  write(1, "a", 1)                        =3D ? ERESTARTSYS (To be restarte=
d if SA_RESTART is set)
  write(1, "a", 1)                        =3D ? ERESTARTSYS (To be restarte=
d if SA_RESTART is set)
  write(1, "a", 1)                        =3D ? ERESTARTSYS (To be restarte=
d if SA_RESTART is set)
  write(1, "a", 1)                        =3D ? ERESTARTSYS (To be restarte=
d if SA_RESTART is set)
  [ repeats forever ]

The problem occurs because the traced task leaves ptrace_stop()
(and the signal handling loop) with the frozen bit set. So let's
call cgroup_leave_frozen(true) unconditionally after sleeping
in ptrace_stop().

With this patch applied, strace works as expected:
  [ pre-main omitted ]
  write(1, "a", 1)                        =3D 1
  exit_group(0)                           =3D ?
  +++ exited with 0 +++

Reported-by: Alex Xu <alex_y_xu@yahoo.ca>
Fixes: 76f969e8948d ("cgroup: cgroup v2 freezer")
Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
---
 kernel/signal.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/signal.c b/kernel/signal.c
index 8607b11ff936..565ba14d89d5 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2112,6 +2112,7 @@ static void ptrace_stop(int exit_code, int why, int c=
lear_code, kernel_siginfo_t
 		preempt_enable_no_resched();
 		cgroup_enter_frozen();
 		freezable_schedule();
+		cgroup_leave_frozen(true);
 	} else {
 		/*
 		 * By the time we got the lock, our tracer went away.
--=20
2.20.1

