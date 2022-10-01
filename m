From: Jiri Olsa <olsajiri-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] perf stat: Support old kernels for bperf cgroup counting
Date: Sat, 1 Oct 2022 15:58:59 +0200
Message-ID: <YzhHo0dJEijtGNzZ@krava>
References: <CAM9d7cjQ20a01YoZi=o-_7HT6TzR0TZgtpscKNvRrMq2yqV1Og@mail.gmail.com>
 <20220922041435.709119-1-namhyung@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date;
        bh=xKd9xq6bw6qI68iHTU/hjvH8L0x2YGL0QK3AOdmJ3AI=;
        b=lQF7IjxlRwt8FCZrwdnNizwSyswVpRaFHzxeLlh9sqhbZN7tDEchQ+QpZrBuXdrip9
         dEb/rkpsJqag+OpBTA7Dhpq8eKm+cj16lssEcdR7hP6UiQJ9oRugsuX9AtiAuG4owPm6
         USCCsprutvxGospLpucVtUelHBFSpkLS9w8uOEhr6sIlMskxXbbvZhqzVtl7UlE7x3bL
         0jErns0AnizLnCtCvOpuz8t9rU+Lck+R8OLTHOi4npl/932rJARoDBbTsg7qMiLcEipt
         1RwD1+IFuDCDa3Gj1QJrRnJR/AFs3lH6lhYLYPzDWUvi4SHgHf3v3CT59ZdxJjHl1aAw
         AbSg==
Content-Disposition: inline
In-Reply-To: <20220922041435.709119-1-namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-perf-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Sep 21, 2022 at 09:14:35PM -0700, Namhyung Kim wrote:
> The recent change in the cgroup will break the backward compatiblity in
> the BPF program.  It should support both old and new kernels using BPF
> CO-RE technique.
> 
> Like the task_struct->__state handling in the offcpu analysis, we can
> check the field name in the cgroup struct.
> 
> Signed-off-by: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

lgtm

Acked-by: Jiri Olsa <jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

jirka

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
>  	__uint(value_size, sizeof(struct bpf_perf_event_value));
>  } cgrp_readings SEC(".maps");
>  
> +/* new kernel cgroup definition */
> +struct cgroup___new {
> +	int level;
> +	struct cgroup *ancestors[];
> +} __attribute__((preserve_access_index));
> +
> +/* old kernel cgroup definition */
> +struct cgroup___old {
> +	int level;
> +	u64 ancestor_ids[];
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
> +	/* recast pointer to capture new type for compiler */
> +	struct cgroup___new *cgrp_new = (void *)cgrp;
> +
> +	if (bpf_core_field_exists(cgrp_new->ancestors)) {
> +		return BPF_CORE_READ(cgrp_new, ancestors[level], kn, id);
> +	} else {
> +		/* recast pointer to capture old type for compiler */
> +		struct cgroup___old *cgrp_old = (void *)cgrp;
> +
> +		return BPF_CORE_READ(cgrp_old, ancestor_ids[level]);
> +	}
> +}
> +
>  static inline int get_cgroup_v1_idx(__u32 *cgrps, int size)
>  {
>  	struct task_struct *p = (void *)bpf_get_current_task();
> @@ -70,7 +97,7 @@ static inline int get_cgroup_v1_idx(__u32 *cgrps, int size)
>  			break;
>  
>  		// convert cgroup-id to a map index
> -		cgrp_id = BPF_CORE_READ(cgrp, ancestors[i], kn, id);
> +		cgrp_id = get_cgroup_v1_ancestor_id(cgrp, i);
>  		elem = bpf_map_lookup_elem(&cgrp_idx, &cgrp_id);
>  		if (!elem)
>  			continue;
> -- 
> 2.37.3.968.ga6b4b080e4-goog
> 
