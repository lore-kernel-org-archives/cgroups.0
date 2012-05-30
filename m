From: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
Subject: Re: [PATCH v3 3/6] expose fine-grained per-cpu data for cpuacct
 stats
Date: Wed, 30 May 2012 12:34:01 +0200
Message-ID: <1338374041.26856.241.camel@twins>
References: <1338371317-5980-1-git-send-email-glommer@parallels.com>
	 <1338371317-5980-4-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338371317-5980-4-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew.Phillips-xheW4WVAX9Y@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On Wed, 2012-05-30 at 13:48 +0400, Glauber Costa wrote:

> +static int cpuacct_stats_percpu_show(struct cgroup *cgrp, struct cftype *cft,
> +				     struct cgroup_map_cb *cb)
> +{
> +	struct cpuacct *ca = cgroup_ca(cgrp);
> +	int cpu;
> +
> +	for_each_online_cpu(cpu) {
> +		do_fill_cb(cb, ca, "user", cpu, CPUTIME_USER);
> +		do_fill_cb(cb, ca, "nice", cpu, CPUTIME_NICE);
> +		do_fill_cb(cb, ca, "system", cpu, CPUTIME_SYSTEM);
> +		do_fill_cb(cb, ca, "irq", cpu, CPUTIME_IRQ);
> +		do_fill_cb(cb, ca, "softirq", cpu, CPUTIME_SOFTIRQ);
> +		do_fill_cb(cb, ca, "guest", cpu, CPUTIME_GUEST);
> +		do_fill_cb(cb, ca, "guest_nice", cpu, CPUTIME_GUEST_NICE);
> +	}
> +
> +	return 0;
> +}

Uhm, hotplug anyone?
