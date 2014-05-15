From: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 9/9] cgroup: use cgroup->self.refcnt for cgroup refcnting
Date: Thu, 15 May 2014 15:56:51 -0600
Message-ID: <53753823.2090402@wwwdotorg.org>
References: <1399670015-23463-1-git-send-email-tj@kernel.org> <1399670015-23463-10-git-send-email-tj@kernel.org> <53751062.2050401@wwwdotorg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <53751062.2050401@wwwdotorg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>, ARM kernel mailing list <linux-arm-kernel@lists.infradead.org>

On 05/15/2014 01:07 PM, Stephen Warren wrote:
> On 05/09/2014 03:13 PM, Tejun Heo wrote:
>> Currently cgroup implements refcnting separately using atomic_t
>> cgroup->refcnt.  The destruction paths of cgroup and css are rather
>> complex and bear a lot of similiarities including the use of RCU and
>> bouncing to a work item.
>>
>> This patch makes cgroup use the refcnt of self css for refcnting
>> instead of using its own.  This makes cgroup refcnting use css's
>> percpu refcnt and share the destruction mechanism.
>> ...
> 
> In next-20150515, this patch causes silent boot failures on NVIDIA Tegra
> ARM systems. There isn't even any earlyprintk. Reverting this one patch
> solves this.
> 
> I was a bit surprised that cgroups would cause such an issue, but
> looking at a normal kernel boot, I guess cgroup does get initialized
> very early:
> 
> Uncompressing Linux... done, booting the kernel.
> [    0.000000] Booting Linux on physical CPU 0x0
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Initializing cgroup subsys cpuacct
> 
> Anyway, I'll try to track down what the problem is, but if someone
> familiar with this patch could give it a look, that'd be very useful,
> since I'm not at all familiar with this code or feature.

It looks like this has something to do with the new code using percpu_
functions from within cgroup_init_early, yet that function being called
before init/main.c calls setup_per_cpu_areas() etc.? Unfortunately I
have to run to some meetings now, so won't look at this until tomorrow.
