From: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH] cgroup: Add cgroupstats numbers to cgroup.stat file
Date: Tue, 15 Sep 2020 23:53:49 +0800
Message-ID: <20200915155349.15181-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kU2nEMhjCVWVrMXPlsQXavcJV9QfPkKaCh123WirJUY=;
        b=fZ2zBCziQ3BDs46gAsEfUI7yxJtBST2rD1IAijko7XSzcOwptW4Ut8cyp/pKulyFN5
         Ya4+QRLBdUkedXev1V3EdJCBcWw7K2d1vm39dZMITMuBww53C+M6rM4NEoxRfDq+96Yq
         2hILdPF14cQEnz3v9ybLMFkS5pimkLRnuRTMrfCq5Hqy0KBcOcUjxpRFWbPMDZMUJqMZ
         JPJbtE/cVWhEHuZd7qbloKU9e+hR+nATFMV8pU+Rx6w1VBa40PqCN6W+dSAz4PQVeQeJ
         kt8jlvKwp4uuM6KWcCHU8nbzruP+ox0zWXUzIfgBxlatJaEpX6d7VdrCYvQraoKKotZH
         aM1g==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, luodaowen.backend-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

In the cgroup v1, we can use netlink interface to get cgroupstats for
a cgroup. But it has been excluded from cgroup v2 interface intentionally
due to the duplication and inconsistencies with other statistics.
To make container monitor tool like "cadvisor" continue to work, we add
these cgroupstats numbers to the cgroup.stat file, and change the
admin-guide doc accordingly.

Reported-by: Daowen Luo <luodaowen.backend-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Tested-by: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Signed-off-by: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst | 15 ++++++++++++++
 kernel/cgroup/cgroup.c                  | 36 +++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 6be43781ec7f..9f781edca95a 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -925,6 +925,21 @@ All cgroup core files are prefixed with "cgroup."
 		A dying cgroup can consume system resources not exceeding
 		limits, which were active at the moment of cgroup deletion.
 
+          nr_running
+                Number of tasks running.
+
+          nr_sleeping
+                Number of tasks sleeping.
+
+          nr_uninterruptible
+                Number of tasks in uninterruptible state.
+
+          nr_stopped
+                Number of tasks in stopped state.
+
+          nr_io_wait
+                Number of tasks waiting on IO.
+
   cgroup.freeze
 	A read-write single value file which exists on non-root cgroups.
 	Allowed values are "0" and "1". The default is "0".
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 0e23ae3b1e56..c6ccacaf812d 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -42,6 +42,7 @@
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
 #include <linux/sched/task.h>
+#include <linux/delayacct.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/percpu-rwsem.h>
@@ -3499,11 +3500,46 @@ static int cgroup_events_show(struct seq_file *seq, void *v)
 static int cgroup_stat_show(struct seq_file *seq, void *v)
 {
 	struct cgroup *cgroup = seq_css(seq)->cgroup;
+	struct css_task_iter it;
+	struct task_struct *tsk;
+	u64 nr_running = 0;
+	u64 nr_sleeping = 0;
+	u64 nr_uninterruptible = 0;
+	u64 nr_stopped = 0;
+	u64 nr_io_wait = 0;
+
+	css_task_iter_start(&cgroup->self, 0, &it);
+	while ((tsk = css_task_iter_next(&it))) {
+		switch (tsk->state) {
+		case TASK_RUNNING:
+			nr_running++;
+			break;
+		case TASK_INTERRUPTIBLE:
+			nr_sleeping++;
+			break;
+		case TASK_UNINTERRUPTIBLE:
+			nr_uninterruptible++;
+			break;
+		case TASK_STOPPED:
+			nr_stopped++;
+			break;
+		default:
+			if (delayacct_is_task_waiting_on_io(tsk))
+				nr_io_wait++;
+			break;
+		}
+	}
+	css_task_iter_end(&it);
 
 	seq_printf(seq, "nr_descendants %d\n",
 		   cgroup->nr_descendants);
 	seq_printf(seq, "nr_dying_descendants %d\n",
 		   cgroup->nr_dying_descendants);
+	seq_printf(seq, "nr_running %llu\n", nr_running);
+	seq_printf(seq, "nr_sleeping %llu\n", nr_sleeping);
+	seq_printf(seq, "nr_uninterruptible %llu\n", nr_uninterruptible);
+	seq_printf(seq, "nr_stopped %llu\n", nr_stopped);
+	seq_printf(seq, "nr_io_wait %llu\n", nr_io_wait);
 
 	return 0;
 }
-- 
2.11.0

