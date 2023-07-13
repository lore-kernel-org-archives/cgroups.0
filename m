From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: remove obsolete comment above struct cgroupstats
Date: Thu, 13 Jul 2023 19:59:38 +0800
Message-ID: <20230713115938.177428-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

There's no flag in the delay accounting structure indicates that the task
is waiting on IO since commit 1193829da1a6 ("delayacct: cleanup flags in
struct task_delay_info and functions use it"). So remove the comment.

Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 include/uapi/linux/cgroupstats.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/uapi/linux/cgroupstats.h b/include/uapi/linux/cgroupstats.h
index aa306e4cd6c1..80b2c8594480 100644
--- a/include/uapi/linux/cgroupstats.h
+++ b/include/uapi/linux/cgroupstats.h
@@ -24,8 +24,6 @@
  * basis. This data is shared using taskstats.
  *
  * Most of these states are derived by looking at the task->state value
- * For the nr_io_wait state, a flag in the delay accounting structure
- * indicates that the task is waiting on IO
  *
  * Each member is aligned to a 8 byte boundary.
  */
-- 
2.33.0

