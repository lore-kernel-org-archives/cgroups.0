From: Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf-next v1 2/5] cgroup: bpf: add cgroup_rstat_updated()
 and cgroup_rstat_flush() kfuncs
Date: Fri, 20 May 2022 08:14:50 -0700
Message-ID: <fa3b35a6-5c3c-42a1-23f0-a8143b4eaa57@fb.com>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-3-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=dKI6dQu6wjTQjbRSozjt86cO6m+HuXIEEDaxEzrfdXE=;
 b=cEVdlanj8BCrlSJjXp/hdlknzURoKuEYi5hR/wOvfV//37i57MyLWD6iwdIXRh2xiOS7
 d5fLd2EYENREr21SDkQMsIP6cX/+el7uklp4nqPe1f1L3P0yrUNTJkKZeKEy96Z1oD8c
 lgEbo1blFr+2IMn3PKUqv+kYwGFsrrlYHnM= 
Content-Language: en-US
In-Reply-To: <20220520012133.1217211-3-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Yosry Ahmed <yosryahmed@google.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>
Cc: Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org



On 5/19/22 6:21 PM, Yosry Ahmed wrote:
> Add cgroup_rstat_updated() and cgroup_rstat_flush() kfuncs to bpf
> tracing programs. bpf programs that make use of rstat can use these
> functions to inform rstat when they update stats for a cgroup, and when
> they need to flush the stats.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---
>   kernel/cgroup/rstat.c | 35 ++++++++++++++++++++++++++++++++++-
>   1 file changed, 34 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
> index e7a88d2600bd..a16a851bc0a1 100644
> --- a/kernel/cgroup/rstat.c
> +++ b/kernel/cgroup/rstat.c
> @@ -3,6 +3,11 @@
>   
>   #include <linux/sched/cputime.h>
>   
> +#include <linux/bpf.h>
> +#include <linux/btf.h>
> +#include <linux/btf_ids.h>
> +
> +
>   static DEFINE_SPINLOCK(cgroup_rstat_lock);
>   static DEFINE_PER_CPU(raw_spinlock_t, cgroup_rstat_cpu_lock);
>   
> @@ -141,7 +146,12 @@ static struct cgroup *cgroup_rstat_cpu_pop_updated(struct cgroup *pos,
>   	return pos;
>   }
>   
> -/* A hook for bpf stat collectors to attach to and flush their stats */
> +/*
> + * A hook for bpf stat collectors to attach to and flush their stats.
> + * Together with providing bpf kfuncs for cgroup_rstat_updated() and
> + * cgroup_rstat_flush(), this enables a complete workflow where bpf progs that
> + * collect cgroup stats can integrate with rstat for efficient flushing.
> + */
>   __weak noinline void bpf_rstat_flush(struct cgroup *cgrp,
>   				     struct cgroup *parent, int cpu)
>   {
> @@ -476,3 +486,26 @@ void cgroup_base_stat_cputime_show(struct seq_file *seq)
>   		   "system_usec %llu\n",
>   		   usage, utime, stime);
>   }
> +
> +/* Add bpf kfuncs for cgroup_rstat_updated() and cgroup_rstat_flush() */
> +BTF_SET_START(bpf_rstat_check_kfunc_ids)
> +BTF_ID(func, cgroup_rstat_updated)
> +BTF_ID(func, cgroup_rstat_flush)
> +BTF_SET_END(bpf_rstat_check_kfunc_ids)
> +
> +BTF_SET_START(bpf_rstat_sleepable_kfunc_ids)
> +BTF_ID(func, cgroup_rstat_flush)
> +BTF_SET_END(bpf_rstat_sleepable_kfunc_ids)
> +
> +static const struct btf_kfunc_id_set bpf_rstat_kfunc_set = {
> +	.owner		= THIS_MODULE,
> +	.check_set	= &bpf_rstat_check_kfunc_ids,
> +	.sleepable_set	= &bpf_rstat_sleepable_kfunc_ids,

There is a compilation error here:

kernel/cgroup/rstat.c:503:3: error: ‘const struct btf_kfunc_id_set’ has 
no member named ‘sleepable_set’; did you mean ‘release_set’?
     503 |  .sleepable_set = &bpf_rstat_sleepable_kfunc_ids,
         |   ^~~~~~~~~~~~~
         |   release_set
   kernel/cgroup/rstat.c:503:19: warning: excess elements in struct 
initializer
     503 |  .sleepable_set = &bpf_rstat_sleepable_kfunc_ids,
         |                   ^
   kernel/cgroup/rstat.c:503:19: note: (near initialization for 
‘bpf_rstat_kfunc_set’)
   make[3]: *** [scripts/Makefile.build:288: kernel/cgroup/rstat.o] Error 1

Please fix.

> +};
> +
> +static int __init bpf_rstat_kfunc_init(void)
> +{
> +	return register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING,
> +					 &bpf_rstat_kfunc_set);
> +}
> +late_initcall(bpf_rstat_kfunc_init);
