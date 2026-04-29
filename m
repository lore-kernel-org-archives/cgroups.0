Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0803806D6
	for <cgroups@vger.kernel.org>; Wed, 29 Apr 2026 02:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777429710; cv=none; b=kYmmwlJD8EwinLB9iwJW6q60EQ/3TqwcVerv2BttRx5qHhD71hsVFNMuRx4j1W6CEehBdWsn2SIz+AXBb9+eEIedDCjmd2pWKM4I6kO8nErtN6npGnfNgucb6pOYezYmRwqd7mz5vfzIheKVD18BxAEsi0MytH744h/SC/az8vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777429710; c=relaxed/simple;
	bh=2os00x0eajezWPWD+cCpUn2HJesWTlY9uwP/L+NmrU8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tbm/ZO6xHla17PKKpHUQ6TdZ7a2FtJecdFrioi2x9+9Q6deh5P9GMNiDuRtq6G7zRly4bTwcy99Zso/np82DlctTeCAAjOwMByVsjo+bIAhJrOUpYa+2ls9JFwl22s3FuC+UPBNuNNNhC7v6bLApDwrtBrhxpnBB4AGdQ/2JL5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DZONtexw; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DZONtexw"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777429697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=si4pob8Nbwk0h2k/iX2PC+8vOE1XCT4dxsoLSEJ3Y8M=;
	b=DZONtexwMlI2LaWNMKw6eoGZkZFSghxVyjxai8XC9nPgC8Zb9wKsho0YvNiZM7nISvEL/l
	hQCJ0tstYaNkPFZcCD+aiycEKmt4GlfMswZCFfPAfVDZ923b/sVZixTss6FbzgAjyzpwIG
	NDzg4Cy8jOtvKQR08EOaCF9/45jRn6A=
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
	Frederic Weisbecker <frederic@kernel.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH] mm/memcontrol: Avoid stuck FLUSHING_CACHED_CHARGE on isolated CPU
Date: Wed, 29 Apr 2026 10:27:22 +0800
Message-ID: <20260429022723.133833-1-hui.zhu@linux.dev>
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

Fixes: 2d05068610a3 ("memcg: Prepare to protect against concurrent isolated cpuset change")
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/memcontrol.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c3d98ab41f1f..cee77b0a95f5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2219,7 +2219,8 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
 	return flush;
 }
 
-static void schedule_drain_work(int cpu, struct work_struct *work)
+static void
+schedule_drain_work(int cpu, struct work_struct *work, unsigned long *flags)
 {
 	/*
 	 * Protect housekeeping cpumask read and work enqueue together
@@ -2227,9 +2228,22 @@ static void schedule_drain_work(int cpu, struct work_struct *work)
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
@@ -2262,7 +2276,8 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 			if (cpu == curcpu)
 				drain_local_memcg_stock(&memcg_st->work);
 			else
-				schedule_drain_work(cpu, &memcg_st->work);
+				schedule_drain_work(cpu, &memcg_st->work,
+						    &memcg_st->flags);
 		}
 
 		if (!test_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags) &&
@@ -2272,7 +2287,8 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
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

