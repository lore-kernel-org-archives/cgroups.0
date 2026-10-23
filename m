Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792772043;
	b=Z9bihGItVRIyRVVFMD+KFEzwgFqUDlEnK9Sg+U5xxElUc4Re2OeBOV63Mv55faoinfld
	 uZybV0wi8rBl15ad7LH4Anuq3nux3xfZKHgjIFTGb0BGR0L+iwNtCocFGlY+nOxyEQj3+
	 uHemCUgt05y88MDhPSaMdC0fLr9d6oCoxGv29QqErLUEoE1O83Kwpz5qchRD+0ZL9xuqk
	 MMMcKcWW59Wiih3kvVHwljRBlFS2Foo5f+e4ISgozNv4WqcU1NfCBs1sj6jhG6b/Q2ofd
	 X+zkKSm3FOo9yLxS915W3kaviEoUc86yXQjKmeRamzFmVAT39hMLQZ3+D6GWhNLf2Zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792772043;
	h=DMARC-Filter:Date:DKIM-Signature:DKIM-Signature:From:To:Cc:Subject:
	 Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding;
	bh=Asfzo7d0ZU4tyWErLKe4Wr1LaU1gRWvW6QItwU7vgRg=;
	b=zxaGQk7zmx9NSXlMbfnKH9WzXjMdcm+NuYr6ZoOtVvxUcfByAuiizBrxeH+Kb3fyZyH5
	 lyTCV4bN3BeSOwycz/Qc+7dhqkRPSSdEOL3Rf1XUYwstoF3P+Mi1DMPOEt4LACN3kvO99
	 PQf0qUJsprdvV1QpUc/ilLz+nSiDJvz09FZ+lvrOmnNN9SdN5+HxN4Iy6Vp7lzw+izCuJ
	 Y1wMup4bn1d/aWbNpB+U/1zTRxRXvH+k/lnwqCQWsW+Ajl5Z+Zf7yY8DBaSNOwXMu+4v1
	 ccbEZrW49o7H+41QhGDvk+279lI5/KzPDnDaJTxw4Es2yyNG3wUFTsnmUYXiHlkdYbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=0Yuev588;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=djBMFzOW;
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3011E606A31B;
	Fri, 23 Oct 2026 16:13:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3011E606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=0Yuev588;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=djBMFzOW
Date: Fri, 23 Oct 2026 18:13:48 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1792772030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Asfzo7d0ZU4tyWErLKe4Wr1LaU1gRWvW6QItwU7vgRg=;
	b=0Yuev588qVG8lOMhfasNCGTpCrsax7sG9ipjBEYzyoV8ZjGljdwTItl7AaTW9qI1x0KEpB
	YzE2BYMNcSwp9b6VXD/92kxE9JLbltu04UMoU8BDfEaQySj5dRsg0X3md2UFi/eskoZvna
	htKYQ1XhlFTMjxFSlBRglWwFDrs71gYgWKw4wYOF4J9sSIZ5YO/p4PV47LRxpkQfcLLg3w
	fnmkL5HwSmUpKx+mf5owISNHfaccPCWRRPf/a/nfaFPDVMQEm9utf808dtXadxxtK3hJS6
	fCihMFeqncwyfJ0P4I1W/Zm6qZ42fpErXKNjawFhwSQ2bVYAcejRJ02LJYIvjw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1792772030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Asfzo7d0ZU4tyWErLKe4Wr1LaU1gRWvW6QItwU7vgRg=;
	b=djBMFzOWevmLNVTffTsSU+q172gBXT/hEAulmgKrP3S/SYUpPL9YJmHVhVR3i5qeAf/fsx
	kSNK4HyT7nVV3BCQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-devel@lists.linux.dev, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
	John Ogness <john.ogness@linutronix.de>,
	Shrikanth Hegde <sshegde@linux.ibm.com>
Subject: [RFC] RT throttling, DL/ fair server, RT_GROUP_SCHED and everything
Message-ID: <20261023161348.t3lpPLQZ@linutronix.de>
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

Hi,

this is about the old RT throttling mechanism, the DL/fair server around
the RT tasks, the /proc/sys/kernel/sched_rt_* mechanism to control the
former and CONFIG_RT_GROUP_SCHED which never worked as it supposed to.
The current status looks like a mess and I'm not sure if there is a bug
somewhere leading to my headaches or if this is just not meant to be
working together. If so out with it.

tl;dr /proc/=E2=80=A6/sched_rt_*, sched_rt_runtime_exceeded() probably
CONFIG_RT_GROUP_SCHED should be removed. A bit of docs should be added
for the fair server (or the right place).

Now. Details.

The "old" RT throttler was meant to throttle RT task(s) that went rogue.
The idea was to throttle the RT tasks so that the admin, using
SCHED_OTHER, could step in and kill the misbehaving task.
This, as simple as it sounds, is problematic on a PREEMPT_RT system
because all the drivers are running also as SCHED_FIFO meaning
throttling the RT class resulted also in not servicing any HW. So an
admin can't interact with the system via SSH/ network or keyboard/ USB.
What often did help was the fact that the RT application did realise its
overstepping and contained themself.
As a result real-time applications under PREEMPT_RT disable the RT
throttler because from time to time they do have legitimate cases where
the RT class runs > 1s and the throttler just breaks everything. So
hush.
Some people did not learn about the RT-throttler because at some point
one CPU could run 100% real-time tasks if there were other CPUs
available (the argument was that the SCHED_OTHER workload could be moved
there).

The throttler used to be present unconditionally. Since commit
5f6bd380c7bdb ("sched/rt: Remove default bandwidth control") (v6.12) it
is hidden behind CONFIG_RT_GROUP_SCHED. Without CONFIG_RT_GROUP_SCHED
defined it does not exist, yet the proc files are there. Not sure if
they do much.

With CONFIG_RT_GROUP_SCHED enabled assigning SCHED_FIFO-1 priority to a
user task is kind of broken as it returns with -EPERM due to

| #ifdef CONFIG_RT_GROUP_SCHED
|                 /*
|                  * Do not allow real-time tasks into groups that have no =
runtime
|                  * assigned.
|                  */
|                 if (rt_group_sched_enabled() &&
|                                 rt_bandwidth_enabled() && rt_policy(polic=
y) &&
|                                 task_group(p)->rt_bandwidth.rt_runtime =
=3D=3D 0 &&
|                                 !task_group_is_autogroup(task_group(p))) {
|                         retval =3D -EPERM;
|                         pr_err("%s(%d)\n", __func__, __LINE__);
|                         goto unlock;
|                 }
| #endif /* CONFIG_RT_GROUP_SCHED */

rt_bandwidth.rt_runtime is zero and auto-group (which is SCHED_OTHER
anyway) is off. I did not find a way to enable one of these knobs. The
cgroup file (rt_runtime_us) that _should_ set rt_bandwidth.rt_runtime is
CGroup v1 and not available (since we do v2 these days). I don't see how
to bypass this. Unless rt_group_sched_enabled() is disabled I see no
hope.
Oh wait, this was exactly mentioned in commit 277e0909754e9 ("sched:
Bypass bandwitdh checks with runtime disabled RT_GROUP_SCHED").

Once I passed these gates I got stuck at the next barrier. Since commit
c2e390197ad13 ("sched/rt: Update default bandwidth for real-time tasks
to ONE") (v7.2) the value for sysctl_sched_rt_runtime is at 1s, same as
sysctl_sched_rt_period. (I am not going to mention that the
documentation in Documentation/scheduler/sched-rt-group.rst is kind of
outdated.)

This means the throttler does nothing since period can not exceed
the runtime. I'm not sure why exactly but I can't lower the value
because then tg_rt_schedulable() will complain in

|         /*
|          * Nobody can have more than the global setting allows.
|          */
|         if (total > to_ratio(global_rt_period(), global_rt_runtime()))
|                 return -EINVAL;

so that one second remains. It can be disabled (via -1). One can revert
the commit and have the throttler is working again (but more later).
Once at 0.95s it can go up to 1s and down again but it can't go below
its initial value. This does not look as it is working as designed.

Without enabled RT_GROUP_SCHED the files can be set. Are they useful?
According to Documentation/scheduler/sched-deadline.rst it used for
"admission control" whatever that means. Anyway the fair server still
kicks if it is disabled. So I *think* this is just something else and
not part for the docs there.

With RT_GROUP_SCHED enabled the two proc files can't change their
content. Plus it all kind of works just for cgroup-v1 and for v2 it
breaks RT applications. And it never worked AFAIK. So from my point of
view CONFIG_RT_GROUP_SCHED did not serve any good and can go.

Moving on. The old throttler did warn one before throttling real-time
tasks so the risk of a heart attack was limited but still there. The
sched* trace events do not show this: the RT task goes away and the CPU
might go idle in the end. But we did have the printk().
On the other hand the fair-server decides that it is time for a
SCHED_OTHER task, the scheduler obeys and we switch to SCHED_OTHER and
then back to SCHED_FIFO. Okay, more efficient (as no CPU in idle). No
hint what goes on.

In order to get to the non-throttling behavior one needs to
	echo 0 > /sys/kernel/debug/sched/fair_server/cpuX/runtime

There is a crumble of documentation in sched-rt-group.rst which went
in via commit b1536481c81fb ("sched/rt: Update limit of sched_rt sysctl
in documentation") but it has nothing to do with CONFIG_RT_GROUP_SCHED
and the fair server is 100% fine working without it. I don't think it is
the right place for this.

Side note: Remember me asking for a sched-event in sched_tick() if
sched-lazy is promoted to an actual scheduling request? Well, this is
what the fair-server preemption looks like with sched event enabled:

|       loop-time-1295    [000] d.h1.   339.006215: sched_stat_runtime: com=
m=3Dloop-time pid=3D1295 runtime=3D3999761 [ns]
|       loop-time-1295    [000] d.h1.   339.006482: sched_stat_runtime: com=
m=3Dloop-time pid=3D1295 runtime=3D267302 [ns]
|       loop-time-1295    [000] d.h1.   339.008953: sched_stat_runtime: com=
m=3Dloop-time pid=3D1295 runtime=3D2471124 [ns]
|       loop-time-1295    [000] dN.2.   339.008955: sched_stat_runtime: com=
m=3Dloop-time pid=3D1295 runtime=3D1152 [ns]
|       loop-time-1295    [000] d..2.   339.008956: sched_switch: prev_comm=
=3Dloop-time prev_pid=3D1295 prev_prio=3D9 prev_state=3DR =3D=3D> next_comm=
=3Dkworker/u4:4 next_pid=3D1148 next_prio=3D120
|    kworker/u4:4-1148    [000] d..21   339.008959: sched_waking: comm=3Dss=
hd-session pid=3D1256 prio=3D120 target_cpu=3D000

suddenly Need-resched is set and we schedule to lower prio task. Not a
problem if you know about this=E2=80=A6 Or have the timer events enabled at
which point dl_task_timer will give you a hint. But we have LLMs so=E2=80=A6

Anyway. Could this interface be moved to /sys/kernel/sched/fair_server
away from the debugfs part? debugfs is not for stable kernels/ ABI. Is
there a reason why this might be considered debugging and not final or
restricted from productive?

Just to summarize:
- Remove /proc/sys/kernel/sched_rt_*
  [ ] Yes [ ] No, because
              _____________________
- Remove CONFIG_RT_GROUP_SCHED
  [ ] Yes [ ] No, because
              _____________________

- An additional trace sched event for fair server preemption
  [ ] Yes   [ ] No, it is silly to have

- Fair server documentation needs to go to
  [ ] It is fine where it is
  [ ] To ____________________

Sebastian
