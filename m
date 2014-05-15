From: Stephen Warren <swarren-3lzwWm7+Weoh9ZMKESR00Q@public.gmane.org>
Subject: Re: [PATCH 9/9] cgroup: use cgroup->self.refcnt for cgroup refcnting
Date: Thu, 15 May 2014 13:07:14 -0600
Message-ID: <53751062.2050401@wwwdotorg.org>
References: <1399670015-23463-1-git-send-email-tj@kernel.org> <1399670015-23463-10-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1399670015-23463-10-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ARM kernel mailing list <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>

On 05/09/2014 03:13 PM, Tejun Heo wrote:
> Currently cgroup implements refcnting separately using atomic_t
> cgroup->refcnt.  The destruction paths of cgroup and css are rather
> complex and bear a lot of similiarities including the use of RCU and
> bouncing to a work item.
> 
> This patch makes cgroup use the refcnt of self css for refcnting
> instead of using its own.  This makes cgroup refcnting use css's
> percpu refcnt and share the destruction mechanism.
>...

In next-20150515, this patch causes silent boot failures on NVIDIA Tegra
ARM systems. There isn't even any earlyprintk. Reverting this one patch
solves this.

I was a bit surprised that cgroups would cause such an issue, but
looking at a normal kernel boot, I guess cgroup does get initialized
very early:

Uncompressing Linux... done, booting the kernel.
[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct

Anyway, I'll try to track down what the problem is, but if someone
familiar with this patch could give it a look, that'd be very useful,
since I'm not at all familiar with this code or feature.
