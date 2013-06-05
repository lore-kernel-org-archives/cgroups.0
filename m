From: Minchan Kim <minchan.kernel.2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4] memcg: Add memory.pressure_level events
Date: Wed, 5 Jun 2013 23:56:07 +0900
Message-ID: <20130605145607.GA2309@blaptop>
References: <20130403035923.GA4752@lizard.gateway.2wire.net>
 <012701ce61c7$141c53b0$3c54fb10$%kim@samsung.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=0mR6aQzqBHshUeV9WIk7WZE5VQYKlcXqWevz+GiZYBE=;
        b=DRA0ZTpZXQyjdm7rhiOJlQKrp/ihm318Y2V0N+siLp6mzr/mPwio1k5ukwTOiFIXB9
         4waAawjFKgxnJNVEEpXs/FEL0ELb5FdY1FjaMOZr8yG4s+iREWM7fWQwvroimCzoqexM
         nqVSz4rcWSRHiYWXLcImT+HgHVcftAHRi2/1j2OJR8Ok4nNqLgqdJUBLQ3j/YtH3Gpxa
         cX1TPd5B3ewlhBtizII3674iKqah1eFU79vLaf1hFqouKsTIsYPJ1DQvWR+jvDQryPBh
         WL0M0+RjgIXhrP19sTY7ZcnuIhLHhGXQebh/V4MmptCCnGN/eI2qrPtmHf4bmcTnqRZe
         poRw==
Content-Disposition: inline
In-Reply-To: <012701ce61c7$141c53b0$3c54fb10$%kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?utf-8?B?6rmA7ZiE7Z2s?= <hyunhee.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: 'Anton Vorontsov' <anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, =?utf-8?B?J+uwleqyveuvvCc=?= <kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, 'Bartlomiej Zolnierkiewicz' <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

Hello,

On Wed, Jun 05, 2013 at 05:31:30PM +0900, =EA=B9=80=ED=98=84=ED=9D=AC w=
rote:
> Hi, Anton,
>=20

Sorry, I'm not Anton but I involved a little bit when this feature was
developed so may I answer your qeustion?

> When calculating pressure level in vmpressure_calc_level, I observed =
that "reclaimed" becomes larger than "scanned".
> In this case, since these values are "unsigned long", pressure return=
s wrong value and critical event is triggered even on low state.
> Do you think that it is possible?=20

True, we have a few reasons.

Culprits I can think easily are THP page reclaiming or bails out reclai=
ming
by fatal signal in shrink_inactive_list.
I guess you don't enable THP so I think culprit is latter.

> If so, in this case, should we make "reclaimed" equal to "scanned"?
> When I tested as below, it could trigger reasonable events.
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> +static enum vmpressure_levels vmpressure_calc_level(unsigned long sc=
anned,
> +						    unsigned long reclaimed)
> +{
> +	unsigned long scale =3D scanned + reclaimed;
> +	unsigned long pressure;
> +	if (reclaimed > scanned)
> +		reclaimed =3D scanned;

Could we simply return VMPRESSURE_LOW?

> +	/*
> +	 * We calculate the ratio (in percents) of how many pages were
> +	 * scanned vs. reclaimed in a given time frame (window). Note that
> +	 * time is in VM reclaimer's "ticks", i.e. number of pages
> +	 * scanned. This makes it possible to set desired reaction time
> +	 * and serves as a ratelimit.
> +	 */
> +	pressure =3D scale - (reclaimed * scale / scanned);
> +	pressure =3D pressure * 100 / scale;
> +	pr_debug("%s: %3lu  (s: %lu  r: %lu)\n", __func__, pressure,
> +		 scanned, reclaimed);
> +
> +	return vmpressure_level(pressure);
> +}
>=20
> Thanks,
> Hyunhee Kim.
>=20
>=20
> -----Original Message-----
> From: owner-linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org [mailto:owner-linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org] On B=
ehalf Of Anton Vorontsov
> Sent: Wednesday, April 03, 2013 12:59 PM
> To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Tejun Heo; David Rientjes; Pekka Enberg; Mel Gorman; Glauber Cost=
a; Michal Hocko; Kirill A. Shutemov; Kamezawa Hiroyuki; Luiz Capitulino=
; Andrew Morton; Greg Thelen; Leonid Moiseichuk; KOSAKI Motohiro; Minch=
an Kim; Bartlomiej Zolnierkiewicz; John Stultz; linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org; lin=
ux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org; patches@lina=
ro.org; kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org
> Subject: [PATCH v4] memcg: Add memory.pressure_level events
>=20
> With this patch userland applications that want to maintain the
> interactivity/memory allocation cost can use the pressure level
> notifications. The levels are defined like this:
>=20
> The "low" level means that the system is reclaiming memory for new
> allocations. Monitoring this reclaiming activity might be useful for
> maintaining cache level. Upon notification, the program (typically
> "Activity Manager") might analyze vmstat and act in advance (i.e.
> prematurely shutdown unimportant services).
>=20
> The "medium" level means that the system is experiencing medium memor=
y
> pressure, the system might be making swap, paging out active file cac=
hes,
> etc. Upon this event applications may decide to further analyze
> vmstat/zoneinfo/memcg or internal memory usage statistics and free an=
y
> resources that can be easily reconstructed or re-read from a disk.
>=20
> The "critical" level means that the system is actively thrashing, it =
is
> about to out of memory (OOM) or even the in-kernel OOM killer is on i=
ts
> way to trigger. Applications should do whatever they can to help the
> system. It might be too late to consult with vmstat or any other
> statistics, so it's advisable to take an immediate action.
>=20
> The events are propagated upward until the event is handled, i.e. the
> events are not pass-through. Here is what this means: for example you=
 have
> three cgroups: A->B->C. Now you set up an event listener on cgroups A=
, B
> and C, and suppose group C experiences some pressure. In this situati=
on,
> only group C will receive the notification, i.e. groups A and B will =
not
> receive it. This is done to avoid excessive "broadcasting" of message=
s,
> which disturbs the system and which is especially bad if we are low o=
n
> memory or thrashing. So, organize the cgroups wisely, or propagate th=
e
> events manually (or, ask us to implement the pass-through events,
> explaining why would you need them.)
>=20
> Performance wise, the memory pressure notifications feature itself is
> lightweight and does not require much of bookkeeping, in contrast to =
the
> rest of memcg features. Unfortunately, as of current memcg implementa=
tion,
> pages accounting is an inseparable part and cannot be turned off. The=
 good
> news is that there are some efforts[1] to improve the situation; plus=
,
> implementing the same, fully API-compatible[2] interface for
> CONFIG_MEMCG=3Dn case (e.g. embedded) is also a viable option, so it =
will
> not require any changes on the userland side.
>=20
> [1] http://permalink.gmane.org/gmane.linux.kernel.cgroups/6291
> [2] http://lkml.org/lkml/2013/2/21/454
>=20
> Signed-off-by: Anton Vorontsov <anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Acked-by: Kirill A. Shutemov <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> ---
>=20
> Hi all,
>=20
> Thanks for the previous reviews!
>=20
> In v4 I addressed Andrew's and Kamezawa's comments:
>=20
> - Documented public interfaces and tunables;
>=20
> - Added documentation for eventfd interface;
>=20
> - Some cosmetic changes: code rearrangements and variables renames
>   (wk->work, lvl->level, etc.);
>=20
> - Changed types for page counters from 'unsigned int' to 'unsigned lo=
ng',
>   this avoids possible overflows;
>=20
> - Added Kamezawa's Ack, and rebased onto 3.9.0-rc5-next-20130402+.
>=20
> In v3:
>=20
> - No changes in the code, just updated commit message to incorporate =
the
>   answer to Minchan Kim's comment regarding applicability to embedded=
 use
>   cases in the light of memcg performance overhead, plus gave some
>   references to Glauber Costa's memcg work.
>=20
> - Rebased onto 3.9.0-rc3-next-20130321.
>=20
> Old changelogs/submissions:
>=20
>   v3: http://lkml.org/lkml/2013/3/22/31
>   v2: http://lkml.org/lkml/2013/2/18/577
>   v1: http://lkml.org/lkml/2013/2/10/140
>   mempressure cgroup: http://lkml.org/lkml/2013/1/4/55
>=20
>  Documentation/cgroups/memory.txt |  70 +++++++-
>  include/linux/vmpressure.h       |  48 +++++
>  mm/Makefile                      |   2 +-
>  mm/memcontrol.c                  |  29 +++
>  mm/vmpressure.c                  | 374 +++++++++++++++++++++++++++++=
++++++++++
>  mm/vmscan.c                      |   8 +
>  6 files changed, 529 insertions(+), 2 deletions(-)
>  create mode 100644 include/linux/vmpressure.h
>  create mode 100644 mm/vmpressure.c
>=20
> diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups=
/memory.txt
> index 3aaa984..1178e23 100644
> --- a/Documentation/cgroups/memory.txt
> +++ b/Documentation/cgroups/memory.txt
> @@ -40,6 +40,7 @@ Features:
>   - soft limit
>   - moving (recharging) account at moving a task is selectable.
>   - usage threshold notifier
> + - memory pressure notifier
>   - oom-killer disable knob and oom-notifier
>   - Root cgroup has no limit controls.
> =20
> @@ -65,6 +66,7 @@ Brief summary of control files.
>   memory.stat			 # show various statistics
>   memory.use_hierarchy		 # set/show hierarchical account enabled
>   memory.force_empty		 # trigger forced move charge to parent
> + memory.pressure_level		 # set memory pressure notifications
>   memory.swappiness		 # set/show swappiness parameter of vmscan
>  				 (See sysctl's vm.swappiness)
>   memory.move_charge_at_immigrate # set/show controls of moving charg=
es
> @@ -778,7 +780,73 @@ At reading, current status of OOM is shown.
>  	under_oom	 0 or 1 (if 1, the memory cgroup is under OOM, tasks may
>  				 be stopped.)
> =20
> -11. TODO
> +11. Memory Pressure
> +
> +The pressure level notifications can be used to monitor the memory
> +allocation cost; based on the pressure, applications can implement
> +different strategies of managing their memory resources. The pressur=
e
> +levels are defined as following:
> +
> +The "low" level means that the system is reclaiming memory for new
> +allocations. Monitoring this reclaiming activity might be useful for
> +maintaining cache level. Upon notification, the program (typically
> +"Activity Manager") might analyze vmstat and act in advance (i.e.
> +prematurely shutdown unimportant services).
> +
> +The "medium" level means that the system is experiencing medium memo=
ry
> +pressure, the system might be making swap, paging out active file ca=
ches,
> +etc. Upon this event applications may decide to further analyze
> +vmstat/zoneinfo/memcg or internal memory usage statistics and free a=
ny
> +resources that can be easily reconstructed or re-read from a disk.
> +
> +The "critical" level means that the system is actively thrashing, it=
 is
> +about to out of memory (OOM) or even the in-kernel OOM killer is on =
its
> +way to trigger. Applications should do whatever they can to help the
> +system. It might be too late to consult with vmstat or any other
> +statistics, so it's advisable to take an immediate action.
> +
> +The events are propagated upward until the event is handled, i.e. th=
e
> +events are not pass-through. Here is what this means: for example yo=
u have
> +three cgroups: A->B->C. Now you set up an event listener on cgroups =
A, B
> +and C, and suppose group C experiences some pressure. In this situat=
ion,
> +only group C will receive the notification, i.e. groups A and B will=
 not
> +receive it. This is done to avoid excessive "broadcasting" of messag=
es,
> +which disturbs the system and which is especially bad if we are low =
on
> +memory or thrashing. So, organize the cgroups wisely, or propagate t=
he
> +events manually (or, ask us to implement the pass-through events,
> +explaining why would you need them.)
> +
> +The file memory.pressure_level is only used to setup an eventfd. To
> +register a notification, an application must:
> +
> +- create an eventfd using eventfd(2);
> +- open memory.pressure_level;
> +- write string like "<event_fd> <fd of memory.pressure_level> <level=
>"
> +  to cgroup.event_control.
> +
> +Application will be notified through eventfd when memory pressure is=
 at
> +the specific level (or higher). Read/write operations to
> +memory.pressure_level are no implemented.
> +
> +Test:
> +
> +   Here is a small script example that makes a new cgroup, sets up a
> +   memory limit, sets up a notification in the cgroup and then makes=
 child
> +   cgroup experience a critical pressure:
> +
> +   # cd /sys/fs/cgroup/memory/
> +   # mkdir foo
> +   # cd foo
> +   # cgroup_event_listener memory.pressure_level low &
> +   # echo 8000000 > memory.limit_in_bytes
> +   # echo 8000000 > memory.memsw.limit_in_bytes
> +   # echo $$ > tasks
> +   # dd if=3D/dev/zero | read x
> +
> +   (Expect a bunch of notifications, and eventually, the oom-killer =
will
> +   trigger.)
> +
> +12. TODO
> =20
>  1. Add support for accounting huge pages (as a separate controller)
>  2. Make per-cgroup scanner reclaim not-shared pages first
> diff --git a/include/linux/vmpressure.h b/include/linux/vmpressure.h
> new file mode 100644
> index 0000000..2e86259
> --- /dev/null
> +++ b/include/linux/vmpressure.h
> @@ -0,0 +1,48 @@
> +#ifndef __LINUX_VMPRESSURE_H
> +#define __LINUX_VMPRESSURE_H
> +
> +#include <linux/mutex.h>
> +#include <linux/list.h>
> +#include <linux/workqueue.h>
> +#include <linux/gfp.h>
> +#include <linux/types.h>
> +#include <linux/cgroup.h>
> +
> +struct vmpressure {
> +	unsigned long scanned;
> +	unsigned long reclaimed;
> +	/* The lock is used to keep the scanned/reclaimed above in sync. */
> +	struct mutex sr_lock;
> +
> +	/* The list of vmpressure_event structs. */
> +	struct list_head events;
> +	/* Have to grab the lock on events traversal or modifications. */
> +	struct mutex events_lock;
> +
> +	struct work_struct work;
> +};
> +
> +struct mem_cgroup;
> +
> +#ifdef CONFIG_MEMCG
> +extern void vmpressure(gfp_t gfp, struct mem_cgroup *memcg,
> +		       unsigned long scanned, unsigned long reclaimed);
> +extern void vmpressure_prio(gfp_t gfp, struct mem_cgroup *memcg, int=
 prio);
> +#else
> +static inline void vmpressure(gfp_t gfp, struct mem_cgroup *memcg,
> +			      unsigned long scanned, unsigned long reclaimed) {}
> +static inline void vmpressure_prio(gfp_t gfp, struct mem_cgroup *mem=
cg,
> +				   int prio) {}
> +#endif /* CONFIG_MEMCG */
> +
> +extern void vmpressure_init(struct vmpressure *vmpr);
> +extern struct vmpressure *memcg_to_vmpressure(struct mem_cgroup *mem=
cg);
> +extern struct cgroup_subsys_state *vmpressure_to_css(struct vmpressu=
re *vmpr);
> +extern struct vmpressure *css_to_vmpressure(struct cgroup_subsys_sta=
te *css);
> +extern int vmpressure_register_event(struct cgroup *cg, struct cftyp=
e *cft,
> +				     struct eventfd_ctx *eventfd,
> +				     const char *args);
> +extern void vmpressure_unregister_event(struct cgroup *cg, struct cf=
type *cft,
> +					struct eventfd_ctx *eventfd);
> +
> +#endif /* __LINUX_VMPRESSURE_H */
> diff --git a/mm/Makefile b/mm/Makefile
> index 3a46287..72c5acb 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -50,7 +50,7 @@ obj-$(CONFIG_FS_XIP) +=3D filemap_xip.o
>  obj-$(CONFIG_MIGRATION) +=3D migrate.o
>  obj-$(CONFIG_QUICKLIST) +=3D quicklist.o
>  obj-$(CONFIG_TRANSPARENT_HUGEPAGE) +=3D huge_memory.o
> -obj-$(CONFIG_MEMCG) +=3D memcontrol.o page_cgroup.o
> +obj-$(CONFIG_MEMCG) +=3D memcontrol.o page_cgroup.o vmpressure.o
>  obj-$(CONFIG_CGROUP_HUGETLB) +=3D hugetlb_cgroup.o
>  obj-$(CONFIG_MEMORY_FAILURE) +=3D memory-failure.o
>  obj-$(CONFIG_HWPOISON_INJECT) +=3D hwpoison-inject.o
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index f608546..64d75a2 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -49,6 +49,7 @@
>  #include <linux/fs.h>
>  #include <linux/seq_file.h>
>  #include <linux/vmalloc.h>
> +#include <linux/vmpressure.h>
>  #include <linux/mm_inline.h>
>  #include <linux/page_cgroup.h>
>  #include <linux/cpu.h>
> @@ -315,6 +316,9 @@ struct mem_cgroup {
>  	/* thresholds for mem+swap usage. RCU-protected */
>  	struct mem_cgroup_thresholds memsw_thresholds;
> =20
> +	/* vmpressure notifications */
> +	struct vmpressure vmpressure;
> +
>  	union {
>  		/* For oom notifier event fd */
>  		struct list_head oom_notify;
> @@ -376,6 +380,7 @@ struct mem_cgroup {
>  	atomic_t	numainfo_events;
>  	atomic_t	numainfo_updating;
>  #endif
> +
>  	/*
>  	 * Per cgroup active and inactive list, similar to the
>  	 * per zone LRU lists.
> @@ -576,6 +581,24 @@ struct mem_cgroup *mem_cgroup_from_css(struct cg=
roup_subsys_state *s)
>  	return container_of(s, struct mem_cgroup, css);
>  }
> =20
> +/* Some nice accessors for the vmpressure. */
> +struct vmpressure *memcg_to_vmpressure(struct mem_cgroup *memcg)
> +{
> +	if (!memcg)
> +		memcg =3D root_mem_cgroup;
> +	return &memcg->vmpressure;
> +}
> +
> +struct cgroup_subsys_state *vmpressure_to_css(struct vmpressure *vmp=
r)
> +{
> +	return &container_of(vmpr, struct mem_cgroup, vmpressure)->css;
> +}
> +
> +struct vmpressure *css_to_vmpressure(struct cgroup_subsys_state *css=
)
> +{
> +	return &mem_cgroup_from_css(css)->vmpressure;
> +}
> +
>  static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
>  {
>  	return (memcg =3D=3D root_mem_cgroup);
> @@ -6074,6 +6097,11 @@ static struct cftype mem_cgroup_files[] =3D {
>  		.unregister_event =3D mem_cgroup_oom_unregister_event,
>  		.private =3D MEMFILE_PRIVATE(_OOM_TYPE, OOM_CONTROL),
>  	},
> +	{
> +		.name =3D "pressure_level",
> +		.register_event =3D vmpressure_register_event,
> +		.unregister_event =3D vmpressure_unregister_event,
> +	},
>  #ifdef CONFIG_NUMA
>  	{
>  		.name =3D "numa_stat",
> @@ -6365,6 +6393,7 @@ mem_cgroup_css_alloc(struct cgroup *cont)
>  	memcg->move_charge_at_immigrate =3D 0;
>  	mutex_init(&memcg->thresholds_lock);
>  	spin_lock_init(&memcg->move_lock);
> +	vmpressure_init(&memcg->vmpressure);
> =20
>  	return &memcg->css;
> =20
> diff --git a/mm/vmpressure.c b/mm/vmpressure.c
> new file mode 100644
> index 0000000..ccbdc9e
> --- /dev/null
> +++ b/mm/vmpressure.c
> @@ -0,0 +1,374 @@
> +/*
> + * Linux VM pressure
> + *
> + * Copyright 2012 Linaro Ltd.
> + *		  Anton Vorontsov <anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> + *
> + * Based on ideas from Andrew Morton, David Rientjes, KOSAKI Motohir=
o,
> + * Leonid Moiseichuk, Mel Gorman, Minchan Kim and Pekka Enberg.
> + *
> + * This program is free software; you can redistribute it and/or mod=
ify it
> + * under the terms of the GNU General Public License version 2 as pu=
blished
> + * by the Free Software Foundation.
> + */
> +
> +#include <linux/cgroup.h>
> +#include <linux/fs.h>
> +#include <linux/log2.h>
> +#include <linux/sched.h>
> +#include <linux/mm.h>
> +#include <linux/vmstat.h>
> +#include <linux/eventfd.h>
> +#include <linux/swap.h>
> +#include <linux/printk.h>
> +#include <linux/vmpressure.h>
> +
> +/*
> + * The window size (vmpressure_win) is the number of scanned pages b=
efore
> + * we try to analyze scanned/reclaimed ratio. So the window is used =
as a
> + * rate-limit tunable for the "low" level notification, and also for
> + * averaging the ratio for medium/critical levels. Using small windo=
w
> + * sizes can cause lot of false positives, but too big window size w=
ill
> + * delay the notifications.
> + *
> + * As the vmscan reclaimer logic works with chunks which are multipl=
e of
> + * SWAP_CLUSTER_MAX, it makes sense to use it for the window size as=
 well.
> + *
> + * TODO: Make the window size depend on machine size, as we do for v=
mstat
> + * thresholds. Currently we set it to 512 pages (2MB for 4KB pages).
> + */
> +static const unsigned long vmpressure_win =3D SWAP_CLUSTER_MAX * 16;
> +
> +/*
> + * These thresholds are used when we account memory pressure through
> + * scanned/reclaimed ratio. The current values were chosen empirical=
ly. In
> + * essence, they are percents: the higher the value, the more number
> + * unsuccessful reclaims there were.
> + */
> +static const unsigned int vmpressure_level_med =3D 60;
> +static const unsigned int vmpressure_level_critical =3D 95;
> +
> +/*
> + * When there are too little pages left to scan, vmpressure() may mi=
ss the
> + * critical pressure as number of pages will be less than "window si=
ze".
> + * However, in that case the vmscan priority will raise fast as the
> + * reclaimer will try to scan LRUs more deeply.
> + *
> + * The vmscan logic considers these special priorities:
> + *
> + * prio =3D=3D DEF_PRIORITY (12): reclaimer starts with that value
> + * prio <=3D DEF_PRIORITY - 2 : kswapd becomes somewhat overwhelmed
> + * prio =3D=3D 0                : close to OOM, kernel scans every p=
age in an lru
> + *
> + * Any value in this range is acceptable for this tunable (i.e. from=
 12 to
> + * 0). Current value for the vmpressure_level_critical_prio is chose=
n
> + * empirically, but the number, in essence, means that we consider
> + * critical level when scanning depth is ~10% of the lru size (vmsca=
n
> + * scans 'lru_size >> prio' pages, so it is actually 12.5%, or one
> + * eights).
> + */
> +static const unsigned int vmpressure_level_critical_prio =3D ilog2(1=
00 / 10);
> +
> +static struct vmpressure *work_to_vmpressure(struct work_struct *wor=
k)
> +{
> +	return container_of(work, struct vmpressure, work);
> +}
> +
> +static struct vmpressure *cg_to_vmpressure(struct cgroup *cg)
> +{
> +	return css_to_vmpressure(cgroup_subsys_state(cg, mem_cgroup_subsys_=
id));
> +}
> +
> +static struct vmpressure *vmpressure_parent(struct vmpressure *vmpr)
> +{
> +	struct cgroup *cg =3D vmpressure_to_css(vmpr)->cgroup;
> +	struct mem_cgroup *memcg =3D mem_cgroup_from_cont(cg);
> +
> +	memcg =3D parent_mem_cgroup(memcg);
> +	if (!memcg)
> +		return NULL;
> +	return memcg_to_vmpressure(memcg);
> +}
> +
> +enum vmpressure_levels {
> +	VMPRESSURE_LOW =3D 0,
> +	VMPRESSURE_MEDIUM,
> +	VMPRESSURE_CRITICAL,
> +	VMPRESSURE_NUM_LEVELS,
> +};
> +
> +static const char *vmpressure_str_levels[] =3D {
> +	[VMPRESSURE_LOW] =3D "low",
> +	[VMPRESSURE_MEDIUM] =3D "medium",
> +	[VMPRESSURE_CRITICAL] =3D "critical",
> +};
> +
> +static enum vmpressure_levels vmpressure_level(unsigned long pressur=
e)
> +{
> +	if (pressure >=3D vmpressure_level_critical)
> +		return VMPRESSURE_CRITICAL;
> +	else if (pressure >=3D vmpressure_level_med)
> +		return VMPRESSURE_MEDIUM;
> +	return VMPRESSURE_LOW;
> +}
> +
> +static enum vmpressure_levels vmpressure_calc_level(unsigned long sc=
anned,
> +						    unsigned long reclaimed)
> +{
> +	unsigned long scale =3D scanned + reclaimed;
> +	unsigned long pressure;
> +
> +	/*
> +	 * We calculate the ratio (in percents) of how many pages were
> +	 * scanned vs. reclaimed in a given time frame (window). Note that
> +	 * time is in VM reclaimer's "ticks", i.e. number of pages
> +	 * scanned. This makes it possible to set desired reaction time
> +	 * and serves as a ratelimit.
> +	 */
> +	pressure =3D scale - (reclaimed * scale / scanned);
> +	pressure =3D pressure * 100 / scale;
> +
> +	pr_debug("%s: %3lu  (s: %lu  r: %lu)\n", __func__, pressure,
> +		 scanned, reclaimed);
> +
> +	return vmpressure_level(pressure);
> +}
> +
> +struct vmpressure_event {
> +	struct eventfd_ctx *efd;
> +	enum vmpressure_levels level;
> +	struct list_head node;
> +};
> +
> +static bool vmpressure_event(struct vmpressure *vmpr,
> +			     unsigned long scanned, unsigned long reclaimed)
> +{
> +	struct vmpressure_event *ev;
> +	enum vmpressure_levels level;
> +	bool signalled =3D false;
> +
> +	level =3D vmpressure_calc_level(scanned, reclaimed);
> +
> +	mutex_lock(&vmpr->events_lock);
> +
> +	list_for_each_entry(ev, &vmpr->events, node) {
> +		if (level >=3D ev->level) {
> +			eventfd_signal(ev->efd, 1);
> +			signalled =3D true;
> +		}
> +	}
> +
> +	mutex_unlock(&vmpr->events_lock);
> +
> +	return signalled;
> +}
> +
> +static void vmpressure_work_fn(struct work_struct *work)
> +{
> +	struct vmpressure *vmpr =3D work_to_vmpressure(work);
> +	unsigned long scanned;
> +	unsigned long reclaimed;
> +
> +	/*
> +	 * Several contexts might be calling vmpressure(), so it is
> +	 * possible that the work was rescheduled again before the old
> +	 * work context cleared the counters. In that case we will run
> +	 * just after the old work returns, but then scanned might be zero
> +	 * here. No need for any locks here since we don't care if
> +	 * vmpr->reclaimed is in sync.
> +	 */
> +	if (!vmpr->scanned)
> +		return;
> +
> +	mutex_lock(&vmpr->sr_lock);
> +	scanned =3D vmpr->scanned;
> +	reclaimed =3D vmpr->reclaimed;
> +	vmpr->scanned =3D 0;
> +	vmpr->reclaimed =3D 0;
> +	mutex_unlock(&vmpr->sr_lock);
> +
> +	do {
> +		if (vmpressure_event(vmpr, scanned, reclaimed))
> +			break;
> +		/*
> +		 * If not handled, propagate the event upward into the
> +		 * hierarchy.
> +		 */
> +	} while ((vmpr =3D vmpressure_parent(vmpr)));
> +}
> +
> +/**
> + * vmpressure() - Account memory pressure through scanned/reclaimed =
ratio
> + * @gfp:	reclaimer's gfp mask
> + * @memcg:	cgroup memory controller handle
> + * @scanned:	number of pages scanned
> + * @reclaimed:	number of pages reclaimed
> + *
> + * This function should be called from the vmscan reclaim path to ac=
count
> + * "instantaneous" memory pressure (scanned/reclaimed ratio). The ra=
w
> + * pressure index is then further refined and averaged over time.
> + *
> + * This function does not return any value.
> + */
> +void vmpressure(gfp_t gfp, struct mem_cgroup *memcg,
> +		unsigned long scanned, unsigned long reclaimed)
> +{
> +	struct vmpressure *vmpr =3D memcg_to_vmpressure(memcg);
> +
> +	/*
> +	 * Here we only want to account pressure that userland is able to
> +	 * help us with. For example, suppose that DMA zone is under
> +	 * pressure; if we notify userland about that kind of pressure,
> +	 * then it will be mostly a waste as it will trigger unnecessary
> +	 * freeing of memory by userland (since userland is more likely to
> +	 * have HIGHMEM/MOVABLE pages instead of the DMA fallback). That
> +	 * is why we include only movable, highmem and FS/IO pages.
> +	 * Indirect reclaim (kswapd) sets sc->gfp_mask to GFP_KERNEL, so
> +	 * we account it too.
> +	 */
> +	if (!(gfp & (__GFP_HIGHMEM | __GFP_MOVABLE | __GFP_IO | __GFP_FS)))
> +		return;
> +
> +	/*
> +	 * If we got here with no pages scanned, then that is an indicator
> +	 * that reclaimer was unable to find any shrinkable LRUs at the
> +	 * current scanning depth. But it does not mean that we should
> +	 * report the critical pressure, yet. If the scanning priority
> +	 * (scanning depth) goes too high (deep), we will be notified
> +	 * through vmpressure_prio(). But so far, keep calm.
> +	 */
> +	if (!scanned)
> +		return;
> +
> +	mutex_lock(&vmpr->sr_lock);
> +	vmpr->scanned +=3D scanned;
> +	vmpr->reclaimed +=3D reclaimed;
> +	scanned =3D vmpr->scanned;
> +	mutex_unlock(&vmpr->sr_lock);
> +
> +	if (scanned < vmpressure_win || work_pending(&vmpr->work))
> +		return;
> +	schedule_work(&vmpr->work);
> +}
> +
> +/**
> + * vmpressure_prio() - Account memory pressure through reclaimer pri=
ority level
> + * @gfp:	reclaimer's gfp mask
> + * @memcg:	cgroup memory controller handle
> + * @prio:	reclaimer's priority
> + *
> + * This function should be called from the reclaim path every time w=
hen
> + * the vmscan's reclaiming priority (scanning depth) changes.
> + *
> + * This function does not return any value.
> + */
> +void vmpressure_prio(gfp_t gfp, struct mem_cgroup *memcg, int prio)
> +{
> +	/*
> +	 * We only use prio for accounting critical level. For more info
> +	 * see comment for vmpressure_level_critical_prio variable above.
> +	 */
> +	if (prio > vmpressure_level_critical_prio)
> +		return;
> +
> +	/*
> +	 * OK, the prio is below the threshold, updating vmpressure
> +	 * information before shrinker dives into long shrinking of long
> +	 * range vmscan. Passing scanned =3D vmpressure_win, reclaimed =3D =
0
> +	 * to the vmpressure() basically means that we signal 'critical'
> +	 * level.
> +	 */
> +	vmpressure(gfp, memcg, vmpressure_win, 0);
> +}
> +
> +/**
> + * vmpressure_register_event() - Bind vmpressure notifications to an=
 eventfd
> + * @cg:		cgroup that is interested in vmpressure notifications
> + * @cft:	cgroup control files handle
> + * @eventfd:	eventfd context to link notifications with
> + * @args:	event arguments (used to set up a pressure level threshold=
)
> + *
> + * This function associates eventfd context with the vmpressure
> + * infrastructure, so that the notifications will be delivered to th=
e
> + * @eventfd. The @args parameter is a string that denotes pressure l=
evel
> + * threshold (one of vmpressure_str_levels, i.e. "low", "medium", or
> + * "critical").
> + *
> + * This function should not be used directly, just pass it to (struc=
t
> + * cftype).register_event, and then cgroup core will handle everythi=
ng by
> + * itself.
> + */
> +int vmpressure_register_event(struct cgroup *cg, struct cftype *cft,
> +			      struct eventfd_ctx *eventfd, const char *args)
> +{
> +	struct vmpressure *vmpr =3D cg_to_vmpressure(cg);
> +	struct vmpressure_event *ev;
> +	int level;
> +
> +	for (level =3D 0; level < VMPRESSURE_NUM_LEVELS; level++) {
> +		if (!strcmp(vmpressure_str_levels[level], args))
> +			break;
> +	}
> +
> +	if (level >=3D VMPRESSURE_NUM_LEVELS)
> +		return -EINVAL;
> +
> +	ev =3D kzalloc(sizeof(*ev), GFP_KERNEL);
> +	if (!ev)
> +		return -ENOMEM;
> +
> +	ev->efd =3D eventfd;
> +	ev->level =3D level;
> +
> +	mutex_lock(&vmpr->events_lock);
> +	list_add(&ev->node, &vmpr->events);
> +	mutex_unlock(&vmpr->events_lock);
> +
> +	return 0;
> +}
> +
> +/**
> + * vmpressure_unregister_event() - Unbind eventfd from vmpressure
> + * @cg:		cgroup handle
> + * @cft:	cgroup control files handle
> + * @eventfd:	eventfd context that was used to link vmpressure with t=
he @cg
> + *
> + * This function does internal manipulations to detach the @eventfd =
from
> + * the vmpressure notifications, and then frees internal resources
> + * associated with the @eventfd (but the @eventfd itself is not free=
d).
> + *
> + * This function should not be used directly, just pass it to (struc=
t
> + * cftype).unregister_event, and then cgroup core will handle everyt=
hing
> + * by itself.
> + */
> +void vmpressure_unregister_event(struct cgroup *cg, struct cftype *c=
ft,
> +				 struct eventfd_ctx *eventfd)
> +{
> +	struct vmpressure *vmpr =3D cg_to_vmpressure(cg);
> +	struct vmpressure_event *ev;
> +
> +	mutex_lock(&vmpr->events_lock);
> +	list_for_each_entry(ev, &vmpr->events, node) {
> +		if (ev->efd !=3D eventfd)
> +			continue;
> +		list_del(&ev->node);
> +		kfree(ev);
> +		break;
> +	}
> +	mutex_unlock(&vmpr->events_lock);
> +}
> +
> +/**
> + * vmpressure_init() - Initialize vmpressure control structure
> + * @vmpr:	Structure to be initialized
> + *
> + * This function should be called on every allocated vmpressure stru=
cture
> + * before any usage.
> + */
> +void vmpressure_init(struct vmpressure *vmpr)
> +{
> +	mutex_init(&vmpr->sr_lock);
> +	mutex_init(&vmpr->events_lock);
> +	INIT_LIST_HEAD(&vmpr->events);
> +	INIT_WORK(&vmpr->work, vmpressure_work_fn);
> +}
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index df78d17..616e2bb 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -19,6 +19,7 @@
>  #include <linux/pagemap.h>
>  #include <linux/init.h>
>  #include <linux/highmem.h>
> +#include <linux/vmpressure.h>
>  #include <linux/vmstat.h>
>  #include <linux/file.h>
>  #include <linux/writeback.h>
> @@ -1982,6 +1983,11 @@ static void shrink_zone(struct zone *zone, str=
uct scan_control *sc)
>  			}
>  			memcg =3D mem_cgroup_iter(root, memcg, &reclaim);
>  		} while (memcg);
> +
> +		vmpressure(sc->gfp_mask, sc->target_mem_cgroup,
> +			   sc->nr_scanned - nr_scanned,
> +			   sc->nr_reclaimed - nr_reclaimed);
> +
>  	} while (should_continue_reclaim(zone, sc->nr_reclaimed - nr_reclai=
med,
>  					 sc->nr_scanned - nr_scanned, sc));
>  }
> @@ -2167,6 +2173,8 @@ static unsigned long do_try_to_free_pages(struc=
t zonelist *zonelist,
>  		count_vm_event(ALLOCSTALL);
> =20
>  	do {
> +		vmpressure_prio(sc->gfp_mask, sc->target_mem_cgroup,
> +				sc->priority);
>  		sc->nr_scanned =3D 0;
>  		aborted_reclaim =3D shrink_zones(zonelist, sc);
> =20
> --=20
> 1.8.1.4
>=20
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=3Dmailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>
>=20
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=3Dmailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>

--=20
Kind regards,
Minchan Kim
