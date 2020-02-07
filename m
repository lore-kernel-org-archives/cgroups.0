From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH v2 2/3] mm: Charge active memcg when no mm is set
Date: Fri, 7 Feb 2020 21:18:07 +0000
Message-ID: <20200207211807.GA138184@chrisdown.name>
References: <cover.1581088326.git.dschatzberg@fb.com>
 <8e41630b9d1c5d00f92a00f998285fa6003af5eb.1581088326.git.dschatzberg@fb.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=s3/+t3C/iGaUgSEBBn4UBiEXAA3Z2xiPjiTjCVmDGl8=;
        b=GfoGaC+/D2IbhwLnfJa3biAe5iPkr+OuRXLKcIZgOZFgYGtGR/dc32KDVeiUu1TXk0
         eWPSWbZikyLpSAEg8CB0va7Ozm1hhXJZLf0Y/bQn/fhxnQL9eZUGeWjN+xq/u9jl7qtc
         WAnaA0kz6pznkybaVC/dd561pV315aJX4mGaU=
Content-Disposition: inline
In-Reply-To: <8e41630b9d1c5d00f92a00f998285fa6003af5eb.1581088326.git.dschatzberg@fb.com>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Dan Schatzberg <dschatzberg@fb.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Thomas Gleixner <tglx@linutronix.de>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>

Dan Schatzberg writes:
>This is a dependency for 3/3

This can be omitted, since "3" won't mean anything in the change history (and 
patch series are generally considered as a unit unless there are explicit 
requests to split them out).

>memalloc_use_memcg() worked for kernel allocations but was silently
>ignored for user pages.
>
>This patch establishes a precedence order for who gets charged:
>
>1. If there is a memcg associated with the page already, that memcg is
>   charged. This happens during swapin.
>
>2. If an explicit mm is passed, mm->memcg is charged. This happens
>   during page faults, which can be triggered in remote VMs (eg gup).
>
>3. Otherwise consult the current process context. If it has configured
>   a current->active_memcg, use that. Otherwise, current->mm->memcg.
>
>Signed-off-by: Dan Schatzberg <dschatzberg@fb.com>
>Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Thanks, this seems reasonable. One (minor and optional) suggestion would be to 
make the title more clear that this is a change in 
try_charge/memalloc_use_memcg behaviour overall rather than a charge site, 
since this wasn't what I expected to find when I saw the patch title :-)

I only have one other question about behaviour when there is no active_memcg 
and mm/memcg in try_charge are NULL below, but assuming that's been checked:

Acked-by: Chris Down <chris@chrisdown.name>

>---
> mm/memcontrol.c | 11 ++++++++---
> mm/shmem.c      |  2 +-
> 2 files changed, 9 insertions(+), 4 deletions(-)
>
>diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>index f7da3ff135ed..69935d166bdb 100644
>--- a/mm/memcontrol.c
>+++ b/mm/memcontrol.c
>@@ -6812,7 +6812,8 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
>  * @compound: charge the page as compound or small page
>  *
>  * Try to charge @page to the memcg that @mm belongs to, reclaiming
>- * pages according to @gfp_mask if necessary.
>+ * pages according to @gfp_mask if necessary. If @mm is NULL, try to
>+ * charge to the active memcg.
>  *
>  * Returns 0 on success, with *@memcgp pointing to the charged memcg.
>  * Otherwise, an error code is returned.
>@@ -6856,8 +6857,12 @@ int mem_cgroup_try_charge(struct page *page, struct mm_struct *mm,
> 		}
> 	}
>
>-	if (!memcg)
>-		memcg = get_mem_cgroup_from_mm(mm);
>+	if (!memcg) {
>+		if (!mm)
>+			memcg = get_mem_cgroup_from_current();
>+		else
>+			memcg = get_mem_cgroup_from_mm(mm);
>+	}

Just to do due diligence, did we double check whether this results in any 
unintentional shift in accounting for those passing in both mm and memcg as 
NULL with no current->active_memcg set, since previously we never even tried to 
consult current->mm and always used root_mem_cgroup in get_mem_cgroup_from_mm?

It's entirely possible that this results in exactly the same outcome as before 
just by different means, but with the number of try_charge callsites I'm not 
totally certain of that.

>
> 	ret = try_charge(memcg, gfp_mask, nr_pages, false);
>
>diff --git a/mm/shmem.c b/mm/shmem.c
>index ca74ede9e40b..70aabd9aba1a 100644
>--- a/mm/shmem.c
>+++ b/mm/shmem.c
>@@ -1748,7 +1748,7 @@ static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
> 	}
>
> 	sbinfo = SHMEM_SB(inode->i_sb);
>-	charge_mm = vma ? vma->vm_mm : current->mm;
>+	charge_mm = vma ? vma->vm_mm : NULL;
>
> 	page = find_lock_entry(mapping, index);
> 	if (xa_is_value(page)) {
>--
>2.17.1
>
