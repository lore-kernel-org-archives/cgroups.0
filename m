Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794332146;
	b=DSVjSFXI8JaYFGjoB/T2RuPF0rwsxitea5dbDPaFFicBgOb47QGMRNES1Og0eTo7nQ4H
	 khY85u0h2Si673UB8qbJrxDwA4s4Ox+dNd6rBWdFpOlcgRPw+cZGhiDSxwV5sf1CdY0NE
	 E8ixPVE0qpfxwoAl92UaDptAs1oz2BLm2JZZCJ4Eej5o65fLpgXtYZXGsqxlMOYs4IhZd
	 o4MqvGAtcG1m4UllvwB6Ie57PR65F13XG3/VgmZXekcSD5ee9HcfnE1h31UWG0fWjpVgy
	 YwoUOJ9lXbYUs559dBZLA2/gOD13pCUv5AEm3yVosneYwYnNDUyEs//dQFiLlGKXIwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794332146;
	h=DMARC-Filter:From:DKIM-Signature:DKIM-Signature:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=qKATZfaP7j93mPzPK2LI85ABT996WxYe1HUN7LIOWWs=;
	b=xBf9sOVKpvhU420rTjW6ns8un/jO/huS8xboAlCXHf2KWRXx4FsJSCGRkcyXeVhF/rPH
	 TdfRWi3f9arVC3VpNMbSKw5VyIqMaWrrbnDqG4zFIQm3143PE/44j8yXdoLREWju5Wuvs
	 TVY7oAV6O9H4VymkFE7tqTMMCdRsAxFhmuL0uyBEkeNFo4ddOxLPmbj2d3IviyEFpKvQ3
	 NitjyzLSjcZ1e759CogZXyMxmdo2sW6zEJIpMq4/kb1KOjA5tpI7pSU/6yjsP/Jc7e3xB
	 NAjTE/3Vl+LDU8m0Zn9ZgxmPCTlAqECjC03dyZ+OGx61SN4pcrVMzj0AguDsufsxKhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=Nku048xR;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=N+wJ66S4;
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C1060A383E;
	Tue, 10 Nov 2026 17:35:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9C1060A383E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=Nku048xR;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=N+wJ66S4
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1794332144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qKATZfaP7j93mPzPK2LI85ABT996WxYe1HUN7LIOWWs=;
	b=Nku048xRe56rBscs+R4YPdFX3ZQuf5rxGLU4vnKamW47iJSwqSSskk5uC7qTAZEhDiCYgS
	kQL254F4o1VDFnswU6XEnYPnm0DX3qPWQ2w4mtz98GYvAaRUdteijU0g7kyfreVAA7y5nC
	CNXqC7dv5bp1nMif70MPxZkFcqEFQgROKEEV1gOU6mSIsOTXN/vAS3Jn2J6XyarqAXY3en
	XiDa5qjuzWkEVh2ADcBk9lag11WT010v5gWDks7PMRd5hAc3EVjpu6BZM19ZA8kdjP3v8o
	1ePvpKJSjCK4Q9yusrlvML/f6pvf2kGInup027oS99hGqgTIybKGLR55dG8/0g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1794332144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qKATZfaP7j93mPzPK2LI85ABT996WxYe1HUN7LIOWWs=;
	b=N+wJ66S4m4BSaxKMFhZP1MLw91xzVjEA35ES/gVfaBMB8vJa98W7GbLUj9cl0SNy/mTjgb
	iQqQOSKsrULNC5BQ==
To: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	rcu@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: John Ogness <john.ogness@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
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
	Qais Yousef <qyousef@layalina.io>
Subject: [PATCH v2 7/7] Documentation/sched: Add fairserver to sched-deadline
Date: Tue, 10 Nov 2026 18:34:49 +0100
Message-ID: <20261110-sched_dl-v2-7-cc9399f7aeb1@linutronix.de>
In-Reply-To: <20261110-sched_dl-v2-0-cc9399f7aeb1@linutronix.de>
References: <20261110-sched_dl-v2-0-cc9399f7aeb1@linutronix.de>
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
 Documentation/scheduler/sched-deadline.rst | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/Documentation/scheduler/sched-deadline.rst b/Documentation/sch=
eduler/sched-deadline.rst
index 23ea88b2ed7dc..f0d667e09d10c 100644
--- a/Documentation/scheduler/sched-deadline.rst
+++ b/Documentation/scheduler/sched-deadline.rst
@@ -577,7 +577,8 @@ Deadline Task Scheduling
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
@@ -604,6 +605,24 @@ Deadline Task Scheduling
  be thus free of oversubscribing the system up to any arbitrary level.
  This is done by writing -1 in /sys/kernel/sched/dl_runtime_us.
=20
+4.1.1 Fair server settings
+--------------------------
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
=20
 4.2 Task interface
 ------------------

--=20
2.55.0

