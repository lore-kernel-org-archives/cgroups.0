From: Chen Baozi <baozich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] memcg: remove the unnecessary MEM_CGROUP_STAT_DATA
Date: Fri, 25 May 2012 16:11:41 +0800
Message-ID: <1337933501-3985-1-git-send-email-baozich@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=um+alovj/1r5dgxOia/0U6YpWD0HnFdKUPxyrFr65GY=;
        b=ZrOAYZJRfpFtt1ROpZ+eNPidAz7zRJ9Aw5dLEOg5uqxnQWjgldDkXS0YcT6nKp9kON
         AmQy42gRUfLirzFwweninXOcf0mnvU+yc6VCac1zzpNv9+sqxVZBzVLDIa0Akyif2ERK
         R2+lyAEkhDXl4RgXOG96OL45YWnq/JSNbBskegZNI4gIZ7eahZsbpRXd0yuGWcTDamor
         PeVj82yGexqIFFpqV2WQwv4s6jDH7CcUgrdBwzddOlJ/I1x24nYPjAyyUxiTHRxNnGEu
         VLf5ffAFPFb+iUYr7Uk6YYGc1FLY2MdRrBiDguvFe+JQV/gkwdNSZOTVWEmTWNDqDWT/
         C+Zw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Chen Baozi <baozich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Since MEM_CGROUP_ON_MOVE has been removed, it comes to be redudant
to hold MEM_CGROUP_STAT_DATA to mark the end of data requires
synchronization.

Signed-off-by: Chen Baozi <baozich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mm/memcontrol.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f342778..446ca94 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -88,7 +88,6 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_RSS,	   /* # of pages charged as anon rss */
 	MEM_CGROUP_STAT_FILE_MAPPED,  /* # of pages charged as file rss */
 	MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
-	MEM_CGROUP_STAT_DATA, /* end of data requires synchronization */
 	MEM_CGROUP_STAT_NSTATS,
 };
 
@@ -2139,7 +2138,7 @@ static void mem_cgroup_drain_pcp_counter(struct mem_cgroup *memcg, int cpu)
 	int i;
 
 	spin_lock(&memcg->pcp_counter_lock);
-	for (i = 0; i < MEM_CGROUP_STAT_DATA; i++) {
+	for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
 		long x = per_cpu(memcg->stat->count[i], cpu);
 
 		per_cpu(memcg->stat->count[i], cpu) = 0;
-- 
1.7.1
