From: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [cgroup:for-next 5/6] kernel/cpuset.c:1710:53: error: 'cpu_isolated_map'
 undeclared
Date: Mon, 02 Mar 2015 13:10:10 -0500
Message-ID: <54F4A782.4050605@redhat.com>
References: <201503030135.5JcSQnmv%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201503030135.5JcSQnmv%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On 03/02/2015 12:24 PM, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
> head:   43315c496d458ba0603c7f019d063bcbf3b6779e
> commit: 87793a671b15d945ea1c278c441af9e5b7d3dd73 [5/6] cpusets,isolcpus: add file to show isolated cpus in cpuset
> config: um-x86_64_defconfig (attached as .config)
> reproduce:
>   git checkout 87793a671b15d945ea1c278c441af9e5b7d3dd73
>   # save the attached .config to linux build tree
>   make ARCH=um SUBARCH=x86_64
> 
> All error/warnings:
> 
>    kernel/cpuset.c: In function 'cpuset_seq_print_isolcpus':
>>> kernel/cpuset.c:1710:53: error: 'cpu_isolated_map' undeclared (first use in this function)
>      cpumask_and(print_isolated_cpus, cs->cpus_allowed, cpu_isolated_map);
>                                                         ^
>    kernel/cpuset.c:1710:53: note: each undeclared identifier is reported only once for each function it appears in
> 
> vim +/cpu_isolated_map +1710 kernel/cpuset.c
> 
>   1704	
>   1705	/* protected by the lock in cpuset_common_seq_show */
>   1706	static cpumask_var_t print_isolated_cpus;
>   1707	
>   1708	static void cpuset_seq_print_isolcpus(struct seq_file *sf, struct cpuset *cs)
>   1709	{
>> 1710		cpumask_and(print_isolated_cpus, cs->cpus_allowed, cpu_isolated_map);
>   1711	
>   1712		seq_printf(sf, "%*pbl\n", cpumask_pr_args(print_isolated_cpus));
>   1713	}

This seems to break because the test is building a
UP kernel with CONFIG_CPUSETS=y

It should be fairly easy to fix this up by moving the
cpu_isolated_map outside CONFIG_SMP, but I wonder if
that is desirable to the scheduler people, especially
given that cpusets does not seem particularly useful
on a UP system...

I can see a few ways to fix this:

1) Move cpu_isolated_map outside CONFIG_SMP, like
   cpu_possible_mask, etc...

2) Change cpumask_and and related functions to just
   ignore all their arguments when building a UP
   kernel, which would allow us to drop cpu_possible_mask
   and others when building a UP kernel

3) Making CONFIG_CPUSETS dependent on CONFIG_SMP

Any preferences?

-- 
All rights reversed
