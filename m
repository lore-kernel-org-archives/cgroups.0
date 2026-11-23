Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795441280;
	b=cwOdmnfDx8cQ4zYMS5Ztb33PKqVs4OAgoaTWn/YEZn4V7TLGo5q58hoirxXnAX/cnISx
	 Tiy1gtLsY04QxSdufvg5d33dNgQdUmLq14YYVylxaflZL48ist7LUbrPvH15EkIEMsnPT
	 oGqc9HFrB5l8jcGl3eKPcze0f/Vrdc4BLRH0sIzG3eD62Gt8EiZrObsnZ6VwZnPfnEaXt
	 pg2JZSpYVM1bSjpay6MNyA13pHUHpbBpmSCUN/f2ZWmrfZs2GJqoN8WClDb+T1K8hRfs+
	 StH6gakURU2cUd5aEKX/a5jNfor5ix0sNsecywYj4i8XOagSFgIyCXIYi/DJUIg9XXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795441280;
	h=DMARC-Filter:From:DKIM-Signature:DKIM-Signature:To:Cc:Subject:Date:
	 Message-ID:MIME-Version:Content-Type:X-Change-ID:
	 Content-Transfer-Encoding;
	bh=P72trEonM6Y7XOEGHhhXrhsy7lLIVh2meQdrUiqYi4o=;
	b=1f6+RqZq/P7p6dUeCrXfGPj4DMVF+7LnPiCBhApTtSk0an7ygnDCRD4z4VLmpMM3nEqN
	 pdtrYV/PVJ/4nSqUfcd7tWa20UR+thWvXCeOwfkT2bkA5mwsfbuFSyKFZ6Q4JuFecDduX
	 kWaxRDcVMEgsWWZKjgIaL2Yzm6c/63AosGl/MHc+r0vR+XdUkGbgPnfeV2Ktm5lAT0wfH
	 AUp9Qap4Z+6MXUOeBab0zwkv68a+lay/O2E50mIFlxWFbJeKKqGmqsrePLd+A/0w2d7nu
	 r/xlP/KBnNCfqATjrWLh1+eLEGt/zrpati2sxHXlqSqKR4iQrwK3r83lTnc6Owa4qaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=A+IyIYva;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=udifRIrb;
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33176606A31E;
	Mon, 23 Nov 2026 13:41:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33176606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=A+IyIYva;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=udifRIrb
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795441275;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=P72trEonM6Y7XOEGHhhXrhsy7lLIVh2meQdrUiqYi4o=;
	b=A+IyIYvauqbZDlTuFJrCwiyTiIrTR6vriQFNX+JdYJu4q8savXR4NH/dytBwbZGhjsntJd
	YnK0tmB62KjWzfNg5gquw/NhJZAWFbbufoDxyJNfowT2pCaT34i9k6sarSM6qSzHbO8jtQ
	Vx/Fk4WSB4qt6hMfaC7Kmij4NGzA7zbaN97S39RzvS73DNRkxIspmj36KJU6E/BI5qB8s7
	sbEqy16YoKSmPvKdOFncc6fXrgiwl8qY0x9ICE+tK0leB5FV8vRMsneOGWU1Rfm2pT0F65
	KwGxi3zY+mWkVgbsTmOQONY2tJDxnopqSVcLBkP9Qbu12tkaz/ypJd1Vj0Z16g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795441275;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=P72trEonM6Y7XOEGHhhXrhsy7lLIVh2meQdrUiqYi4o=;
	b=udifRIrbEh/keW0kFfcUyYMsULoybeOen4TtMT0Qo4cawCyDADEASsnztHVzeJQ/M9HIYi
	/Ay43CgGfEjxNDDQ==
To: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	rcu@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	luca abeni <luca.abeni@santannapisa.it>,
	Yuri Andriaccio <yurand2000@gmail.com>,
	Yuri Andriaccio <yuri.andriaccio@santannapisa.it>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
	Qais Yousef <qyousef@layalina.io>,
	John Ogness <john.ogness@linutronix.de>
Subject: [PATCH v4 0/6] sched: RT throttling cleanup and a bit of documentation
Date: Mon, 23 Nov 2026 14:41:06 +0100
Message-ID: <20261123-sched_dl-v4-0-d523e4d960d3@linutronix.de>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20261110-sched_dl-a9727787112f
Content-Transfer-Encoding: quoted-printable

People used to disable the RT throttling mechanism by writing -1 to
/proc/sys/kernel/sched_rt_runtime_us. Since v6.12 they can still do this
but they don't disable RT throttling anymore. Instead this throttling
mechanism has been taken over by the fair_server which can be configured
via debugfs.
This is not really documented but a hint appeared a few cycles later in
Documentation/scheduler/sched-rt-group.rst. This can be found once you
know what you are looking for because this document describes the RT
group scheduling (CONFIG_RT_GROUP_SCHED). The fair_server is used even
without it.
The then there is global DL resource control which also shares this
file proc file (which is stuck if CONFIG_RT_GROUP_SCHED is enabled).

This little series:
- Marks CONFIG_RT_GROUP_SCHED as broken because I was not allowed to
  remove it.

- Untangles DL usage of sched_rt_runtime_us and moves it to
    /sys/kernel/sched/dl_period_us
    /sys/kernel/sched/dl_runtime_us

  This keeps the _us semantic that we used to have /proc. It _could_ be
  changed to ns instead.
  The updates to the proc interface are mirrored to the /sys interface
  and produce warning on the first write without CONFIG_RT_GROUP_SCHED
  enabled.

- rcutorture is not touched anymore. Joel Fernandes is working on it.
  The rcutorture can be fixed independently since the sysctl variables
  are no longer removed.

- Adds sysfs interface under /sys/kernel/sched/cpuX to represent the
  runqueues. The only knob for now is fair_server_{period|runtime}
  representing the fair_server parameters. If all goes well, debugfs
  could be removed. The ext server could be moved, too.

- I tried to correct/ update documentation while at it. I added the -doc
  folks on Cc so they are aware. I can drop them in the next posting, I
  expect that this gets routed via the sched/-tip.

v3=E2=80=A6v4: https://patch.msgid.link/20261113-sched_dl-v3-0-a76ffa1cdeee=
@linutronix.de
  - Drop the cpu_active() verification for DL admission control updates.
    Mathieu is working on getting it to work so I preserve it and don't
    touch it.

  - Drop the RCU-torture changes. Joel is reworking it so it no longer
    needs to disable the RT-throttling (or the fair_server now).

  - The proc/ sysctl knobs are not removed. Update to the sysctl
    interface are mirror to the sysfs admission control but not the
    other way around. An update to the sysctl interface without
    CONFIG_RT_GROUP_SCHED enabled will print a warning.
    LTP was complaining about the removal. On the other hand it was just
    complaining that writting -2 to runtime resulted in EBADF instead
    EINVAL. So=E2=80=A6

v2=E2=80=A6v3: https://patch.msgid.link/20261110-sched_dl-v2-0-cc9399f7aeb1=
@linutronix.de
  - Corrected in wording sched-rt-group.rst (Pointed out by Randy)
  - RCU-torture now disables the fair_server from its boost-thread. The
    code expects the CPU to be active which is after the CPU-hotplug
    notifier is run. An alternative would be to not start the
    fair_server (in the RCU-torture built-in case).
  - sched_dl_try_boundary() has now a private mutex to perform the
    update. sashiko complains that the values are read outside of
    sched_domains_mutex and written back while it is held, making it
    possible to write stale period/ runtime values back.
  - proper u64 casting for NSEC_PER_USEC multiplication.
  - sysfs_dl_runtime is not static and accessed in
    dl_bandwidth_enabled(). This was missed earlier.
    The remaining sysctl_sched_rt_{runtime|period} are now also hidden
    behind CONFIG_RT_GROUP_SCHED.

v1=E2=80=A6v2: https://lore.kernel.org/all/20261105164724.yxONBd03@linutron=
ix.de/
  - Tejun and PeterZ asked for marking CONFIG_RT_GROUP_SCHED broken
    first.
  - Everything after patch #1 that got queued up.

RFC=E2=80=A6v1: https://lore.kernel.org/all/20261023161348.t3lpPLQZ@linutro=
nix.de/
  - Try to remove RT-GROUP-sched after figuring out that it is useless.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

---
Sebastian Andrzej Siewior (6):
      sched: Mark RT_GROUP_SCHED broken
      sched: Move DL's admission control to sysfs
      sched: Add sysfs files for the per-CPU fair_server knobs
      sched: Limit sysctl sched_rt_{period|runtime}_us to RT_GROUP_SCHED
      Documentation/sched: Drop the section enumeration in sched-deadline
      Documentation/sched: Add fairserver to sched-deadline

 Documentation/arch/arm64/asymmetric-32bit.rst |   2 +-
 Documentation/scheduler/sched-deadline.rst    | 149 ++++++------
 Documentation/scheduler/sched-rt-group.rst    |   7 +-
 init/Kconfig                                  |   2 +-
 kernel/sched/deadline.c                       | 312 ++++++++++++++++++++++=
+++-
 kernel/sched/debug.c                          |  56 +----
 kernel/sched/features.h                       |   2 +
 kernel/sched/rt.c                             |  27 +--
 kernel/sched/sched.h                          |  65 +++---
 9 files changed, 432 insertions(+), 190 deletions(-)
---
base-commit: a4d7daea71be591034445c17d4d81132a1785a12
change-id: 20261110-sched_dl-a9727787112f

Best regards,
--=20=20
Sebastian Andrzej Siewior <bigeasy@linutronix.de>

