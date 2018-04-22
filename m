From: Greg Thelen <gthelen@google.com>
Subject: [RFC PATCH 1/2] memcg: fix memory.low
Date: Sun, 22 Apr 2018 13:26:11 -0700
Message-ID: <20180422202612.127760-2-gthelen@google.com>
References: <20180320223353.5673-1-guro@fb.com>
 <20180422202612.127760-1-gthelen@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XaQD4HxtDl+oY38Yst87FddHUnKE2OHe89TRs+klFa8=;
        b=I2KYKKrDcbc1YhVpVGIJUEpfLUfE2mZR7vpTAPzAYJL07QFb/CcPMMyVfqbPGylTS3
         cD345qbMiGW0b6yICSk2NPsbLYmD13V1SgcXhBKCQgPLh8VGt3IrxUSHxGQVa7WuLD1S
         bnhUE0ABDEzssf49U/G6AZvD9ii7hVRpp5DC9Q6aUCUmNgKUIFxXObhPPbnCfwC0mbtb
         8OF5oXJuRM+4Bq95dhGgR0YURFU4kyipDpIW+nNYyKIUS0zucbEb5BNI1LT13IkbCDyZ
         YEMjEXc6Vnfi0/8uoHuSvLJN9F1/QnkH/6ys0LgfSoxU0+akqkRODNgfGI81FwYE1c4z
         YOsA==
In-Reply-To: <20180422202612.127760-1-gthelen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: guro@fb.com, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>, Tejun Heo <tj@kernel.org>, Cgroups <cgroups@vger.kernel.org>, kernel-team@fb.com, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Greg Thelen <gthelen@google.com>

When targeting reclaim to a memcg, protect that memcg from reclaim is
memory consumption of any level is below respective memory.low.

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 mm/memcontrol.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 670e99b68aa6..9668f620203a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5341,8 +5341,8 @@ struct cgroup_subsys memory_cgrp_subsys = {
  * @root: the top ancestor of the sub-tree being checked
  * @memcg: the memory cgroup to check
  *
- * Returns %true if memory consumption of @memcg, and that of all
- * ancestors up to (but not including) @root, is below the normal range.
+ * Returns %true if memory consumption of @memcg, or any of its ancestors
+ * up to (but not including) @root, is below the normal range.
  *
  * @root is exclusive; it is never low when looked at directly and isn't
  * checked when traversing the hierarchy.
@@ -5379,12 +5379,12 @@ bool mem_cgroup_low(struct mem_cgroup *root, struct mem_cgroup *memcg)
 	if (memcg == root)
 		return false;
 
+	/* If any level is under, then protect @memcg from reclaim */
 	for (; memcg != root; memcg = parent_mem_cgroup(memcg)) {
-		if (page_counter_read(&memcg->memory) >= memcg->low)
-			return false;
+		if (page_counter_read(&memcg->memory) <= memcg->low)
+			return true; /* protect from reclaim */
 	}
-
-	return true;
+	return false; /* not protected from reclaim */
 }
 
 /**
-- 
2.17.0.484.g0c8726318c-goog

