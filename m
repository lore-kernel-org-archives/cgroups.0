Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1384042E8C8
	for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 10:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789121958; cv=none; b=uK/dxkf0RYMBiAMIPYK9MiW2NHwDi1o/9+EhLln9u53c+hofnmglfrNVzRlmv2sBEAx4dtRggC1l/Qq0IiHkLqQcSFoScf8aO2EbxUjWLjQat/XaV5TvFJe+OB9sx3/C9GEzZjNG0sUHmcMyUyxHJaWlczCGkmtDGyA3l5XurDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789121958; c=relaxed/simple;
	bh=BxrZFbzDf2SyAOpYi68fzTgGFq/6jGpMGUzY0dphSbY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nicx5l+KqsA9xi/Wvrwqd+5eq+AsWXDJ2DRUv9EWAliDIymXV/0CdW9ssnceZoO2Y4rsmexJ+PhDheOu6mtAxSZV0ic/m2VoZ5bcfJC3ArF+1hbpEMYGIVSZN/Ss7ZuqKZKgEw1sTu9Hw7u0YPji+JF4c1zPQfTdChekCnJR3b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=D0oJRd3A; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=PB7VQeQ5; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="D0oJRd3A";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="PB7VQeQ5"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1789121945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OXOpLTSTo4iNnhNTVXX1FQP73d0OnFLISfa5cBxa4SY=;
	b=D0oJRd3AO1cfI0OyIgv1qG7Dego9mPmmGXIBXRqsB/aUejM2xmeBbcM4h0rZW9aF/BELYd
	tTy8q8IGobdgofL8GWJQTzhHktcajrxG/CTg//vXx/BA8WemidxYnjKDlukIxIFbtg6yJa
	upQEQu1b67sxbNHNyEoL0NNrDrHMldDPdrzCALHtTm5eNDdlzb9QcGWPjghdB0jTxWejy7
	M/du+nhOUr4J8EfkDMYhPEwLHfbIWRMwMyDAnG0w+0G5Q9SlYtIn7eMZzQji8Qpz/xZUkm
	V3hWgVw3/sna8SqQmV82Wqe58o1jvtFTPKKIbeoNq8d7nmfInUMPZB2cQdgqrw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1789121945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OXOpLTSTo4iNnhNTVXX1FQP73d0OnFLISfa5cBxa4SY=;
	b=PB7VQeQ5KrvTKRqtd03OJf7ciWPhtXEs3pwogTC1F1Zmf4+5ZzPuNGqS83hX8FhTr3tic8
	NGL9j+FzMwyndXAw==
To: cgroups@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] cgroup: Move cgrp_dead_ task+iwork into its own struct
Date: Fri, 11 Sep 2026 12:19:00 +0200
Message-ID: <20260911101900.984420-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

cgrp_dead_tasks and cgrp_dead_tasks_iwork are independent per-CPU
variables and are independently accessed via a this_cpu_ptr().

Having a custom struct with those two members makes it possible to have
only one per-CPU accessor and access the second member via an offset.
This makes the code a bit more compact and is micro-optimization.

Besides that, it allows cgrp_dead_tasks_iwork_fn() to access the list
pointer via the passed iwork pointer. This not only eliminates the
this_cpu_ptr() but also makes it possible to be invoked on a different
CPU. This does not happen as of today but might if I can flush the
irq_work items from another CPU during CPU-hotplug events.

Create struct cgroup_dead with the per-CPU variables as members. Access
the struct with a per-CPU accessor and use the cointer_of() in the
irq_work callback.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/cgroup/cgroup.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 2d532bf2c0c7a..5277274f48b54 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -7194,15 +7194,19 @@ static void do_cgroup_task_dead(struct task_struct =
*tsk)
  * the cgroup and task_struct can be pinned indefinitely. Bounce through l=
azy
  * irq_work to allow batching while ensuring timely completion.
  */
-static DEFINE_PER_CPU(struct llist_head, cgrp_dead_tasks);
-static DEFINE_PER_CPU(struct irq_work, cgrp_dead_tasks_iwork);
+struct cgroup_dead {
+	struct irq_work		iwork;
+	struct llist_head	tasks;
+};
+static DEFINE_PER_CPU(struct cgroup_dead, cgroup_dead);
=20
 static void cgrp_dead_tasks_iwork_fn(struct irq_work *iwork)
 {
+	struct cgroup_dead *cgrp_dead =3D container_of(iwork, struct cgroup_dead,=
 iwork);
 	struct llist_node *lnode;
 	struct task_struct *task, *next;
=20
-	lnode =3D llist_del_all(this_cpu_ptr(&cgrp_dead_tasks));
+	lnode =3D llist_del_all(&cgrp_dead->tasks);
 	llist_for_each_entry_safe(task, next, lnode, cg_dead_lnode) {
 		do_cgroup_task_dead(task);
 		put_task_struct(task);
@@ -7214,17 +7218,20 @@ static void __init cgroup_rt_init(void)
 	int cpu;
=20
 	for_each_possible_cpu(cpu) {
-		init_llist_head(per_cpu_ptr(&cgrp_dead_tasks, cpu));
-		per_cpu(cgrp_dead_tasks_iwork, cpu) =3D
-			IRQ_WORK_INIT_LAZY(cgrp_dead_tasks_iwork_fn);
+		struct cgroup_dead *cgrp_dead =3D per_cpu_ptr(&cgroup_dead, cpu);
+
+		init_llist_head(&cgrp_dead->tasks);
+		cgrp_dead->iwork =3D IRQ_WORK_INIT_LAZY(cgrp_dead_tasks_iwork_fn);
 	}
 }
=20
 void cgroup_task_dead(struct task_struct *task)
 {
+	struct cgroup_dead *cgrp_dead =3D this_cpu_ptr(&cgroup_dead);
+
 	get_task_struct(task);
-	llist_add(&task->cg_dead_lnode, this_cpu_ptr(&cgrp_dead_tasks));
-	irq_work_queue(this_cpu_ptr(&cgrp_dead_tasks_iwork));
+	llist_add(&task->cg_dead_lnode, &cgrp_dead->tasks);
+	irq_work_queue(&cgrp_dead->iwork);
 }
 #else	/* CONFIG_PREEMPT_RT */
 static void __init cgroup_rt_init(void) {}
--=20
2.55.0

