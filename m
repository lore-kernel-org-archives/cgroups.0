From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 1/2] mm: introduce memory.min
Date: Fri, 20 Apr 2018 10:01:04 -0700
Message-ID: <527af98a-8d7f-42ab-9ba8-71444ef7e25f@infradead.org>
References: <20180420163632.3978-1-guro@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Rk/w/5zPhGt5KGLe04p9SZJUsnIRlMTryTo2SVcxNDM=; b=n7omMFPuz3KMIfzw9Ud3APtdpW
        PtyMp6JR0cq7PkSIXrlJdDm8crfHGF1Ny5kJ/oUF64auPBy0fZoJf1VYxqcopxKdF7hz7GDzbq218
        kNPX9TdZZBzTJJxSbMk2e4iF+fh48Tk9iQ3HsBNDR4jJQRfmIIPkTfKQgXa0AbysawP7LqSlvj+LF
        TJt0i9rC5PQn3I2G4fP/Dk9cI3Prf0Tv0DSLEp+CmET1SvDo6lZCPa97kzzHLVUwjuA6nUhZm6wS/
        QC+Qzl2cc7RGgwI+c4F2CncakczoRcIuakAuIdGQB7IV711OA+F/89rrXInDV7zwzY9C2nXEIJgGC
      
In-Reply-To: <20180420163632.3978-1-guro@fb.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <guro@fb.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tejun Heo <tj@kernel.org>

On 04/20/18 09:36, Roman Gushchin wrote:

> ---
>  Documentation/cgroup-v2.txt  | 20 +++++++++
>  include/linux/memcontrol.h   | 15 ++++++-
>  include/linux/page_counter.h | 11 ++++-
>  mm/memcontrol.c              | 99 ++++++++++++++++++++++++++++++++++++--------
>  mm/page_counter.c            | 63 ++++++++++++++++++++--------
>  mm/vmscan.c                  | 19 ++++++++-
>  6 files changed, 189 insertions(+), 38 deletions(-)
> 
> diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
> index 657fe1769c75..49c846020f96 100644
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
> +	is within its effectife min boundary, the cgroup's memory

	              effective

> +	won't be reclaimed under any conditions. If there is no
> +	unprotected reclaimable memory available, OOM killer
> +	is invoked.
> +
> +	Effective low boundary is limited by memory.min values of
> +	all ancestor cgroups. If there is memory.mn overcommitment

	                                  memory.min ? overcommit

> +	(child cgroup or cgroups are requiring more protected memory,

	                                          drop ending ','  ^^

> +	than parent will allow), then each child cgroup will get
> +	the part of parent's protection proportional to the its

	                                             to its

> +	actual memory usage below memory.min.
> +
> +	Putting more memory than generally available under this
> +	protection is discouraged and may lead to constant OOMs.
> +
>    memory.low
>  	A read-write single value file which exists on non-root
>  	cgroups.  The default is "0".


-- 
~Randy
