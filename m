From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH bpf-next v1 5/5] bpf: add a selftest for cgroup
 hierarchical stats collection
Date: Fri, 3 Jun 2022 18:23:39 +0200
Message-ID: <20220603162339.GA25043@blackbody.suse.cz>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-6-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1654273421; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2GUYLgLLblP6ZShyfDapCvEFm9z4SpPOJsQkTp/Thic=;
        b=FsBSBMGajNErb9riTALytwTaDYhoeYZ8mPEfQ4Mfitmatc3wsEncKsjqO2JuEPRyYmjVrk
        KpSXVyz+B31NXEVJa0r04ACq1AFXVB4qXswKT9CQgcVXmohknJoOpq4SWi+WOo6nTk3EI1
        A8PiB8z7udFoHPur1cnPgTwioo5rZ04=
Content-Disposition: inline
In-Reply-To: <20220520012133.1217211-6-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>, Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel

On Fri, May 20, 2022 at 01:21:33AM +0000, Yosry Ahmed <yosryahmed@google.com> wrote:
> +#define CGROUP_PATH(p, n) {.name = #n, .path = #p"/"#n}
> +
> +static struct {
> +	const char *name, *path;

Please unify the order of path and name with the macro (slightly
confusing ;-).

> +SEC("tp_btf/mm_vmscan_memcg_reclaim_end")
> +int BPF_PROG(vmscan_end, struct lruvec *lruvec, struct scan_control *sc)
> +{
> [...]
> +	struct cgroup *cgrp = task_memcg(current);
> [...]
> +	/* cgrp may not have memory controller enabled */
> +	if (!cgrp)
> +		return 0;

Yes, the controller may not be enabled (for a cgroup).
Just noting that the task_memcg() implementation will fall back to
root_mem_cgroup in such a case (or nearest ancestor), you may want to
use cgroup_ss_mask() for proper detection.

Regards,
Michal
