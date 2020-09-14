From: Xunlei Pang <xlpang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH] mm: memcg: yield cpu when we fail to charge pages
Date: Mon, 14 Sep 2020 12:15:27 +0800
Message-ID: <c21b1788-6bf0-b675-7066-396f21da2c76@linux.alibaba.com>
References: <20200908185051.62420-1-jpitti@cisco.com>
Reply-To: xlpang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200908185051.62420-1-jpitti-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Julius Hemanth Pitti <jpitti-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xe-linux-external-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org

On 2020/9/9 AM2:50, Julius Hemanth Pitti wrote:
> For non root CG, in try_charge(), we keep trying
> to charge until we succeed. On non-preemptive
> kernel, when we are OOM, this results in holding
> CPU forever.
> 
> On SMP systems, this doesn't create a big problem
> because oom_reaper get a change to kill victim
> and make some free pages. However on a single-core
> CPU (or cases where oom_reaper pinned to same CPU
> where try_charge is executing), oom_reaper shall
> never get scheduled and we stay in try_charge forever.
> 
> Steps to repo this on non-smp:
> 1. mount -t tmpfs none /sys/fs/cgroup
> 2. mkdir /sys/fs/cgroup/memory
> 3. mount -t cgroup none /sys/fs/cgroup/memory -o memory
> 4. mkdir /sys/fs/cgroup/memory/0
> 5. echo 40M > /sys/fs/cgroup/memory/0/memory.limit_in_bytes
> 6. echo $$ > /sys/fs/cgroup/memory/0/tasks
> 7. stress -m 5 --vm-bytes 10M --vm-hang 0
> 
> Signed-off-by: Julius Hemanth Pitti <jpitti-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> ---
>  mm/memcontrol.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 0d6f3ea86738..4620d70267cb 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2652,6 +2652,8 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	if (fatal_signal_pending(current))
>  		goto force;
>  
> +	cond_resched();
> +
>  	/*
>  	 * keep retrying as long as the memcg oom killer is able to make
>  	 * a forward progress or bypass the charge if the oom killer
> 

This should be fixed by:
https://lkml.org/lkml/2020/8/26/1440

Thanks,
Xunlei
