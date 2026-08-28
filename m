Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22714364058;
	Fri, 28 Aug 2026 17:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.67.55.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787939448; cv=none; b=t6520VGYq35QTtgBzC7m9Jnwe3NInYcou2sxtHrfbdGsAL6bEYCGen7myZZXScZx90Gqo17fKUudkvqrrvuXSnHADywMlEkt1Q06bM36n6Q+PKon3+UCz3MH6Cn0mhCfVmkPFkzMBP7Ul+z9igSjFq02GzGtDa/aAMpDJx1rlbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787939448; c=relaxed/simple;
	bh=JvJ+o6146P4oRHKDVyAsH1RN98XuBcxixGMSU5PVFZc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=nlaAVQA6rta1Um+xSleeJOlhoV74/tjG3QiEfc/pn0ky1V0vhOY0xGvqwXha5FFv3fKm2fd3lBXU2e5caAgMvoQfl/DznMt49olqnkJVOVXqWmJBE/7w98m/t03JSLgUhbn9Grfa3TcNrq+vum/OvGTpt88mO3z/gn8VlTxvg9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com; spf=pass smtp.mailfrom=surriel.com; dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b=hzwq2uTi; arc=none smtp.client-ip=96.67.55.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=surriel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b="hzwq2uTi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References; bh=HRZSERTM0W44dOUuuxbU9VU3oVx0AWLYRmfUpfpxEzc=; b=hz
	wq2uTiBTs8IkwanKDfjgJVs1pnY2pp2w3uzTcO7HgW8d1Hvy8ZeNbPuQ1SxbBooaq/QUzSrOHiEpb
	7TQD2iTEBnTiB5qScFe5IN6zrGaNINE4x7Q1uv1k9OOr+Z0zhRQcUnP81v+8Mv/7ukzZYYpLDumoX
	ENifvuszFTj8zU5VW+5QRvMWO0Qv5oDaSEBrPqru6G8G5DVTbHnIWfox7sOJTlmHwXCx2iXrYkU1E
	GDP44K8sM89Eueh9TO2HSnS+0JVnmrlSf6N3N9WgA7onuMh2BfLA3nya5z6wXkJ8DlMtFo8KxS5rM
	vaQlQ8hR5eHXWUSKVMy7/0Wvvbw/aORw==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1x00ir-000000093Tk-0mpH;
	Fri, 28 Aug 2026 17:50:37 +0000
Date: Fri, 28 Aug 2026 13:50:36 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew
 Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, kernel-team@meta.com
Subject: [PATCH v2] mm/memcontrol: fix stuck FLUSHING_CACHED_CHARGE bit on
 isolated cpus
Message-ID: <20260828135036.7d44361f@fangorn>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

When drain_all_stock() sets FLUSHING_CACHED_CHARGE before checking
isolation, schedule_drain_work() can drop the work in a separate RCU
critical section, and housekeeping_update()'s synchronize_rcu() can race
that second check, leaving the flag set.

drain_local_stock() only clears the bit for work that ran, so the flag
remains set and the stock is never drained again.

Have schedule_drain_work() return whether the work was queued, and clear
FLUSHING_CACHED_CHARGE in drain_all_stock() when the remote CPU is
isolated, so future drains can retry.

Fixes: 6a792697a53a ("memcg: do not drain charge pcp caches on remote isolated cpus")
Cc: stable@vger.kernel.org
Suggested-by: Michal Hocko <mhocko@suse.com>
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Rik van Riel <riel@surriel.com>
---
v2: use the approach suggested by Michal and Shakeel

Link: https://lore.kernel.org/all/cover.1787890328.git.riel@surriel.com/

 mm/memcontrol.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1271d390b617..309398e943ca 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2306,7 +2306,7 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
 	return flush;
 }
 
-static void schedule_drain_work(int cpu, struct work_struct *work)
+static bool schedule_drain_work(int cpu, struct work_struct *work)
 {
 	/*
 	 * Protect housekeeping cpumask read and work enqueue together
@@ -2315,8 +2315,11 @@ static void schedule_drain_work(int cpu, struct work_struct *work)
 	 * pending work on newly isolated CPUs.
 	 */
 	guard(rcu)();
-	if (!cpu_is_isolated(cpu))
-		queue_work_on(cpu, memcg_wq, work);
+	if (cpu_is_isolated(cpu))
+		return false;
+
+	queue_work_on(cpu, memcg_wq, work);
+	return true;
 }
 
 /*
@@ -2348,8 +2351,9 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 				      &memcg_st->flags)) {
 			if (cpu == curcpu)
 				drain_local_memcg_stock(&memcg_st->work);
-			else
-				schedule_drain_work(cpu, &memcg_st->work);
+			else if (!schedule_drain_work(cpu, &memcg_st->work))
+				clear_bit(FLUSHING_CACHED_CHARGE,
+					  &memcg_st->flags);
 		}
 
 		if (!test_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags) &&
@@ -2358,8 +2362,9 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 				      &obj_st->flags)) {
 			if (cpu == curcpu)
 				drain_local_obj_stock(&obj_st->work);
-			else
-				schedule_drain_work(cpu, &obj_st->work);
+			else if (!schedule_drain_work(cpu, &obj_st->work))
+				clear_bit(FLUSHING_CACHED_CHARGE,
+					  &obj_st->flags);
 		}
 	}
 	migrate_enable();
-- 
2.55.0


