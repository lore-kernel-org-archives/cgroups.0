From: Anton Vorontsov <anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH RFC] memcg: MEMCG_NR_FILE_MAPPED should update _STAT_CACHE as
 well
Date: Mon, 23 Apr 2012 01:28:35 -0700
Message-ID: <20120423082835.GA32359@lizard>
References: <20120302162753.GA11748@oksana.dev.rtsoft.ru>
 <20120305091934.588c160b.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120305091934.588c160b.kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org

...otherwise the we're getting the wrong numbers in usage_in_bytes.

On Mon, Mar 05, 2012 at 09:19:34AM +0900, KAMEZAWA Hiroyuki wrote:
[...]
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 228d646..c8abdc5 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -3812,6 +3812,9 @@ static inline u64 mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
> >  
> >         val = mem_cgroup_recursive_stat(memcg, MEM_CGROUP_STAT_CACHE);
> >         val += mem_cgroup_recursive_stat(memcg, MEM_CGROUP_STAT_RSS);
> > +       val += mem_cgroup_recursive_stat(memcg, MEM_CGROUP_STAT_FILE_MAPPED);
> > 
> > 1. Is there any particular reason we don't currently account file mapped
> >    memory in usage_in_bytes?
> > 
> >    To me, MEM_CGROUP_STAT_FILE_MAPPED hunk seems logical even if we
> >    don't use it for lowmemory notifications.
> > 
> >    Plus, it seems that FILE_MAPPED _is_ accounted for the non-root
> >    cgroups, so I guess it's clearly a bug for the root memcg?
> 
> CACHE includes all file caches. Why do you think FILE_MAPPED is not included in CACHE ?

There were tons of changes in the memcg lately, but I believe the issue
is still there.

For example, looking into this code flow:

-> page_add_file_rmap() (mm/rmap.c)
 -> mem_cgroup_inc_page_stat(page, MEMCG_NR_FILE_MAPPED) (include/linux/memcontrol.h)
  -> void mem_cgroup_update_page_stat(page, MEMCG_NR_FILE_MAPPED, 1) (mm/memcontrol.c)

And then:

void mem_cgroup_update_page_stat(struct page *page,
                                 enum mem_cgroup_page_stat_item idx, int val)
{
        ...
        switch (idx) {
        case MEMCG_NR_FILE_MAPPED:
                idx = MEM_CGROUP_STAT_FILE_MAPPED;
                break;
        default:
                BUG();
        }

        this_cpu_add(memcg->stat->count[idx], val);
        ...
}

So, clearly, this function only bothers updating _FILE_MAPPED only,
leaving _CACHE alone.

If you're saying that _CACHE meant to include _FILE_MAPPED, then
I guess the patch down below would be a proper fix then... Otherwise
we need to be consistent on stats reporting, and either fall-back
to my original fix (in mem_cgroup_usage()), or think about doing it
some other way...

Signed-off-by: Anton Vorontsov <anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---

The patch is against current -next.

Thanks,

 mm/memcontrol.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 884e936..760ecf5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1958,6 +1958,8 @@ void mem_cgroup_update_page_stat(struct page *page,
 
 	switch (idx) {
 	case MEMCG_NR_FILE_MAPPED:
+		idx = MEM_CGROUP_STAT_CACHE;
+		this_cpu_add(memcg->stat->count[idx], val);
 		idx = MEM_CGROUP_STAT_FILE_MAPPED;
 		break;
 	default:
-- 
1.7.9.2
