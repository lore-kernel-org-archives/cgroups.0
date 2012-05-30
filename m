From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v3 3/6] expose fine-grained per-cpu data for cpuacct stats
Date: Wed, 30 May 2012 14:44:48 +0400
Message-ID: <4FC5FA20.50301@parallels.com>
References: <1338371317-5980-1-git-send-email-glommer@parallels.com>   <1338371317-5980-4-git-send-email-glommer@parallels.com>  <1338374041.26856.241.camel@twins> <4FC5F7A0.2000201@parallels.com> <1338374628.26856.244.camel@twins>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338374628.26856.244.camel@twins>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew.Phillips-xheW4WVAX9Y@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On 05/30/2012 02:43 PM, Peter Zijlstra wrote:
> On Wed, 2012-05-30 at 14:34 +0400, Glauber Costa wrote:
>> On 05/30/2012 02:34 PM, Peter Zijlstra wrote:
>>> On Wed, 2012-05-30 at 13:48 +0400, Glauber Costa wrote:
>>>
>>>> +static int cpuacct_stats_percpu_show(struct cgroup *cgrp, struct cftype *cft,
>>>> +				     struct cgroup_map_cb *cb)
>>>> +{
>>>> +	struct cpuacct *ca = cgroup_ca(cgrp);
>>>> +	int cpu;
>>>> +
>>>> +	for_each_online_cpu(cpu) {
>>>> +		do_fill_cb(cb, ca, "user", cpu, CPUTIME_USER);
>>>> +		do_fill_cb(cb, ca, "nice", cpu, CPUTIME_NICE);
>>>> +		do_fill_cb(cb, ca, "system", cpu, CPUTIME_SYSTEM);
>>>> +		do_fill_cb(cb, ca, "irq", cpu, CPUTIME_IRQ);
>>>> +		do_fill_cb(cb, ca, "softirq", cpu, CPUTIME_SOFTIRQ);
>>>> +		do_fill_cb(cb, ca, "guest", cpu, CPUTIME_GUEST);
>>>> +		do_fill_cb(cb, ca, "guest_nice", cpu, CPUTIME_GUEST_NICE);
>>>> +	}
>>>> +
>>>> +	return 0;
>>>> +}
>>>
>>> Uhm, hotplug anyone?
>> What's with hotplug ?
>
>
> Who's to say all cpus are online at this point? If you don't want to
> make the files come and go with hotplug, one should use
> for_each_possible_cpu().
>
I don't oppose that.
But I don't really parse what you mean by "make the files go away". We 
have just one file, with multiple entries. The entries are in key:value 
form, so I don't see a huge problem in having some entries disappearing.

As a matter of fact, this is exactly what happens in /proc/stat when you 
offline a cpu: the correspondent line will stop showing up.

