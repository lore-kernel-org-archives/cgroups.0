Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9D61A6828;
	Sat, 18 Jul 2026 08:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784362653; cv=none; b=WWw31LFkcBFcCbfWpqG/OtUokF1xFmEbEzX6VTIIZDE1HRLMpjZ3fzOy2ephQkMrb/ELQX1hinua99/p36fJjvrAGTmAqC4/G8R+Qhvm3SHCKPFkJxKj1wDWXfems4pDUiItikwbQ0Yc+60lCUt2pM/v/3LBm7vhRNFVZwvQvxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784362653; c=relaxed/simple;
	bh=S9SaarLMvjcF6W87Ecc1BGNusWtqScBsK45Tj75rK6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avhySCK/hMLtnry5PdL/vze8TT3XM5je8RpEMEbOT/HQtEhfYCoHQbmFUlcdO/fSRteh7a0lNPOEBONEgOGC3Dg6k5FFNT6x5YzDLO0Yfh9U6lLAMSg+vZhzgcOM7EMXIvgQojydU5B78AYAePsQUpjt6qrJ6y1INgZFHRQSesY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YNe1xjak; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YNe1xjak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945771F00A3E;
	Sat, 18 Jul 2026 08:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784362651;
	bh=rK7f/yrU/XkKkieXKGr2jA09Uvg8ypmIEStVeH5Zf4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YNe1xjaktf4HYiHtZ583eLrDEYIbqnVMLqD0dqW36QXF1P9EX2pvpAg6TNxW+b86m
	 uNSYX767FEA4kvznSFrWnunLo/bFfsj7LA1MGZ7MrwecN/0dDjYPA8Pl18eytMQmvr
	 KjCso8/ywUqY4vvlxlWYRLUTL6MhuHeiQeki7xEAZdopZK35J1TDo31I5kJuq8BurB
	 NBmIQ217Ee8nr2nAtaeJXhGmgk98eUikhozGxKjO2jDCRwl2OhDKApxnrpIiikNbzY
	 Gn77krx3JQJcZAcrcVdsQRQPaNC5TsASrcPMnLQSwSlLwjS7SXYk5JMrwFNVAGhoGB
	 CX0oQ19Ek/M2w==
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
Subject: [PATCH 3/8] sched_ext: Relocate scx_cgroup_enabled
Date: Fri, 17 Jul 2026 22:17:22 -1000
Message-ID: <20260718081727.582037-4-tj@kernel.org>
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

scx_cgroup_enabled is in the CONFIG_EXT_GROUP_SCHED block. The upcoming
cgroup migration re-homing needs the gate outside the block. Move the
definition and flag flips outside CONFIG_EXT_GROUP_SCHED. No functional
changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/sched/ext/ext.c      | 18 ++++++++++++------
 kernel/sched/ext/internal.h |  1 +
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/ext/ext.c b/kernel/sched/ext/ext.c
index 145bda57b6fe..cd99947b4229 100644
--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -80,6 +80,14 @@ static bool scx_switching_all;
 DEFINE_STATIC_KEY_FALSE(__scx_switched_all);
 static DEFINE_STATIC_KEY_FALSE(__scx_tid_to_task_enabled);
 
+/*
+ * Gates cgroup ops delivery. Set at the end of the cgroup init phase of root
+ * enable and cleared before root disable starts tearing down tasks, both under
+ * scx_cgroup_lock(). Holding cgroup_lock() and seeing %true guarantees no race
+ * against root tearing down tasks.
+ */
+bool scx_cgroup_enabled;
+
 /*
  * True once SCX_OPS_TID_TO_TASK has been negotiated with the root scheduler
  * and the tid->task table is live. Wraps the static key so callers don't
@@ -4309,7 +4317,6 @@ bool scx_can_stop_tick(struct rq *rq)
 #ifdef CONFIG_EXT_GROUP_SCHED
 
 DEFINE_STATIC_PERCPU_RWSEM(scx_cgroup_ops_rwsem);
-static bool scx_cgroup_enabled;
 
 void scx_tg_init(struct task_group *tg)
 {
@@ -4689,8 +4696,6 @@ static void scx_cgroup_exit(struct scx_sched *sch)
 {
 	struct cgroup_subsys_state *css;
 
-	scx_cgroup_enabled = false;
-
 	/*
 	 * scx_tg_on/offline() are excluded through cgroup_lock(). If we walk
 	 * cgroups and exit all the inited ones, all online cgroups are exited.
@@ -4745,9 +4750,6 @@ static int scx_cgroup_init(struct scx_sched *sch)
 		tg->scx.flags |= SCX_TG_INITED;
 	}
 
-	WARN_ON_ONCE(scx_cgroup_enabled);
-	scx_cgroup_enabled = true;
-
 	return 0;
 }
 
@@ -5971,6 +5973,7 @@ static void scx_root_disable(struct scx_sched *sch)
 	 * doesn't race against scx_disable_and_exit_task().
 	 */
 	scx_cgroup_lock();
+	scx_cgroup_enabled = false;
 	scx_cgroup_exit(sch);
 	scx_cgroup_unlock();
 
@@ -7234,6 +7237,9 @@ static void scx_root_enable_workfn(struct kthread_work *work)
 	if (ret)
 		goto err_disable_unlock_all;
 
+	WARN_ON_ONCE(scx_cgroup_enabled);
+	scx_cgroup_enabled = true;
+
 	scx_task_iter_start(&sti, NULL);
 	while ((p = scx_task_iter_next_locked(&sti))) {
 		/*
diff --git a/kernel/sched/ext/internal.h b/kernel/sched/ext/internal.h
index 4f4130f0d121..d76ac22019af 100644
--- a/kernel/sched/ext/internal.h
+++ b/kernel/sched/ext/internal.h
@@ -1949,6 +1949,7 @@ __printf(3, 0) s32 scx_bstr_format(struct scx_sched *sch, struct scx_bstr_buf *b
 extern raw_spinlock_t scx_sched_lock;
 extern struct mutex scx_enable_mutex;
 extern struct percpu_rw_semaphore scx_fork_rwsem;
+extern bool scx_cgroup_enabled;
 extern raw_spinlock_t scx_exit_bstr_buf_lock;
 extern struct scx_bstr_buf scx_exit_bstr_buf;
 #ifdef CONFIG_EXT_SUB_SCHED
-- 
2.55.0

