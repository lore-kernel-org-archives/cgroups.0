Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794567036;
	b=ActH6j7qAme8mVxpRt+QK/TlRM3sq2BUbE1j4cv4a7xb87doi9oU1F9pc3KI74GrQ3vI
	 T8Yrpfx4kuWF8DynjbDEmEy6U2GetEOxjAcUpN8DsKtpADLtIvwYxzC1frr/MiainpfoL
	 N2EyppAJCzdyNpL92lckhVPnzHw63509Kj5k2S2uxpiqp91a1jsM8V0gkfrkQVddvfCKb
	 cVXpSdcbUSBVbfakddPGVfqKZKZjCDqjvahigezk2JMm+aRXP1XPBZnQBnc1lqgV5zAvO
	 dK+Y6bkud4HNfn2O7VqtgvkuVxf18TgKCl9wEuG1VhGEJui/HvAr83FfnfzwCeBObBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794567036;
	h=DMARC-Filter:From:DKIM-Signature:DKIM-Signature:To:Cc:Subject:Date:
	 Message-ID:MIME-Version:Content-Type:X-Change-ID:
	 Content-Transfer-Encoding;
	bh=gIZRfw4gWK7vI8bioIBfkQAfaKzsb2SmnoDPKkZQi7I=;
	b=jY68oFDWZ6WPW0kQxAANYtjFrse8V57Xo6mSLX6ucBoOlpSFlqRwpDC7nWREdqtjZrMU
	 N2rwaDdK+Tx5H3MGOHMJqILA+nSX+uLPu3B3Tnxh9cOB0ThUAwOo29wB0mvmWP7TNMSg9
	 0AFfHSW/UQ8twz6cOPScrHrNkz5ESwnSBSsper6kCc0i47xDLGC4f4uhcyivYXnU7VBVi
	 p/Vg0V6mcajx1EkuQsETVa/zpLVUq1RavdZA1bsBWTJtwJ8wnne0yPGmHRZbVZKyt4Z1/
	 sABcgzZSGitgHH2q7w3aLz8+EH0/vH2wdphuezE9mdt70JfvoNY1tGONjx+mxeaWekQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b="1/GY8KRO";
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=xmEtnQyv;
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6450606A31C;
	Fri, 13 Nov 2026 10:50:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A6450606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=1/GY8KRO;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=xmEtnQyv
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1794567033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gIZRfw4gWK7vI8bioIBfkQAfaKzsb2SmnoDPKkZQi7I=;
	b=1/GY8KRO0PIeivIWs7wDEYAwBlKeLJrO/WmKE5tRR3PsHM219SSdwK/qSUDZXzZLUpWztT
	5WpXulW3BD3kN5BKrZpffx+F3xc2gSiK9oCzysNO2ub+JIoTSoGT9jXpax78AHV78vUBky
	4jfC2wZYJQT9WVBJ6YusdzPoAMBJ0UoGiDGbRnFTwepgPlATXARSzs8lMwDQ3C1AaCurXS
	XbJ9zc+52LIISaNm2Wgs97FonQOb6NnG0D0SVR3LAs51mt+i5Slryp1McwGN6mfOapPgyH
	tVGner1TobhPyzx50+BMXK8260w53s8E8Inl7253ySnJgPQfgatZH7wptkRCaw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1794567033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gIZRfw4gWK7vI8bioIBfkQAfaKzsb2SmnoDPKkZQi7I=;
	b=xmEtnQyvnx6ZeRXMw5J3eGW0ORacrKRn68w3R2qAJi6yZXYGvhVgeocoB6AdEoEBnTjqr4
	nJzzCN0SormakEAw==
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
Subject: [PATCH v3 0/8] sched: RT throttling cleanup and a bit of documentation
Date: Fri, 13 Nov 2026 11:50:21 +0100
Message-ID: <20261113-sched_dl-v3-0-a76ffa1cdeee@linutronix.de>
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
This is not really documented by a hint appeared a few cycles later in
Documentation/scheduler/sched-rt-group.rst. This can be found once you
know what you are looking for because this document describes the RT
group scheduling (CONFIG_RT_GROUP_SCHED). The fair_server is used even
without it.
The then there is global DL resource control which also shares this
file proc file (which is stuck if CONFIG_RT_GROUP_SCHED is enabled).

This little series:
- Make sure the fair_serve configuration can only be changed while the
  CPU is active. Mathieu tries to fix this and allow it instead. That
  would be an alternative.

- Marks CONFIG_RT_GROUP_SCHED as broken because I was not allowed to
  remove it.

- Untangles DL usage of sched_rt_runtime_us and moves it to
    /sys/kernel/sched/dl_period_us
    /sys/kernel/sched/dl_runtime_us

  This keeps the _us sematic that we used to have /proc. It _could_ be
  changed to ns instead. Or replaced with a per-CPU/RQ setting if this
  is simpler/ preferred on the DL side.

- Moves rcutorture away from the procfs interface since it tries to
  shutdown the fair_server for its testing.

- Adds sysfs interface under /sys/kernel/sched/cpuX to represent the
  runqueues. The only knob for now is fair_server_{period|runtime}
  representing the fair_server parameters. If all goes well, debugfs
  could be removed. The ext server could be moved, too.

- I tried to correct/ update documentation while at it. I added the -doc
  folks on Cc so they are aware. I can drop them in the next posting, I
  expect that this gets routed via the sched/-tip.

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
Sebastian Andrzej Siewior (8):
      sched/deadline: Reject debugfs dl_server writes for not-active CPUs.
      sched: Mark RT_GROUP_SCHED broken
      rcutorture: Don't try to disable to RT throttling.
      sched: rcutorture: Allow to disable DL fair_server
      sched: Move DL's admission control to sysfs
      sched: Limit sysctl sched_rt_{period|runtime}_us to RT_GROUP_SCHED
      sched: Add sysfs files for the per-CPU fair_server knobs
      Documentation/sched: Add fairserver to sched-deadline

 Documentation/arch/arm64/asymmetric-32bit.rst |   2 +-
 Documentation/scheduler/sched-deadline.rst    |  36 ++-
 Documentation/scheduler/sched-rt-group.rst    |   7 +-
 init/Kconfig                                  |   2 +-
 kernel/rcu/rcu.h                              |   2 -
 kernel/rcu/rcutorture.c                       |  37 +--
 kernel/sched/deadline.c                       | 346 ++++++++++++++++++++++=
+++-
 kernel/sched/debug.c                          |  56 +----
 kernel/sched/features.h                       |   2 +
 kernel/sched/rt.c                             |  65 ++---
 kernel/sched/sched.h                          |  63 +++--
 11 files changed, 439 insertions(+), 179 deletions(-)
---
base-commit: fd9230005e85472b81c1c7c16afe93dd878996b1
change-id: 20261110-sched_dl-a9727787112f

Best regards,
--=20=20
Sebastian Andrzej Siewior <bigeasy@linutronix.de>

