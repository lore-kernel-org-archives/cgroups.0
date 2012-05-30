From: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
Subject: Re: [PATCH v3 6/6] expose per-taskgroup schedstats in cgroup
Date: Wed, 30 May 2012 13:22:47 +0200
Message-ID: <1338376967.26856.262.camel@twins>
References: <1338371317-5980-1-git-send-email-glommer@parallels.com>
	 <1338371317-5980-7-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338371317-5980-7-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew.Phillips-xheW4WVAX9Y@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On Wed, 2012-05-30 at 13:48 +0400, Glauber Costa wrote:
> +static u64 tg_idle(struct task_group *tg, int cpu)
> +{
> +       u64 val;
> +
> +       if (tg != &root_task_group) {
> +               val = cfs_read_sleep(tg->se[cpu]);
> +               /* If we have rt tasks running, we're not really idle */
> +               val -= rt_rq(exec_clock, tg, cpu);
> +       } else
> +               /*
> +                * There are many errors here that we are accumulating.
> +                * However, we only provide this in the interest of having
> +                * a consistent interface for all cgroups. Everybody
> +                * probing the root cgroup should be getting its figures
> +                * from system-wide files as /proc/stat. That would be faster
> +                * to begin with...
> +                *
> +                * Ditto for steal.
> +                */
> +               val = kcpustat_cpu(cpu).cpustat[CPUTIME_IDLE] * TICK_NSEC;

You just violated 2 coding style rules in one go :-)

If one side of the if-else has braces, the other side should have too.
If a block is multi-line (regardless of multi-stmt) it should have
braces.

/me hands you a bucket full of {}.

> +       return val;
> +} 
