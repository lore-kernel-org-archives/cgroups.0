From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V7 13/14] hugetlb: migrate hugetlb cgroup info from oldpage to new page during migration
Date: Wed, 30 May 2012 20:08:58 +0530
Message-ID: <1338388739-22919-14-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1338388739-22919-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1338388739-22919-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com, rientjes@google.com, mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Andrea Arcangeli <aarcange@redhat.com>

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

With HugeTLB pages, hugetlb cgroup is uncharged in compound page destructor.  Since
we are holding a hugepage reference, we can be sure that old page won't
get uncharged till the last put_page().  On successful migrate, we can
move the memcg information to new page's page_cgroup and mark the old
page's page_cgroup unused.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/hugetlb_cgroup.h |    8 ++++++++
 mm/hugetlb_cgroup.c            |   30 ++++++++++++++++++++++++++++++
 mm/migrate.c                   |    5 +++++
 3 files changed, 43 insertions(+)

diff --git a/include/linux/hugetlb_cgroup.h b/include/linux/hugetlb_cgroup.h
index fbf8c5f..387cbd6 100644
--- a/include/linux/hugetlb_cgroup.h
+++ b/include/linux/hugetlb_cgroup.h
@@ -43,6 +43,8 @@ extern void hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
 extern void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
 					   struct hugetlb_cgroup *h_cg);
 extern int hugetlb_cgroup_file_init(int idx) __init;
+extern void hugetlb_cgroup_migrate(struct page *oldhpage,
+				   struct page *newhpage);
 #else
 static inline bool hugetlb_cgroup_disabled(void)
 {
@@ -81,5 +83,11 @@ static inline int __init hugetlb_cgroup_file_init(int idx)
 {
 	return 0;
 }
+
+static inline void hugetlb_cgroup_migrate(struct page *oldhpage,
+					  struct page *newhpage)
+{
+	return;
+}
 #endif  /* CONFIG_MEM_RES_CTLR_HUGETLB */
 #endif
diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index 49a3f20..f99007b 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -401,6 +401,36 @@ int __init hugetlb_cgroup_file_init(int idx)
 	return 0;
 }
 
+void hugetlb_cgroup_migrate(struct page *oldhpage, struct page *newhpage)
+{
+	struct cgroup *cg;
+	struct page_cgroup *pc;
+	struct hugetlb_cgroup *h_cg;
+
+	VM_BUG_ON(!PageHuge(oldhpage));
+
+	if (hugetlb_cgroup_disabled())
+		return;
+
+	pc = lookup_page_cgroup(oldhpage);
+	lock_page_cgroup(pc);
+	cg = pc->cgroup;
+	h_cg = hugetlb_cgroup_from_cgroup(cg);
+	pc->cgroup = root_h_cgroup->css.cgroup;
+	ClearPageCgroupUsed(pc);
+	cgroup_exclude_rmdir(&h_cg->css);
+	unlock_page_cgroup(pc);
+
+	/* move the h_cg details to new cgroup */
+	pc = lookup_page_cgroup(newhpage);
+	lock_page_cgroup(pc);
+	pc->cgroup = cg;
+	SetPageCgroupUsed(pc);
+	unlock_page_cgroup(pc);
+	cgroup_release_and_wakeup_rmdir(&h_cg->css);
+	return;
+}
+
 struct cgroup_subsys hugetlb_subsys = {
 	.name = "hugetlb",
 	.create     = hugetlb_cgroup_create,
diff --git a/mm/migrate.c b/mm/migrate.c
index 927254c..22f414f 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -33,6 +33,7 @@
 #include <linux/memcontrol.h>
 #include <linux/syscalls.h>
 #include <linux/hugetlb.h>
+#include <linux/hugetlb_cgroup.h>
 #include <linux/gfp.h>
 
 #include <asm/tlbflush.h>
@@ -928,6 +929,10 @@ static int unmap_and_move_huge_page(new_page_t get_new_page,
 
 	if (anon_vma)
 		put_anon_vma(anon_vma);
+
+	if (!rc)
+		hugetlb_cgroup_migrate(hpage, new_hpage);
+
 	unlock_page(hpage);
 out:
 	put_page(new_hpage);
-- 
1.7.10

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
