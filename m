From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH] memcg: Use scnprintf instead of sprintf
Date: Wed, 18 Apr 2012 11:45:56 +0530
Message-ID: <1334729756-10212-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <20120416161354.b967790c.akpm@linux-foundation.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120416161354.b967790c.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

This make sure we don't overflow.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 mm/memcontrol.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 519d370..0ccf934 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5269,14 +5269,14 @@ static void mem_cgroup_destroy(struct cgroup *cont)
 }
 
 #ifdef CONFIG_MEM_RES_CTLR_HUGETLB
-static char *mem_fmt(char *buf, unsigned long n)
+static char *mem_fmt(char *buf, int size, unsigned long hsize)
 {
-	if (n >= (1UL << 30))
-		sprintf(buf, "%luGB", n >> 30);
-	else if (n >= (1UL << 20))
-		sprintf(buf, "%luMB", n >> 20);
+	if (hsize >= (1UL << 30))
+		scnprintf(buf, size, "%luGB", hsize >> 30);
+	else if (hsize >= (1UL << 20))
+		scnprintf(buf, size, "%luMB", hsize >> 20);
 	else
-		sprintf(buf, "%luKB", n >> 10);
+		scnprintf(buf, size, "%luKB", hsize >> 10);
 	return buf;
 }
 
@@ -5287,7 +5287,7 @@ int __init mem_cgroup_hugetlb_file_init(int idx)
 	struct hstate *h = &hstates[idx];
 
 	/* format the size */
-	mem_fmt(buf, huge_page_size(h));
+	mem_fmt(buf, 32, huge_page_size(h));
 
 	/* Add the limit file */
 	cft = &h->mem_cgroup_files[0];
-- 
1.7.10
