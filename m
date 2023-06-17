From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: remove obsolete comment on cgroup_on_dfl()
Date: Sat, 17 Jun 2023 15:48:09 +0800
Message-ID: <20230617074809.1929778-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

The debug feature is supported since commit 8cc38fa7fa31 ("cgroup: make
debug an implicit controller on cgroup2"), update corresponding comment.

Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index cd497b90e11a..bfe3cd8ccf36 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -313,8 +313,6 @@ bool cgroup_ssid_enabled(int ssid)
  *   masks of ancestors.
  *
  * - blkcg: blk-throttle becomes properly hierarchical.
- *
- * - debug: disallowed on the default hierarchy.
  */
 bool cgroup_on_dfl(const struct cgroup *cgrp)
 {
-- 
2.27.0

