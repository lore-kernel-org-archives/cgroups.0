From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: Re: [PATCH] perf stat: Support old kernels for bperf cgroup counting
Date: Fri, 30 Sep 2022 15:48:37 -0700
Message-ID: <CAEf4BzZhHYYOmNhLdrpsXSDE5kaXvgSN00X-8aAySDwAKX0RCw@mail.gmail.com>
References: <CAM9d7cjQ20a01YoZi=o-_7HT6TzR0TZgtpscKNvRrMq2yqV1Og@mail.gmail.com>
 <20220922041435.709119-1-namhyung@kernel.org>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rLr4Pui1WgAmc20FBE5q6rikXP7BZ6KUet36h8qjGrQ=;
        b=j/f7sU21OUk8kPvxztuKT5RBnJwNT0hXLpzsQ2xrK8zgdjoKihE425h6cOYq7h8jhD
         BmxZbSm/gW8kVMpISmmD6SmOhUiguGYs3Byys1w0Zy/P5QefmjDN12gsnBW6Uu9rErAV
         2DQ9bm7dg3CJ0lrxl4Ve6NJKftG/Xhn9/KRS3DDC67P7MX3DpgTnenITb5tI0RQ5xZyy
         oR4A5OHpMMIMgU+H/r23k4CLd2+TsRJJSmrgQYH+3ep+SOIkv2qjR8KU+cAA9kahCs3U
         gZmgCXIfFNHDAMFICPmTEmNcXOPnX4gUI30gKgEFSVPw/z2AA+hk8rPtCHbY8RqZi+cq
         0w/A==
In-Reply-To: <20220922041435.709119-1-namhyung@kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Namhyung Kim <namhyung@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-perf-users@vger.kernel.org, Song Liu <songliubraving@fb.com>, bpf@vger.kernel.org

On Wed, Sep 21, 2022 at 9:21 PM Namhyung Kim <namhyung@kernel.org> wrote:
>
> The recent change in the cgroup will break the backward compatiblity in
> the BPF program.  It should support both old and new kernels using BPF
> CO-RE technique.
>
> Like the task_struct->__state handling in the offcpu analysis, we can
> check the field name in the cgroup struct.
>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
> Arnaldo, I think this should go through the cgroup tree since it depends
> on the earlier change there.  I don't think it'd conflict with other
> perf changes but please let me know if you see any trouble, thanks!
>
>  tools/perf/util/bpf_skel/bperf_cgroup.bpf.c | 29 ++++++++++++++++++++-
>  1 file changed, 28 insertions(+), 1 deletion(-)
>
> diff --git a/tools/perf/util/bpf_skel/bperf_cgroup.bpf.c b/tools/perf/util/bpf_skel/bperf_cgroup.bpf.c
> index 488bd398f01d..4fe61043de04 100644
> --- a/tools/perf/util/bpf_skel/bperf_cgroup.bpf.c
> +++ b/tools/perf/util/bpf_skel/bperf_cgroup.bpf.c
> @@ -43,12 +43,39 @@ struct {
>         __uint(value_size, sizeof(struct bpf_perf_event_value));
>  } cgrp_readings SEC(".maps");
>
> +/* new kernel cgroup definition */
> +struct cgroup___new {
> +       int level;
> +       struct cgroup *ancestors[];
> +} __attribute__((preserve_access_index));
> +
> +/* old kernel cgroup definition */
> +struct cgroup___old {
> +       int level;
> +       u64 ancestor_ids[];
> +} __attribute__((preserve_access_index));
> +
>  const volatile __u32 num_events = 1;
>  const volatile __u32 num_cpus = 1;
>
>  int enabled = 0;
>  int use_cgroup_v2 = 0;
>
> +static inline __u64 get_cgroup_v1_ancestor_id(struct cgroup *cgrp, int level)
> +{
> +       /* recast pointer to capture new type for compiler */
> +       struct cgroup___new *cgrp_new = (void *)cgrp;
> +
> +       if (bpf_core_field_exists(cgrp_new->ancestors)) {
> +               return BPF_CORE_READ(cgrp_new, ancestors[level], kn, id);

have you checked generated BPF code for this ancestors[level] access?
I'd expect CO-RE relocation for finding ancestors offset and then just
normal + level * 8 arithmetic, but would be nice to confirm. Apart
from this, looks good to me:

Acked-by: Andrii Nakryiko <andrii@kernel.org>


> +       } else {
> +               /* recast pointer to capture old type for compiler */
> +               struct cgroup___old *cgrp_old = (void *)cgrp;
> +
> +               return BPF_CORE_READ(cgrp_old, ancestor_ids[level]);
> +       }
> +}
> +
>  static inline int get_cgroup_v1_idx(__u32 *cgrps, int size)
>  {
>         struct task_struct *p = (void *)bpf_get_current_task();
> @@ -70,7 +97,7 @@ static inline int get_cgroup_v1_idx(__u32 *cgrps, int size)
>                         break;
>
>                 // convert cgroup-id to a map index
> -               cgrp_id = BPF_CORE_READ(cgrp, ancestors[i], kn, id);
> +               cgrp_id = get_cgroup_v1_ancestor_id(cgrp, i);
>                 elem = bpf_map_lookup_elem(&cgrp_idx, &cgrp_id);
>                 if (!elem)
>                         continue;
> --
> 2.37.3.968.ga6b4b080e4-goog
>
