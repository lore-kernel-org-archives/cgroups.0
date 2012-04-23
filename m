From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH -V6 12/14] memcg: move HugeTLB resource count to parent
 cgroup on memcg removal
Date: Mon, 23 Apr 2012 15:45:37 -0700
Message-ID: <20120423154537.675d490c.akpm@linux-foundation.org>
References: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1334573091-18602-13-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1334573091-18602-13-git-send-email-aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 16 Apr 2012 16:14:49 +0530
"Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:

> This add support for memcg removal with HugeTLB resource usage.

include/linux/memcontrol.h:504: warning: 'struct cgroup' declared inside parameter list
include/linux/memcontrol.h:504: warning: its scope is only this definition or declaration, which is probably not what you want
include/linux/memcontrol.h:509: warning: 'struct cgroup' declared inside parameter list

Documentation/SubmitChecklist, section 2.  Please do these things -
what you have done here is to send untested code, for some
configuration options.


I'll try this:

 include/linux/hugetlb.h    |    6 +-----
 include/linux/memcontrol.h |   11 -----------
 2 files changed, 1 insertion(+), 16 deletions(-)

--- a/include/linux/memcontrol.h~memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix
+++ a/include/linux/memcontrol.h
@@ -499,17 +499,6 @@ static inline int mem_cgroup_hugetlb_fil
 	return 0;
 }
 
-static inline int
-mem_cgroup_move_hugetlb_parent(int idx, struct cgroup *cgroup,
-			       struct page *page)
-{
-	return 0;
-}
-
-static inline bool mem_cgroup_have_hugetlb_usage(struct cgroup *cgroup)
-{
-	return 0;
-}
 #endif  /* CONFIG_MEM_RES_CTLR_HUGETLB */
 #endif /* _LINUX_MEMCONTROL_H */
 
--- a/include/linux/hugetlb.h~memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix
+++ a/include/linux/hugetlb.h
@@ -337,10 +337,6 @@ static inline unsigned int pages_per_hug
 
 #ifdef CONFIG_MEM_RES_CTLR_HUGETLB
 extern int hugetlb_force_memcg_empty(struct cgroup *cgroup);
-#else
-static inline int hugetlb_force_memcg_empty(struct cgroup *cgroup)
-{
-	return 0;
-}
 #endif
+
 #endif /* _LINUX_HUGETLB_H */
_
 

We shouldn't be calling these functions if CONFIG_MEM_RES_CTLR_HUGETLB=n?
