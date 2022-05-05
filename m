From: Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] mm/memcontrol: Export memcg->watermark via sysfs for v2 memcg
Date: Thu, 5 May 2022 05:13:30 -0700
Message-ID: <20220505121329.GA32827@us192.sjc.aristanetworks.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-A; t=1651752810;
        bh=t7IyGM1PKLvCYj6DQvv6UjWdSV7ltvFKCoW393kXRNw=;
        h=Date:From:To:Cc:Subject:From;
        b=E1j+U2hl6CofJ8uiprGDIHpGd2TFUWswYtuDc/9R27b1EB7Y69W7zoVvtRffljx5Z
         sjAYQQ0Kpsd/xuo7Tk3grwQCOvgXO4VBje31QSr4qeRkDyuL/TgSBrTvHDAByWyGmL
         piIhedVavXg/djHKPya8N8MoAAJoSqgNURHEG0NZ6V/+86tbzw2LTJrI0V/j8ZrAkE
         uNov92hP4YCmKgaktYB+WeffKims7dHVH62bxVsTXc+FiK+lfQ2jGVR8TYDjJxKL50
         8/fEfu+s+495H7MKCSyZnSFJj9QGwIbqC6BhnKFlvxq8C+2wPRHN+4EnMxYHpd5M1z
         AY2l58vGnkRDA==
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org

v1 memcg exports memcg->watermark as "memory.mem_usage_in_bytes" in
sysfs. This is missing for v2 memcg though "memory.current" is exported.
There is no other easy way of getting this information in Linux.
getrsuage() returns ru_maxrss but that's the max RSS of a single process
instead of the aggregated max RSS of all the processes. Hence, expose
memcg->watermark as "memory.watermark" for v2 memcg.

Signed-off-by: Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 725f76723220..57ed07deff3e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6098,6 +6098,14 @@ static u64 memory_current_read(struct cgroup_subsys_state *css,
 	return (u64)page_counter_read(&memcg->memory) * PAGE_SIZE;
 }
 
+static u64 memory_watermark_read(struct cgroup_subsys_state *css,
+				 struct cftype *cft)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+
+	return (u64)memcg->memory.watermark * PAGE_SIZE;
+}
+
 static int memory_min_show(struct seq_file *m, void *v)
 {
 	return seq_puts_memcg_tunable(m,
@@ -6361,6 +6369,11 @@ static struct cftype memory_files[] = {
 		.flags = CFTYPE_NOT_ON_ROOT,
 		.read_u64 = memory_current_read,
 	},
+	{
+		.name = "watermark",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.read_u64 = memory_watermark_read,
+	},
 	{
 		.name = "min",
 		.flags = CFTYPE_NOT_ON_ROOT,
-- 
2.28.0

