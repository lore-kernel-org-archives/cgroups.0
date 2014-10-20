From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch] mm: memcontrol: micro-optimize
 mem_cgroup_update_page_stat()
Date: Mon, 20 Oct 2014 20:59:44 +0200
Message-ID: <20141020185944.GC505@dhcp22.suse.cz>
References: <1413818259-10913-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=+l2Ipaq89fV72Cj2+ZiSnSO9KzP0bFrrQR5WsfMThHU=;
        b=ZmG5RTw6B6Ax1bpcVV+pVnCkrPkW2m8GizsVPMi/MgvrwMK+JNBMnlOVISqvPGNIVM
         8U37U1JWYiAtDWwAWoSoUNw60Y53jDeC7HTqxMn+8rWZ73ZXoQO58UDgVodHyHRDWwzD
         IGDaiSEeCcXtUrhHYRARmDVEvFoBkIAC49eel0SUeXv+gWW6vS8e6LhzjkV0iy/5Sdx3
         v4B0veiLd07MfdRvogzIjUI4DOJ4kL8yHrJ9FxqH9Pt8AjqUZfvitMbBt+meShJdxgIE
         KWeZGUD+L/4gQV7PA6mzcvLndKuvQwN4lU7+GZZ6Q9QbFWbtlGsocnWJItDbFRwb1xIr
         zWTQ==
Content-Disposition: inline
In-Reply-To: <1413818259-10913-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon 20-10-14 11:17:39, Johannes Weiner wrote:
> Do not look up the page_cgroup when the memory controller is
> runtime-disabled, but do assert that the locking protocol is followed
> under DEBUG_VM regardless.  Also remove the unused flags variable.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Michal Hocko <mhocko@suse.cz>

mem_cgroup_split_huge_fixup is following the same pattern and might be
folded into this one. I can send a separate patch if you prefer, though.
---
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3a203c7ec6c7..544e32292c7f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3167,7 +3167,7 @@ static inline void memcg_unregister_all_caches(struct mem_cgroup *memcg)
  */
 void mem_cgroup_split_huge_fixup(struct page *head)
 {
-	struct page_cgroup *head_pc = lookup_page_cgroup(head);
+	struct page_cgroup *head_pc;
 	struct page_cgroup *pc;
 	struct mem_cgroup *memcg;
 	int i;
@@ -3175,6 +3175,8 @@ void mem_cgroup_split_huge_fixup(struct page *head)
 	if (mem_cgroup_disabled())
 		return;
 
+	head_pc = lookup_page_cgroup(head);
+
 	memcg = head_pc->mem_cgroup;
 	for (i = 1; i < HPAGE_PMD_NR; i++) {
 		pc = head_pc + i;
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
