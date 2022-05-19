From: Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH] memcg: provide reclaim stats via 'memory.reclaim'
Date: Thu, 19 May 2022 00:59:47 -0700
Message-ID: <xr937d6ic5qk.fsf@gthelen2.svl.corp.google.com>
References: <20220518223815.809858-1-vaibhav@linux.ibm.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5ASte9vGYV8NmyufWXTtDt+wnTToG5G7bVCsDgy4Kpg=;
        b=gwTVGnSBCH1OItkK8408hxAE3H+3MOivih34m7SBHEGT0+6hAZOMLNPptS8SIvLmuk
         dn2y46gEkcFMT6rDddZ+v7a37E4u+yB8m9HWh7XNQNIo8o+qpgOH/q9QPz/KwdaFOIVV
         Nq6tzQ02jiflJjryDeixn4W/tNmMMnumKiTZ36ZxRroI3RPCmJHaY4M7pNq/lV3jccpO
         rZPjU/9DuAsZ2bqhz0zyrw8D0P4kaiQK7kHNRTbeHzkIcduFAaVBVEqNoXOd8BJqnfd4
         NYrOoQgzKjbdFMCsMqLS1DyP1f9llOtIzlwbiTSrOq7EO3K9qk7QpbKFIsyOkuDu1TuB
         Mt5A==
In-Reply-To: <20220518223815.809858-1-vaibhav@linux.ibm.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vaibhav Jain <vaibhav@linux.ibm.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>, Shakeel Butt <shakeelb@google.com>, Yosry Ahmed <yosryahmed@google.com>

Vaibhav Jain <vaibhav@linux.ibm.com> wrote:

> [1] Provides a way for user-space to trigger proactive reclaim by introducing
> a write-only memcg file 'memory.reclaim'. However reclaim stats like number
> of pages scanned and reclaimed is still not directly available to the
> user-space.
>
> This patch proposes to extend [1] to make the memcg file 'memory.reclaim'
> readable which returns the number of pages scanned / reclaimed during the
> reclaim process from 'struct vmpressure' associated with each memcg. This should
> let user-space asses how successful proactive reclaim triggered from memcg
> 'memory.reclaim' was ?
>
> With the patch following command flow is expected:
>
>  # echo "1M" > memory.reclaim
>
>  # cat memory.reclaim
>    scanned 76
>    reclaimed 32

I certainly appreciate the ability for shell scripts to demonstrate
cgroup operations with textual interfaces, but such interface seem like
they are optimized for ease of use by developers.

I wonder if for runtime production use an ioctl or netlink interface has
been considered for cgroup? I don't think there are any yet, but such
approaches seem like a more straightforward ways to get nontrivial
input/outputs from a single call (e.g. like this proposal). And they
have the benefit of not requiring ascii serialization/parsing overhead.

> [1]:  https://lore.kernel.org/r/20220425190040.2475377-1-yosryahmed@google.com
>
> Cc: Shakeel Butt <shakeelb@google.com>
> Cc: Yosry Ahmed <yosryahmed@google.com>
> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
> ---
>  Documentation/admin-guide/cgroup-v2.rst | 15 ++++++++++++---
>  mm/memcontrol.c                         | 14 ++++++++++++++
>  2 files changed, 26 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 27ebef2485a3..44610165261d 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1209,18 +1209,27 @@ PAGE_SIZE multiple when read back.
>  	utility is limited to providing the final safety net.
>  
>    memory.reclaim
> -	A write-only nested-keyed file which exists for all cgroups.
> +	A nested-keyed file which exists for all cgroups.
>  
> -	This is a simple interface to trigger memory reclaim in the
> -	target cgroup.
> +	This is a simple interface to trigger memory reclaim and retrieve
> +	reclaim stats in the target cgroup.
>  
>  	This file accepts a single key, the number of bytes to reclaim.
>  	No nested keys are currently supported.
>  
> +	Reading the file returns number of pages scanned and number of
> +	pages reclaimed from the memcg. This information fetched from
> +	vmpressure info associated with each cgroup.
> +
>  	Example::
>  
>  	  echo "1G" > memory.reclaim
>  
> +	  cat memory.reclaim
> +
> +	  scanned 78
> +	  reclaimed 30
> +
>  	The interface can be later extended with nested keys to
>  	configure the reclaim behavior. For example, specify the
>  	type of memory to reclaim from (anon, file, ..).
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 2e2bfbed4717..9e43580a8726 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6423,6 +6423,19 @@ static ssize_t memory_oom_group_write(struct kernfs_open_file *of,
>  	return nbytes;
>  }
>  
> +static int memory_reclaim_show(struct seq_file *m, void *v)
> +{
> +	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
> +	struct vmpressure *vmpr = memcg_to_vmpressure(memcg);
> +
> +	spin_lock(&vmpr->sr_lock);
> +	seq_printf(m, "scanned %lu\nreclaimed %lu\n",
> +		   vmpr->scanned, vmpr->reclaimed);
> +	spin_unlock(&vmpr->sr_lock);
> +
> +	return 0;
> +}
> +
>  static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
>  			      size_t nbytes, loff_t off)
>  {
> @@ -6525,6 +6538,7 @@ static struct cftype memory_files[] = {
>  		.name = "reclaim",
>  		.flags = CFTYPE_NS_DELEGATABLE,
>  		.write = memory_reclaim,
> +		.seq_show  = memory_reclaim_show,
>  	},
>  	{ }	/* terminate */
>  };
