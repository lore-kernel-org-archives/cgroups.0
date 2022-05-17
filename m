From: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH bpf-next v2 2/7] cgroup: bpf: flush bpf stats on
 rstat flush
Date: Mon, 16 May 2022 19:08:40 -0700
Message-ID: <20220517020840.vyfp5cit66fs2k2o@MBP-98dd607d3435.dhcp.thefacebook.com>
References: <20220515023504.1823463-1-yosryahmed@google.com>
 <20220515023504.1823463-3-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EhSJRAeClIxsH0n9sFab63mgbLc++zW1P8KwkkDOW2c=;
        b=TyMBoeYxS5mFRDLo8Oqj9XZaCSAOh9T7N8WhHeJjjYmS+6pnKVHlvu84MWs1TsRPip
         VvubkItsCpn7YWwlPtPkWHs8WHI0UEhjulAhirwEZSuJP6tIFq/FSm5jiVxxr9XVT7zu
         sm0/2HJwRdtB6VIhHhINbgQXtEq4tI//dA4LG3MXuDJMmx05BAoRrX3uWhNKp7WKfr4d
         3JytCUziPR25LtgqezGXEyxdO/mca2I8ZjQ0huht40T4ryXHrHEgW3NRy44jIimGW74Q
         eKby9VSV7wUBO317XM2yhQZCBcE+WuHTeQElAzIvhXBNAyMthtgjz+HNyUtf57q5Kpwl
         dBAA==
Content-Disposition: inline
In-Reply-To: <20220515023504.1823463-3-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TZUIDd8j+nm9g@public.gmane.org

On Sun, May 15, 2022 at 02:34:59AM +0000, Yosry Ahmed wrote:
> +
> +void bpf_rstat_flush(struct cgroup *cgrp, int cpu)
> +{
> +	struct bpf_rstat_flusher *flusher;
> +	struct bpf_rstat_flush_ctx ctx = {
> +		.cgrp = cgrp,
> +		.parent = cgroup_parent(cgrp),
> +		.cpu = cpu,
> +	};
> +
> +	rcu_read_lock();
> +	migrate_disable();
> +	spin_lock(&bpf_rstat_flushers_lock);
> +
> +	list_for_each_entry(flusher, &bpf_rstat_flushers, list)
> +		(void) bpf_prog_run(flusher->prog, &ctx);
> +
> +	spin_unlock(&bpf_rstat_flushers_lock);
> +	migrate_enable();
> +	rcu_read_unlock();
> +}
> diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
> index 24b5c2ab5598..0285d496e807 100644
> --- a/kernel/cgroup/rstat.c
> +++ b/kernel/cgroup/rstat.c
> @@ -2,6 +2,7 @@
>  #include "cgroup-internal.h"
>  
>  #include <linux/sched/cputime.h>
> +#include <linux/bpf-rstat.h>
>  
>  static DEFINE_SPINLOCK(cgroup_rstat_lock);
>  static DEFINE_PER_CPU(raw_spinlock_t, cgroup_rstat_cpu_lock);
> @@ -168,6 +169,7 @@ static void cgroup_rstat_flush_locked(struct cgroup *cgrp, bool may_sleep)
>  			struct cgroup_subsys_state *css;
>  
>  			cgroup_base_stat_flush(pos, cpu);
> +			bpf_rstat_flush(pos, cpu);

Please use the following approach instead:

__weak noinline void bpf_rstat_flush(struct cgroup *cgrp, struct cgroup *parent, int cpu)
{
}

and change above line to:
  bpf_rstat_flush(pos, cgroup_parent(pos), cpu);

Then tracing bpf fentry progs will be able to attach to bpf_rstat_flush.
Pretty much the patches 1, 2, 3 are not necessary.
In patch 4 add bpf_cgroup_rstat_updated/flush as two kfuncs instead of stable helpers.

This way patches 1,2,3,4 will become 2 trivial patches and we will be
able to extend the interface between cgroup rstat and bpf whenever we need
without worrying about uapi stability.

We had similar discusison with HID subsystem that plans to use bpf in HID
with the same approach.
See this patch set:
https://lore.kernel.org/bpf/20220421140740.459558-2-benjamin.tissoires-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org/
You'd need patch 1 from it to enable kfuncs for tracing.

Your patch 5 is needed as-is.
Yonghong,
please review it.
Different approach for patch 1-4 won't affect patch 5.
Patches 6 and 7 look good.

With this approach that patch 7 will mostly stay as-is. Instead of:
+SEC("rstat/flush")
+int vmscan_flush(struct bpf_rstat_flush_ctx *ctx)
+{
+       struct vmscan_percpu *pcpu_stat;
+       struct vmscan *total_stat, *parent_stat;
+       struct cgroup *cgrp = ctx->cgrp, *parent = ctx->parent;

it will become

SEC("fentry/bpf_rstat_flush")
int BPF_PROG(vmscan_flush, struct cgroup *cgrp, struct cgroup *parent, int cpu)
