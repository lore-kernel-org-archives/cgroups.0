Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164B23E929C
	for <cgroups@vger.kernel.org>; Fri,  4 Sep 2026 17:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788543117; cv=none; b=g/7eAZ2AAtAd29wCNu7xgqWTs14RGE7gS7ZKhg8eJc1RSqkptYpxId3eTlQNNQulTgTABkeP6ryOXjLfyIH9RQ+YzSgg0T6fvxz5ZhJ4l/3Cs0pUTPyZOIE1T7FMN7qbBXenhI6TmrK09UXMYWDxmHgznYBycgYXH6kwURlqMQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788543117; c=relaxed/simple;
	bh=CwxNiV+6cxQL0zBKZQS8TnMWY5wyqs+1hcKMKWmAWPM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=CXe3GWYLHIQzwfV+ys/595fWvwOBskperYkrecB7m1GffqVuNxzwcgRtE/f5rM722aSBneqW/RzOumuNBaEgJlokQ0cZKYBHwqpLd5WhW5yz41QS5IcgEaYWthk0YMqM2SV6/wjORBThY/CMy2w6qKr7bhsfS1NENMrr08hd/Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stevensd.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ARNGHKPx; arc=none smtp.client-ip=209.85.210.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stevensd.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ARNGHKPx"
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7eb6a8c61deso1364318a34.3
        for <cgroups@vger.kernel.org>; Fri, 04 Sep 2026 10:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788543115; x=1789147915; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6tqulB8FDTNVxXNeXDPTSBTeFrFMPJvixAJvKQn0AlQ=;
        b=ARNGHKPxNENuTFhziYMvSucNOztmhDbkGo1SC9zAAoxP56hlUe+tP7xZqWnJeCLW05
         k9srbsIJYSImX1uzzB5bI4nZicRbrVQP4M0oBxVmoAk+MLWnCfQzTc9JUKdMyH8teN+c
         IhzDxplnz3+8F31OpVI5RhnzLAcqLGHVPGWC1vZ2E/x8bC70pKnwHvg44ttAs3zTjTFW
         +/5ukKwvT6Mo7huGkMNR058RPCW4J/zuGrS+G/iL1Oh5/rVc+wrcT7H6Ebk19TH0ToZo
         dp0ZthIgbdgSJlBAy2n4w+CH6Y/2F64lL1kepNho0PMejJ/47FIo+NZGTgbgZ3FDf+hZ
         SuPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788543115; x=1789147915;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6tqulB8FDTNVxXNeXDPTSBTeFrFMPJvixAJvKQn0AlQ=;
        b=Vt3vBD5UuIX2LKWxWIyln6JytjQ59486WPQHKzJGdqC3wWpXYT9tJiurmPSqx6MH9z
         QniYKZFLt+Vsjs+GupvBiSyJPTTnGAgnXPgHLUAMczl06nBGU0S79GVluJysMWcH5Nqj
         3CNN2uWlHEENNUBhJtUgtgRH0FsEg2mNDyorkDio98BXDhXI+fZJzgbvDpmkXUXmN2A+
         PjmXh2ULBVDPFiYrsTvsJ+mP6gPYKoDl48QG9zCD4TJZJIqD41H//Vhsg2l8MJFhLpED
         Fb3p+9hEU0F99kvBRLER+tno/eB/xVQA//OuFPx+YQ+gkPxOSWNqwjjdMXuihXBRN3xk
         1hqQ==
X-Forwarded-Encrypted: i=1; AKwUvBzw9G2hQyfsYrYvQs9bgSztsnW3Uy/3DCZxXhTxNNJfh6k5rM/n331+p3pbSP/C5TecnQmif5SU@vger.kernel.org
X-Gm-Message-State: AFuF++mTjuJVUCCAiLqifcFizGvDajp2I6vI2tNxe/5v9XlqT1AARmcs
	sw/eH98D6iRccYaUJM+PDBne0s76HVNEltXfIjB18TDkGCQrxARSiQuOctFRttsLdMhhPNujzGQ
	02rEti5bg46Fprg==
X-Received: from dyjh19.prod.google.com ([2002:a05:7300:5613:b0:315:877c:f169])
 (user=stevensd job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:60b:b0:6b7:8396:f3c2 with SMTP id 006d021491bc7-6b78396f7ecmr3028618eaf.36.1788543114426;
 Fri, 04 Sep 2026 10:31:54 -0700 (PDT)
Date: Fri,  4 Sep 2026 10:31:45 -0700
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
Message-ID: <20260904173145.2028377-1-stevensd@google.com>
Subject: [PATCH v2] memcg: Don't call schedule_work when no spinning is allowed
From: David Stevens <stevensd@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, David Stevens <stevensd@google.com>, 
	Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"

Memcg charging can be done from any context, but calling schedule_work()
isn't safe from an NMI. If memory.high is breached from a context where
spinning isn't allowed, use irq_work to schedule the reclaim work.

Fixes: 3ac4638a734a ("memcg: make memcg_rstat_updated nmi safe")
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: David Stevens <stevensd@google.com>
---
v2:
  - Added missing includes reported by Lorenzo and kernel test robot
  - Added Acked-by

 include/linux/memcontrol.h |  2 ++
 mm/memcontrol.c            | 13 ++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 8170bb8066a2..4a5ef0aba475 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -23,6 +23,7 @@
 #include <linux/writeback.h>
 #include <linux/page-flags.h>
 #include <linux/shrinker.h>
+#include <linux/irq_work_types.h>
 
 struct mem_cgroup;
 struct obj_cgroup;
@@ -219,6 +220,7 @@ struct mem_cgroup {
 	spinlock_t	 peaks_lock;
 
 	/* Range enforcement for interrupt charges */
+	struct irq_work high_irq_work;
 	struct work_struct high_work;
 
 #ifdef CONFIG_ZSWAP
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6dc4888a90f3..0e8b302ca9ad 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -62,6 +62,7 @@
 #include <linux/seq_buf.h>
 #include <linux/sched/isolation.h>
 #include <linux/kmemleak.h>
+#include <linux/irq_work.h>
 #include "internal.h"
 #include "swap_table.h"
 #include <net/sock.h>
@@ -2360,6 +2361,11 @@ static void high_work_func(struct work_struct *work)
 	reclaim_high(memcg, MEMCG_CHARGE_BATCH, GFP_KERNEL);
 }
 
+static void high_irq_work_func(struct irq_work *work)
+{
+	schedule_work(&container_of(work, struct mem_cgroup, high_irq_work)->high_work);
+}
+
 /*
  * Clamp the maximum sleep time per allocation batch to 2 seconds. This is
  * enough to still cause a significant slowdown in most cases, while still
@@ -2752,7 +2758,10 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		/* Don't bother a random interrupted task */
 		if (!in_task()) {
 			if (mem_high) {
-				schedule_work(&memcg->high_work);
+				if (allow_spinning)
+					schedule_work(&memcg->high_work);
+				else
+					irq_work_queue(&memcg->high_irq_work);
 				break;
 			}
 			continue;
@@ -4129,6 +4138,7 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 		goto fail;
 
 	INIT_WORK(&memcg->high_work, high_work_func);
+	init_irq_work(&memcg->high_irq_work, high_irq_work_func);
 	vmpressure_init(&memcg->vmpressure);
 	INIT_LIST_HEAD(&memcg->memory_peaks);
 	INIT_LIST_HEAD(&memcg->swap_peaks);
@@ -4337,6 +4347,7 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
 		static_branch_dec(&memcg_bpf_enabled_key);
 
 	vmpressure_cleanup(&memcg->vmpressure);
+	irq_work_sync(&memcg->high_irq_work);
 	cancel_work_sync(&memcg->high_work);
 	memcg1_remove_from_trees(memcg);
 	free_shrinker_info(memcg);

base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
-- 
2.55.0.979.g7e5102b832-goog

