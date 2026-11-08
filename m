Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794164059;
	b=DDYGywVe3PewnZdGnEx/uto+cDHf1+RQJqyy/PbdrP2wFJtZg/QgVQyHAFL0lqWDeJvd
	 wUxagHlLBaaVHz5urlzAKvWzLc4fCcziSUIx5aWHF1na4ME/ZWOLNPOx0tv42pv1JQIZt
	 +uyf80yVsoMOuK7M6WwHfb/IMXhUtILTYvfl1Oty2Z/4HLJJogcL0CQkWcxdAJYu4Zxaa
	 gG2SVzNc+TLalH7IfEnrXThrvDSeIQ2fqFhns2iHCUYxv9oQtmRdGaaV+7qKOqi5PsOPF
	 VWt/YZTcYwJNR5BMp2L4E+mONPkxiFBwoaLpLgRobtL+Cud/3aRVjBr/854EdWln/fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794164059;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=3vLJVwKqGHJhLlHReq62MZN5HmY6eP1Wndxuj2uS7zo=;
	b=kUo+wyFVFcsFr1yYxfGs3WYAGKWpL6bm9BpsiQ2lXCXMZzYjAqrAW+0iHStamj3rErWp
	 U5LL9WYs+NxmdEjU1eZmxwTxDRpAu6WHgpxpYjt0kVLq7tWwAHSB2uIpgqfDfrpvvZ+E7
	 tvNNOEf0R1f+6+uJsYMCEiolC1C3gpIXPq3GTeM44QpKjY44Ynb5Pu0+2COmYux1unitI
	 H+lcM87LXO08aCgFn+kQoWpaoKLdppeioB1035/9gZbj9+ddgwU1uQMlMPFuqW/fHaQqm
	 vPaqhBIiKnpatsZVrXmYfoSZYUU8ZFxATXUo0bN7/icmE4jG9vJrJVgYtpb6NT21Bpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=eT0P43lH;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898A5606A33A;
	Sun,  8 Nov 2026 18:54:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 898A5606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=eT0P43lH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794164057;
	bh=3vLJVwKqGHJhLlHReq62MZN5HmY6eP1Wndxuj2uS7zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eT0P43lHUNGm2iheVFNAN4hIwAjXiczN4YymPdatdw6wurn57jIxSoqf3tPk7/CYv
	 c52vlSK/WSJcYCkP7uwTPrMmbffRw2r7f8/19/MbIZyPKMY8dDCpPzxy3x/3eN8lya
	 L0mf50xOYaKiK3h7sBP15q0VdT0/7FVkS0HeFK/+9mB+0Be8r125W4PVL+jIj7rzFj
	 +2otLHeFYznZ6/BS5Sb/8W/tY9fvJw+M7nU1L6JKbE+2EP4tzNNH/eeyhvOmC7JUid
	 YMMN9nb53pYwCQMNTwf4IanNrWSKUZCELKyUBTsYMBoXVcWYWxDljDv9bMqSgcB+ya
	 u0oEuwgTMDsGw==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jN2Bx3RwbzMcs;
	Sun, 08 Nov 2026 13:54:17 -0500 (EST)
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
Subject: [PATCH v5 03/29] sched/deadline: Do not admit bandwidth for parameters that are kept
Date: Sun,  8 Nov 2026 13:53:40 -0500
Message-Id: <20261108185406.1549770-4-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
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

__sched_setscheduler() runs the deadline admission test on a request
with SCHED_FLAG_KEEP_PARAMS. But the task keeps its parameters: the
call skips __setscheduler_params().

Commit f4dddf90d58d ("sched: Skip priority checks with
SCHED_FLAG_KEEP_PARAMS") made sys_sched_setattr() copy the task's own
parameters into such a request. Then the priority checks pass.
get_params() copies them without a lock.

Another call can change the task's parameters before
__sched_setscheduler() takes the runqueue lock. The request is then
stale, and dl_param_changed() takes it for a change. sched_dl_overflow()
would put the stale bandwidth in place of the task's own in total_bw,
and in this_bw for a sleeping task. But the task keeps its own dl_bw.
Its release at the 0-lag time takes that dl_bw, and the difference
stays behind.

Fix this by skipping sched_dl_overflow() for SCHED_FLAG_KEEP_PARAMS.
There is nothing to admit for parameters that are kept.

Found by reading, after the Sashiko AI review of the first posting of
this series raised the boosted case of the previous patch. Not
reproduced: the parameter change must land inside that window.

Fixes: a509a7cd7974 ("sched/uclamp: Extend sched_setattr() to support utilization clamping")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/syscalls.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index 0e8b5c7324f6..894f93a80d5d 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -690,8 +690,13 @@ int __sched_setscheduler(struct task_struct *p,
 	 * of a SCHED_DEADLINE task) we need to check if enough bandwidth
 	 * is available. Keep this check last. If a later check failed,
 	 * nothing would give back the bandwidth it reserves.
+	 *
+	 * With SCHED_FLAG_KEEP_PARAMS, the task keeps its parameters, so
+	 * there is nothing to admit. The parameters in attr may also be
+	 * stale: sys_sched_setattr() read them from the task without a lock.
 	 */
-	if ((dl_policy(policy) || dl_task(p)) && sched_dl_overflow(p, policy, attr)) {
+	if (!(attr->sched_flags & SCHED_FLAG_KEEP_PARAMS) &&
+	    (dl_policy(policy) || dl_task(p)) && sched_dl_overflow(p, policy, attr)) {
 		retval = -EBUSY;
 		goto unlock;
 	}
-- 
2.47.3

