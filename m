Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907259;
	b=lbxDbEtkyhNdn9pGYyf4APmXqX31o9ExYon+0dd0+axMEcvjn39Y1t3jWVH7d52npt/q
	 5M7oHjgMB9JA1FN+WHG6W/uhgqt3hmPBdPpbLjtpiiLdWMRHb8uqqohiMHUk10XTVr/R9
	 AgguAP5IqYsZEv9jWsHADkgJTuKiJfxNseK4IT04YcXxW2+bv29/4W2UFn7if1VAyOOgY
	 g60xI9mIFj4CP8muGblGRWZkdQN2npfRgtaoYDAp9URtnDh1OxSg6x0BYqaKfA6DtqOCd
	 YHFluAmQQP/Aez1/q0gApeVDzmQSWtYmgJC3AAg3bkpiN20qREqZWQhX34bfxbc/yCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907259;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=dqzI7szqypUolQPlKTiL4Tger2zQvjkv2ryDgx7nJmw=;
	b=zXikZAw0qHPLhco0sO/ukw/vDKYVC175dSq5LvyyvXBqgLETmXSUO32AdCWJ3gxZ8So9
	 PIN07I402B7SavZMet0Mq2z3ATi3N5E51FwVD67RJmF2XSMhcfewkLurbozYIlu9LzThU
	 kyLmP0CMYguy4z6KrwVXggFJ1Oj1c641MhEUMIm36tjhlQ5nTKZPqcQkvS9i8ZzDM3DLG
	 So3MoJ3hgJdr4rFpcNey+LXCBk3P2Prq3I+QULuBRxDnEE7i0fLYs3JNHJy2bQXJZKLRJ
	 ++9niHC44uSeN0+O0AQLh1aE4HGZOjVNWMWjbxxBIBSIih7jOz+jphDBsYPvmg5/Kzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=n7WrZUl4;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04D26082BD7;
	Thu,  5 Nov 2026 19:34:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D04D26082BD7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=n7WrZUl4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793907251;
	bh=dqzI7szqypUolQPlKTiL4Tger2zQvjkv2ryDgx7nJmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n7WrZUl4HVhwggDjxrZhYnTcgqm5yQImvMMSYbBgRKFZ0XjiRHBDPrVKsXV9XD+4t
	 98XZs/2WjtMOuMf3vXpVBDvPlKSLY5qhPhyoYt6tFXGadNbFFXWCoJ7YmdXDTwn22+
	 teF0ZEU2qUjjHtCEPLyORXzBr2OBvcof+D6Fe5fhZ22czdO81EJ9Yl+REoeNa+M8I7
	 yUFzfAPKnBYBX7/UgzUXgAz3Ecaj8KuJziXY6IXvXpmn08aoACZRr/U4tXnkk/3YT0
	 9QqcrarSwIzQWOoNDBI40uzw9urR39YPxh3eqB3gBJoka9zzWoj8VFY8RP3KcfIZDU
	 3MrLvX05WNzCA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLCDM08wSzLPS;
	Thu, 05 Nov 2026 14:34:11 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
Subject: [PATCH v3 13/24] sched/deadline: Leave a dying task out of a rebuild of the accounting
Date: Thu,  5 Nov 2026 14:33:48 -0500
Message-Id: <20261105193359.1450487-14-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261105193359.1450487-1-mathieu.desnoyers@efficios.com>
References: <20261105193359.1450487-1-mathieu.desnoyers@efficios.com>
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

A rebuild of the root domains' accounting finds the tasks of a cpuset
through css_task_iter, which hides an exiting task once its process has
no live thread left, and hides a dying thread of a process with live
threads only once cgroup_task_dead() takes it off the cpuset, after its
last schedule. The walk without cpusets finds every task. Either can
find a task at its last schedule, between the release of its bandwidth
there, task_non_contending() past its 0-lag time, and the reset of its
dl_bw: both run under the runqueue lock, which the walk does not take.
The walk then counts, in a root domain the rebuild has just cleared, a
bandwidth that nothing releases again.

Leave out a dead task that is not on the departed list: its bandwidth
is released, or being released. do_task_dead() sets TASK_DEAD under
pi_lock, which the walk holds, so a task found alive dies after the
walk, and releases what the walk counted. A dead task on the list keeps
its bandwidth until its timer, and the rebuild counts it where the list
says, as before.

Found by the Sashiko AI review of the second posting of this series.

Fixes: f9a25f776d78 ("cpusets: Rebuild root domain deadline accounting information")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/deadline.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 7a0c27e76028..d9bd01a1bac0 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3594,6 +3594,15 @@ void dl_add_task_root_domain(struct task_struct *p)
 		cpu = p->dl.dl_departed_cpu;
 		if (!cpu_active(cpu))
 			goto unlock;
+	} else if (READ_ONCE(p->__state) == TASK_DEAD) {
+		/*
+		 * Dead and not departed: its bandwidth was released at its
+		 * last schedule, under its runqueue lock and not this one,
+		 * and dl_bw may still say otherwise. do_task_dead() sets
+		 * TASK_DEAD under pi_lock before that, so a task found alive
+		 * here dies after this walk, and releases what it counted.
+		 */
+		goto unlock;
 	}
 	rq = cpu_rq(cpu);
 	dl_b = &rq->rd->dl_bw;
-- 
2.47.3

