Received: from mta0.migadu.com (out-115.mta0.migadu.com [91.218.175.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948CD4B95D4
	for <cgroups@vger.kernel.org>; Sat, 10 Oct 2026 19:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.115
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791659717; cv=none; b=UIAhSRdS36aOUmbxFN7Irx0knW1spk0NzrwCBCwzzOurNEoEoqDPu26Ne55sq8D7Bk1iGoMVUBzevowAOQ5ss7HYBIWj6+59+N6Csgm6M3qXTqTe5j+iswRQINdiHtgRDAfGL4YtWOsnwLdwnvmTm8ZVjy9j5tTUd6KKa4iRsG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791659717; c=relaxed/simple;
	bh=3NootzqI/O3+CC49sjVYixviyBMP0OLY4tolwLWBCqY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eLRsAg7CniS1JTSjsrtQO8xF9YyC+9Fhrhfv7CWNLt6/uzVzMBixNik1ZjfAXhQSy1b9U1fqZpSp8Ly7CrJxzpdkuSSbEgVkmGoutpeh30SqWctOriSh7UtckQQwOMkYgqQRZ3Zbtg9Y6O2B61gbiF11ydJ1QUT95Mf7er7pXls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WunxtgpF; arc=none smtp.client-ip=91.218.175.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WunxtgpF"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=3NootzqI/O3+CC49sjVYixviyBMP0OLY4tolwLWBCqY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791659709; v=1; x=1792264509;
 b=WunxtgpFZosZ7b9DNfW0Qj51YCICbBdVdAQdiHvA5wqX5ocFetVODfW80KsFOnZNs6o8/SJn
 REXQdqQEHuoNkgafBfCDHZZ8LXuORi+4OJFWexepRO2FbQPcIncToxv9UWjZbz/RYwbKHvG71Yu
 PJqPK6LkkaSloM87xZ6ZRUkE=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 585ebba4e45e8649;
	Sat, 10 Oct 2026 19:15:06 +0000
X-Mizu-Trace-ID: 585ebba4e45e8649
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Peter Zijlstra <peterz@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] sched/psi: Remove the RCU wait from trigger destruction
Date: Sat, 10 Oct 2026 12:15:00 -0700
Message-ID: <20261010191500.3895736-1-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the Meta fleet, we found PSI trigger destruction waiting for an RCU
grace period while holding kernfs node_mutex, blocking other users [1].
File close and node drain hold this mutex while calling the release
callback. Cgroup removal and disabling cgroup.pressure also hold
cgroup_mutex during the drain.

The wait was added by commit 0e94682b73bf ("psi: introduce psi monitor")
to protect worker and trigger lookups. Commit 461daba06bdc
("psi: eliminate kthread_worker from psi trigger scheduling mechanism")
replaced the worker queue with a group timer. The scheduler now only
checks whether rtpoll_task is NULL; it uses neither the task nor the
trigger. Commit a06247c6804f ("psi: Fix uaf issue when psi trigger is
destroyed while being polled") removed trigger replacement and polling's
RCU lookup.

Trigger lists are protected by mutexes. Proc poll/select entries are
removed before their file references are dropped. eventpoll_release()
removes epoll entries before the file release callback.
Commit aff037078eca ("sched/psi: use kernfs polling functions for PSI
trigger polling") moved cgroup polling to a kernfs waitqueue whose
lifetime follows the file.

A late timer firing only wakes the group waitqueue. The system group is
static, and commit 5457025fa8ca ("sched/psi: Shut down rtpoll_timer in
psi_cgroup_free()") shuts down the cgroup timer before freeing the group.
Cgroup reclamation already waits for scheduler readers.

Remove synchronize_rcu() from psi_trigger_destroy() and use
rcu_access_pointer() for the worker NULL check. Keep kthread_stop()
outside the trigger mutex.

Tested trigger churn, notifications and cgroup removal in an 8-CPU VM
with KASAN, lockdep, and full and lazy preemption. No warnings were found.

Link: https://github.com/bpftrace/user-tools/tree/master/runnablelockmonitor [1]
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 kernel/sched/psi.c | 25 +++++--------------------
 1 file changed, 5 insertions(+), 20 deletions(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 4e152410653d..7c5381423334 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -626,8 +626,6 @@ static void init_rtpoll_triggers(struct psi_group *group, u64 now)
 static void psi_schedule_rtpoll_work(struct psi_group *group, unsigned long delay,
 				   bool force)
 {
-	struct task_struct *task;
-
 	/*
 	 * atomic_xchg should be called even when !force to provide a
 	 * full memory barrier (see the comment inside psi_rtpoll_work).
@@ -635,19 +633,16 @@ static void psi_schedule_rtpoll_work(struct psi_group *group, unsigned long dela
 	if (atomic_xchg(&group->rtpoll_scheduled, 1) && !force)
 		return;
 
-	rcu_read_lock();
-
-	task = rcu_dereference(group->rtpoll_task);
 	/*
-	 * kworker might be NULL in case psi_trigger_destroy races with
-	 * psi_task_change (hotpath) which can't use locks
+	 * Only test whether a worker is installed; do not dereference the task.
+	 * A racing trigger destruction may leave the timer armed.
+	 * psi_cgroup_free() shuts it down before freeing the group.
+	 * The system PSI group is static.
 	 */
-	if (likely(task))
+	if (likely(rcu_access_pointer(group->rtpoll_task)))
 		mod_timer(&group->rtpoll_timer, jiffies + delay);
 	else
 		atomic_set(&group->rtpoll_scheduled, 0);
-
-	rcu_read_unlock();
 }
 
 static void psi_rtpoll_work(struct psi_group *group)
@@ -1488,22 +1483,12 @@ void psi_trigger_destroy(struct psi_trigger *t)
 		mutex_unlock(&group->rtpoll_trigger_lock);
 	}
 
-	/*
-	 * Wait for psi_schedule_rtpoll_work RCU to complete its read-side
-	 * critical section before destroying the trigger and optionally the
-	 * rtpoll_task.
-	 */
-	synchronize_rcu();
 	/*
 	 * Stop kthread 'psimon' after releasing rtpoll_trigger_lock to prevent
 	 * a deadlock while waiting for psi_rtpoll_work to acquire
 	 * rtpoll_trigger_lock
 	 */
 	if (task_to_destroy) {
-		/*
-		 * After the RCU grace period has expired, the worker
-		 * can no longer be found through group->rtpoll_task.
-		 */
 		kthread_stop(task_to_destroy);
 		atomic_set(&group->rtpoll_scheduled, 0);
 	}
-- 
2.53.0-Meta

