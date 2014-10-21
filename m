From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch 4/4] mm: memcontrol: simplify per-memcg page statistics
 accounting
Date: Tue, 21 Oct 2014 17:05:54 -0400
Message-ID: <20141021210554.GC29116@phnom.home.cmpxchg.org>
References: <1413922896-29042-1-git-send-email-hannes@cmpxchg.org>
 <1413922896-29042-4-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1413922896-29042-4-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 04:21:36PM -0400, Johannes Weiner wrote:
> @@ -315,13 +290,13 @@ mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
>  {
>  }
>  
> -static inline void mem_cgroup_begin_update_page_stat(struct page *page,
> +static inline void mem_cgroup_begin_page_stat(struct page *page,
>  					bool *locked, unsigned long *flags)

I forgot to refresh after fixing the allnoconfig build.  Andrew could
you fold the following please if/when merging this patch?  Thanks!

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 4dc4a2aec440..ea007615e8f9 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -290,9 +290,10 @@ mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
 {
 }
 
-static inline void mem_cgroup_begin_page_stat(struct page *page,
+static inline struct mem_cgroup *mem_cgroup_begin_page_stat(struct page *page,
 					bool *locked, unsigned long *flags)
 {
+	return NULL;
 }
 
 static inline void mem_cgroup_end_page_stat(struct mem_cgroup *memcg,

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
