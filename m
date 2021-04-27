From: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/1] sched/fair: Fix unfairness caused by missing load
 decay
Date: Tue, 27 Apr 2021 16:26:11 +0200
Message-ID: <20210427142611.GA22056@vingu-book>
References: <20210425080902.11854-1-odin@uged.al>
 <20210425080902.11854-2-odin@uged.al>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=tsLEq65WPKHRwU8rIMWjygbXMsjIHkGUMZ3Ia5QeHAw=;
        b=vxoNyU80KxxiBotb0lzjxlUzkwvkfWvuC8wvl+fAljbT8jvboVaOZTyTmoBBkVYEy8
         ODF18O5VwyagVT62PXJy8ixj23oSXmuh1KLUwKFguIPsnOLkhWeWUapx3ecC6VOb9UpO
         VclnghnBwzwggXYn/U8vznLQeKPRibZYBIl7aIqvEU2gPrjUG0nFbAo3w9VfsAKbB7hB
         qPmOZDXpkvZWQxouq7kGlCKcM/DGcjs++xKMIx+COAJqRPPI4J4iQ0bVFs10x0XSbz/m
         6DstotHlMNmCPVtifdBKbg5L7BDZ2JC3cLpY1c6gmLD2+z5m2nVeY4CCzdkVTNy6sjtu
         jnmw==
Content-Disposition: inline
In-Reply-To: <20210425080902.11854-2-odin-RObV4cXtwVA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Le dimanche 25 avril 2021 =E0 10:09:02 (+0200), Odin Ugedal a =E9crit :
> This fixes an issue where old load on a cfs_rq is not properly decayed,
> resulting in strange behavior where fairness can decrease drastically.
> Real workloads with equally weighted control groups have ended up
> getting a respective 99% and 1%(!!) of cpu time.
>=20
> When an idle task is attached to a cfs_rq by attaching a pid to a cgroup,
> the old load of the task is attached to the new cfs_rq and sched_entity by
> attach_entity_cfs_rq. If the task is then moved to another cpu (and
> therefore cfs_rq) before being enqueued/woken up, the load will be moved
> to cfs_rq->removed from the sched_entity. Such a move will happen when
> enforcing a cpuset on the task (eg. via a cgroup) that force it to move.

Would be good to mention that the problem happens only if the new cfs_rq has
been removed from the leaf_cfs_rq_list because its PELT metrics were already
null. In such case __update_blocked_fair() never updates the blocked load of
the new cfs_rq and never propagate the removed load in the hierarchy.

>=20
> The load will however not be removed from the task_group itself, making
> it look like there is a constant load on that cfs_rq. This causes the
> vruntime of tasks on other sibling cfs_rq's to increase faster than they
> are supposed to; causing severe fairness issues. If no other task is
> started on the given cfs_rq, and due to the cpuset it would not happen,
> this load would never be properly unloaded. With this patch the load
> will be properly removed inside update_blocked_averages. This also
> applies to tasks moved to the fair scheduling class and moved to another
> cpu, and this path will also fix that. For fork, the entity is queued
> right away, so this problem does not affect that.
>=20
> For a simple cgroup hierarchy (as seen below) with two equally weighted
> groups, that in theory should get 50/50 of cpu time each, it often leads
> to a load of 60/40 or 70/30.
>=20
> parent/
>   cg-1/
>     cpu.weight: 100
>     cpuset.cpus: 1
>   cg-2/
>     cpu.weight: 100
>     cpuset.cpus: 1
>=20
> If the hierarchy is deeper (as seen below), while keeping cg-1 and cg-2
> equally weighted, they should still get a 50/50 balance of cpu time.
> This however sometimes results in a balance of 10/90 or 1/99(!!) between
> the task groups.
>=20
> $ ps u -C stress
> USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
> root       18568  1.1  0.0   3684   100 pts/12   R+   13:36   0:00 stress=
 --cpu 1
> root       18580 99.3  0.0   3684   100 pts/12   R+   13:36   0:09 stress=
 --cpu 1
>=20
> parent/
>   cg-1/
>     cpu.weight: 100
>     sub-group/
>       cpu.weight: 1
>       cpuset.cpus: 1
>   cg-2/
>     cpu.weight: 100
>     sub-group/
>       cpu.weight: 10000
>       cpuset.cpus: 1
>=20
> This can be reproduced by attaching an idle process to a cgroup and
> moving it to a given cpuset before it wakes up. The issue is evident in
> many (if not most) container runtimes, and has been reproduced
> with both crun and runc (and therefore docker and all its "derivatives"),
> and with both cgroup v1 and v2.
>=20
> Fixes: 3d30544f0212 ("sched/fair: Apply more PELT fixes")

The fix tag should be :
Fixes: 039ae8bcf7a5 ("sched/fair: Fix O(nr_cgroups) in the load balancing p=
ath")

This patch re-introduced the del of idle cfs_rq from leaf_cfs_rq_list in or=
der to
skip useless update of blocked load.


> Signed-off-by: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
> ---
>  kernel/sched/fair.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>=20
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 794c2cb945f8..ad7556f99b4a 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -10916,6 +10916,19 @@ static void attach_task_cfs_rq(struct task_struc=
t *p)
> =20
>  	if (!vruntime_normalized(p))
>  		se->vruntime +=3D cfs_rq->min_vruntime;
> +
> +	/*
> +	 * Make sure the attached load will decay properly
> +	 * in case the task is moved to another cpu before
> +	 * being queued.
> +	 */
> +	if (!task_on_rq_queued(p)) {
> +		for_each_sched_entity(se) {
> +			if (se->on_rq)
> +				break;
> +			list_add_leaf_cfs_rq(cfs_rq_of(se));
> +		}
> +	}

propagate_entity_cfs_rq() already goes across the tg tree to
propagate the attach/detach.

would be better to call list_add_leaf_cfs_rq(cfs_rq)  inside this function
instead of looping twice the tg tree. Something like:

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 33b1ee31ae0f..18441ce7316c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -11026,10 +11026,10 @@ static void propagate_entity_cfs_rq(struct sched_=
entity *se)
        for_each_sched_entity(se) {
                cfs_rq =3D cfs_rq_of(se);

-               if (cfs_rq_throttled(cfs_rq))
-                       break;
+               if (!cfs_rq_throttled(cfs_rq))
+                       update_load_avg(cfs_rq, se, UPDATE_TG);

-               update_load_avg(cfs_rq, se, UPDATE_TG);
+               list_add_leaf_cfs_rq(cfs_rq);
        }
 }
 #else


>
>  }
> =20
>  static void switched_from_fair(struct rq *rq, struct task_struct *p)
> --=20
> 2.31.1
>=20
