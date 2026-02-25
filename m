Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D450F3815E2;
	Wed, 25 Feb 2026 05:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771995748; cv=none; b=YC8i+kp3VJ1uD2uM875UZJMRyHUr6iAGGgId0G1MAzMHbEiCyT/O0L6ibYk1li/n+gDjwwJVzwFQli5fIYD/rTF3O/Gc9D+VAmRNLNR+AP9U2oREwa9C8yzZfwRO5nupuRwLBt7eBWXqEL9rFFajaAhV121udYDR97sYGO0Hhto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771995748; c=relaxed/simple;
	bh=bpVBhLOZHuEWAD07jM0KKQa5GmByw789h7fJTVNXjG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kD/tREcrdcBhkQgpG0sOKw4giJ0bNV7yCnW6exeSpDWdX/r0g9v7j0WsSQ6cEnpGcrf51fPkIrJszTxU62sK7MMdLs7TnTliJZQeLraRAGnJESH5Q/dxW6PLu4wYIIAZsd/FETSI4/rCwTybzFT1QCtuJuzz2fl1gBXEcCPAimk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MuBUwsDG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MuBUwsDG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99873C19422;
	Wed, 25 Feb 2026 05:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771995748;
	bh=bpVBhLOZHuEWAD07jM0KKQa5GmByw789h7fJTVNXjG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MuBUwsDGeVnh33fb9tZatxFXhs/ub0uDvnvB2S6gZ7dfBiDPUBxk6q31i1uUWOhKs
	 hNKHfMvpuh9KBmsKxTk24M2vfOYp/3Z0kRaaMXSQwWKvVjgsW1XiglE1cTwvFUblEJ
	 NJm9EWPPxLpZwmMq9z9hZHIIKKTmcKWQy5oRGkUsEGNK24ZToIfoBpwxBHhNazgdMT
	 LNtECpOiCLON4zuHM/H7BUEZMKqFw4f7h09kEMYf1gUjUhAC2z2RDbT9TLRqeZs0Hb
	 uRXRWNlGySsFZ17ReP6luPmrWVy7qPV6hqovbWATTminTzNKQdQakG4TYW/G13f5XX
	 tl4VXLzIQh+5A==
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org,
	sched-ext@lists.linux.dev
Cc: void@manifault.com,
	arighi@nvidia.com,
	changwoo@igalia.com,
	emil@etsalapatis.com,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	cgroups@vger.kernel.org,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 32/34] sched_ext: Factor out scx_link_sched() and scx_unlink_sched()
Date: Tue, 24 Feb 2026 19:01:50 -1000
Message-ID: <20260225050152.1070601-33-tj@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225050152.1070601-1-tj@kernel.org>
References: <20260225050152.1070601-1-tj@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Factor out scx_link_sched() and scx_unlink_sched() functions to reduce
code duplication in the scheduler enable/disable paths.

No functional change.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/sched/ext.c | 53 +++++++++++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 22 deletions(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index 39c5f22862b0..5d08971b0832 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -4806,6 +4806,33 @@ static void refresh_watchdog(void)
 		cancel_delayed_work_sync(&scx_watchdog_work);
 }
 
+static void scx_link_sched(struct scx_sched *sch)
+{
+	scoped_guard(raw_spinlock_irq, &scx_sched_lock) {
+#ifdef CONFIG_EXT_SUB_SCHED
+		struct scx_sched *parent = scx_parent(sch);
+		if (parent)
+			list_add_tail(&sch->sibling, &parent->children);
+#endif	/* CONFIG_EXT_SUB_SCHED */
+		list_add_tail_rcu(&sch->all, &scx_sched_all);
+	}
+
+	refresh_watchdog();
+}
+
+static void scx_unlink_sched(struct scx_sched *sch)
+{
+	scoped_guard(raw_spinlock_irq, &scx_sched_lock) {
+#ifdef CONFIG_EXT_SUB_SCHED
+		if (scx_parent(sch))
+			list_del_init(&sch->sibling);
+#endif	/* CONFIG_EXT_SUB_SCHED */
+		list_del_rcu(&sch->all);
+	}
+
+	refresh_watchdog();
+}
+
 #ifdef CONFIG_EXT_SUB_SCHED
 static DECLARE_WAIT_QUEUE_HEAD(scx_unlink_waitq);
 
@@ -4955,12 +4982,7 @@ static void scx_sub_disable(struct scx_sched *sch)
 	synchronize_rcu_expedited();
 	disable_bypass_dsp(sch);
 
-	raw_spin_lock_irq(&scx_sched_lock);
-	list_del_init(&sch->sibling);
-	list_del_rcu(&sch->all);
-	raw_spin_unlock_irq(&scx_sched_lock);
-
-	refresh_watchdog();
+	scx_unlink_sched(sch);
 
 	mutex_unlock(&scx_enable_mutex);
 
@@ -5096,11 +5118,7 @@ static void scx_root_disable(struct scx_sched *sch)
 	if (sch->ops.exit)
 		SCX_CALL_OP(sch, SCX_KF_UNLOCKED, exit, NULL, ei);
 
-	raw_spin_lock_irq(&scx_sched_lock);
-	list_del_rcu(&sch->all);
-	raw_spin_unlock_irq(&scx_sched_lock);
-
-	refresh_watchdog();
+	scx_unlink_sched(sch);
 
 	/*
 	 * scx_root clearing must be inside cpus_read_lock(). See
@@ -5855,11 +5873,7 @@ static s32 scx_root_enable(struct sched_ext_ops *ops, struct bpf_link *link)
 	 */
 	rcu_assign_pointer(scx_root, sch);
 
-	raw_spin_lock_irq(&scx_sched_lock);
-	list_add_tail_rcu(&sch->all, &scx_sched_all);
-	raw_spin_unlock_irq(&scx_sched_lock);
-
-	refresh_watchdog();
+	scx_link_sched(sch);
 
 	scx_idle_enable(ops);
 
@@ -6120,12 +6134,7 @@ static s32 scx_sub_enable(struct sched_ext_ops *ops, struct bpf_link *link)
 		goto out_put_cgrp;
 	}
 
-	raw_spin_lock_irq(&scx_sched_lock);
-	list_add_tail(&sch->sibling, &parent->children);
-	list_add_tail_rcu(&sch->all, &scx_sched_all);
-	raw_spin_unlock_irq(&scx_sched_lock);
-
-	refresh_watchdog();
+	scx_link_sched(sch);
 
 	if (sch->level >= SCX_SUB_MAX_DEPTH) {
 		scx_error(sch, "max nesting depth %d violated",
-- 
2.53.0

