Received: from mta0.migadu.com (out-6.mta0.migadu.com [91.218.175.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2051828852E
	for <cgroups@vger.kernel.org>; Thu, 27 Aug 2026 02:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787799322; cv=none; b=WAfEV1DoS8F2Ctp9K++aHFbiISpzKB040azq2QY+HtQ0JzuHh+w7Av4CGnCyGYIiGm6+6s47jqSzCa3qrQHR/5/sOWjUjlUlEDgq59cWLFqxiQ1TMojjnOLFHIuMEsE88QKqURvXDLQsf/qmf+W51K3T56ARX488n4WNz2nniyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787799322; c=relaxed/simple;
	bh=+WYQTsDYVTtYJtW2ln0YBQa4L8nYSewLmll/nAIQFt8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Rc2P0Am/7IcEBLGqj+KH2OHDBDyRs5fjUtOWY/I4sGvE0R4VFsjkSnxXvh7dJU5DnLgepa4qLoeksk3SvFzh4PFUgo/0ULootC0Ra1OZVwSw00P7N28WFxeLF5fIJMdxUtH+XSoKG3m2ABneBwar+xBXmDuCwZ+5eKHLMGduNuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YHxc8c/K; arc=none smtp.client-ip=91.218.175.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YHxc8c/K"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=+WYQTsDYVTtYJtW2ln0YBQa4L8nYSewLmll/nAIQFt8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787799315; v=1; x=1788404115;
 b=YHxc8c/K1aRBnoUqGWDsmc0GsN66KPh1fJB3gEkKaJiSA6YzwfSggrevRL/IDTJ2igKJIDdc
 nX+GlABx1SURQMeC/j5Yh5jT3ydmLI3yWUzGFPj6+r+fM7pvipNQlqr8thzgT4PPvwB+VaS+H2v
 2t4SXudkYr8WGovOZ5Srvm9c=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost.localdomain (147.136.157.3)
	by smtp.migadu.com with ESMTPS id 1c0d3bd05cbfb2fd;
	Thu, 27 Aug 2026 02:55:15 +0000
X-Mizu-Trace-ID: 1c0d3bd05cbfb2fd
X-Migadu-Flow: FLOW_OUT
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>,
	stable@vger.kernel.org,
	syzbot+ced4d9a8cadb5ef3adae@syzkaller.appspotmail.com,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Chris Li <chrisl@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Jan Kara <jack@suse.cz>,
	Tejun Heo <tj@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/memcontrol: fix data-race on reading jiffies_64
Date: Thu, 27 Aug 2026 10:54:56 +0800
Message-ID: <20260827025457.116191-1-jiayuan.chen@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KCSAN reported a data-race between tick_do_update_jiffies64() updating
jiffies_64 and mem_cgroup_flush_stats_ratelimited() reading it directly.

Unlike jiffies, jiffies_64 is not volatile, so raw reads are plain
accesses and can even be torn on 32-bit. Use get_jiffies_64() instead,
and fix the same pattern in mem_cgroup_flush_foreign().

Cc: <stable@vger.kernel.org>
Fixes: 508bed884767 ("mm: memcg: change flush_next_time to flush_last_time")
Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty flushing")
Reported-by: syzbot+ced4d9a8cadb5ef3adae@syzkaller.appspotmail.com
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
---
feel free to drop Fixes tag.
---
 mm/memcontrol.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 11b85f4b6828..5a3fe057debc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -757,7 +757,7 @@ static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force)
 		return;
 
 	if (mem_cgroup_is_root(memcg))
-		WRITE_ONCE(flush_last_time, jiffies_64);
+		WRITE_ONCE(flush_last_time, get_jiffies_64());
 
 	css_rstat_flush(&memcg->css);
 }
@@ -785,7 +785,7 @@ void mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg)
 {
 	/* Only flush if the periodic flusher is one full cycle late */
-	if (time_after64(jiffies_64, READ_ONCE(flush_last_time) + 2*FLUSH_TIME))
+	if (time_after64(get_jiffies_64(), READ_ONCE(flush_last_time) + 2 * FLUSH_TIME))
 		mem_cgroup_flush_stats(memcg);
 }
 
@@ -3945,7 +3945,7 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(wb->memcg_css);
 	unsigned long intv = msecs_to_jiffies(dirty_expire_interval * 10);
-	u64 now = jiffies_64;
+	u64 now = get_jiffies_64();
 	int i;
 
 	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
-- 
2.43.0

