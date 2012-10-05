From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [patch 2/2] mm: memcg: clean up mm_match_cgroup() signature
Date: Fri, 5 Oct 2012 13:53:36 -0700
Message-ID: <20121005135336.1ee7082f.akpm@linux-foundation.org>
References: <1349374157-20604-1-git-send-email-hannes@cmpxchg.org>
	<1349374157-20604-3-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1349374157-20604-3-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu,  4 Oct 2012 14:09:17 -0400
Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:

> It really should return a boolean for match/no match.  And since it
> takes a memcg, not a cgroup, fix that parameter name as well.
> 
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -84,14 +84,14 @@ extern struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg);
>  extern struct mem_cgroup *mem_cgroup_from_cont(struct cgroup *cont);
>  
>  static inline
> -int mm_match_cgroup(const struct mm_struct *mm, const struct mem_cgroup *cgroup)
> +bool mm_match_cgroup(const struct mm_struct *mm, const struct mem_cgroup *memcg)
>  {
> -	struct mem_cgroup *memcg;
> -	int match;
> +	struct mem_cgroup *task_memcg;
> +	bool match;
>  
>  	rcu_read_lock();
> -	memcg = mem_cgroup_from_task(rcu_dereference((mm)->owner));
> -	match = memcg && __mem_cgroup_same_or_subtree(cgroup, memcg);
> +	task_memcg = mem_cgroup_from_task(rcu_dereference((mm)->owner));
> +	match = task_memcg && __mem_cgroup_same_or_subtree(memcg, task_memcg);
>  	rcu_read_unlock();
>  	return match;
>  }

This needed massaging after droppage of your [1/2]:



From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: mm: memcg: clean up mm_match_cgroup() signature

It really should return a boolean for match/no match.  And since it
takes a memcg, not a cgroup, fix that parameter name as well.

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
---
 1 file changed, 7 insertions(+), 7 deletions(-)

index 8686294..7698182 100644
Signed-off-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
---

 include/linux/memcontrol.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcg-clean-up-mm_match_cgroup-signature include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcg-clean-up-mm_match_cgroup-signature
+++ a/include/linux/memcontrol.h
@@ -84,13 +84,13 @@ extern struct mem_cgroup *parent_mem_cgr
 extern struct mem_cgroup *mem_cgroup_from_cont(struct cgroup *cont);
 
 static inline
-int mm_match_cgroup(const struct mm_struct *mm, const struct mem_cgroup *cgroup)
+bool mm_match_cgroup(const struct mm_struct *mm, const struct mem_cgroup *memcg)
 {
-	struct mem_cgroup *memcg;
-	int match;
+	struct mem_cgroup *task_memcg;
+	bool match;
 
 	rcu_read_lock();
-	memcg = mem_cgroup_from_task(rcu_dereference((mm)->owner));
+	task_memcg = mem_cgroup_from_task(rcu_dereference((mm)->owner));
 	match = __mem_cgroup_same_or_subtree(cgroup, task_memcg);
 	rcu_read_unlock();
 	return match;
@@ -258,10 +258,10 @@ static inline struct mem_cgroup *try_get
 	return NULL;
 }
 
-static inline int mm_match_cgroup(struct mm_struct *mm,
+static inline bool mm_match_cgroup(struct mm_struct *mm,
 		struct mem_cgroup *memcg)
 {
-	return 1;
+	return true;
 }
 
 static inline int task_in_mem_cgroup(struct task_struct *task,
_


Also,


From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: mm-memcg-clean-up-mm_match_cgroup-signature-fix

mm_match_cgroup is not a macro

Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Signed-off-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
---

 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/memcontrol.h~mm-memcg-clean-up-mm_match_cgroup-signature-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcg-clean-up-mm_match_cgroup-signature-fix
+++ a/include/linux/memcontrol.h
@@ -90,7 +90,7 @@ bool mm_match_cgroup(const struct mm_str
 	bool match;
 
 	rcu_read_lock();
-	task_memcg = mem_cgroup_from_task(rcu_dereference((mm)->owner));
+	task_memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
 	match = __mem_cgroup_same_or_subtree(cgroup, task_memcg);
 	rcu_read_unlock();
 	return match;
_
