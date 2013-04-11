From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: remove bind() method from cgroup_subsys.
Date: Thu, 11 Apr 2013 10:02:07 +0800
Message-ID: <5166199F.7090104@huawei.com>
References: <1365594077-17655-1-git-send-email-ramirose@gmail.com> <20130410175035.GA17641@mtj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130410175035.GA17641-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Rami Rosen <ramirose-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

Cc: Galuber

On 2013/4/11 1:50, Tejun Heo wrote:
>>From 84cfb6ab484b442d5115eb3baf9db7d74a3ea626 Mon Sep 17 00:00:00 2001
> From: Rami Rosen <ramirose-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Date: Wed, 10 Apr 2013 14:41:17 +0300
> 
> The bind() method of cgroup_subsys is not used in any of the
> controllers (cpuset, freezer, blkio, net_cls, memcg, net_prio,
> devices, perf, hugetlb, cpu and cpuacct)
> 

I remember Glauber once used the bind() callback to detect if cpuacct and
cpu are mounted together and if so do some optimization.

Then he gave up on it and just deprecated cpuacct, but then it was decided
that it can't be decprecated and removed as that will break userspace.

So mayber Glauber will want to use this callback again?

> tj: Removed the entry on ->bind() from
>     Documentation/cgroups/cgroups.txt.  Also updated a couple
>     paragraphs which were suggesting that dynamic re-binding may be
>     implemented.  It's not gonna.
> 
> Signed-off-by: Rami Rosen <ramirose-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
> Applied to cgroup/for-3.10 with documentation updated.
> 
