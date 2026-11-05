Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793880578;
	b=DleiVMgQb/KoFS1NuYlHO7zLlZ3bDLur+vx126n6+GlaPNzsEsrbOAj75K7h7NWgPKRM
	 Af6MPqEsfgwNitiDiKsxrEOU6OYnoNXAyZwE3fVkPMhoXQbDbdUR3YovvfuoGYGBh+6D3
	 StMCAkrWnlDEd25yUMORHgldGO3ZufoLFdwmkeqx8bTpfFLPh8KwetbAXPC4BmMDt1KXf
	 +Lx5+yhluMcj5G8xx42ABaBnV2D8I3ABaQe/Uofw5pSmPq/XKanL43+ATABSMcdfJjvTI
	 oPyq7Xvh5Q13PMTH91QNnp8Xw9+uh4wUVqvMDVb04b2lGkItX7F2nD8Sr6gO6Xv86dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793880578;
	h=DMARC-Filter:Date:DKIM-Signature:DKIM-Signature:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=VLI3tsLjWgFo/M+ht55Dzc93Zh+oSgKyrWv+ds6AzTE=;
	b=aPaYf8n4PWRPjhOZ8D75SdRgCT7/Rz7vYvlPXXpgDZYzy8Qlh+9VTVd7BagQ4SYlBVPY
	 MG2kYWfZZQJepxHOjsevXFNFnOJnOBsf3KftQj18667uhEO857BQrGdkZFgy4OAd5MRpI
	 t9+PuY0q6we72kDynTftV4TUFE5elzDu4Na5DreHDsFLfdsTvb5htHtehSZ73UROlq/k/
	 Yzv5LIZxY7PybIhwQtCTWzvJwQeZA0qmucdmjZurc91fraD1gkyBXuoekPVQHpVpjBavL
	 +81NIIOdJi54nGQCak7P9Kk8cacHfqdq8+jBXp8uznh5mX2yPeccBR1oZn0xqNRdLYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=H8eEqMlz;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=yRTd4ZoV;
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673ED606A336;
	Thu,  5 Nov 2026 12:09:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 673ED606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=H8eEqMlz;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=yRTd4ZoV
Date: Thu, 5 Nov 2026 13:09:32 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1793880574;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VLI3tsLjWgFo/M+ht55Dzc93Zh+oSgKyrWv+ds6AzTE=;
	b=H8eEqMlzcdzd898GU7zTXYGjslyeROH/zk5iNNfAxJvqkuiCVMx6T5f57A1xkNeKVwD86d
	ifZku4DiICEaldOxgdpNHm1fiDo60m3NP9LZzbhef46u3hUsjGM8oqQiZMFn0ZcZFFvFLo
	OnwMhS3FZKkaTmVakcVewkEzMsyUP79BOGmxWRSzTVYGmk1j1pBXPEikeof6JaghZ08jzS
	ZAKcas2pn5mLYHldeFjMhNhwPeX+yxnk6NzuXH30Gldj1ersbJtAsgfhRB9Fhl6R/5/Aj4
	lNshfVMKNkzUrjfl80rqBSIv30FertsWiaYWWEyhR/gMyVHhrprZvFOIjEbuNA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1793880574;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VLI3tsLjWgFo/M+ht55Dzc93Zh+oSgKyrWv+ds6AzTE=;
	b=yRTd4ZoVKPen8uZuQO4i3zPiyG+f/HGwwIBXFtWW80/LwERbrOwLbSzuEwT32cSgRpA+HE
	yJgOHF5Lhsy35KAQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Juri Lelli <juri.lelli@redhat.com>
Cc: linux-rt-devel@lists.linux.dev, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
	John Ogness <john.ogness@linutronix.de>,
	Shrikanth Hegde <sshegde@linux.ibm.com>
Subject: Re: [RFC] RT throttling, DL/ fair server, RT_GROUP_SCHED and
 everything
Message-ID: <20261105120932.lSBBenqn@linutronix.de>
References: <20261023161348.t3lpPLQZ@linutronix.de>
 <at8J1mimeQ2oPZDE@jlelli-thinkpadt14gen4.remote.csb>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <at8J1mimeQ2oPZDE@jlelli-thinkpadt14gen4.remote.csb>

On 2026-10-26 09:05:42 [+0100], Juri Lelli wrote:
> Hi Sebastian,
Hi Juri,

> On 23/10/26 18:13, Sebastian Andrzej Siewior wrote:
> > Hi,
> >=20
> > this is about the old RT throttling mechanism, the DL/fair server around
> > the RT tasks, the /proc/sys/kernel/sched_rt_* mechanism to control the
> > former and CONFIG_RT_GROUP_SCHED which never worked as it supposed to.
> > The current status looks like a mess and I'm not sure if there is a bug
> > somewhere leading to my headaches or if this is just not meant to be
> > working together. If so out with it.
> >=20
> > tl;dr /proc/=E2=80=A6/sched_rt_*, sched_rt_runtime_exceeded() probably
> > CONFIG_RT_GROUP_SCHED should be removed. A bit of docs should be added
> > for the fair server (or the right place).
>=20
> Thanks for putting this recap together!
>=20
> > Now. Details.
>=20
> ...
>=20
> > Without enabled RT_GROUP_SCHED the files can be set. Are they useful?
> > According to Documentation/scheduler/sched-deadline.rst it used for
> > "admission control" whatever that means. Anyway the fair server still
> > kicks if it is disabled. So I *think* this is just something else and
> > not part for the docs there.
>=20
> Right, confusing, but for a root_domain comprising M CPUs, -deadline task=
s can
> be created while the sum of their bandwidths stays below
>=20
>   M * (sched_rt_runtime_us / sched_rt_period_us)

My understanding is that this is the runtime available to a DL task and
the length of a DL period (after the accounted runtime is reset). The
left over runtime (of runtime is less than period) is either buffer
(idle) or SCHED_OTHER runtime.
This defines how much runtime a DL task gets from the system, correct?

> and writing -1 disables the check altogether. That's the "admission contr=
ol"
> the docs hand-wave about, and it's also why the knobs can't simply be del=
eted.
> As you noticed already, the servers are completely independent of these k=
nobs:
> writing -1 does not disable the fair server, it only lifts the DL admissi=
on
> cap. In principle we could move this to a different interface that reads =
closer
> to the underlying purpose, but I'm not sure how much breakage it could ca=
use.

That is my point. The rt_ runtime/ period is about DL properties and not
RT as in SCHED_FIFO/ RR as it once was. Both are set to one second as of
today and can not be changed with enabled CONFIG_RT_GROUP_SCHED.

Could we please move it to /sys/kernel/sched/ and rename it as dl
something? Is there any reason to keep as-is? There is
	Documentation/scheduler/sched-deadline.rst
	Documentation/arch/arm64/asymmetric-32bit.rst

referring to it in DL context. There is "ftracetest" writing
unconditionally -1 as a workaround, see commit 57c4cfd4a2eef
("ftrace/selftests: workaround cgroup RT scheduling issues").

If the runtime/ period arguments are fine then we could keep
it and make them only apply for the DL period.

Two files have been repurposed and if your intention as to disable the
RT throttler then you will be surprised.

> ...
>=20
> > Anyway. Could this interface be moved to /sys/kernel/sched/fair_server
> > away from the debugfs part? debugfs is not for stable kernels/ ABI. Is
> > there a reason why this might be considered debugging and not final or
> > restricted from productive?
>=20
> I think this was raised already in the past, but at the time maybe it
> was still to early to say if dl-servers will stick around. They now have
> got more users (sched-ext), so it might be a time we discuss a stable
> (non-debug) interface for it. Your suggestion doesn't look bad to me.

Thank you.

> > Just to summarize:
> > - Remove /proc/sys/kernel/sched_rt_*
> >   [ ] Yes [ ] No, because
> >               _____________________
>=20
> Yes and no :). We need an interface to tweak admission control, but we
> could find a better/different one.

Okay.

> > - Remove CONFIG_RT_GROUP_SCHED
> >   [ ] Yes [ ] No, because
> >               _____________________
>=20
> Luca already commented on this. I believe the plan is still to come up
> with a DEADLINE backed RT_GROUP_SCHED for Cgroups v2. If cleaner, an
> approach could be to first merge the removal of RT_GROUP_SCHED and then
> reimplement the whole lot as Yuri and Luca are proposing to do. The
> series is already somewhat doing that, but it could be made more
> explicit/clean I guess.

okay, then let me prepare a removal of this then.

> > - An additional trace sched event for fair server preemption
> >   [ ] Yes   [ ] No, it is silly to have
>=20
> With 820725b0eb59f ("sched: Add deadline tracepoints") we already have
> some of that: sched_dl_{throttle,replenish,update,server_start,server_sto=
p},
> which fire for fair/ext servers too (there's a type field, DL_SERVER_FAIR
> and friends). They of course require something like this [1] to be
> activated. We could add more if they are still not enough to get a clear
> picture about what's going on.

Hmm. You may want to merge Qais's current master to get it compiled
again ;) But then nothing hooks it up, so I just replaced with with
trace_printk() just to see what happens and got:

|       loop-time-1612    [000] d.h1.   154.121809: sched_stat_runtime: com=
m=3Dloop-time pid=3D1612 runtime=3D3999981 [ns]
|       loop-time-1612    [000] d.h1.   154.123812: sched_stat_runtime: com=
m=3Dloop-time pid=3D1612 runtime=3D2003097 [ns]
|       loop-time-1612    [000] d.h1.   154.123812: replenish_dl_entity: tr=
ace_sched_dl_replenish_tp
^
|       loop-time-1612    [000] dN.2.   154.123814: sched_stat_runtime: com=
m=3Dloop-time pid=3D1612 runtime=3D1783 [ns]
|       loop-time-1612    [000] d..2.   154.123815: sched_switch: prev_comm=
=3Dloop-time prev_pid=3D1612 prev_prio=3D9 prev_state=3DR =3D=3D> next_comm=
=3Dksoftirqd/0 next_pid=3D14 next_prio=3D120
|     ksoftirqd/0-14      [000] d..2.   154.123817: sched_stat_runtime: com=
m=3Dksoftirqd/0 pid=3D14 runtime=3D3036 [ns]
|     ksoftirqd/0-14      [000] d..2.   154.123817: update_curr_dl_se: trac=
e_sched_dl_update_tp
|     ksoftirqd/0-14      [000] d..2.   154.123818: dl_server_stop.part.0: =
trace_sched_dl_server_stop_tp
|     ksoftirqd/0-14      [000] d..2.   154.123819: sched_switch: prev_comm=
=3Dksoftirqd/0 prev_pid=3D14 prev_prio=3D120 prev_state=3DS =3D=3D> next_co=
mm=3Dloop-time next_pid=3D1612 next_prio=3D9
|       loop-time-1612    [000] d.h1.   154.125809: sched_stat_runtime: com=
m=3Dloop-time pid=3D1612 runtime=3D1992016 [ns]
|       loop-time-1612    [000] d.h1.   154.129809: sched_stat_runtime: com=
m=3Dloop-time pid=3D1612 runtime=3D4000522 [ns]
|       loop-time-1612    [000] d.h1.   154.133809: sched_stat_runtime: com=
m=3Dloop-time pid=3D1612 runtime=3D3999631 [ns]
|       loop-time-1612    [000] d.h2.   154.133810: sched_waking: comm=3Dks=
oftirqd/0 pid=3D14 prio=3D120 target_cpu=3D000
|       loop-time-1612    [000] d.h3.   154.133811: sched_stat_runtime: com=
m=3Dloop-time pid=3D1612 runtime=3D1463 [ns]
|       loop-time-1612    [000] d.h3.   154.133811: dl_server_start: trace_=
sched_dl_server_start_tp
|       loop-time-1612    [000] dNh3.   154.133811: sched_wakeup: comm=3Dks=
oftirqd/0 pid=3D14 prio=3D120 target_cpu=3D000
|       loop-time-1612    [000] d..2.   154.133812: sched_switch: prev_comm=
=3Dloop-time prev_pid=3D1612 prev_prio=3D9 prev_state=3DR =3D=3D> next_comm=
=3Dksoftirqd/0 next_pid=3D14 next_prio=3D120
^
|     ksoftirqd/0-14      [000] d..2.   154.133812: sched_stat_runtime: com=
m=3Dksoftirqd/0 pid=3D14 runtime=3D2054 [ns]
|     ksoftirqd/0-14      [000] d..2.   154.133812: update_curr_dl_se: trac=
e_sched_dl_update_tp
|     ksoftirqd/0-14      [000] d..2.   154.133813: dl_server_stop.part.0: =
trace_sched_dl_server_stop_tp
|     ksoftirqd/0-14      [000] d..2.   154.133814: sched_switch: prev_comm=
=3Dksoftirqd/0 prev_pid=3D14 prev_prio=3D120 prev_state=3DS =3D=3D> next_co=
mm=3Dloop-time next_pid=3D1612 next_prio=3D9
|       loop-time-1612    [000] d.h1.   154.137809: sched_stat_runtime: com=
m=3Dloop-time pid=3D1612 runtime=3D3996495 [ns]
|       loop-time-1612    [000] d.h2.   154.137810: sched_waking: comm=3Dks=
oftirqd/0 pid=3D14 prio=3D120 target_cpu=3D000

Comparing the first and the second preemption point, it is different.
The first looks like a direct consequence of the fair_server and second
probably because of the left over budget. This reflects the
implementation and I understand if you don't want to expose this
directly as-is. There is also this where the N flag just vanishes:
|       loop-time-1612    [000] d.h1.   159.029809: sched_stat_runtime: com=
m=3Dloop-time pid=3D1612 runtime=3D3997426 [ns]
|       loop-time-1612    [000] d.h2.   159.029811: sched_waking: comm=3Dks=
oftirqd/0 pid=3D14 prio=3D120 target_cpu=3D000
|       loop-time-1612    [000] d.h3.   159.029811: sched_stat_runtime: com=
m=3Dloop-time pid=3D1612 runtime=3D1543 [ns]
|       loop-time-1612    [000] d.h3.   159.029811: dl_server_start: trace_=
sched_dl_server_start_tp
|       loop-time-1612    [000] d.h3.   159.029811: enqueue_dl_entity: trac=
e_sched_dl_replenish_tp
|       loop-time-1612    [000] dNh3.   159.029811: sched_wakeup: comm=3Dks=
oftirqd/0 pid=3D14 prio=3D120 target_cpu=3D000
|       loop-time-1612    [000] d.h1.   159.033809: sched_stat_runtime: com=
m=3Dloop-time pid=3D1612 runtime=3D3998449 [ns]
|       loop-time-1612    [000] d.h1.   159.037809: sched_stat_runtime: com=
m=3Dloop-time pid=3D1612 runtime=3D4000072 [ns]
|       loop-time-1612    [000] d.h1.   159.041809: sched_stat_runtime: com=
m=3Dloop-time pid=3D1612 runtime=3D3999901 [ns]

I assume the bandwidth was replenished and then loop-time could remain
on the CPU. It would probably help if I would weld have dump some DL
details along=E2=80=A6
I'm not sure if it would be better to add some DL details along or
extend sched_switch with a scheduling reason.

There are also no trace events for DL tasks if they exceed their
requested runtime, right? I *think* there is a signal (or can be) sent
if the DL task runs for too long.=20
The sched_pelt* events didn't contain any bandwidth information as far
as I can tell (you just pointed me there as an example how those trace
points could be utilized I suppose).

> > - Fair server documentation needs to go to
> >   [ ] It is fine where it is
> >   [ ] To ____________________
>=20
> Not fine where it is: the servers (fair & ext) work independently of
> RT_GROUP_SCHED and deserve their own description (defaults 50ms/1s per
> CPU, what they guarantee for fair tasks under RT pressure, how to tune
> or disable them). Either a new section in sched-deadline.rst (they are
> DL servers after all) or a small standalone file works for me.

Okay. Let me look into this.

> Thanks!
> Juri
>=20
> 1 - https://github.com/jlelli/sched_tp/commits/deadline-tp/
>     from Qais' https://github.com/qais-yousef/sched_tp
>=20

Sebastian
