From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: BUG: HANG_DETECT waiting for migration_cpu_stop() complete
Date: Tue, 6 Sep 2022 22:50:28 +0200
Message-ID: <YxeylMvgc/wKcJqk@hirez.programming.kicks-ass.net>
References: <88b2910181bda955ac46011b695c53f7da39ac47.camel@mediatek.com>
 <b605c3ec-94ab-a55f-5825-9b370d77ecf3@quicinc.com>
 <203d4614c1b2a498a240ace287156e9f401d5395.camel@mediatek.com>
 <YxeR0RoiTdm8sWCJ@slm.duckdns.org>
 <02b8e7b3-941d-8bb9-cd0e-992738893ba3@redhat.com>
 <36a73401-7011-834a-7949-c65a2f66246c@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=GzCE/imuOcJ+g/sNBTROhEBFbz+670zTIBkR3Ox5lik=; b=Wq8JJC2I8k9ghAF1rh90IxH1g1
        6B5eeRWNA2ClA+/QuqBjIVPG+vOa3naUYz8tkXZegSrBEdZEUeeyQPxJ0M4MXqQrI5I68PDnyDsIb
        QUgqk3THblmxaJlRawNJTfv6AOvl5GQkHL++vjZRa4qhEObP5x3vbkUhKXKqmK2zhil4k31p4BUsu
        1w86Xyg88pCB74zI6M76HtjoaEcEEo5ZB6xGGgIozCgqSwYMb5IuzzkpupWExTX+bjHBZJlz3wYfp
        hvEBL908KQXs42Ckacb877wbojdN45KH60/PEhO7xReXrO6e8NWPxkfmSW/OXKYC3P2CnbKHaRWyi
        a9Ozu7dQ==;
Content-Disposition: inline
In-Reply-To: <36a73401-7011-834a-7949-c65a2f66246c-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jing-Ting Wu <jing-ting.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, Mukesh Ojha <quic_mojha-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, wsd_upstream-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Jonathan.JMChen-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, "chris.redpath-5wv7dgnIgG8@public.gmane.org" <chris.redpath-5wv7dgnIgG8@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Vincent Donnefort <vdonnefort-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lixiong.liu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, wenju.xu

On Tue, Sep 06, 2022 at 04:40:03PM -0400, Waiman Long wrote:

I've not followed the earlier stuff due to being unreadable; just
reacting to this..

> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 838623b68031..5d9ea1553ec0 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2794,9 +2794,9 @@ static int __set_cpus_allowed_ptr_locked(struct
> task_struct *p,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (cpumask_equal(&p->cpus_=
mask, new_mask))
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 got=
o out;
>=20
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (WARN_ON_ONCE(p =3D=3D cur=
rent &&
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 is_migration_disabled(p) &&
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 !cpumask_test_cpu(task_cpu(p), new_mask)))
> {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (is_migration_disabled(p) =
&&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 !cpumask_test_cpu=
(task_cpu(p), new_mask)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 WARN_=
ON_ONCE(p =3D=3D current);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret=
 =3D -EBUSY;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 got=
o out;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
> @@ -2818,7 +2818,11 @@ static int __set_cpus_allowed_ptr_locked(struct
> task_struct *p,
> =A0=A0=A0=A0=A0=A0=A0 if (flags & SCA_USER)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 user_mask =3D clear_user_cp=
us_ptr(p);
>=20
> -=A0=A0=A0=A0=A0=A0 ret =3D affine_move_task(rq, p, rf, dest_cpu, flags);
> +=A0=A0=A0=A0=A0=A0 if (!is_migration_disabled(p) || (flags & SCA_MIGRATE=
_ENABLE)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret =3D affine_move_task(rq, =
p, rf, dest_cpu, flags);
> +=A0=A0=A0=A0=A0=A0 } else {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 task_rq_unlock(rq, p, rf);
> +=A0=A0=A0=A0=A0=A0 }

This cannot be right. There might be previous set_cpus_allowed_ptr()
callers that are blocked and waiting for the task to land on a valid
CPU.

