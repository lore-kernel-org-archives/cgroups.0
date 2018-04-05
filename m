From: Roman Gushchin <guro@fb.com>
Subject: [PATCH v3 3/4] mm: treat memory.low value inclusive
Date: Thu, 5 Apr 2018 19:59:20 +0100
Message-ID: <20180405185921.4942-3-guro@fb.com>
References: <20180405185921.4942-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=zx3LVvUyXeVnVVLhrX4NR9Uv7SH8jMhxOiT1g0qcsPU=;
 b=fM3UXdRzDEsay23MQBsrEE5Yz3d+Wnj2nEyr5u+javrbvXETz2r19Aepq50jP+ZXUfH+
 3RPotRe9+o3lU674YakfbJ2bS1J/PPX4qgFPgcNYbHOt91E39LzBnGzs1jxKdEPfRdP2
 dIiZUd8NL3TEDB/OHYhEmKfOn0qwYq8b5Ko= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=zx3LVvUyXeVnVVLhrX4NR9Uv7SH8jMhxOiT1g0qcsPU=;
 b=Uct5x5odeODoY41yA4Vc9xvmhCrCMbvUlHgI90t7iHsaM6GEvmb24ItJ8bOWFSNCCK1WlnNOdKQe65+dxfdpLE+jKx1wijv9ZJMHU0bVefmdvGT9JivHAl6V2nx3MRpF1TNhTN+Fc3eYFhf2cVpN0awexwscVps3/FwxXlAs5GA=
In-Reply-To: <20180405185921.4942-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org
Cc: Roman Gushchin <guro@fb.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

If memcg's usage is equal to the memory.low value, avoid reclaiming
from this cgroup while there is a surplus of reclaimable memory.

This sounds more logical and also matches memory.high and memory.max
behavior: both are inclusive.

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: kernel-team@fb.com
Cc: linux-mm@kvack.org
Cc: cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 mm/memcontrol.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 78cf21f2a943..1cd6e9bf24f2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5608,14 +5608,14 @@ struct cgroup_subsys memory_cgrp_subsys = {
 };
 
 /**
- * mem_cgroup_low - check if memory consumption is below the normal range
+ * mem_cgroup_low - check if memory consumption is in the normal range
  * @root: the top ancestor of the sub-tree being checked
  * @memcg: the memory cgroup to check
  *
  * WARNING: This function is not stateless! It can only be used as part
  *          of a top-down tree iteration, not for isolated queries.
  *
- * Returns %true if memory consumption of @memcg is below the normal range.
+ * Returns %true if memory consumption of @memcg is in the normal range.
  *
  * @root is exclusive; it is never low when looked at directly
  *
@@ -5709,7 +5709,7 @@ bool mem_cgroup_low(struct mem_cgroup *root, struct mem_cgroup *memcg)
 	elow = min(elow, parent_elow * low_usage / siblings_low_usage);
 exit:
 	memcg->memory.elow = elow;
-	return usage < elow;
+	return usage <= elow;
 }
 
 /**
-- 
2.14.3

