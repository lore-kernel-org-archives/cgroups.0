From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: minor cleanup for cgroup_extra_stat_show()
Date: Thu, 6 Jul 2023 17:42:42 +0800
Message-ID: <20230706094242.1707709-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Make it under CONFIG_CGROUP_SCHED to rid of __maybe_unused annotation.
And further fetch cgrp inside cgroup_extra_stat_show() directly to rid
of __maybe_unused annotation of cgrp. No functional change intended.

Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index bfe3cd8ccf36..b990eda6b3cd 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3654,9 +3654,10 @@ static int cgroup_stat_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static int __maybe_unused cgroup_extra_stat_show(struct seq_file *seq,
-						 struct cgroup *cgrp, int ssid)
+#ifdef CONFIG_CGROUP_SCHED
+static int cgroup_extra_stat_show(struct seq_file *seq, int ssid)
 {
+	struct cgroup *cgrp = seq_css(seq)->cgroup;
 	struct cgroup_subsys *ss = cgroup_subsys[ssid];
 	struct cgroup_subsys_state *css;
 	int ret;
@@ -3672,15 +3673,15 @@ static int __maybe_unused cgroup_extra_stat_show(struct seq_file *seq,
 	css_put(css);
 	return ret;
 }
+#endif
 
 static int cpu_stat_show(struct seq_file *seq, void *v)
 {
-	struct cgroup __maybe_unused *cgrp = seq_css(seq)->cgroup;
 	int ret = 0;
 
 	cgroup_base_stat_cputime_show(seq);
 #ifdef CONFIG_CGROUP_SCHED
-	ret = cgroup_extra_stat_show(seq, cgrp, cpu_cgrp_id);
+	ret = cgroup_extra_stat_show(seq, cpu_cgrp_id);
 #endif
 	return ret;
 }
-- 
2.33.0

