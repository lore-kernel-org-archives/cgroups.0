From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 7/7] memcg: print more detailed info while memcg oom happening
Date: Wed, 04 Jul 2012 16:25:44 +0800
Message-ID: <4FF3FE08.3090302@gmail.com>
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com> <1340881609-5935-1-git-send-email-handai.szj@taobao.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=MMyVPzCK2TxTQ2T4ybPCTC2qZbixQ7MMZLpqtAaHWgw=;
        b=K1iyqxdy/wKk7P7d7bQRIf3sGw9oHjRnYLMCyWaTQZtZtQpOcDLiFLrqhjOdQBRMD9
         zAT8egKZsdGR3WWXISAxJI4EuGrbWM6QSLylAooDXEs+w8Zve4VDWPsxlP+5Ki8e4KyX
         OJc1jTvtFT3DLUiPSqoTxfzShf01+s9AVrrUc+LhCGvvytRdk4v84B2hKJG+JcGDGkiv
         m8JLG0uTJCaXHbOxszn/9wn5K4lgNvpq7ziVJAvCWOZc9hSZ8RQt1VB2Kte0UglJHT7l
         kV5OqFKk/3ggvQYGGk7VQm5Snh37NVq+DaXOJPKjoMcjy7wLEVrf29cqs/FJu3gjbpbm
         ZHCQ==
In-Reply-To: <1340881609-5935-1-git-send-email-handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

Hi, Kame

How about this bit=EF=BC=9F :-)

On 06/28/2012 07:06 PM, Sha Zhengju wrote:
> From: Sha Zhengju<handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>
> While memcg oom happening, the dump info is limited, so add this
> to provide memcg page stat.
>
> Signed-off-by: Sha Zhengju<handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> ---
>   mm/memcontrol.c |   42 ++++++++++++++++++++++++++++++++++--------
>   1 files changed, 34 insertions(+), 8 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8493119..3ed41e9 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -101,6 +101,14 @@ static const char * const mem_cgroup_events_name=
s[] =3D {
>   	"pgmajfault",
>   };
>
> +static const char * const mem_cgroup_lru_names[] =3D {
> +	"inactive_anon",
> +	"active_anon",
> +	"inactive_file",
> +	"active_file",
> +	"unevictable",
> +};
> +
>   /*
>    * Per memcg event counter is incremented at every pagein/pageout. =
With THP,
>    * it will be incremated by the number of pages. This counter is us=
ed for
> @@ -1358,6 +1366,30 @@ static void move_unlock_mem_cgroup(struct mem_=
cgroup *memcg,
>   	spin_unlock_irqrestore(&memcg->move_lock, *flags);
>   }
>
> +#define K(x) ((x)<<  (PAGE_SHIFT-10))
> +static void mem_cgroup_print_oom_stat(struct mem_cgroup *memcg)
> +{
> +	int i;
> +
> +	printk(KERN_INFO "Memory cgroup stat:\n");
> +	for (i =3D 0; i<  MEM_CGROUP_STAT_NSTATS; i++) {
> +		if (i =3D=3D MEM_CGROUP_STAT_SWAP&&  !do_swap_account)
> +			continue;
> +		printk(KERN_CONT "%s:%ldKB ", mem_cgroup_stat_names[i],
> +			   K(mem_cgroup_read_stat(memcg, i)));
> +	}
> +
> +	for (i =3D 0; i<  MEM_CGROUP_EVENTS_NSTATS; i++)
> +		printk(KERN_CONT "%s:%lu ", mem_cgroup_events_names[i],
> +			   mem_cgroup_read_events(memcg, i));
> +
> +	for (i =3D 0; i<  NR_LRU_LISTS; i++)
> +		printk(KERN_CONT "%s:%luKB ", mem_cgroup_lru_names[i],
> +			   K(mem_cgroup_nr_lru_pages(memcg, BIT(i))));
> +	printk(KERN_CONT "\n");
> +
> +}
> +
>   /**
>    * mem_cgroup_print_oom_info: Called from OOM with tasklist_lock he=
ld in read mode.
>    * @memcg: The memory cgroup that went over limit
> @@ -1422,6 +1454,8 @@ done:
>   		res_counter_read_u64(&memcg->memsw, RES_USAGE)>>  10,
>   		res_counter_read_u64(&memcg->memsw, RES_LIMIT)>>  10,
>   		res_counter_read_u64(&memcg->memsw, RES_FAILCNT));
> +
> +	mem_cgroup_print_oom_stat(memcg);
>   }
>
>   /*
> @@ -4043,14 +4077,6 @@ static int mem_control_numa_stat_show(struct c=
group *cont, struct cftype *cft,
>   }
>   #endif /* CONFIG_NUMA */
>
> -static const char * const mem_cgroup_lru_names[] =3D {
> -	"inactive_anon",
> -	"active_anon",
> -	"inactive_file",
> -	"active_file",
> -	"unevictable",
> -};
> -
>   static inline void mem_cgroup_lru_names_not_uptodate(void)
>   {
>   	BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_lru_names) !=3D NR_LRU_LISTS);
