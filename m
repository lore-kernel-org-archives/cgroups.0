From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 7/8] hugetlb: do not fail in hugetlb_cgroup_pre_destroy
Date: Wed, 31 Oct 2012 11:16:30 -0700
Message-ID: <1351707391-22287-8-git-send-email-tj@kernel.org>
References: <1351707391-22287-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=lk34HbgjWydRlrGkyhUV1jNQuMv3OsDTd5wK9Kow7/8=;
        b=PX6feaa7NZIK6JR9u3WiZGOX7zGjTeM97bMfYVGijpWRvcrsql5vasvQSfTW1Qa4/Y
         wzBDvMwGKhrvYAo136+t/PXT2eWVsQpzdTNbKEU8vAbBcFIfk2hJGyItuvv/VN9ReXqH
         p0BoyNMdik4+KGe7VyarGAmT7AsEAz2aNt19UFC+Z0jZkdQJR9VtfaJGXvGl7iLhHqF+
         AidN0Q/uPlw7hqhHoiZmp3I+qrhZhWN4mX2WylOOedrTRzFGhSPg4RUYHVou+rcfzA/M
         +JP152S6YEN+MF+7Potd3KOFRVT9SKfvzCnSSt87trtPaBQNe+4hj/eZciHMr804MPlf
         HZpg==
In-Reply-To: <1351707391-22287-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

Now that pre_destroy callbacks are called from the context where neither
any task can attach the group nor any children group can be added there
is no other way to fail from hugetlb_pre_destroy.

Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Reviewed-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reviewed-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 mm/hugetlb_cgroup.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index a3f358f..dc595c6 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -159,14 +159,9 @@ static int hugetlb_cgroup_pre_destroy(struct cgroup *cgroup)
 {
 	struct hstate *h;
 	struct page *page;
-	int ret = 0, idx = 0;
+	int idx = 0;
 
 	do {
-		if (cgroup_task_count(cgroup) ||
-		    !list_empty(&cgroup->children)) {
-			ret = -EBUSY;
-			goto out;
-		}
 		for_each_hstate(h) {
 			spin_lock(&hugetlb_lock);
 			list_for_each_entry(page, &h->hugepage_activelist, lru)
@@ -177,8 +172,8 @@ static int hugetlb_cgroup_pre_destroy(struct cgroup *cgroup)
 		}
 		cond_resched();
 	} while (hugetlb_cgroup_have_usage(cgroup));
-out:
-	return ret;
+
+	return 0;
 }
 
 int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
-- 
1.7.11.7
