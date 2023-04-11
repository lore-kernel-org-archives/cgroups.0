From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] memcg: Default value setting in memcg-v1
Date: Tue, 11 Apr 2023 11:10:25 +0200
Message-ID: <ZDUkAWT59seiD8+8@dhcp22.suse.cz>
References: <20230406091450.167779-1-shaun.tancheff@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1681204226; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J8OA3wgt+Z7nlPBRmZK8bnpZsdI2d7MNXaYAdmJPsgA=;
        b=F/GtwlKhIk6gdskzQIDdvelDeOaGATFGEdUdGAJRZ0+M/AzoL/mXWsiWKdBP7p6hsmGO59
        4HVw0kozzIL26HT6VfwUn7KEKjYxTMUGEEG0uWx0ZnCjvBrslPgt8pu3NYTmEkEhr3XplX
        znbWPl/iaqrIVPxft/0avEwyyDPAoZs=
Content-Disposition: inline
In-Reply-To: <20230406091450.167779-1-shaun.tancheff-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shaun Tancheff <shaun.tancheff-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shaun Tancheff <shaun.tancheff-ZPxbGqLxI0U@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 06-04-23 16:14:50, Shaun Tancheff wrote:
> From: Shaun Tancheff <shaun.tancheff-ZPxbGqLxI0U@public.gmane.org>
> 
> Setting min, low and high values with memcg-v1
> provides bennefits for  users that are unable to update
> to memcg-v2.

min, low and high limits are cgroup v2 concepts which are not a fit for
v1 implementation. The primary reason why v2 interface has been created
was that existing v1 interfaces and internal constrains (most
notably soft limit and tasks in inter nodes for memcg) were not
reformable. It is really hard to define a proper semantic for memory
protection when inter node tasks can compete with hierarchy beneath.

> Setting min, low and high can be set in memcg-v1
> to apply enough memory pressure to effective throttle
> filesystem I/O without hitting memcg oom.

This is not a proper way to achieve that. As I've already state in the
previous submission of a similar patch
(20230330202232.355471-1-shaun.tancheff-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org), cgroup v1 dirty data
throttling has some downsides because it cannot effectively throttle
GFP_NOFS allocations. One way around that is to reduce the dirty data
limit to prevent from over dirty memcg LRUs. I would recommend to move
forward to cgroup v2 though.

> This can be enabled by setting the sysctl values:
>   vm.memcg_v1_min_default
>   vm.memcg_v1_low_default
>   vm.memcg_v1_high_default
>
> When a memory control group is newly crated the
> min, low and high values are set to percent of the
> maximum based on the min, low and high default
> values respectively.

This also looks like an anti-pattern in the cgroup world. For two
reasons. First of all min, low (reclaim protection) is hierarchical and
global default value makes a very little sense for anything than flat
hierarchies and even then it makes it really easy to misconfigure system
too easily.
Also percentage is a very suboptimal interface in general as the
granularity is just too coarse for anything than small limits.
 
> This resolves an issue with memory pressure when users
> initiate unbounded I/O on various file systems such as
> ext4, XFS and NFS.

Filesystems should still be controllable by dirty limits. This might
lead to a suboptimal IO throughput but this might be a better workaround
if you cannot afford to move to cgroup v2. V1 interface is considered
legacy and support is limited. New features are only added if there
absolutely is not other way around to keep legacy applications running.

HTH
-- 
Michal Hocko
SUSE Labs
