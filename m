From: Paul Turner <pjt@google.com>
Subject: Re: [PATCH v3 3/6] expose fine-grained per-cpu data for cpuacct stats
Date: Wed, 30 May 2012 04:24:29 -0700
Message-ID: <CAPM31RJanAvDB+pZ+h5J3W6KXvAwPgbbeXgw6C_56tx_Mc+cgA@mail.gmail.com>
References: <1338371317-5980-1-git-send-email-glommer@parallels.com> <1338371317-5980-4-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding:x-system-of-record;
        bh=yiQHUagw7Zr2XN8yzrSxAQmFoEEwzJ9WgDnndf82jCE=;
        b=hHH9+qcMtESdjNETFMhSNFxQhS6H7uiVo+zCrS7qGi09GvnGz+sDHO7/ejCKtyYTKC
         ctavTwpzRA6HNbvMfAtNSQU6AKGCKgOR2qdAVYeZJ2NiymBEp5aGls8CsbYSIhdSjADG
         E7kpgQQsJoH+F/bc+unakPILLdaupDSCqercumN6MgpXHGyORFaaCkSMMR8yK+cg/vv4
         c+Rz0Vtjb/xTXNecVBs/L28RXIiJJft5NBubfjF+h1oc1w9NSBiNrcTl1s8gmcy3VszQ
         9i6LdlC1IZvhfkXXoHuypS5BIn2r778Gc8GftImKvKZy3FpB439bG9sAUr0bBqcrn/QJ
         Fctw==
In-Reply-To: <1338371317-5980-4-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, devel@openvz.org, Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, handai.szj@gmail.com, Andrew.Phillips@lmax.com, Serge Hallyn <serge.hallyn@canonical.com>

On Wed, May 30, 2012 at 2:48 AM, Glauber Costa <glommer@parallels.com> =
wrote:
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
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Paul Turner <pjt@google.com>
> ---
> =A0kernel/sched/core.c | =A0 33 +++++++++++++++++++++++++++++++++
> =A01 file changed, 33 insertions(+)
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 220d416..4c1d7e9 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -8178,6 +8178,35 @@ static int cpuacct_stats_show(struct cgroup *c=
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

I don't know if there's much that can be trivially done about it but I
suspect these are a bit of a memory allocation time-bomb on a many-CPU
machine.  The cgroup:seq_file mating (via read_map) treats everything
as /one/ record.  This means that seq_printf is going to end up
eventually allocating a buffer that can fit _everything_ (as well as
every power-of-2 on the way there).  Adding insult to injury is that
that the backing buffer is kmalloc() not vmalloc().

200+ bytes per-cpu above really is not unreasonable (46 bytes just for
the text, plus a byte per base 10 digit we end up reporting), but that
then  leaves us looking at order-12/13 allocations just to print this
thing when there are O(many) cpus.

> + =A0 =A0 =A0 return 0;
> +}
> +
> =A0static struct cftype files[] =3D {
> =A0 =A0 =A0 =A0{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.name =3D "usage",
> @@ -8192,6 +8221,10 @@ static struct cftype files[] =3D {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.name =3D "stat",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.read_map =3D cpuacct_stats_show,
> =A0 =A0 =A0 =A0},
> + =A0 =A0 =A0 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .name =3D "stat_percpu",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .read_map =3D cpuacct_stats_percpu_show=
,
> + =A0 =A0 =A0 },
> =A0 =A0 =A0 =A0{ } =A0 =A0 /* terminate */
> =A0};
>
> --
> 1.7.10.2
>
