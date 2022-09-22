From: Jing-Ting Wu <jing-ting.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: Re: BUG: HANG_DETECT waiting for migration_cpu_stop() complete
Date: Thu, 22 Sep 2022 13:40:47 +0800
Message-ID: <93f4ce9486ec4b856ba0f3bfe956fc9b2d3cb4cf.camel@mediatek.com>
References: <20220907000741.2496-1-hdanton@sina.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=V/4+Moo1S3nQcLY9jDjtjnWEDd9L/Kw2aufNRHGosCA=;
        b=Zo90xoefOKJHvtfEFcDTAqWFMMlSWhYdihn9YUwakBoC7hSj65xFQOnkygZWjRWo+0MaOfGzMIuyKHdO04SqksKYo04Q/Ql+ZbID6f3GpTsr00YT5rq3AD7qAoZiR0Fhzx7za2FPjitpJ6vUJJ8lOcjWUAYbbUvnHd5+FHK+MKU=;
In-Reply-To: <20220907000741.2496-1-hdanton-k+cT0dCbe1g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Hillf Danton <hdanton-k+cT0dCbe1g@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, ValentinSchneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, TejunHeo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, wsd_upstream-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Jonathan.JMChen-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, "chris.redpath-5wv7dgnIgG8@public.gmane.org" <chris.redpath-5wv7dgnIgG8@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Vincent Donnefort <vdonnefort-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Christian Brauner <brauner@ke>

On Wed, 2022-09-07 at 08:07 +0800, Hillf Danton wrote:
> On 5 Sep 2022 10:47:36 +0800 Jing-Ting Wu <jing-ting.wu-NuS5LvNUpcJWk0Hti=
k3J/w@public.gmane.org>
> wrote
> >=20
> > We meet the HANG_DETECT happened in T SW version with kernel-5.15.
> > Many tasks have been blocked for a long time.
> >=20
> > Root cause:
> > migration_cpu_stop() is not complete due to
> > is_migration_disabled(p) is
> > true, complete is false and complete_all() never get executed.
> > It let other task wait the rwsem.
>=20
> See if handing task over to stopper again in case of migration
> disabled
> could survive your tests.
>=20
> Hillf
>=20
> --- linux-5.15/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2322,9 +2322,7 @@ static int migration_cpu_stop(void *data
>  	 * holding rq->lock, if p->on_rq =3D=3D 0 it cannot get enqueued
> because
>  	 * we're holding p->pi_lock.
>  	 */
> -	if (task_rq(p) =3D=3D rq) {
> -		if (is_migration_disabled(p))
> -			goto out;
> +	if (task_rq(p) =3D=3D rq && !is_migration_disabled(p)) {
> =20
>  		if (pending) {
>  			p->migration_pending =3D NULL;

Because Peter have some concern for patch by Waiman.
We add Hillf's patch to our stability test.
But there are side effects after patched.
The warning appear once < two weeks.=20

Backtrace as follows:
[name:panic&]WARNING: CPU: 6 PID: 32583 at affine_move_task
pc : affine_move_task
lr : __set_cpus_allowed_ptr_locked
Call trace:
affine_move_task
__set_cpus_allowed_ptr_locked
migrate_enable
__cgroup_bpf_run_filter_skb
ip_finish_output
ip_output


The root cause is when is_migration_disabled(p) is true=EF=BC=8Cthe patched
version will set p->migration_pending to NULL by migration_cpu_stop.
And in affine_move_task will raise a WARN_ON_ONCE(!pending).

Kernel-5.15/kernel/sched/core.c:
static int affine_move_task(struct rq *rq, struct task_struct *p,
struct rq_flags *rf, int dest_cpu, unsigned int flags) {
...
	If (WARN_ON_ONCE(!pending)) {
 	  Task_rq_unlock(rq,p,fr);
  	  return -EINVAL;
	}
...
}

But the tasks have not been migrated to the new affinity CPU, so there
should be pending tasks to be processed, so p->migration_pending should
not be NULL.



Without patch:
When is_migration_disabled is true, then goto out and not set p-
>migration_pending to NULL.

static int migration_cpu_stop(void *data) {
...
	If (task_rq(p) =3D=3D rq) {
        	     if (is_migration_disabled(p))
                	           goto out;
	}
...
}


With patch:
When is_migration_disabled is true and pending is true, goto else if
flow. Because p->cpus_ptr not updated when migrate_disable, so this
condition is always true and p->migration_pending will set to NULL.

static int migration_cpu_stop(void *data) {
...
	If (task_rq(p) =3D=3D rq && !is_migration_disabled(p) ) {
 	  ...
	} else if (pending) {
	  ...
	  If (cpumask_test_cpu(task_cpu(p), p-> cpus_ ptr)) {=20
        	p->migration_pending =3D NULL;
      		 complete =3D true;
      		 goto out;
	}
...
}






Best regards,
Jing-Ting Wu


