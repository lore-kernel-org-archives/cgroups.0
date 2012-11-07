From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 1/2] memcg, oom: provide more precise dump info while
 memcg oom happening
Date: Wed, 7 Nov 2012 23:17:09 +0100
Message-ID: <20121107221709.GB26382@dhcp22.suse.cz>
References: <1352277602-21687-1-git-send-email-handai.szj@taobao.com>
 <1352277696-21724-1-git-send-email-handai.szj@taobao.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Rc7bk1S6jCbJ9ihb1oTa7T11w/GbwbcgeyFbjceRfoY=;
        b=Bwvz27lEhQT1S1rcD6prKnwqdD+wo3+77vxF9dW2Mdp1QrJtsz11+CyhhTJJ2bdko7
         7Ik5eq8dept7tsHXfulU0r320b4LFCTGMK5zjpdf00RDBsvVITQzMmUy9wF1RYG9vAeL
         CP1FF0bJxmxEdHv0ytHnp3KMSW+cZMt6OjcPiXFLFKo3mTHoV75DteetBwIZ0JtI88yb
         OkJgGj9iObitqP4rxNTchhaaLGRMvCojh7nTOQuIGx2iZB/KJe2+kQKC/38paSmKA3Ok
         FKP2n4FMtrxxjlG2rUQgun1pAWjDwZmjlTRJysSDpNLHqRL2mQLgEbUXpnwFYZpuqNJD
         h46w==
Content-Disposition: inline
In-Reply-To: <1352277696-21724-1-git-send-email-handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Wed 07-11-12 16:41:36, Sha Zhengju wrote:
> From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> 
> Current, when a memcg oom is happening the oom dump messages is still global
> state and provides few useful info for users. This patch prints more pointed
> memcg page statistics for memcg-oom.
> 
> Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> ---
>  mm/memcontrol.c |   71 ++++++++++++++++++++++++++++++++++++++++++++++++-------
>  mm/oom_kill.c   |    6 +++-
>  2 files changed, 66 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 0eab7d5..2df5e72 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
[...]
> @@ -1501,8 +1509,59 @@ static void move_unlock_mem_cgroup(struct mem_cgroup *memcg,
>  	spin_unlock_irqrestore(&memcg->move_lock, *flags);
>  }
>  
> +#define K(x) ((x) << (PAGE_SHIFT-10))
> +static void mem_cgroup_print_oom_stat(struct mem_cgroup *memcg)
> +{
> +	struct mem_cgroup *mi;
> +	unsigned int i;
> +
> +	if (!memcg->use_hierarchy && memcg != root_mem_cgroup) {
> +		for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
> +			if (i == MEM_CGROUP_STAT_SWAP && !do_swap_account)
> +				continue;
> +			printk(KERN_CONT "%s:%ldKB ", mem_cgroup_stat_names[i],
> +				K(mem_cgroup_read_stat(memcg, i)));
> +		}
> +
> +		for (i = 0; i < MEM_CGROUP_EVENTS_NSTATS; i++)
> +			printk(KERN_CONT "%s:%lu ", mem_cgroup_events_names[i],
> +				mem_cgroup_read_events(memcg, i));
> +
> +		for (i = 0; i < NR_LRU_LISTS; i++)
> +			printk(KERN_CONT "%s:%luKB ", mem_cgroup_lru_names[i],
> +				K(mem_cgroup_nr_lru_pages(memcg, BIT(i))));
> +	} else {
> +
> +		for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
> +			long long val = 0;
> +
> +			if (i == MEM_CGROUP_STAT_SWAP && !do_swap_account)
> +				continue;
> +			for_each_mem_cgroup_tree(mi, memcg)
> +				val += mem_cgroup_read_stat(mi, i);
> +			printk(KERN_CONT "%s:%lldKB ", mem_cgroup_stat_names[i], K(val));
> +		}
> +
> +		for (i = 0; i < MEM_CGROUP_EVENTS_NSTATS; i++) {
> +			unsigned long long val = 0;
> +
> +			for_each_mem_cgroup_tree(mi, memcg)
> +				val += mem_cgroup_read_events(mi, i);
> +			printk(KERN_CONT "%s:%llu ",
> +				mem_cgroup_events_names[i], val);
> +		}
> +
> +		for (i = 0; i < NR_LRU_LISTS; i++) {
> +			unsigned long long val = 0;
> +
> +			for_each_mem_cgroup_tree(mi, memcg)
> +				val += mem_cgroup_nr_lru_pages(mi, BIT(i));
> +			printk(KERN_CONT "%s:%lluKB ", mem_cgroup_lru_names[i], K(val));
> +		}
> +	}

This is just plain ugly. for_each_mem_cgroup_tree is use_hierarchy aware
and there is no need for if (use_hierarchy) part.
memcg != root_mem_cgroup test doesn't make much sense as well because we
call that a global oom killer ;)
-- 
Michal Hocko
SUSE Labs
