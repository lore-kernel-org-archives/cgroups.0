From: Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] mm: memcg: export workingset refault stats for cgroup v1
Date: Tue, 16 Aug 2022 11:58:01 -0700
Message-ID: <20220816185801.651091-1-shy828301@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=CzN9U8S3U5wsu3LqNuDxk2kPbUdDS4xzFtJt6PkLgao=;
        b=nEJGoYq9tv3G9+Ot3Wzbzv5hIglYLNiZQq9ZXoTqRMxHgwM8D52w9VWUrDhl3opKDD
         5oF/RI5eAvBaSJMsNaQ0q0kQCgisTMna3oT0Irfh5bOmrLnOKEftArR+a3ajnYK0gITF
         neIIREcQfSomM34o4HRxg4bKaH7isikWJMKJhysVdM7jxIOpLd8JHWGZWZMWeL+QFgQ6
         DfF9Dw6+rZWkljsnOwhdmsIhKU5wEUYGvU+RRxCm65xnOZLkqRd8OZlYjKrFAxwIuIEw
         vR/7Doj33/N+i0VuS+A/XMWQM1Kb3PZCb2sPBXCaOvEOgR/hZn5Ym/gWX/YAvkobcigl
         i02w==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Workingset refault stats are important and usefule metrics to measure
how well reclaimer and swapping work and how healthy the services are,
but they are just available for cgroup v2.  There are still plenty users
with cgroup v1, export the stats for cgroup v1.

Signed-off-by: Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
I do understand the development of cgroup v1 is actually stalled and
the community is reluctant to accept new features for v1.  However
the workingset refault stats are really quite useful and exporting
two new stats, which have been supported by v2, seems ok IMHO.  So
hopefully this patch could be considered.  Thanks.

 mm/memcontrol.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b69979c9ced5..e300437896dc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3975,6 +3975,8 @@ static const unsigned int memcg1_stats[] = {
 	NR_FILE_MAPPED,
 	NR_FILE_DIRTY,
 	NR_WRITEBACK,
+	WORKINGSET_REFAULT_ANON,
+	WORKINGSET_REFAULT_FILE,
 	MEMCG_SWAP,
 };
 
@@ -3988,6 +3990,8 @@ static const char *const memcg1_stat_names[] = {
 	"mapped_file",
 	"dirty",
 	"writeback",
+	"workingset_refault_anon",
+	"workingset_refault_file",
 	"swap",
 };
 
@@ -4016,7 +4020,8 @@ static int memcg_stat_show(struct seq_file *m, void *v)
 		if (memcg1_stats[i] == MEMCG_SWAP && !do_memsw_account())
 			continue;
 		nr = memcg_page_state_local(memcg, memcg1_stats[i]);
-		seq_printf(m, "%s %lu\n", memcg1_stat_names[i], nr * PAGE_SIZE);
+		seq_printf(m, "%s %lu\n", memcg1_stat_names[i],
+			   nr * memcg_page_state_unit(memcg1_stats[i]));
 	}
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++)
@@ -4047,7 +4052,7 @@ static int memcg_stat_show(struct seq_file *m, void *v)
 			continue;
 		nr = memcg_page_state(memcg, memcg1_stats[i]);
 		seq_printf(m, "total_%s %llu\n", memcg1_stat_names[i],
-						(u64)nr * PAGE_SIZE);
+			   (u64)nr * memcg_page_state_unit(memcg1_stats[i]));
 	}
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++)
-- 
2.26.3

