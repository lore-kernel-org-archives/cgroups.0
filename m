Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795096185;
	b=NqB3esV4TTXDfI/vZw5GIoqGza6EL+7Qpwh7dRuZddFqvnADq/KjG8KPd3BH1c3S4TW+
	 GyzwdgeXQSxPn6jYssnpgc9H3d3uNidU3I6W1/3bcFPFjz8ggqRVL63Ef4RtUJI2r9uJB
	 XozRkGMbIUtMpbhb0YnNJ8B0/nEVoG3AoBedkQPEQ+QvyDpBcB8P9QExbP6JAeHhojvkl
	 9p7CTUdmHKikszQ/H1ekuZghv8A7rgMc9lzCxVhqA+txfn90d3SKHl1EfXkqu4BEGnm6k
	 uNVzdo37ya472Ba6uPlPPz+QSmblyzcBZyfawTwHBzGmxF6Mn5mlBmr6Jj8+qlQqjlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795096185;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=VF8D/NpkOVfXwYS7vocB3YSAlBjCCPP6hp45RuIin7I=;
	b=QL20OMXSMZQ8d94EByPFZFlUdhfAWpo1ififH3ZKBBRZyjh35lvut8QCCxka4XqwW25v
	 +fYU20fPHxv8n2NyLDj2/OaX6/tjAoFAqQrbqvlFFrSLYkN4xDlvAF9e0V5eKgkyxHNZn
	 nE636DZjaCdj0rTabhbCyBY1E01zyw5sPIJJPL2Yt4ZZQFBs89grfLfH47mz80kHfMerK
	 PqbBPl6z317bUp25uLevybWKn38RNkNn5xEi4RnlN5zuzJ59R1wWAeCn0pdeJXSzbXCmx
	 kjkIsrXZbFPr9oP6zFEVRwc85z17NJmlXlt2MsYWYI1V8pVydBai7A1EcVvG/lVaD6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=JkMS5KGC;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF482606A32C;
	Thu, 19 Nov 2026 13:49:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF482606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=JkMS5KGC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795096184;
	bh=VF8D/NpkOVfXwYS7vocB3YSAlBjCCPP6hp45RuIin7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JkMS5KGCdrAAyJr/6GlBCW303t/UdNmymt4owZaDqKKccoJEp8Lwhz8fr7OHQDg/M
	 2qQwu1a+gV0ciCPc2dyVrl/2Zgw5HnPsHZo+NCZWHGMlbKrBbv1UTB1wf3PKfzAQNx
	 7j8sWcTaz1l87XRioH3TIx5ACzW76wfIpsDTHTPJqwOvY76xdl65mNYJ7WkWA6os0X
	 +soN3u8jDIfL8fm3bPD5UqGHiJHZhh1aOj1EvE2rQH7F9qXNVAnPCDcSMag3JQ7eyl
	 Og1nfac5EM17gIKYEVLGQXNpKyco8OSipdS8BqguFeFgen5OYG9VC6w/jpFFA8neZD
	 116SgwAwVdyDw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVfwR6MTFzRM6;
	Thu, 19 Nov 2026 08:49:43 -0500 (EST)
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
Subject: [PATCH v3 02/17] sched/deadline: Do not admit bandwidth for parameters that are kept
Date: Thu, 19 Nov 2026 08:49:25 -0500
Message-Id: <ab5b150fe61d5db767aa98f1b1255661ad5de333.1795092090.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795092090.git.mathieu.desnoyers@efficios.com>
References: <cover.1795092090.git.mathieu.desnoyers@efficios.com>
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

Found by reading, after the Sashiko AI review of this series raised the
boosted case of the previous patch. Not reproduced: the parameter change
must land inside that window.

Fixes: a509a7cd7974 ("sched/uclamp: Extend sched_setattr() to support utilization clamping")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/syscalls.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index 89b0d5787f45..6f8ce5fd94a1 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -690,8 +690,16 @@ int __sched_setscheduler(struct task_struct *p,
 	 * of a SCHED_DEADLINE task) we need to check if enough bandwidth
 	 * is available. Keep this check last. If a later check failed,
 	 * nothing would give back the bandwidth it reserves.
+	 *
+	 * With SCHED_FLAG_KEEP_PARAMS, the task keeps its parameters, so
+	 * there is nothing to admit. Such a call changes other attributes,
+	 * such as the utilization clamps. A deadline task does not use its
+	 * clamps, but keeps them for when it leaves the class. The
+	 * parameters in attr may also be stale: sys_sched_setattr() read
+	 * them from the task without a lock.
 	 */
-	if ((dl_policy(policy) || dl_task(p)) && sched_dl_overflow(p, policy, attr)) {
+	if (!(attr->sched_flags & SCHED_FLAG_KEEP_PARAMS) &&
+	    (dl_policy(policy) || dl_task(p)) && sched_dl_overflow(p, policy, attr)) {
 		retval = -EBUSY;
 		goto unlock;
 	}
-- 
2.47.3

