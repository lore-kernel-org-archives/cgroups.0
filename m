From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH -V9 11/15] hugetlb/cgroup: Add charge/uncharge routines for hugetlb cgroup
Date: Fri, 15 Jun 2012 15:36:10 +0530
Message-ID: <87k3z8nb3h.fsf@skywalker.in.ibm.com>
References: <1339583254-895-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339583254-895-12-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120614092539.GI27397@tiehlicka.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120614092539.GI27397-VqjxzfR4DlwKmadIfiO5sKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> writes:

> On Wed 13-06-12 15:57:30, Aneesh Kumar K.V wrote:
>> From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> 
>> This patchset add the charge and uncharge routines for hugetlb cgroup.
>> We do cgroup charging in page alloc and uncharge in compound page
>> destructor. Assigning page's hugetlb cgroup is protected by hugetlb_lock.
>> 
>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>
> Reviewed-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
>
> One minor comment
> [...]
>> +void hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
>> +				  struct hugetlb_cgroup *h_cg,
>> +				  struct page *page)
>> +{
>> +	if (hugetlb_cgroup_disabled() || !h_cg)
>> +		return;
>> +
>> +	spin_lock(&hugetlb_lock);
>> +	set_hugetlb_cgroup(page, h_cg);
>> +	spin_unlock(&hugetlb_lock);
>> +	return;
>> +}
>
> I guess we can remove the lock here because nobody can see the page yet,
> right?
>

We need that to make sure when we remove cgroup we find correct page
hugetlb cgroup values. But i guess we have a bug here. How about the
below ?

NOTE: We also need another patch to update active list during soft
offline. I will send that in reply.

commit e4c3fd3cc0f0faa30ea283cb48ba478a5c0d3e74
Author: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Date:   Fri Jun 15 14:42:27 2012 +0530

    hugetlb/cgroup: Assign the page hugetlb cgroup when we move the page to active list.
    
    page's hugetlb cgroup assign and moving to active list should happen with
    hugetlb_lock held. Otherwise when we remove the hugetlb cgroup we would
    iterate the active list and will find page with NULL hugetlb cgroup values.
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ee4da3b..b90dfb4 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1146,9 +1146,12 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 	}
 	spin_lock(&hugetlb_lock);
 	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve);
-	spin_unlock(&hugetlb_lock);
-
-	if (!page) {
+	if (page) {
+		/* update page cgroup details */
+		hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, page);
+		spin_unlock(&hugetlb_lock);
+	} else {
+		spin_unlock(&hugetlb_lock);
 		page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
 		if (!page) {
 			hugetlb_cgroup_uncharge_cgroup(idx,
@@ -1159,14 +1162,13 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 		}
 		spin_lock(&hugetlb_lock);
 		list_move(&page->lru, &h->hugepage_activelist);
+		hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, page);
 		spin_unlock(&hugetlb_lock);
 	}
 
 	set_page_private(page, (unsigned long)spool);
 
 	vma_commit_reservation(h, vma, addr);
-	/* update page cgroup details */
-	hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, page);
 	return page;
 }
 
diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index 8e7ca0a..d4f3f7b 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -218,6 +218,7 @@ done:
 	return ret;
 }
 
+/* Should be called with hugetlb_lock held */
 void hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
 				  struct hugetlb_cgroup *h_cg,
 				  struct page *page)
@@ -225,9 +226,7 @@ void hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
 	if (hugetlb_cgroup_disabled() || !h_cg)
 		return;
 
-	spin_lock(&hugetlb_lock);
 	set_hugetlb_cgroup(page, h_cg);
-	spin_unlock(&hugetlb_lock);
 	return;
 }
 
