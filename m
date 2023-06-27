From: Miaohe Lin <linmiaohe@huawei.com>
Subject: [PATCH] cgroup: fix obsolete comment above for_each_css()
Date: Tue, 27 Jun 2023 19:40:59 +0800
Message-ID: <20230627114059.1310936-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, hannes@cmpxchg.org, lizefan.x@bytedance.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linmiaohe@huawei.com

cgroup_tree_mutex is removed since commit 8353da1f91f1 ("cgroup: remove
cgroup_tree_mutex"), update corresponding comment.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 4d42f0cbc11e..a6238958fe0b 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -680,7 +680,7 @@ EXPORT_SYMBOL_GPL(of_css);
  * @ssid: the index of the subsystem, CGROUP_SUBSYS_COUNT after reaching the end
  * @cgrp: the target cgroup to iterate css's of
  *
- * Should be called under cgroup_[tree_]mutex.
+ * Should be called under cgroup_mutex.
  */
 #define for_each_css(css, ssid, cgrp)					\
 	for ((ssid) = 0; (ssid) < CGROUP_SUBSYS_COUNT; (ssid)++)	\
-- 
2.27.0

