From: Shakeel Butt <shakeelb@google.com>
Subject: [PATCH] mm: memcg: expose mem_cgroup_put API
Date: Wed,  7 Mar 2018 18:48:50 -0800
Message-ID: <20180308024850.39737-1-shakeelb@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=dLauWtxjF5Rad+8FslU9jZFF2sc/hz5VoS3D7/2wSsM=;
        b=iVTR+VEwS0YYkvEGOnnjJqHu0gtdsDt32saKA3j8poJ1Vv7zr+vTnaxBM7x9stuXNl
         8LjYx1Rf4nYfoLhaycvCqED7XIDXhcqbV5t/4eTWlTNrPPuRNhBs0g1KC+l0k6xzYUDW
         Wnro6S97FjJAXsycbP9eqehgVn4/6plrJxH98sva30o7aRVfYPBRV7G9cmKXCtfYLGw9
         aEOfzI/r8NOVvy27/C9ADM1oq7Qm8jGFbSlj+gywLnhDlt5oR2zxPwniO+DHhls5G235
         9sm/GPA7GO4KOFHJ5P19IVwj5XtQrX8GoreOub5SU3+o9To7iGc3KTD4tfp9pUqGgitt
         4DaA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@kernel.org>, Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Shakeel Butt <shakeelb@google.com>

This patch exports mem_cgroup_put API to put the refcnt of the memory
cgroup.

Signed-off-by: Shakeel Butt <shakeelb@google.com>
---
 include/linux/memcontrol.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index c46016bb25eb..0da79e116a07 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -344,6 +344,11 @@ struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state *css){
 	return css ? container_of(css, struct mem_cgroup, css) : NULL;
 }
 
+static inline void mem_cgroup_put(struct mem_cgroup *memcg)
+{
+	css_put(&memcg->css);
+}
+
 #define mem_cgroup_from_counter(counter, member)	\
 	container_of(counter, struct mem_cgroup, member)
 
@@ -789,6 +794,10 @@ static inline bool task_in_mem_cgroup(struct task_struct *task,
 	return true;
 }
 
+static inline void mem_cgroup_put(struct mem_cgroup *memcg)
+{
+}
+
 static inline struct mem_cgroup *
 mem_cgroup_iter(struct mem_cgroup *root,
 		struct mem_cgroup *prev,
-- 
2.16.2.395.g2e18187dfd-goog

