From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v4 06/25] memcg: Make it possible to use the stock for
 more than one page.
Date: Thu, 21 Jun 2012 23:14:52 +0200
Message-ID: <20120621211452.GB31759@tiehlicka.suse.cz>
References: <1340015298-14133-1-git-send-email-glommer@parallels.com>
 <1340015298-14133-7-git-send-email-glommer@parallels.com>
 <20120620132804.GF5541@tiehlicka.suse.cz>
 <4FE2264F.4070805@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4FE2264F.4070805-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Cristoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Wed 20-06-12 23:36:47, Glauber Costa wrote:
> On 06/20/2012 05:28 PM, Michal Hocko wrote:
> >On Mon 18-06-12 14:27:59, Glauber Costa wrote:
> >>From: Suleiman Souhlal <ssouhlal-HZy0K5TPuP5AfugRpC6u6w@public.gmane.org>
> >>
> >>Signed-off-by: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >>Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> >>Acked-by: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> >
> >I am not sure the patch is good to merge on its own without the rest.
> >One comment bellow.
> >
> >>---
> >>  mm/memcontrol.c |   18 +++++++++---------
> >>  1 file changed, 9 insertions(+), 9 deletions(-)
> >>
> >>diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> >>index ce15be4..00b9f1e 100644
> >>--- a/mm/memcontrol.c
> >>+++ b/mm/memcontrol.c
> >>@@ -1998,19 +1998,19 @@ static DEFINE_PER_CPU(struct memcg_stock_pcp, memcg_stock);
> >>  static DEFINE_MUTEX(percpu_charge_mutex);
> >>
> >>  /*
> >>- * Try to consume stocked charge on this cpu. If success, one page is consumed
> >>- * from local stock and true is returned. If the stock is 0 or charges from a
> >>- * cgroup which is not current target, returns false. This stock will be
> >>- * refilled.
> >>+ * Try to consume stocked charge on this cpu. If success, nr_pages pages are
> >>+ * consumed from local stock and true is returned. If the stock is 0 or
> >>+ * charges from a cgroup which is not current target, returns false.
> >>+ * This stock will be refilled.
> >>   */
> >>-static bool consume_stock(struct mem_cgroup *memcg)
> >>+static bool consume_stock(struct mem_cgroup *memcg, int nr_pages)
> >>  {
> >>  	struct memcg_stock_pcp *stock;
> >>  	bool ret = true;
> >
> >I guess you want:
> >	if (nr_pages > CHARGE_BATCH)
> >		return false;
> >
> >because you don't want to try to use stock for THP pages.
> 
> 
> The code reads:
> 
> +       if (memcg == stock->cached && stock->nr_pages >= nr_pages)
> +               stock->nr_pages -= nr_pages;
> 
> Isn't stock->nr_pages always <= CHARGE_BATCH by definition?

Yes it is, but why to disable preemption if we know this has no chance
to succeed at all?

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
