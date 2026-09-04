Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A293AD511;
	Fri,  4 Sep 2026 03:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788493720; cv=none; b=Ml2IfdTbb2eY09tI8e4Hu0hySrfkzQn/oDyFdqYIucMjZnOMLGRyJHW8fNyeRUXUUJgNlD2jmqrm0LAGr6KhvGIcwPGTjVMERc9NIOednRtbQw+DdtyHp+70EV/q/LS8/n6QKU8cB619bEpqPqPqZJ4u92Ertl6MPO3dxMeoXio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788493720; c=relaxed/simple;
	bh=MT6MfLHzUWlYjBxa45N8wdeJ+sOo6aJ71kPXxy2tg3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O/Mib1qkNqAI47O0tT1ltc7eVYixi5njSXxFDCDB2wUzjrUBkbvEUukGzx+X2bS6R72fpqHixPAVn9oAq5kcBW8c8plf4hBeYbj3PMe9k5Z/quaH9uvMs0sjAlTbaqSveafmoX60W0CBfIhQvGqegdh2EJ9+NHwWpdUwn3NVU7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=pYYnPWxT; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="pYYnPWxT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=P3
	SGhphpkiE9E2YevTfiMjq9NUdddUaAUez/XmB+dLo=; b=pYYnPWxTnlMQ6Bo5iL
	bECPS7TpFGu1wAj/OsWHgTBkZx0QzZ2PNuheGxcrU6dVQyVvC+MOaKcU7lInT5wd
	YXngNX87sS0xENfWDeBs6814BmH3ttQ+KFoManYk3CFlg/VAv4nas8Kbnn4eosWg
	xhEfI6ylAT2rnnuztBSmmWA4s=
Received: from localhost (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgAH8447P5pqxZOENg--.44249S2;
	Fri, 04 Sep 2026 11:47:08 +0800 (CST)
From: Hui Su <sh_def@163.com>
To: Tejun Heo <tj@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>
Cc: Hui Su <sh_def@163.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	John Stultz <jstultz@google.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] sched: Account cgroup CPU time to the execution context
Date: Fri,  4 Sep 2026 11:47:07 +0800
Message-ID: <20260904034707.268416-1-sh_def@163.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgAH8447P5pqxZOENg--.44249S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxGrW8JFW5Zw4xAr45ur1UGFg_yoW5Zw4kpF
	Z5Xa1UXws5tF1jyr4jyasY934fGws3JwnIqr4DJw1fAFyfG3W8KryI9r1jyF1jyr4IyF1I
	vrsY934xCF1UKw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zi75r7UUUUU=
X-CM-SenderInfo: xvkbvvri6rljoofrz/xtbC6R4gf2qaPz7mowAA3c

Proxy execution separates the scheduling context from the execution
context. Commit aa4f74dfd42b ("sched: Fix runtime accounting w/ split
exec & sched contexts") made per-task and thread-group runtime
accounting follow the task that actually executes, while cgroup CPU
usage is charged to the donor.

When the donor and execution task belong to different cgroups, this
makes a task's execution time count against a different cgroup from the
one the task belongs to.

Cgroup CPU usage should follow the execution context, matching the
per-task, thread-group, and cgroup user/system accounting. Keep
scheduling state associated with the donor, but charge cgroup CPU
usage to rq->curr.

A reproducer with the donor and execution task in separate cgroups
showed the execution task accumulating runtime while cgroup CPU usage
was charged to the donor's cgroup. With this change, the execution
task's cgroup accumulates the CPU usage instead. The same behavior was
verified with an RT donor and with legacy cpuacct accounting.

Fixes: aa4f74dfd42b ("sched: Fix runtime accounting w/ split exec & sched contexts")
Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Hui Su <sh_def@163.com>
---
Changes since v1:
- Rework the fix following Tejun Heo's review: make cgroup CPU usage
  follow the execution context instead of moving cgroup user/system
  accounting to the scheduling context.
- Drop the per-rq cputime owner, deferred boundary handling, and donor
  lifetime tracking, which are no longer needed.
- Rework the reproducer expectation around execution-context cgroup
  CPU usage.

Testing:
- cgroup v2 proxy reproducer: executor runtime +1.483s, donor cgroup A
  usage +0, and executor cgroup B usage +1.629s.
- RT donor reproducer: executor runtime +0.991s, donor cgroup A usage
  +125us, and executor cgroup B usage +0.991s.
- cgroup v1 cpuacct: usage charged to the executor cgroup.
- sched_proxy_exec=off control passed.
- CONFIG_SCHED_PROXY_EXEC / CONFIG_CGROUPS /
  CONFIG_CGROUP_CPUACCT build matrix passed.
- W=1 kernel/sched/fair.o passed.
- checkpatch --strict and git diff --check passed.

v1: https://lore.kernel.org/lkml/5733b51108eda90c1bda98a68d58b5e6ccbc24ec.1788433334.git.sh_def@163.com/

 kernel/sched/fair.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8dff37059faf..6fcf67d741e8 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1404,7 +1404,6 @@ static s64 update_se(struct rq *rq, struct sched_entity *se)
 
 	se->exec_start = now;
 	if (entity_is_task(se)) {
-		struct task_struct *donor = task_of(se);
 		struct task_struct *running = rq->curr;
 		/*
 		 * If se is a task, we account the time against the running
@@ -1417,8 +1416,7 @@ static s64 update_se(struct rq *rq, struct sched_entity *se)
 		account_group_exec_runtime(running, delta_exec);
 		account_mm_sched(rq, running, delta_exec);
 
-		/* cgroup time is always accounted against the donor */
-		cgroup_account_cputime(donor, delta_exec);
+		cgroup_account_cputime(running, delta_exec);
 	} else {
 		/* If not task, account the time against donor se  */
 		se->sum_exec_runtime += delta_exec;
-- 
2.54.0

