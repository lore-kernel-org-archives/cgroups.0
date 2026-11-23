Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795441288;
	b=amt9A/wYdt9z60YgzAzcn2QgG/L4nq4NQkL/173+FpDbxDXIVG+SuLpLzLyd+ZASB9ah
	 lp6xZsS9oE3i01eXx9R7IORdY6T9sA6EIkl8bxalBJT2llXEx+hrKhxc1x5K+dwktR5Wn
	 ldsN8Bu1SbrmE6KDOgjgnLYvv1g5i+Y7eOFbzsZVViaJfLQIK/w/gJL8fJ5rXc7cm6/Ur
	 +loJWo3Drn4tkBoXgxr9ToCOT3p5lETcvN/A2bni4ZbRrcFEFjqX68BUoBCQzstlTyXsH
	 jPzlTfarOL2/aKekjJtxVu5+J4gGerq5UbHhJ+sh/644LdUpAuC4eilwKBsB6xWxaxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795441288;
	h=DMARC-Filter:From:DKIM-Signature:DKIM-Signature:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=cBBYBLjlAq079X1zPcFLpx+yVcLxS3a0w7IA6kI6vug=;
	b=OHPrV9oMx0rsS/Ql772gzO2ABmvFX25ZscUtENcknHbqjNwaJ1EW9Po+WYoOLI1Oz5Ig
	 EEk6qb3K7VCSw2N4Kf6J6s2mGV3tY/mj6/I/mtPskk2vV8TZBXxEghn9bh36szC2gl5Nt
	 zdZLR9G44Wtm/vtFcgm+ftx0BmvlKkNTGHtTH/+akiB4QEbujWRxffv+Y7ek1mRiazpyN
	 NxXUvMzbHIyPqhsDQP4iH87FzZnM2KFeTDCEScgQt7EMg6g1xG6aAT8E7lO09amddBGuN
	 bzr3NVYU3tWOaZbWXcXcJjSFVsQfu3kXjTvUsKVJMdYKZSy6mmtz3wKipPoVM0EdbAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=uuzKinzh;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=UnvrdVCd;
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD262606A68C;
	Mon, 23 Nov 2026 13:41:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD262606A68C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=uuzKinzh;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=UnvrdVCd
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795441284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cBBYBLjlAq079X1zPcFLpx+yVcLxS3a0w7IA6kI6vug=;
	b=uuzKinzhLY6gUggensA9AdKF9HwSQEROiiZC3Bh32tQs10+fQHKM6ASgDTrReUrSMKwfQI
	fNEs4PRfX6H7x+sDOSzuX3kbQ5zdjwfVHvF3xUM4dwcQUekf2u1Vk4l1O+3veHn5GuMqE1
	AzCCM1kp+aJiW1Yr4/ClBOE9bOHr/Epj3uT8AB5su3AU9uiSw8XE0Jd2mjRQAkXbRbLoEv
	OIbvnH1uJomjck9stsO+3Eu2OpvKZkOiLHvhQTSEGaWYEO25HgLcoSxuWS70S1BCi7nw6T
	jKvnKoSdHirM9xPJqvKbsSFAIbn7XKZCiNt2YoL69ZL8FBxG5x4m3dPM6Btwrw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795441284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cBBYBLjlAq079X1zPcFLpx+yVcLxS3a0w7IA6kI6vug=;
	b=UnvrdVCdTs1oo+Weoqtvnm3XclHC0ucFLW1imkJRcZI/ztNv/HRrjA+lPiUS0VJ9k/ZOq0
	SJOxN1J6u6apAvBQ==
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
Subject: [PATCH v4 6/6] Documentation/sched: Add fairserver to sched-deadline
Date: Mon, 23 Nov 2026 14:41:12 +0100
Message-ID: <20261123-sched_dl-v4-6-d523e4d960d3@linutronix.de>
In-Reply-To: <20261123-sched_dl-v4-0-d523e4d960d3@linutronix.de>
References: <20261123-sched_dl-v4-0-d523e4d960d3@linutronix.de>
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
Content-Transfer-Encoding: quoted-printable

The fair_server ensures the fair-class gets CPU run-time and throttles
even the rt-class if needed. Add this bit of wisdom and the recently
added sysfs knobs for configutiation.

Assisted-by: LLM
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 Documentation/scheduler/sched-deadline.rst | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/Documentation/scheduler/sched-deadline.rst b/Documentation/sch=
eduler/sched-deadline.rst
index b76bb61cd48fd..b2c1ae8b7dddf 100644
--- a/Documentation/scheduler/sched-deadline.rst
+++ b/Documentation/scheduler/sched-deadline.rst
@@ -552,7 +552,8 @@ Bandwidth management
  level.
=20
  A main difference between deadline bandwidth management and RT-throttling
- is that -deadline tasks have bandwidth on their own (while -rt ones don't=
!),
+ is that -deadline tasks have bandwidth on their own (while -rt have only
+ throttling via the fair_server),
  and thus we don't need a higher level throttling mechanism to enforce the
  desired bandwidth. In other words, this means that interface parameters a=
re
  only used at admission control time (i.e., when the user calls
@@ -579,6 +580,25 @@ System wide settings
  be thus free of oversubscribing the system up to any arbitrary level.
  This is done by writing -1 in /sys/kernel/sched/dl_runtime_us.
=20
+Fair server settings
+--------------------
+
+ The fair server ensures that fair-class tasks (SCHED_OTHER) are not starv=
ed
+ and can be scheduled even when tasks in the RT scheduling class
+ (SCHED_FIFO and SCHED_RR) are consuming all CPU time. It replaces the
+ legacy RT throttling mechanism, which was configured through the procfs
+ interface.
+
+ The fair server executes fair-class tasks through a deadline-scheduling
+ server with a runtime budget. It guarantees that the runtime configured by
+ fair_server_runtime is provided within the interval defined by
+ fair_server_period.
+
+ Both values are specified in nanoseconds and can be configured on a
+ per-CPU basis through /sys/kernel/sched/cpuX. Setting
+ fair_server_runtime to 0 disables the fair server on the corresponding
+ CPU.
+
 Task interface
 --------------
=20

--=20
2.55.0

