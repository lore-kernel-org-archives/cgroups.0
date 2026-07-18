Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8EA22F74A;
	Sat, 18 Jul 2026 08:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784362652; cv=none; b=ZO2FOmYodfYng8Ku3iWqnX1PSUB0HIiymFf4I4xnw+e7DBi9I0I9Ra12GnjwG9xhmonr8MPQcwbH5JdKp25vo2m89kIGyTevqVBqUTDvIBE9YYc2jduyimqViekRWSR+Xshrtduhh4zxyIkAxjBWamjFrXlMaKhez+BKeMNkwKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784362652; c=relaxed/simple;
	bh=44aCUjR9LxCbyL/3k+dKS7SCZIcmVWAQOyO30PzmRII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=huphUfx4Pk0DOYFGnWhDnzDFPcjpQcKHB/9xCl8L9QyI1uCsokx9TjNgg8TX1itzc4RBV9XF5nO2MgXCQxNcgoZY+zx2PKxuyu2fiBbYav9Z1nodG56vtHSQB+3uetMPcHrDcF7TAjXEZu8qNIRaOh7QGCY9s2McscPXn0fBCN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J9xG/4lV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J9xG/4lV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976041F00A3D;
	Sat, 18 Jul 2026 08:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784362650;
	bh=yNpqwPmyNHmSgcRo+zP2o/75UX50bGjdZYy89v5TIvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J9xG/4lV76+tDBc4ioMiAhfT8JRfdLelPmesGlt82iuz32EEYbK26fwY/vevj8uLW
	 sJPZFCAsBGk7SqO52+MApF58/Ic3tGQDypCABcyOE8aBiPUmoxqZEFHY6M/X3aW0uI
	 tjHBWyHEhAmpjMMOD3sNa54j/HdIl7b7IOE7ZC8L5qrRd5rMLENKLXt55kTCVtqzSP
	 WcMYynT5B+wPxRZnZli2Uox3jtOfMIB5SpQ1GCD34sjq99II3Ki0G4VTt9uJjHuIXx
	 yK7B9epUH54YaSooROfo+BC8mcwfp7nb1OIY4aa5LMALAtbaw6/NcuogcvaZgXDgww
	 XEjDFHXeOLE2w==
From: Tejun Heo <tj@kernel.org>
To: David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>
Cc: sched-ext@lists.linux.dev,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/8] sched_ext: Factor out scx_rehome_task() and scx_punt_task()
Date: Fri, 17 Jul 2026 22:17:21 -1000
Message-ID: <20260718081727.582037-3-tj@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260718081727.582037-1-tj@kernel.org>
References: <20260718081727.582037-1-tj@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Factor out scx_rehome_task() and scx_punt_task() from the sub-disable
re-home loop and scx_fail_parent(). The upcoming cgroup migration re-homing
also needs scx_rehome_task(). No functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/sched/ext/sub.c | 84 ++++++++++++++++++++++++++++--------------
 1 file changed, 56 insertions(+), 28 deletions(-)

diff --git a/kernel/sched/ext/sub.c b/kernel/sched/ext/sub.c
index c7f70cf877d1..5f7ac6696d17 100644
--- a/kernel/sched/ext/sub.c
+++ b/kernel/sched/ext/sub.c
@@ -758,6 +758,57 @@ void drain_descendants(struct scx_sched *sch)
 	wait_event(scx_unlink_waitq, list_empty(&sch->children));
 }
 
+/**
+ * scx_rehome_task - Move a task to a sched it has been initialized for
+ * @to: sched taking over @p, @p's init on it already complete
+ * @p: task to re-home
+ *
+ * Exit @p from its current sched and switch it over to @to, overriding the
+ * state to %SCX_TASK_READY to account for the already completed init. A task
+ * on a non-ext class, possible under an %SCX_OPS_SWITCH_PARTIAL root, stays
+ * %READY and is enabled by switching_to_scx() if it switches over.
+ */
+static void scx_rehome_task(struct scx_sched *to, struct task_struct *p)
+{
+	lockdep_assert_held(&p->pi_lock);
+	lockdep_assert_rq_held(task_rq(p));
+
+	scoped_guard (sched_change, p, DEQUEUE_SAVE | DEQUEUE_MOVE) {
+		scx_disable_and_exit_task(scx_task_sched(p), p);
+		scx_set_task_state(p, SCX_TASK_INIT_BEGIN);
+		scx_set_task_state(p, SCX_TASK_INIT);
+		scx_set_task_sched(p, to);
+		scx_set_task_state(p, SCX_TASK_READY);
+		if (p->sched_class == &ext_sched_class)
+			scx_enable_task(to, p);
+	}
+}
+
+/**
+ * scx_punt_task - Hand a task to a failed sched without initialization
+ * @to: failed and bypassed sched taking custody of @p
+ * @p: task to punt
+ *
+ * Take @p off its current sched and put it on @to at %SCX_TASK_NONE. @to is
+ * dying and its teardown will re-home @p properly.
+ *
+ * Used when @to must take over @p but failed to initialize it. Bypass keeps
+ * scheduling decisions away from @to but @p can still trigger its task ops,
+ * which may confuse the BPF side. @to is dying anyway. The exit paths skip
+ * %NONE tasks (see __scx_disable_and_exit_task() and switched_from_scx()).
+ */
+static void scx_punt_task(struct scx_sched *to, struct task_struct *p)
+{
+	lockdep_assert_held(&p->pi_lock);
+	lockdep_assert_rq_held(task_rq(p));
+	WARN_ON_ONCE(!READ_ONCE(to->bypass_depth));
+
+	scoped_guard (sched_change, p, DEQUEUE_SAVE | DEQUEUE_MOVE) {
+		scx_disable_and_exit_task(scx_task_sched(p), p);
+		scx_set_task_sched(p, to);
+	}
+}
+
 static void scx_fail_parent(struct scx_sched *sch,
 			    struct task_struct *failed, s32 fail_code)
 {
@@ -769,9 +820,9 @@ static void scx_fail_parent(struct scx_sched *sch,
 		  fail_code, failed->comm, failed->pid);
 
 	/*
-	 * Once $parent is bypassed, it's safe to put SCX_TASK_NONE tasks into
-	 * it. This may cause downstream failures on the BPF side but $parent is
-	 * dying anyway.
+	 * Once $parent is bypassed, tasks can be punted into it. This may
+	 * cause downstream failures on the BPF side but $parent is dying
+	 * anyway.
 	 */
 	scx_bypass(parent, true);
 
@@ -780,10 +831,7 @@ static void scx_fail_parent(struct scx_sched *sch,
 		if (scx_task_on_sched(parent, p))
 			continue;
 
-		scoped_guard (sched_change, p, DEQUEUE_SAVE | DEQUEUE_MOVE) {
-			scx_disable_and_exit_task(sch, p);
-			scx_set_task_sched(p, parent);
-		}
+		scx_punt_task(parent, p);
 	}
 	scx_task_iter_stop(&sti);
 }
@@ -881,27 +929,7 @@ void scx_sub_disable(struct scx_sched *sch)
 			continue;
 		}
 
-		scoped_guard (sched_change, p, DEQUEUE_SAVE | DEQUEUE_MOVE) {
-			/*
-			 * $p is initialized for $parent and still attached to
-			 * @sch. Disable and exit for @sch, switch over to
-			 * $parent and override the state to READY to account
-			 * for $p having already been initialized.
-			 */
-			scx_disable_and_exit_task(sch, p);
-			scx_set_task_state(p, SCX_TASK_INIT_BEGIN);
-			scx_set_task_state(p, SCX_TASK_INIT);
-			scx_set_task_sched(p, parent);
-			scx_set_task_state(p, SCX_TASK_READY);
-
-			/*
-			 * A task on a non-ext class, possible under an
-			 * %SCX_OPS_SWITCH_PARTIAL root, stays READY and is
-			 * enabled by switching_to_scx() if it switches over.
-			 */
-			if (p->sched_class == &ext_sched_class)
-				scx_enable_task(parent, p);
-		}
+		scx_rehome_task(parent, p);
 
 		task_rq_unlock(rq, p, &rf);
 		put_task_struct(p);
-- 
2.55.0

