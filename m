From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v13 5/7] mm, oom: add cgroup v2 mount option for
 cgroup-aware OOM killer
Date: Fri, 1 Dec 2017 09:41:13 +0100
Message-ID: <20171201084113.47lnuo3diwxts732@dhcp22.suse.cz>
References: <20171130152824.1591-1-guro@fb.com>
 <20171130152824.1591-6-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171130152824.1591-6-guro@fb.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@vger.kernel.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Thu 30-11-17 15:28:22, Roman Gushchin wrote:
> Add a "groupoom" cgroup v2 mount option to enable the cgroup-aware
> OOM killer. If not set, the OOM selection is performed in
> a "traditional" per-process way.
> 
> The behavior can be changed dynamically by remounting the cgroupfs.

Is it ok to create oom_group if the option is not enabled? This looks
confusing. I forgot all the details about how cgroup core creates file
so I do not have a good idea how to fix this.

> Signed-off-by: Roman Gushchin <guro@fb.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: kernel-team@fb.com
> Cc: cgroups@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org
> ---
>  include/linux/cgroup-defs.h |  5 +++++
>  kernel/cgroup/cgroup.c      | 10 ++++++++++
>  mm/memcontrol.c             |  3 +++
>  3 files changed, 18 insertions(+)
> 
> diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
> index 8b7fd8eeccee..9fb99e25d654 100644
> --- a/include/linux/cgroup-defs.h
> +++ b/include/linux/cgroup-defs.h
> @@ -81,6 +81,11 @@ enum {
>  	 * Enable cpuset controller in v1 cgroup to use v2 behavior.
>  	 */
>  	CGRP_ROOT_CPUSET_V2_MODE = (1 << 4),
> +
> +	/*
> +	 * Enable cgroup-aware OOM killer.
> +	 */
> +	CGRP_GROUP_OOM = (1 << 5),
>  };
>  
>  /* cftype->flags */
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 0b1ffe147f24..7338e12979e1 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -1731,6 +1731,9 @@ static int parse_cgroup_root_flags(char *data, unsigned int *root_flags)
>  		if (!strcmp(token, "nsdelegate")) {
>  			*root_flags |= CGRP_ROOT_NS_DELEGATE;
>  			continue;
> +		} else if (!strcmp(token, "groupoom")) {
> +			*root_flags |= CGRP_GROUP_OOM;
> +			continue;
>  		}
>  
>  		pr_err("cgroup2: unknown option \"%s\"\n", token);
> @@ -1747,6 +1750,11 @@ static void apply_cgroup_root_flags(unsigned int root_flags)
>  			cgrp_dfl_root.flags |= CGRP_ROOT_NS_DELEGATE;
>  		else
>  			cgrp_dfl_root.flags &= ~CGRP_ROOT_NS_DELEGATE;
> +
> +		if (root_flags & CGRP_GROUP_OOM)
> +			cgrp_dfl_root.flags |= CGRP_GROUP_OOM;
> +		else
> +			cgrp_dfl_root.flags &= ~CGRP_GROUP_OOM;
>  	}
>  }
>  
> @@ -1754,6 +1762,8 @@ static int cgroup_show_options(struct seq_file *seq, struct kernfs_root *kf_root
>  {
>  	if (cgrp_dfl_root.flags & CGRP_ROOT_NS_DELEGATE)
>  		seq_puts(seq, ",nsdelegate");
> +	if (cgrp_dfl_root.flags & CGRP_GROUP_OOM)
> +		seq_puts(seq, ",groupoom");
>  	return 0;
>  }
>  
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 5d27a4bbd478..c76d5fb55c5c 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2869,6 +2869,9 @@ bool mem_cgroup_select_oom_victim(struct oom_control *oc)
>  	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
>  		return false;
>  
> +	if (!(cgrp_dfl_root.flags & CGRP_GROUP_OOM))
> +		return false;
> +
>  	if (oc->memcg)
>  		root = oc->memcg;
>  	else
> -- 
> 2.14.3

-- 
Michal Hocko
SUSE Labs
