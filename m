From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [v10 5/6] mm, oom: add cgroup v2 mount option for cgroup-aware
 OOM killer
Date: Wed, 4 Oct 2017 16:04:53 -0400
Message-ID: <20171004200453.GE1501@cmpxchg.org>
References: <20171004154638.710-1-guro@fb.com>
 <20171004154638.710-6-guro@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1+OkQSwRMW4tMSsWasFO6oH6g7d1kPW02CoCb+JU1Qs=; b=esDMtZN4GqnitGEWa362z4niEZ
        GejSl0h4ecGgGqaaXg1Edmaw1BL2EoP5ddUYON6RIORshoGL+dMYHIewkVZmlUf5+2hlIuD0Lhe0f
        ZoI38eFH/HsD2V+YGTK8EfrTQ7IIAwIwp9TL/LzEdoPmtJVCBJ0GabJVVEsC6g8Ml0Lw=;
Content-Disposition: inline
In-Reply-To: <20171004154638.710-6-guro-b10kYP2dOMg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Oct 04, 2017 at 04:46:37PM +0100, Roman Gushchin wrote:
> Add a "groupoom" cgroup v2 mount option to enable the cgroup-aware
> OOM killer. If not set, the OOM selection is performed in
> a "traditional" per-process way.
> 
> The behavior can be changed dynamically by remounting the cgroupfs.
>
> Signed-off-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
> Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: kernel-team-b10kYP2dOMg@public.gmane.org
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> ---
>  include/linux/cgroup-defs.h |  5 +++++
>  kernel/cgroup/cgroup.c      | 10 ++++++++++
>  mm/memcontrol.c             |  3 +++
>  3 files changed, 18 insertions(+)
> 
> diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
> index 3e55bbd31ad1..cae5343a8b21 100644
> --- a/include/linux/cgroup-defs.h
> +++ b/include/linux/cgroup-defs.h
> @@ -80,6 +80,11 @@ enum {
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
> index c3421ee0d230..8d8aa46ff930 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -1709,6 +1709,9 @@ static int parse_cgroup_root_flags(char *data, unsigned int *root_flags)
>  		if (!strcmp(token, "nsdelegate")) {
>  			*root_flags |= CGRP_ROOT_NS_DELEGATE;
>  			continue;
> +		} else if (!strcmp(token, "groupoom")) {
> +			*root_flags |= CGRP_GROUP_OOM;
> +			continue;
>  		}
>  
>  		pr_err("cgroup2: unknown option \"%s\"\n", token);
> @@ -1725,6 +1728,11 @@ static void apply_cgroup_root_flags(unsigned int root_flags)
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
> @@ -1732,6 +1740,8 @@ static int cgroup_show_options(struct seq_file *seq, struct kernfs_root *kf_root
>  {
>  	if (cgrp_dfl_root.flags & CGRP_ROOT_NS_DELEGATE)
>  		seq_puts(seq, ",nsdelegate");
> +	if (cgrp_dfl_root.flags & CGRP_GROUP_OOM)
> +		seq_puts(seq, ",groupoom");
>  	return 0;
>  }
>  
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1fcd6cc353d5..2e82625bd354 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2865,6 +2865,9 @@ bool mem_cgroup_select_oom_victim(struct oom_control *oc)
>  	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
>  		return false;
>  
> +	if (!(cgrp_dfl_root.flags & CGRP_GROUP_OOM))
> +		return false;

That will silently ignore what the user writes to the memory.oom_group
control files across the system's cgroup tree.

We'll have a knob that lets the workload declare itself an indivisible
memory consumer, that it would like to get killed in one piece, and
it's silently ignored because of a mount option they forgot to pass.

That's not good from an interface perspective.

On the other hand, the only benefit of this patch is to shield users
from changes to the OOM killing heuristics. Yet, it's really hard to
imagine that modifying the victim selection process slightly could be
called a regression in any way. We have done that many times over,
without a second thought on backwards compatibility:

5e9d834a0e0c oom: sacrifice child with highest badness score for parent
a63d83f427fb oom: badness heuristic rewrite
778c14affaf9 mm, oom: base root bonus on current usage

Let's not make the userspace interface crap because of some misguided
idea that the OOM heuristic is a hard promise to userspace. It's never
been, and nobody has complained about changes in the past.

This case is doubly silly, as the behavior change only applies to
cgroup2, which doesn't exactly have a large base of legacy users yet.

Let's just drop this 5/6 patch.
