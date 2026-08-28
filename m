Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE37391E76;
	Fri, 28 Aug 2026 13:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.67.55.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787924793; cv=none; b=Uu78/4LHJQYYHVWNERCBKbimDut+THj5voqx72y/zECwOAZQEl9OsTOA8swCDzdAJUvFIltcaVUaMq39rn+Zquu2Z2QGjDGQtUuOZ82A6lChNxobiv7vcoOioiHHzx2QOtZdRHx5dq192AmLt3z4BBi2LkSylqBr7L/SdS+2ves=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787924793; c=relaxed/simple;
	bh=/AUbOXLbCVCQjm0+YW4SW5lQPjQLIXY9ybWXRRosM6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQb/hK2gvnF3KlGcTHVOdqmY1qZGGwvuBGHcu7CwIPEx6/xl17k80lw264cMTc5Twvl417ykwwDVVUhXeKJJf+45IEv2ZlWzn/DXQHYLacaobik/yugv+E+c3YZ3kYzd7a+sLo+oumEw0dP7OBjzbShX/SlQNMd3mIhav989nf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com; spf=pass smtp.mailfrom=surriel.com; dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b=NnZNH0/K; arc=none smtp.client-ip=96.67.55.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=surriel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b="NnZNH0/K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=9TfgXIoukN/RPVFm1I+e7bggSQFoinJyk03xgumztOQ=; b=NnZNH0
	/Kz1ZEAaFeSw5eQJXsW2aeU6YbzoXE+iOLimV0vZZtb1oVYNMYEUZCo8JMBjKpMZ5yH3S+fV7vcOO
	qKk461zeTFImkVEIeTIpUS67b/cbPvv3oafPXwDHdNEvexeCxV7yIC+3LB96cKgC5sPzpJRSvRdbh
	010F/tSvQC0fN4cxlXGclzSXZr30Ef+qTdbZ8anTTk9OJG99VpeaZlkMMnKqTjBwdyzPVONjx6mDP
	Em0DOkkIWD5/vDbr5QmPWTt8vECuVzUT9VG1tCybO8bgQ4lmCMr3+GuPwOzV4reJwTTlSiEurXxNN
	xGPVYZIIcqD5gp6WYwvyp/Ai+onA==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1wzwuY-00000008zmT-0utG;
	Fri, 28 Aug 2026 13:46:26 +0000
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: Rik van Riel <riel@surriel.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	stable@vger.kernel.org
Subject: [PATCH] mm/memcontrol: avoid stuck FLUSHING_CACHED_CHARGE bit on isolated cpus
Date: Fri, 28 Aug 2026 09:46:21 -0400
Message-ID: <a611f2bc40d30f9c14a6f41b173185975c46a203.1787890328.git.riel@surriel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1787890328.git.riel@surriel.com>
References: <cover.1787890328.git.riel@surriel.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

drain_all_stock() can leave FLUSHING_CACHED_CHARGE set after the
work is dropped.  It sets the bit before checking isolation and
schedule_drain_work() checks isolation and queues in a separate RCU
critical section, so housekeeping_update()'s synchronize_rcu() can
race the second check.

drain_local_stock() only clears the bit for work that ran, so the bit
remains set and the stock is never drained again.

Reorganize the drain_all_stock() loop, reducing nesting, splitting
out local vs remote cpu handling, and skipping everything on isolated
cpus, which solves the stuck FLUSHING_CACHED_CHARGE flag.

Fixes: 6a792697a53a ("memcg: do not drain charge pcp caches on remote isolated cpus")
Cc: stable@vger.kernel.org
Assisted-by: Hermes:muse-spark-1.2
Signed-off-by: Rik van Riel <riel@surriel.com>

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a660ea0f820b..b0d8ec042d48 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2330,19 +2330,6 @@ static bool obj_stock_should_drain(struct obj_stock_pcp *stock,
 	return true;
 }
 
-static void schedule_drain_work(int cpu, struct work_struct *work)
-{
-	/*
-	 * Protect housekeeping cpumask read and work enqueue together
-	 * in the same RCU critical section so that later cpuset isolated
-	 * partition update only need to wait for an RCU GP and flush the
-	 * pending work on newly isolated CPUs.
-	 */
-	guard(rcu)();
-	if (!cpu_is_isolated(cpu))
-		queue_work_on(cpu, memcg_wq, work);
-}
-
 /*
  * Drains all per-CPU charge caches for given root_memcg resp. subtree
  * of the hierarchy under it.
@@ -2366,19 +2353,23 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 		struct memcg_stock_pcp *memcg_st = &per_cpu(memcg_stock, cpu);
 		struct obj_stock_pcp *obj_st = &per_cpu(obj_stock, cpu);
 
-		if (memcg_stock_should_drain(memcg_st, root_memcg)) {
-			if (cpu == curcpu)
+		if (cpu == curcpu) {
+			if (memcg_stock_should_drain(memcg_st, root_memcg))
 				drain_local_memcg_stock(&memcg_st->work);
-			else
-				schedule_drain_work(cpu, &memcg_st->work);
-		}
-
-		if (obj_stock_should_drain(obj_st, root_memcg)) {
-			if (cpu == curcpu)
+			if (obj_stock_should_drain(obj_st, root_memcg))
 				drain_local_obj_stock(&obj_st->work);
-			else
-				schedule_drain_work(cpu, &obj_st->work);
+			continue;
 		}
+
+		/* Pairs with RCU barrier in housekeeping_update(). */
+		guard(rcu)();
+		if (cpu_is_isolated(cpu))
+			continue;
+
+		if (memcg_stock_should_drain(memcg_st, root_memcg))
+			queue_work_on(cpu, memcg_wq, &memcg_st->work);
+		if (obj_stock_should_drain(obj_st, root_memcg))
+			queue_work_on(cpu, memcg_wq, &obj_st->work);
 	}
 	migrate_enable();
 	mutex_unlock(&percpu_charge_mutex);
