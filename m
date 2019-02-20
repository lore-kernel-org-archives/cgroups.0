From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v8 4/7] cgroup: cgroup v2 freezer
Date: Wed, 20 Feb 2019 22:14:29 +0000
Message-ID: <20190220221423.GA17163@castle.DHCP.thefacebook.com>
References: <20190219220252.4906-1-guro@fb.com>
 <20190219220252.4906-5-guro@fb.com> <20190220144202.GB9477@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=vRyGtMiV4S9uZ2jSO/FhO78PpFAG+X+zUg/RwBzRnQQ=;
 b=RyYN8mIQeQI/lqJf4sFTKZUqlT9kfQQcf6+c/9a896T4R5tCjU5AxAc12NYLAho96FVV
 3CwbkOVtoaIFT8dWN5qt+VMTbR+ZLsvINPkWn+qHPgocI1bhZc7DlAl86TzyGwCdtkyC
 DEhT0FwD/IaJt/OSZgI5Z6hZDlP/oDVMQnQ= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vRyGtMiV4S9uZ2jSO/FhO78PpFAG+X+zUg/RwBzRnQQ=;
 b=gfzc4FcFEY7JcwqjZR2gc3TU+bGeq5yThNgFNoDXwCgOLyh5TV5FgkKMQqrDaI8t5fak1vK13iUP1Vx21c1f73puzRoAxTzok9NPYfOhbmHVZj8r55rF/Fahc9Nk35UeB+UYwHlAar7zZdQLO0zKsBvc+Vc89hPVDIK4eRj1MsM=
In-Reply-To: <20190220144202.GB9477@redhat.com>
Content-Language: en-US
Content-ID: <55A513311A1D57409936E10272BF1017@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Wed, Feb 20, 2019 at 03:42:02PM +0100, Oleg Nesterov wrote:
> On 02/19, Roman Gushchin wrote:
> >
> > @@ -2065,6 +2066,7 @@ static void ptrace_stop(int exit_code, int why, i=
nt clear_code, kernel_siginfo_t
> >  		preempt_disable();
> >  		read_unlock(&tasklist_lock);
> >  		preempt_enable_no_resched();
> > +		cgroup_enter_stopped();
> >  		freezable_schedule();
> >  	} else {
> >  		/*
> > @@ -2243,6 +2245,7 @@ static bool do_signal_stop(int signr)
> >  		}
> > =20
> >  		/* Now we don't run again until woken by SIGCONT or SIGKILL */
> > +		cgroup_enter_stopped();
> >  		freezable_schedule();
> >  		return true;
>=20
> Please see my reply to 0/7.

Answered in that thread.

>=20
> > @@ -2280,7 +2286,8 @@ static void do_jobctl_trap(void)
> >  		    !(signal->flags & SIGNAL_STOP_STOPPED))
> >  			signr =3D SIGTRAP;
> >  		WARN_ON_ONCE(!signr);
> > -		ptrace_do_notify(signr, signr | (PTRACE_EVENT_STOP << 8),
> > +		ptrace_do_notify(signr,
> > +				 signr | (PTRACE_EVENT_STOP << 8),
> >  				 CLD_STOPPED);
>=20
> white-space cleanup?

Sorry, a bogus change. Please, ignore it.

>=20
> > @@ -2363,7 +2419,8 @@ bool get_signal(struct ksignal *ksig)
> >  	 * we should notify the parent, prepare_signal(SIGCONT) encodes
> >  	 * the CLD_ si_code into SIGNAL_CLD_MASK bits.
> >  	 */
> > -	if (unlikely(signal->flags & SIGNAL_CLD_MASK)) {
> > +	if (unlikely(signal->flags & SIGNAL_CLD_MASK) &
> > +	    !(current->jobctl & JOBCTL_TRAP_FREEZE)) {
>=20
> Hmm, why?

If a process is going from the stopped to the frozen state, it looks like
it's better to delay parent's notification up to the moment when it will
actually run.

Thanks!
