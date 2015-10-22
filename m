From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: eliminate root memory.current
Date: Thu, 22 Oct 2015 08:29:42 -0400
Message-ID: <20151022122942.GA23792@cmpxchg.org>
References: <1445453394-15156-1-git-send-email-hannes@cmpxchg.org>
 <20151022090756.GB26854@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151022090756.GB26854-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Thu, Oct 22, 2015 at 11:07:56AM +0200, Michal Hocko wrote:
> On Wed 21-10-15 14:49:54, Johannes Weiner wrote:
> > memory.current on the root level doesn't add anything that wouldn't be
> > more accurate and detailed using system statistics. It already doesn't
> > include slabs, and it'll be a pain to keep in sync when further memory
> > types are accounted in the memory controller. Remove it.
> > 
> > Note that this applies to the new unified hierarchy interface only.
> 
> OK, I can understand your reasoning, other knobs are !root as well.
> 
> > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> 
> After the bug mentioned below is fixed
> Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Thanks!

> > @@ -5022,7 +5022,7 @@ static void mem_cgroup_bind(struct cgroup_subsys_state *root_css)
> >  static u64 memory_current_read(struct cgroup_subsys_state *css,
> >  			       struct cftype *cft)
> >  {
> > -	return mem_cgroup_usage(mem_cgroup_from_css(css), false);
> > +	return page_counter_read(&mem_cgroup_from_css(css)->memory);
> 
> We want that in bytes though.

Right you are, thanks for catching that.

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 mm/memcontrol.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c71fe40..2cd149e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5022,7 +5022,9 @@ static void mem_cgroup_bind(struct cgroup_subsys_state *root_css)
 static u64 memory_current_read(struct cgroup_subsys_state *css,
 			       struct cftype *cft)
 {
-	return page_counter_read(&mem_cgroup_from_css(css)->memory);
+	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+
+	return (u64)page_counter_read(&memcg->memory) * PAGE_SIZE;
 }
 
 static int memory_low_show(struct seq_file *m, void *v)
-- 
2.6.1
