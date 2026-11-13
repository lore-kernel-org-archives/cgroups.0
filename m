Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794567042;
	b=DSbRxA8yiGUh8kWF0tsxBVNQHHc7Eu0akgjKeh46uAH3Z4LbT9riOrJolAWYpZZ4yrRP
	 dodn5UEMioY4WkKUdLgGja3vwyw7XzxGFt6TG7BmEzpWa/5OyhARmz2JwHsQPnoNUMXK7
	 xYYO7xNbajvan0cREoh0kToN8hPWNgI3aGqThmw/xptspeIaygorNoTWIbjYvJYUj+Hls
	 yw2pht35Dshsjfs4rQ9kc7rzOcj+tqw3ImsURZYqi59z+IKAodLRVAatsHkArtf5kq2BR
	 MYWdKGBig5/aqpHi333OoQ0QFH1pDSlCIsAPQiIcwbkXoRKaO27pqpBJUqXTG1z/aBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794567042;
	h=DMARC-Filter:From:DKIM-Signature:DKIM-Signature:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=qKATZfaP7j93mPzPK2LI85ABT996WxYe1HUN7LIOWWs=;
	b=HZwBG73bK5MXcgQPQkvj7RvIWo92iEYRoigAteFKAbdkOny7Wlv+07umEIHpFGZasiRR
	 Mi18XOflO/AZncYg6/gB7OQ3PFfEU5oJj3iFTY1Duokk5Q7adWxaXnh6niE6COH6rhniv
	 0FqfV3yLbyhoohYB3GBpEL4igi0vJpd23w2ljnRzyWoooSls57j5HCEkLmpFNS69zvrha
	 WtOPYNYHfg7MAKMGHZ8wHplI8iG9hhUYeV7JaLwczm+khUyucAsKneXjiG44pncZtQwGv
	 Fg7xuroxWCL6NZ7atCsH7um8I6i1zMfaC+s9ISmg+68SWX7Qc3o/hnz8x0/xj2OyJ/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=zXlIeLQm;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=LmL4VpeG;
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5849A60A2621;
	Fri, 13 Nov 2026 10:50:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5849A60A2621
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=zXlIeLQm;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=LmL4VpeG
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1794567040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qKATZfaP7j93mPzPK2LI85ABT996WxYe1HUN7LIOWWs=;
	b=zXlIeLQmBG1ux3nUFjTlGOJDrBaxToMN0OdlYlHrKRf2zEunqnLosDGNZ/GeqQw0HqFjAm
	fV6prU9gxlIeq4IjzwsJWpNg2MkqIMP05K8xme6aTNrsaHkqXa2ZkDnpRxoLiSkPACRTvV
	hw61bSjZycWlz5xRU55zOm+glOiZ8Sndord7CvN0TEorW5aMtSjfAJpjnddiiXi5TfVx3w
	BE8lkh8Q8KOwpyBU+D3F31EnNnyhvZXaO88Zhr3dfiTI0/+NLwWZcCzvXjyiIyfaAcq8hP
	qB/H09dniPahJ2jMIM3q1D6Qt0oh8DG3ic3j2HPRnmFZgwmwvA0Nmf0VK7jtNg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1794567040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qKATZfaP7j93mPzPK2LI85ABT996WxYe1HUN7LIOWWs=;
	b=LmL4VpeGvKLQSQpcS9ht5HCIVeiq9actrPPxXHcawHQCvlCGhctfcJh36PcuBUhW+FNYrX
	n7b2TgA9kuc8+dBQ==
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
Subject: [PATCH v3 8/8] Documentation/sched: Add fairserver to sched-deadline
Date: Fri, 13 Nov 2026 11:50:29 +0100
Message-ID: <20261113-sched_dl-v3-8-a76ffa1cdeee@linutronix.de>
In-Reply-To: <20261113-sched_dl-v3-0-a76ffa1cdeee@linutronix.de>
References: <20261113-sched_dl-v3-0-a76ffa1cdeee@linutronix.de>
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

