From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH][3.11] cpuset: fix the return value of cpuset_write_u64()
Date: Tue, 13 Aug 2013 10:05:59 +0800
Message-ID: <52099487.8010601@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Writing to this file always returns -ENODEV:

  # echo 1 > cpuset.memory_pressure_enabled
  -bash: echo: write error: No such device

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.9+
---
 kernel/cpuset.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 1b9c315..c602ab8 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1607,11 +1607,13 @@ static int cpuset_write_u64(struct cgroup *cgrp, struct cftype *cft, u64 val)
 {
 	struct cpuset *cs = cgroup_cs(cgrp);
 	cpuset_filetype_t type = cft->private;
-	int retval = -ENODEV;
+	int retval = 0;
 
 	mutex_lock(&cpuset_mutex);
-	if (!is_cpuset_online(cs))
+	if (!is_cpuset_online(cs)) {
+		retval = -ENODEV;
 		goto out_unlock;
+	}
 
 	switch (type) {
 	case FILE_CPU_EXCLUSIVE:
-- 
1.8.0.2
