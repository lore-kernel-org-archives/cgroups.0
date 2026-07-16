Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E3A2FFDD6
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 03:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784171942; cv=none; b=ADWILk52xjiHgUuqKyePvCfvoYxmo+BklMf2AgF9rRSJtYqQZMvpalylT0DlGsTUTGOPvBkmH/dP2AQQk3atpLHIVkztIOayiJmVlSh1NdIKFxTHQO1icLOU8+sC+HJ74ltIFu1gBGtlDGesGMVYGi2ftMGRI35L4xkgj+69nHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784171942; c=relaxed/simple;
	bh=ZtzyzWp9Hgr1m5lQFzzbe5uY6ndBEnGQz9PtUl9w+4Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nf0kRCQnC6eVT2cUHo3fxtxZOZ4Lu3oMdR8yQ6EB+2I5KGBQDnWzNbyjAZqtix8U8/hHTBW1pN1P5ZGI98HTE0UN41gH5bwuN5g17dNlSzUbw5FcI9pJjzt33/CIwJGY9jiS+nzcFceJaZpXV9U0EjI+p5VphWxsBBpME4PVeYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oAjDD2Dp; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oAjDD2Dp"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784171938;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F2+wiVXqFER56suiYoyluTh0yWbLBUPuPSa5i4pNZtw=;
	b=oAjDD2DpPLx2y9QSnMyAFBPveYRCeMghBcqkdxtvOR9T/UEs6XEs8tW+NrTh/JNIun8I5D
	2js20WvXL/faUC9EDv3qfo0IFZ4OfkBlNIb8a2so502eCSH0uFq85rCsvSNeRGpbkMO3FM
	aEpKNADeVm/Jkm8GTBmu+fA/Tr1t49k=
From: Ridong <ridong.chen@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Cc: Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 2/2] mm: vmscan: fix node reclaim ignoring swappiness parameter
Date: Thu, 16 Jul 2026 11:17:29 +0800
Message-Id: <20260716031729.1064007-3-ridong.chen@linux.dev>
In-Reply-To: <20260716031729.1064007-1-ridong.chen@linux.dev>
References: <20260716031729.1064007-1-ridong.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Ridong Chen <chenridong@xiaomi.com>

sc_swappiness() had two separate definitions depending on
CONFIG_MEMCG. The !CONFIG_MEMCG variant simply returned
vm_swappiness, ignoring the proactive_swappiness value passed
through scan_control. This caused the swappiness parameter
written to /sys/devices/system/node/nodeX/reclaim to have no
effect when CONFIG_MEMCG is disabled.

Fix this by consolidating sc_swappiness() into a single definition
that checks sc->proactive_swappiness first, then falls back to
mem_cgroup_swappiness() which already handles both CONFIG_MEMCG
and !CONFIG_MEMCG.

Before fix (swappiness=max ignored, mostly file pages reclaimed):

    # cat /proc/sys/vm/swappiness
    60
    # cat /proc/vmstat | grep pgsteal
    pgsteal_kswapd 0
    pgsteal_direct 0
    pgsteal_khugepaged 0
    pgsteal_proactive 1840
    pgsteal_anon 25
    pgsteal_file 1815
    # echo "64M swappiness=max" > /sys/devices/system/node/node0/reclaim
    # cat /proc/vmstat | grep pgsteal
    pgsteal_kswapd 0
    pgsteal_direct 0
    pgsteal_khugepaged 0
    pgsteal_proactive 18013
    pgsteal_anon 337
    pgsteal_file 17676

After fix (swappiness=max honored, anon pages reclaimed as expected):

    # cat /proc/vmstat | grep pgsteal
    pgsteal_kswapd 0
    pgsteal_direct 0
    pgsteal_khugepaged 0
    pgsteal_proactive 0
    pgsteal_anon 0
    pgsteal_file 0
    # echo "64M swappiness=max" > /sys/devices/system/node/node0/reclaim
    # cat /proc/vmstat | grep pgsteal
    pgsteal_kswapd 0
    pgsteal_direct 0
    pgsteal_khugepaged 0
    pgsteal_proactive 16283
    pgsteal_anon 16283
    pgsteal_file 0

Cc: stable@vger.kernel.org # 6.17+
Fixes: b980077899ea ("mm: introduce per-node proactive reclaim interface")
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Barry Song <baohua@kernel.org>
---
 mm/vmscan.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 986dde8e7429..bd71595c8b2b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -199,6 +199,13 @@ struct scan_control {
  */
 int vm_swappiness = 60;
 
+static int sc_swappiness(struct scan_control *sc, struct mem_cgroup *memcg)
+{
+	if (sc->proactive && sc->proactive_swappiness)
+		return *sc->proactive_swappiness;
+	return mem_cgroup_swappiness(memcg);
+}
+
 #ifdef CONFIG_MEMCG
 
 /* Returns true for reclaim through cgroup limits or cgroup interfaces. */
@@ -239,13 +246,6 @@ static bool writeback_throttling_sane(struct scan_control *sc)
 #endif
 	return false;
 }
-
-static int sc_swappiness(struct scan_control *sc, struct mem_cgroup *memcg)
-{
-	if (sc->proactive && sc->proactive_swappiness)
-		return *sc->proactive_swappiness;
-	return mem_cgroup_swappiness(memcg);
-}
 #else
 static bool cgroup_reclaim(struct scan_control *sc)
 {
@@ -261,11 +261,6 @@ static bool writeback_throttling_sane(struct scan_control *sc)
 {
 	return true;
 }
-
-static int sc_swappiness(struct scan_control *sc, struct mem_cgroup *memcg)
-{
-	return READ_ONCE(vm_swappiness);
-}
 #endif
 
 static void set_task_reclaim_state(struct task_struct *task,
-- 
2.34.1

