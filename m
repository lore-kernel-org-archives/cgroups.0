Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805CA3D1CAA
	for <cgroups@vger.kernel.org>; Tue, 30 Jun 2026 07:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782802833; cv=none; b=ebppglp0kaqGVxH3/Ky7zJsm7ngWt9P9SdRKcsDjKYA5M4f7yr6eFy7IhpcxFpOoPLd0onU5635YkX0o7ue1QzJgdKvCDciPdYhuUBPoDheCTB5Z2cnNxNai0LJZTwytEh8YHgL1jaH82kDpKPRwGLRGe5802JJbrMLZqhrjJuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782802833; c=relaxed/simple;
	bh=19i350MkxT4XNJGB2uI/7sHZNW4Ahexpn4UfDkFxiLk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dvuM/cnvPztDOGvqamesPWrUN2ykAoYN4xTRzaiexl3eJSDZOb+lNjwFIkwIDOJgn0Nne8P5ax1NQQFlfjq5nHmGY9gLN9jHfuSL4WIm0ip+ibSq0/FYwLVTDu65nCQBbIY5X2OCiJalTuZpPR74GMB7TedquoM1aDN1o7j4oFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cPXxk3yC; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cPXxk3yC"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782802819;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yRc15okIcuMzadoX86qxhT9vGGbP9472K9XPn91BZag=;
	b=cPXxk3yCuGb+JXOZx/gUvQc1NXw+z2SjcVl9btWHVr/vmR1Brk0BGzzYfKf+uh8g0aWNGB
	qb0QbZURpU0XDZhwKH1AGMgOTgR610IYPoieOSjk/0LdQm46x9RJaoWbYh9xP0n9eqgTBK
	pffv9TqiRrEqiATfwOyVISNeFFf4BHk=
From: Hui Zhu <hui.zhu@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [RESEND PATCH v2] mm/memcontrol: Avoid stuck FLUSHING_CACHED_CHARGE on isolated CPU
Date: Tue, 30 Jun 2026 15:00:04 +0800
Message-ID: <20260630070004.470181-1-hui.zhu@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Hui Zhu <zhuhui@kylinos.cn>

drain_all_stock() sets FLUSHING_CACHED_CHARGE before calling
schedule_drain_work() to queue per-CPU drain work.  When the target
CPU is isolated (cpu_is_isolated() == true), the work is silently
not queued, but FLUSHING_CACHED_CHARGE stays set.  Every subsequent
drain_all_stock() then sees the bit and skips this stock entirely,
so the entry is effectively pinned until something else on that CPU
runs drain_local_*_stock() and clears the bit -- which on a long-
isolated CPU may never happen.

The original idea was to actually perform the drain from the calling
CPU on behalf of the isolated one, by adding a lock around the
per-CPU stock so that a remote drainer could safely touch it.  In
practice this turned out to be intrusive: the stock data structures
and their fast paths (consume_stock(), refill_stock(), the obj_stock
helpers) are deliberately designed around current-CPU-only access,
and retrofitting cross-CPU serialisation onto them adds non-trivial
locking and PREEMPT_RT concerns for very little gain.

Looking at the actual amount of charge that can accumulate in a
single per-CPU stock, it is bounded and small, so leaving an
isolated CPU's stock undrained for a while is not a real problem.
The only real bug is that the stuck FLUSHING_CACHED_CHARGE bit
prevents future drain_all_stock() callers from re-attempting once
the CPU is no longer isolated.

Fix this minimally by clearing FLUSHING_CACHED_CHARGE when the work
could not be queued because the target CPU is isolated.  The cached
charge itself is left in place; it will be released the next time
the CPU runs drain_local_*_stock() (e.g. after leaving isolation,
or if the isolated CPU itself calls drain_all_stock() -- in that
case cpu == curcpu causes drain_local_memcg_stock() to be invoked
directly), and the next drain_all_stock() call is free to retry
instead of skipping the stock forever.

Fixes: 6a792697a53a ("memcg: do not drain charge pcp caches on remote isolated cpus")
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
Changelog:
v2:
According to the comments of Waiman Long, updated fixes.

 mm/memcontrol.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6dc4888a90f3..2e66b4a2c25d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2256,7 +2256,8 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
 	return flush;
 }
 
-static void schedule_drain_work(int cpu, struct work_struct *work)
+static void
+schedule_drain_work(int cpu, struct work_struct *work, unsigned long *flags)
 {
 	/*
 	 * Protect housekeeping cpumask read and work enqueue together
@@ -2264,9 +2265,22 @@ static void schedule_drain_work(int cpu, struct work_struct *work)
 	 * partition update only need to wait for an RCU GP and flush the
 	 * pending work on newly isolated CPUs.
 	 */
-	guard(rcu)();
-	if (!cpu_is_isolated(cpu))
-		queue_work_on(cpu, memcg_wq, work);
+	scoped_guard(rcu) {
+		if (!cpu_is_isolated(cpu)) {
+			queue_work_on(cpu, memcg_wq, work);
+			return;
+		}
+	}
+
+	/*
+	 * The target CPU is isolated: the drain work was not queued.
+	 * Clear FLUSHING_CACHED_CHARGE so that future drain_all_stock()
+	 * callers can re-attempt instead of skipping this stock forever.
+	 * The cached charge is left in place; it will be released the
+	 * next time the CPU itself runs drain_local_*_stock() (e.g.
+	 * after leaving isolation), or by a follow-up mechanism.
+	 */
+	clear_bit(FLUSHING_CACHED_CHARGE, flags);
 }
 
 /*
@@ -2299,7 +2313,8 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 			if (cpu == curcpu)
 				drain_local_memcg_stock(&memcg_st->work);
 			else
-				schedule_drain_work(cpu, &memcg_st->work);
+				schedule_drain_work(cpu, &memcg_st->work,
+						    &memcg_st->flags);
 		}
 
 		if (!test_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags) &&
@@ -2309,7 +2324,8 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 			if (cpu == curcpu)
 				drain_local_obj_stock(&obj_st->work);
 			else
-				schedule_drain_work(cpu, &obj_st->work);
+				schedule_drain_work(cpu, &obj_st->work,
+						    &obj_st->flags);
 		}
 	}
 	migrate_enable();
-- 
2.43.0

