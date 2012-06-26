From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v4 2/2] memcg: change mem_control_xxx to mem_cgroup_xxx
Date: Tue, 26 Jun 2012 12:54:37 -0700
Message-ID: <20120626125437.26050bb0.akpm@linux-foundation.org>
References: <1340622959-13136-1-git-send-email-liwp.linux@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340622959-13136-1-git-send-email-liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 25 Jun 2012 19:15:59 +0800
Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> 
> Unify memcg functions to mem_cgroup_xxx.

How about we unify memcg functions to memcg_xxx?

> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3999,7 +3999,7 @@ static int mem_cgroup_move_charge_write(struct cgroup *cgrp,
>  #endif
>  
>  #ifdef CONFIG_NUMA
> -static int mem_control_numa_stat_show(struct cgroup *cont, struct cftype *cft,
> +static int mem_cgroup_numa_stat_show(struct cgroup *cont, struct cftype *cft,
>  				      struct seq_file *m)

memcg_numa_stat_show(), etc.

