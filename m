Received: from mta1.migadu.com (out-228.mta1.migadu.com [95.215.58.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74113A63F2
	for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 12:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787659346; cv=none; b=alrwlMvbKZONa5tk+8NpS9fPVdLUsZmPMURaDPdjzDy0j1ww5uAPnNnpCiw0QdtUB999xHK4dIqe7hy8ZjkfpkeNEU1bEEyWmwF/edivegW8uOBsk3yQ6g20DrA0PdJOPzvlIEe7KttL0YH1rAWCn5lh/iA+ethTkJMJXcBheD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787659346; c=relaxed/simple;
	bh=F10YmlO6apGqfUY4pH79O4UBnWaDT2uzM2vlHZEvwc8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iW2U0pOMSx/4SJpBgODiqqaaNvJNJ3BbOGvY9KeBG7DvbUStmX7AkhpE3cYWGRosoczZs71vEpPx/hzuEMiBrRU3x25f+eacSl9+kCvmkrjXaTjg0OIGClIcyqEJaQLiDpFYJJpcPpAyJoNbRKn7FScBGiuPNaP2ZVrumQsFrAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=e2Jxv3rU; arc=none smtp.client-ip=95.215.58.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="e2Jxv3rU"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=F10YmlO6apGqfUY4pH79O4UBnWaDT2uzM2vlHZEvwc8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787659340; v=1; x=1788264140;
 b=e2Jxv3rU/BVOOF/XlsLRYuW6TJVaPCLGXp8de6AP9i1ANC86JTqyrQx8U17azoX9m/GfILPu
 /LqXhNsNGM0EUWa10IOs0s/GS/Fg9bs/ltmuiJDxiwbrKy0LywN7Y1nPJrZ280wjHbsjCe8ca54
 MLrJMc1iH8+WRvkqEnnTLY6o=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost.localdomain (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 95c8932470f5c4c0;
	Tue, 25 Aug 2026 12:02:10 +0000
X-Mizu-Trace-ID: 95c8932470f5c4c0
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org
Cc: cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH] mm/memcontrol: remove unused memcg parameter in calculate_high_delay()
Date: Tue, 25 Aug 2026 20:01:53 +0800
Message-ID: <20260825120153.1405-1-hongfu.li@linux.dev>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hongfu Li <lihongfu@kylinos.cn>

The memcg argument of calculate_high_delay() is never referenced in
its function body. The delay calculation only depends on nr_pages
and max_overage, and both callers have already obtained max_overage
from the same memcg.

Drop this unused parameter and update the two call sites inside
__mem_cgroup_handle_over_high().

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 mm/memcontrol.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 11b85f4b6828..8bdb6988e7f0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2515,8 +2515,7 @@ static u64 swap_find_max_overage(struct mem_cgroup *memcg)
  * Get the number of jiffies that we should penalise a mischievous cgroup which
  * is exceeding its memory.high by checking both it and its ancestors.
  */
-static unsigned long calculate_high_delay(struct mem_cgroup *memcg,
-					  unsigned int nr_pages,
+static unsigned long calculate_high_delay(unsigned int nr_pages,
 					  u64 max_overage)
 {
 	unsigned long penalty_jiffies;
@@ -2594,10 +2593,10 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
 	 * memory.high is breached and reclaim is unable to keep up. Throttle
 	 * allocators proactively to slow down excessive growth.
 	 */
-	penalty_jiffies = calculate_high_delay(memcg, nr_pages,
+	penalty_jiffies = calculate_high_delay(nr_pages,
 					       mem_find_max_overage(memcg));
 
-	penalty_jiffies += calculate_high_delay(memcg, nr_pages,
+	penalty_jiffies += calculate_high_delay(nr_pages,
 						swap_find_max_overage(memcg));
 
 	/*
-- 
2.54.0

