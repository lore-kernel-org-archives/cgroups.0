From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 1/2] mm: introduce memory.min
Date: Fri, 20 Apr 2018 10:29:13 -0700
Message-ID: <e1ffe28c-841f-1714-7460-d2a6d309176c@infradead.org>
References: <20180420163632.3978-1-guro@fb.com>
 <527af98a-8d7f-42ab-9ba8-71444ef7e25f@infradead.org>
 <20180420172039.GA4965@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=oShycAtc7FeLgNixkM4wOWJ3Bqf05q4zgJqCxU3dUu8=; b=CTX3YQPRJPcc2ioD1VWT1ot7KF
        JpJneFna5Felot6EBhtsrM0qy2VF9OhAE9TzOCreyDk0DYovwhg5Hyu4oYvqPAEdQXB8l1PcsMdIB
        JQO6ivu+LUFBFt71ZMvhrMkpHJyLijT1ke/PThNhnw15invkKNAybyAkvr3Uz8yM94KiH5WhZxaQG
        U9Qp5dv+bz0gP/29v3/t65TNN0koOx4f7cMZM3jXZWB+m5QPci0GfYRYWknWzTA0Bb/WUJo+TsgHz
        t/aM6pj1tmpaL2vWcqnyjO44cf4H5HaJvdepAXBUluGNKzzO3ms93t6Mjcl/Rr056um7w2W6hW8nY
      
In-Reply-To: <20180420172039.GA4965@castle.DHCP.thefacebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tejun Heo <tj@kernel.org>

On 04/20/18 10:20, Roman Gushchin wrote:
> 
> Hi, Randy!
> 
> An updated version below.
> 
> Thanks!

OK, looks good now. Thanks.

FWIW:
Reviewed-by: Randy Dunlap <rdunlap@infradead.org> # for Documentation/ only.

> ------------------------------------------------------------
> 
> 
> From 2225fa0b3400431dd803f206b20a9344f0dfcd0a Mon Sep 17 00:00:00 2001
> From: Roman Gushchin <guro@fb.com>
> Date: Fri, 20 Apr 2018 15:24:44 +0100
> Subject: [PATCH 1/2] mm: introduce memory.min
> 
> Memory controller implements the memory.low best-effort memory
> protection mechanism, which works perfectly in many cases and
> allows protecting working sets of important workloads from
> sudden reclaim.
> 
> But it's semantics has a significant limitation: it works
> only until there is a supply of reclaimable memory.
> This makes it pretty useless against any sort of slow memory
> leaks or memory usage increases. This is especially true
> for swapless systems. If swap is enabled, memory soft protection
> effectively postpones problems, allowing a leaking application
> to fill all swap area, which makes no sense.
> The only effective way to guarantee the memory protection
> in this case is to invoke the OOM killer.
> 
> This patch introduces the memory.min interface for cgroup v2
> memory controller. It works very similarly to memory.low
> (sharing the same hierarchical behavior), except that it's
> not disabled if there is no more reclaimable memory in the system.
> 
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> ---
>  Documentation/cgroup-v2.txt  | 24 ++++++++++-
>  include/linux/memcontrol.h   | 15 ++++++-
>  include/linux/page_counter.h | 11 ++++-
>  mm/memcontrol.c              | 99 ++++++++++++++++++++++++++++++++++++--------
>  mm/page_counter.c            | 63 ++++++++++++++++++++--------
>  mm/vmscan.c                  | 19 ++++++++-
>  6 files changed, 191 insertions(+), 40 deletions(-)
> 
> diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
> index 657fe1769c75..a413118b9c29 100644
> --- a/Documentation/cgroup-v2.txt
> +++ b/Documentation/cgroup-v2.txt
> @@ -1002,6 +1002,26 @@ PAGE_SIZE multiple when read back.
>  	The total amount of memory currently being used by the cgroup
>  	and its descendants.
>  
> +  memory.min
> +	A read-write single value file which exists on non-root
> +	cgroups.  The default is "0".
> +
> +	Hard memory protection.  If the memory usage of a cgroup
> +	is within its effective min boundary, the cgroup's memory
> +	won't be reclaimed under any conditions. If there is no
> +	unprotected reclaimable memory available, OOM killer
> +	is invoked.
> +
> +	Effective low boundary is limited by memory.min values of
> +	all ancestor cgroups. If there is memory.min overcommitment
> +	(child cgroup or cgroups are requiring more protected memory
> +	than parent will allow), then each child cgroup will get
> +	the part of parent's protection proportional to its
> +	actual memory usage below memory.min.
> +
> +	Putting more memory than generally available under this
> +	protection is discouraged and may lead to constant OOMs.
> +
>    memory.low
>  	A read-write single value file which exists on non-root
>  	cgroups.  The default is "0".
> @@ -1013,9 +1033,9 @@ PAGE_SIZE multiple when read back.
>  
>  	Effective low boundary is limited by memory.low values of
>  	all ancestor cgroups. If there is memory.low overcommitment
> -	(child cgroup or cgroups are requiring more protected memory,
> +	(child cgroup or cgroups are requiring more protected memory
>  	than parent will allow), then each child cgroup will get
> -	the part of parent's protection proportional to the its
> +	the part of parent's protection proportional to its
>  	actual memory usage below memory.low.
>  
>  	Putting more memory than generally available under this



-- 
~Randy
