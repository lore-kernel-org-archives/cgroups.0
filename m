From: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v11 7/9] hugetlb: support file_region coalescing again
Date: Mon,  3 Feb 2020 15:22:46 -0800
Message-ID: <20200203232248.104733-7-almasrymina@google.com>
References: <20200203232248.104733-1-almasrymina@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=AAnnuPr/HPGLn+hB/1uqyzxSnBEz8gxTGjNzCNKjlS0=;
        b=YkgvUjOhEnSOR192jl1bKhbfajQljLIUBasKGgoyrMqoBix5dJvEkT/w2gCbif5WQg
         AxALwxZVORapq4E2odlv0R7fR5oDwsdOtA4u60L4ddNBtTyyNtEO02kYWzB4r2Sp7dvS
         yNv6hQnHsomyne2JwoZvzi4fAPIq5CJfZ/x6ZOmmbQsm8DUB9YTqi16x2upBDlR9mamg
         HVGabJAx3mW4ia2vc/uNw+qQ6nXSFvrWYIvNMb/ucRE1rZmjK8JozF3Sd+61ODjhFdVq
         Mehl/BIchmECuN2gfIXQtg+NWrrITCnPqrRsQiwIJLD19ZWvKOZjDW0cITiMBcAX89oU
         iAEw==
In-Reply-To: <20200203232248.104733-1-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

An earlier patch in this series disabled file_region coalescing in order
to hang the hugetlb_cgroup uncharge info on the file_region entries.

This patch re-adds support for coalescing of file_region entries.
Essentially everytime we add an entry, we check to see if the
hugetlb_cgroup uncharge info is the same as any adjacent entries. If it
is, instead of adding an entry we simply extend the appropriate entry.

This is an important performance optimization as private mappings add
their entries page by page, and we could incur big performance costs for
large mappings with lots of file_region entries in their resv_map.

Signed-off-by: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

---
 mm/hugetlb.c | 62 +++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 52 insertions(+), 10 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ec0b55ea1506e..058dd9c8269cf 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -272,6 +272,22 @@ static void record_hugetlb_cgroup_uncharge_info(struct hugetlb_cgroup *h_cg,
 #endif
 }

+static bool has_same_uncharge_info(struct file_region *rg,
+				   struct hugetlb_cgroup *h_cg,
+				   struct hstate *h)
+{
+#ifdef CONFIG_CGROUP_HUGETLB
+	return rg &&
+	       rg->reservation_counter ==
+		       &h_cg->rsvd_hugepage[hstate_index(h)] &&
+	       rg->pages_per_hpage == pages_per_huge_page(h) &&
+	       rg->css == &h_cg->css;
+
+#else
+	return true;
+#endif
+}
+
 /* Must be called with resv->lock held. Calling this with count_only == true
  * will count the number of pages to be added but will not modify the linked
  * list. If regions_needed != NULL and count_only == true, then regions_needed
@@ -286,7 +302,7 @@ static long add_reservation_in_range(struct resv_map *resv, long f, long t,
 	long add = 0;
 	struct list_head *head = &resv->regions;
 	long last_accounted_offset = f;
-	struct file_region *rg = NULL, *trg = NULL, *nrg = NULL;
+	struct file_region *rg = NULL, *trg = NULL, *nrg = NULL, *prg = NULL;

 	if (regions_needed)
 		*regions_needed = 0;
@@ -318,16 +334,34 @@ static long add_reservation_in_range(struct resv_map *resv, long f, long t,
 		if (rg->from > last_accounted_offset) {
 			add += rg->from - last_accounted_offset;
 			if (!count_only) {
-				nrg = get_file_region_entry_from_cache(
-					resv, last_accounted_offset, rg->from);
-				record_hugetlb_cgroup_uncharge_info(h_cg, nrg,
-								    h);
-				list_add(&nrg->link, rg->link.prev);
+				/* Check if the last region can be extended. */
+				if (prg && prg->to == last_accounted_offset &&
+				    has_same_uncharge_info(prg, h_cg, h)) {
+					prg->to = rg->from;
+				/* Check if the next region can be extended. */
+				} else if (has_same_uncharge_info(rg, h_cg,
+								  h)) {
+					rg->from = last_accounted_offset;
+				/* If neither of the regions can be extended,
+				 * add a region.
+				 */
+				} else {
+					nrg = get_file_region_entry_from_cache(
+						resv, last_accounted_offset,
+						rg->from);
+					record_hugetlb_cgroup_uncharge_info(
+						h_cg, nrg, h);
+					list_add(&nrg->link, rg->link.prev);
+				}
 			} else if (regions_needed)
 				*regions_needed += 1;
 		}

 		last_accounted_offset = rg->to;
+		/* Record rg as the 'previous file region' incase we need it
+		 * for the next iteration.
+		 */
+		prg = rg;
 	}

 	/* Handle the case where our range extends beyond
@@ -336,10 +370,18 @@ static long add_reservation_in_range(struct resv_map *resv, long f, long t,
 	if (last_accounted_offset < t) {
 		add += t - last_accounted_offset;
 		if (!count_only) {
-			nrg = get_file_region_entry_from_cache(
-				resv, last_accounted_offset, t);
-			record_hugetlb_cgroup_uncharge_info(h_cg, nrg, h);
-			list_add(&nrg->link, rg->link.prev);
+			/* Check if the last region can be extended. */
+			if (prg && prg->to == last_accounted_offset &&
+			    has_same_uncharge_info(prg, h_cg, h)) {
+				prg->to = last_accounted_offset;
+			} else {
+				/* If not, just create a new region. */
+				nrg = get_file_region_entry_from_cache(
+					resv, last_accounted_offset, t);
+				record_hugetlb_cgroup_uncharge_info(h_cg, nrg,
+								    h);
+				list_add(&nrg->link, rg->link.prev);
+			}
 		} else if (regions_needed)
 			*regions_needed += 1;
 	}
