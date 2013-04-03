From: Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] memcg: Add memory.pressure_level events
Date: Tue, 2 Apr 2013 21:00:40 -0700
Message-ID: <20130403040039.GA8687@lizard.gateway.2wire.net>
References: <20130322071351.GA3971@lizard.gateway.2wire.net>
 <5152511A.1010707@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5152511A.1010707-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Leonid Moiseichuk <leonid.moiseichuk-xNZwKgViW5gAvxtiuMwx3w@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org

On Wed, Mar 27, 2013 at 10:53:30AM +0900, Kamezawa Hiroyuki wrote:
[...]
> >+++ b/mm/memcontrol.c
> >@@ -49,6 +49,7 @@
> >  #include <linux/fs.h>
> >  #include <linux/seq_file.h>
> >  #include <linux/vmalloc.h>
> >+#include <linux/vmpressure.h>
> >  #include <linux/mm_inline.h>
> >  #include <linux/page_cgroup.h>
> >  #include <linux/cpu.h>
> >@@ -376,6 +377,9 @@ struct mem_cgroup {
> >  	atomic_t	numainfo_events;
> >  	atomic_t	numainfo_updating;
> >  #endif
> >+
> >+	struct vmpressure vmpr;
> >+
> 
> How about placing this just below "memsw_threshold" ?
> memory objects around there is not performance critical.

Yup, done.

[...]
> >+static const unsigned int vmpressure_win = SWAP_CLUSTER_MAX * 16;
> >+static const unsigned int vmpressure_level_med = 60;
> >+static const unsigned int vmpressure_level_critical = 95;
> >+static const unsigned int vmpressure_level_critical_prio = 3;
> >+
> more comments are welcomed...
> 
> I'm not against the numbers themselves but I'm not sure how these numbers are
> selected...I'm glad if you show some reasons in changelog or somewhere.

Sure, in v4 the numbers are described in the comments.

[...]
> >+static enum vmpressure_levels vmpressure_calc_level(unsigned int scanned,
> >+						    unsigned int reclaimed)
> >+{
> >+	unsigned long scale = scanned + reclaimed;
> >+	unsigned long pressure;
> >+
> >+	if (!scanned)
> >+		return VMPRESSURE_LOW;
> 
> Can you add comment here ? When !scanned happens ?

Yeah, the comment is needed. in v4 I added explanation for this case.

[...]
> >+	mutex_lock(&vmpr->sr_lock);
> >+	vmpr->scanned += scanned;
> >+	vmpr->reclaimed += reclaimed;
> >+	mutex_unlock(&vmpr->sr_lock);
> >+
> >+	if (scanned < vmpressure_win || work_pending(&vmpr->work))
> >+		return;
> >+	schedule_work(&vmpr->work);
> >+}
> 
> I'm not sure how other guys thinks but....could you place the definition
> of work_fn above calling it ? you call vmpressure_wk_fn(), right ?

Yup. OK, I rearranged the code a bit.

[...]
> >  	do {
> >+		vmpressure_prio(sc->gfp_mask, sc->target_mem_cgroup,
> >+				sc->priority);
> >  		sc->nr_scanned = 0;
> >  		aborted_reclaim = shrink_zones(zonelist, sc);
> >
> >
> 
> When you answers Andrew's comment and fix problems, feel free to add
> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

Thanks a lot for the reviews, Kamezawa!

Anton
