Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794924671;
	b=a3G6um0IZ4fYItqGEVbZunmiJSz2jSXWQ3BhIHAe637nkRpmbme1CCYU10xygzGaxhn3
	 jRzqm8FgZZZeDMo7pi1KlZfWmQbhTtuOKLeHV3ECULcwS8vOFBYUg5w05x23KaOoOsBS0
	 qzCdmzKRhdBo2KAHGmv3YSAPCaBOoMddYxNgpQ1EIcFVw2OwQ1tD7POCMo4ITPr8YC1lL
	 MOs9jU1C0OyCP0W18BdRpEX7wMF26i20KkzTCPLvWdcgivLFcLv9nzRHVR0K76OXjPfeO
	 cnhteWXjQ2gx1SrNPwguRUH45tFg9iNROCYCRR1Tmh/BOaBWmTUhVWLugt4vP4J7c3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794924671;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Syy7EGKLcXircqvCT0dmeZd+ivVK1LoZsMfUNK5n15w=;
	b=1wToY+K+1Ga5sLUa/wrzPp4IjFnoaZ7G0yGcrSEO3aKrLrmlGlIHMFedzWnn4h7SD1vB
	 7nFj92OkuPKARxoWHvJs9r7T3Z0i7Oy1nhGKUL7Kfltf2yKD/bunsWn+ecn/NRcRetwM1
	 2pdmRXiqOfVNYd+y31OyFYlyAMBrUgHjZKI4U5UxYgSQorMOfVIWcw7HAMGk8lxqxp90V
	 e+Gavft+0H68UE+yQEGm1WaxVJiktJL0sUhRlGcOUCdvMFlbM5KkAsiiyFLUiDeY7cRvk
	 CnNGPka4rVnqFqf2zExkdgVDYMaZ39yKdz6yR6LJANDrGYq22Ca7OThSFmvI98L5uxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=PGhZV9zp;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4841C60A2612;
	Tue, 17 Nov 2026 14:11:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4841C60A2612
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=PGhZV9zp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794924665;
	bh=Syy7EGKLcXircqvCT0dmeZd+ivVK1LoZsMfUNK5n15w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PGhZV9zpSDIxgUcUDcSsppWdX63dN8CLxusrpLNVq73LNReka8W7li+QAEHLDclyo
	 hAE8NDLkb1kxFDDgUSxmvAMR9amn9CX2bwI08zI7+/M+7OApQUfxMOd0fCzJgUwhHf
	 VC8dRApXX/Iygi7Le6f4ll+hmSivkiouKauslI/a9r2sFDQ2iD2f3GSEBd1h5DEHho
	 IRz//pQQZXs2KhXYqaC0bPHOhsNiGTGkRWo2amIsINKJewVk46e4uCnTPyPvL5POl0
	 emL/OLjO7g0LiEwFoXdTKA0uhKQsvP1DzrHn75k73yiAYr2iFFBs6rktAYES3iIYLd
	 VlMYFd+bP22jw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jTRV164wDzR8J;
	Tue, 17 Nov 2026 09:11:05 -0500 (EST)
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
Subject: [PATCH v7 09/40] rtmutex: Continue the chain walk when a waiter's deadline donor changes
Date: Tue, 17 Nov 2026 09:10:30 -0500
Message-Id: <c8b228501d8981454f63843b394019fefd4002f3.1794922146.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1794922146.git.mathieu.desnoyers@efficios.com>
References: <cover.1794922146.git.mathieu.desnoyers@efficios.com>
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

A task boosted by a SCHED_DEADLINE waiter runs on the parameters of a
donor, dl.pi_se. Commit 2279f540ea7d ("sched/deadline: Fix priority
inheritance with multiple scheduling classes") made the donor follow the
chain. rt_mutex_setprio() copies the donor of the top waiter to the
owner. So the owner at the end of a chain points at the deadline task at
its head. That task waits on no lock the owner holds.

The chain walk stops at a task whose waiter has the same sort keys as
the task: the priority and the deadline. Then "there is no further
priority adjustment necessary". Before 2279f540ea7d, this was enough.
The refill read the parameters of the owner's own top waiter, which is
blocked and so alive.

But a boost can change the donor of a blocked task and leave its keys
as they were. The task keeps a deadline priority. It sleeps, so no
refill moves its deadline. The walk then stops one lock too early.

M and O are SCHED_OTHER tasks. W and Z are SCHED_DEADLINE tasks. Z has
the earlier deadline. L1, L1' and L2 are rt_mutexes:

  O            M                       W                       Z

  locks L2     locks L1 and L1'
                                       blocks on L1'
                                         rt_mutex_setprio(M, W)
                                           M->dl.pi_se = &W->dl
               blocks on L2
                 rt_mutex_setprio(O, M)
                   O->dl.pi_se = &W->dl
                                                               blocks on L1
                                                                 rt_mutex_setprio(M, Z)
                                                                   M->dl.pi_se = &Z->dl
                                                                 chain walk at M:
                                                                   keys equal, stops
                                       times out on L1'
                                       exits

O runs on W's parameters, with a later deadline than Z's, while Z waits
for it. After W exits, O's next refill would read W's freed task_struct.

A deboost has the same effect. Take a deadline task that a waiter with
an earlier deadline boosts, and that blocks on a second lock. It keeps
its own deadline. When that waiter leaves, rt_mutex_setprio() makes the
task its own donor again. Its keys stay equal. A policy change in
__setscheduler_dl_pi() can also change the donor of a blocked task with
no change of keys. rt_mutex_adjust_pi() then skips the walk.

Setting up the deadline tasks needs CAP_SYS_NICE. The timeout of a
FUTEX_LOCK_PI needs no privilege. The Sashiko AI review of the sixth
posting of this series found the deboost case.

Fix this by recording the donor in the waiter with the sort keys, in
waiter_update_prio(). rt_waiter_up_to_date() compares both. The walk and
rt_mutex_adjust_pi() use it. A new donor then takes the walk on to the
next owner, and rt_mutex_setprio() gives that owner the new donor. The
waiter's copy is only compared, never dereferenced. A task without a
deadline priority is always its own donor, so its walks do not change.

A known limit remains. Two walks can overlap on a chain of three locks
or more. The owners further down then keep the old donor until the
first walk reaches them.

The case pi_chain_donor_leaves of deadline_bw_test, added later in this
series, tests the missed boost. W leaves SCHED_DEADLINE there, in place
of exiting. Without this patch, another deadline task gets no CPU time.
On v7.4-rc2 the case passes. There, a blocked task that leaves
SCHED_DEADLINE keeps its parameters, so O runs on W's.

Fixes: 2279f540ea7d ("sched/deadline: Fix priority inheritance with multiple scheduling classes")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org # v5.15+
---
 kernel/locking/rtmutex.c        | 22 ++++++++++++++++++++--
 kernel/locking/rtmutex_api.c    |  2 +-
 kernel/locking/rtmutex_common.h |  3 +++
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index 5a9534c715b8..c78dfe9c93fc 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -369,10 +369,12 @@ static __always_inline void
 waiter_update_prio(struct rt_mutex_waiter *waiter, struct task_struct *task)
 {
 	lockdep_assert_held(&waiter->lock->wait_lock);
+	lockdep_assert_held(&task->pi_lock);
 	lockdep_assert(RB_EMPTY_NODE(&waiter->tree.entry));
 
 	waiter->tree.prio = __waiter_prio(task);
 	waiter->tree.deadline = task->dl.deadline;
+	waiter->pi_se = task->dl.pi_se;
 }
 
 /*
@@ -433,6 +435,21 @@ static __always_inline int rt_waiter_node_equal(struct rt_waiter_node *left,
 	return 1;
 }
 
+/*
+ * Return true if @waiter is up to date with its task @task. Compare the
+ * sort keys and the deadline donor, which rt_mutex_setprio() copies from
+ * @task to the lock owner. A boost or a deboost of @task can change its
+ * donor and leave its keys as they were. The owner must then get the new
+ * donor: the old one can exit. The caller holds @task->pi_lock, which
+ * protects @task->dl.pi_se. @waiter->pi_se is never dereferenced.
+ */
+static __always_inline bool
+rt_waiter_up_to_date(struct rt_mutex_waiter *waiter, struct task_struct *task)
+{
+	return rt_waiter_node_equal(&waiter->tree, task_to_waiter_node(task)) &&
+	       waiter->pi_se == task->dl.pi_se;
+}
+
 static inline bool rt_mutex_steal(struct rt_mutex_waiter *waiter,
 				  struct rt_mutex_waiter *top_waiter)
 {
@@ -824,12 +841,13 @@ static int __sched rt_mutex_adjust_prio_chain(struct task_struct *task,
 
 	/*
 	 * If the waiter priority is the same as the task priority
-	 * then there is no further priority adjustment necessary.  If
+	 * then there is no further priority adjustment necessary. The
+	 * task must also pass on the same deadline donor.  If
 	 * deadlock detection is off, we stop the chain walk. If its
 	 * enabled we continue, but stop the requeueing in the chain
 	 * walk.
 	 */
-	if (rt_waiter_node_equal(&waiter->tree, task_to_waiter_node(task))) {
+	if (rt_waiter_up_to_date(waiter, task)) {
 		if (!detect_deadlock)
 			goto out_unlock_pi;
 		else
diff --git a/kernel/locking/rtmutex_api.c b/kernel/locking/rtmutex_api.c
index eb18b094473c..6bdbd36bac94 100644
--- a/kernel/locking/rtmutex_api.c
+++ b/kernel/locking/rtmutex_api.c
@@ -510,7 +510,7 @@ void __sched rt_mutex_adjust_pi(struct task_struct *task)
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
 
 	waiter = task->pi_blocked_on;
-	if (!waiter || rt_waiter_node_equal(&waiter->tree, task_to_waiter_node(task))) {
+	if (!waiter || rt_waiter_up_to_date(waiter, task)) {
 		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 		return;
 	}
diff --git a/kernel/locking/rtmutex_common.h b/kernel/locking/rtmutex_common.h
index c38b7bdea7b3..c0f391c352e3 100644
--- a/kernel/locking/rtmutex_common.h
+++ b/kernel/locking/rtmutex_common.h
@@ -43,6 +43,8 @@ struct rt_waiter_node {
  * @pi_tree:		node to enqueue into the mutex owner waiters tree
  * @task:		task reference to the blocked task
  * @lock:		Pointer to the rt_mutex on which the waiter blocks
+ * @pi_se:		The deadline donor of @task when @tree was last updated.
+ *			Only compared, never dereferenced.
  * @wake_state:		Wakeup state to use (TASK_NORMAL or TASK_RTLOCK_WAIT)
  * @ww_ctx:		WW context pointer
  *
@@ -54,6 +56,7 @@ struct rt_mutex_waiter {
 	struct rt_waiter_node	pi_tree;
 	struct task_struct	*task;
 	struct rt_mutex_base	*lock;
+	struct sched_dl_entity	*pi_se;
 	unsigned int		wake_state;
 	struct ww_acquire_ctx	*ww_ctx;
 };
-- 
2.47.3

