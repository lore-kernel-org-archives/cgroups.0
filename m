Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794855964;
	b=gU/PLX0+dUlHHC7ZCVTMqUTTRkcWd0L/6IYlog7oyp2GC4dj6Hg6odEIxgN8QNVoSJ8L
	 Ql0siUy+iYcVeOEucdOc9kD0VauOq5igkq8uZZk1WWnw7DkC3/PLi4uduJSDnOGcnOXFx
	 BKiHz/O1FB60Kxr6T/OH9+C/PxrhZ0+56pOqKSVEONr+yR1rKOHjtXi7/oUTbfjFENbm6
	 LZvW2HKkxn38570G09de7i4LNFPBIXtNFtFvMTF7So2ioFrpzhSKS9mXEg9E2f6knTMTv
	 BZZRjMOzFNLNOB2JrSbHtQBs4b70A8Ji4ElP4odbRdA2Ozdy+Y8Zm5YqaZZ4mNb+0hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794855964;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=c7kHFQNtHHCA9GqdWu4FwicvvHwQfScFWuPDB3TXQvk=;
	b=O48KfTmi363HssDk+YiZ/Eeug5F3bGjoc1qSPE1n+cZRMRl28tlgNEcrPa+utRtm7JFl
	 txz9v0QK4BCoQs0XgH05x6OYvh4SXPJVjXCK9wqqqwtfBxMOMTVxUTRHhZNclQn7CotPk
	 SPzCLb4OSrWeNKgSDE9anFrJK1dKK1DnWD/BNq0U7rCgBehVFMuJcWvMGK9O8ufRjn+oA
	 pB7pjpqKHbkEOu/aG4d3a9OVM2tkPAGzfKEETt2W6wqOJj/dzOPZJvhPdKCh4lwHUJsLn
	 pJdeavvoDc3fZQ9i7ShBmK+Q2G+bjq0xpkYV/MSMH6mLzWsKd02zrqh9Wn1GTkl2qWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=fytTXzYR;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E648606A89C;
	Mon, 16 Nov 2026 19:06:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E648606A89C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=fytTXzYR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794855954;
	bh=c7kHFQNtHHCA9GqdWu4FwicvvHwQfScFWuPDB3TXQvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fytTXzYRWKttd0lVwY9DuIbHmhDRjp0QF75uB64/BUSFFGGhLJGNthj6HiJCm17C8
	 +jSJ8riP6vC243y5NIXpFdLNyW/YoWafkp68ZjB7cIoRZO17+bz6zMxSe5CURa/jQT
	 7vr3hK/1O+sWDE5HuVa3FojPQyc+PSSx8k63ZQKn0BjcVjnnx7TboJajF5aE5rUhWu
	 U91XA+pT+10duFr8rW7xc2RlZCy/t7Mwrxgqrz4cUkyvVNpnut0RAtUJ1V0B7Glg8E
	 pvJNqYHQpnODs2UeSHwvnrXj29vspPO7RqWSjVx0k21LJqxi/Fag957OjgOUbdzTEI
	 dZ+Sje9b0xdrg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jSy4f3pyQzRGc;
	Mon, 16 Nov 2026 14:05:54 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	tglx@kernel.org,
	will@kernel.org,
	boqun@kernel.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	luca.abeni@santannapisa.it,
	mathieu.poirier@linaro.org,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	parri.andrea@gmail.com,
	m.szyprowski@samsung.com,
	kayracizmeci@gmail.com,
	weihengqiuu@gmail.com,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH v6 05/37] sched/deadline: Refuse dl_server debugfs writes while the rq is offline
Date: Mon, 16 Nov 2026 14:05:17 -0500
Message-Id: <20261116190549.230119-6-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261116190549.230119-1-mathieu.desnoyers@efficios.com>
References: <20261116190549.230119-1-mathieu.desnoyers@efficios.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 4043f5498416 ("sched/deadline: Reject debugfs dl_server writes
for offline CPUs") refuses a write to a dl_server's runtime or period
on an offline CPU. Its message says that such a write has no meaningful
semantics.

It tests cpu_online(). But during hotplug the CPU is still online while
it sits in the default root domain. This lasts from the rebuild in
sched_cpu_deactivate() to the offline, and from the online to
sched_cpu_activate(). That root domain does not count the server's
bandwidth. A write in the window still goes through admission. With
admission control off, it changes total_bw there. On v7.4-rc1, a write
of the current value divides by zero in that window. The previous patch
removes the division, not the write.

Fix this by testing rq->online instead. It is set under the runqueue
lock when the CPU joins a root domain that counts it, after
cpu_active() is set.

A write now fails with EBUSY while the CPU goes offline or comes
online, as a write on an offline CPU already does. Writes at any other
time are unchanged.

Applied without the previous patch, this patch alone also stops the
oops. The reproducer survives 20 rounds with no warning, in 3 VMs of 3.

Fixes: d741f297bcea ("sched/fair: Fair server interface")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/debug.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index e6a3b516c703..e0d6cd3bd607 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -410,7 +410,15 @@ static ssize_t sched_server_write_common(struct file *filp, const char __user *u
 			return  -EINVAL;
 		}
 
-		if (!cpu_online(cpu_of(rq)))
+		/*
+		 * Refuse the write while the runqueue is offline. This
+		 * includes the windows where the CPU goes offline or comes
+		 * online. The root domain then does not count the server's
+		 * bandwidth, and may have no active CPU. rq->online is set
+		 * under this lock when the CPU joins a root domain that
+		 * counts it. cpu_active() is set before that.
+		 */
+		if (!rq->online)
 			return -EBUSY;
 
 		update_rq_clock(rq);
-- 
2.47.3

