From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 4/5] expose fine-grained per-cpu data for cpuacct stats
Date: Wed, 18 Apr 2012 08:30:39 -0400
Message-ID: <CAFj3OHUzKDdS_3LrnTk+XaRVt+fGxWkvmh9cjv88Dt4n8Q39MA@mail.gmail.com>
References: <1334010315-4453-1-git-send-email-glommer@parallels.com>
	<1334010315-4453-5-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=XeNlj2gIG7ulIZMtCvdvjtu0nHJoujJFbVvXb9XRS74=;
        b=Tn5k7cPgGnWJFilMtMe5T/oFpwfaVtVhB79dCpL90DDtH1sKi9C8XdlspUkQ/T3TCz
         0dmyGATcRdiQMOq2qJ0B4e09HMV/9K2ofPVE+aCQYZRZZqWmMhF+FQMIVXkN3S7jYHGe
         XRkw5W8GdW74j63bar7d8WLbwOcvEJhnYrHSNWM/K322n01LPy6bY/6+2GNZxlY8Ztbg
         yu+urKHHzfK7PWU991A1Rqr1FYwHFl9MYIOQKrbf4wiRdDXXVoAaIbkjUiTQFVQofPil
         aqVqKA2IbN982Dc0OAbBS8ITn6xVVlB0+/iLNxUiTJd+wtYwjlWjBMIqbgCe9Amtbh9k
         o2/Q==
In-Reply-To: <1334010315-4453-5-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, lxc-users-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Andrew.Phillips-xheW4WVAX9Y@public.gmane.org

_

On Mon, Apr 9, 2012 at 6:25 PM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> w=
rote:
> The cpuacct cgroup already exposes user and system numbers in a per-c=
group
> fashion. But they are a summation along the whole group, not a per-cp=
u figure.
> Also, they are coarse-grained version of the stats usually shown at p=
laces
> like /proc/stat.
>
> I want to have enough cgroup data to emulate the /proc/stat interface=
=2E To
> achieve that, I am creating a new file "stat_percpu" that displays th=
e
> fine-grained per-cpu data. The original data is left alone.
>
> The format of this file resembles the one found in the usual cgroup's=
 stat
> files. But of course, the fields will be repeated, one per cpu, and p=
refixed
> with the cpu number.
>
> Therefore, we'll have something like:
>
> =A0cpu0.user X
> =A0cpu0.system Y
> =A0...
> =A0cpu1.user X1
> =A0cpu1.system Y1
> =A0...
>

Why not show the all-cpu data together with the per-cpu one?  I think
the total one
is an usual concern in most cases.

> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
>
> =A0kernel/sched/core.c | =A0 34 ++++++++++++++++++++++++++++++++++
> =A01 files changed, 34 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 1ee3772..52bae67 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -8186,6 +8186,35 @@ static int cpuacct_stats_show(struct cgroup *c=
grp, struct cftype *cft,
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> +static inline void do_fill_cb(struct cgroup_map_cb *cb, struct cpuac=
ct *ca,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *str, =
int cpu, int index)
> +{
> + =A0 =A0 =A0 char name[24];
> + =A0 =A0 =A0 struct kernel_cpustat *kcpustat =3D per_cpu_ptr(ca->cpu=
stat, cpu);
> +
> + =A0 =A0 =A0 snprintf(name, sizeof(name), "cpu%d.%s", cpu, str);
> + =A0 =A0 =A0 cb->fill(cb, name, cputime64_to_clock_t(kcpustat->cpust=
at[index]));
> +}
> +
> +static int cpuacct_stats_percpu_show(struct cgroup *cgrp, struct cft=
ype *cft,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0struct cgroup_map_cb *cb)
> +{
> + =A0 =A0 =A0 struct cpuacct *ca =3D cgroup_ca(cgrp);
> + =A0 =A0 =A0 int cpu;
> +
> + =A0 =A0 =A0 for_each_online_cpu(cpu) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 do_fill_cb(cb, ca, "user", cpu, CPUTIME=
_USER);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 do_fill_cb(cb, ca, "nice", cpu, CPUTIME=
_NICE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 do_fill_cb(cb, ca, "system", cpu, CPUTI=
ME_SYSTEM);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 do_fill_cb(cb, ca, "irq", cpu, CPUTIME_=
IRQ);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 do_fill_cb(cb, ca, "softirq", cpu, CPUT=
IME_SOFTIRQ);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 do_fill_cb(cb, ca, "guest", cpu, CPUTIM=
E_GUEST);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 do_fill_cb(cb, ca, "guest_nice", cpu, C=
PUTIME_GUEST_NICE);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> =A0static struct cftype files[] =3D {
> =A0 =A0 =A0 =A0{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.name =3D "usage",
> @@ -8200,6 +8229,11 @@ static struct cftype files[] =3D {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.name =3D "stat",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.read_map =3D cpuacct_stats_show,
> =A0 =A0 =A0 =A0},
> + =A0 =A0 =A0 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .name =3D "stat_percpu",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .read_map =3D cpuacct_stats_percpu_show=
,
> + =A0 =A0 =A0 },
> +
> =A0};
>
> =A0static int cpuacct_populate(struct cgroup_subsys *ss, struct cgrou=
p *cgrp)
> --
> 1.7.7.6
>
