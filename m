From: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC 4/4] bpf,cgroup,perf: extend bpf-cgroup to support
 tracepoint attachment
Date: Thu, 18 Nov 2021 20:33:26 -0800
Message-ID: <20211119043326.a4pmgitlkljpamgh@ast-mbp.dhcp.thefacebook.com>
References: <20211118202840.1001787-1-Kenny.Ho@amd.com>
 <20211118202840.1001787-5-Kenny.Ho@amd.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wUYPD/dK7AbnmjRt7DrfQALSJEYOeqazWN+/nDCsZLE=;
        b=a2hOSHDbbGGI/Snv4mcOO+vrCftQw4roHy+cd6KGotO6J02ATNiF0hoYAbTTNMwb7W
         KkDkfLCikndxpSP0pUpRx8sf0vpEGC+dZC/Is0QucWsR9vQPLodQivhxlLw5Q/5/7ISm
         xltnpoduAlf2krlb4/olzkA1vuqSR8qWx5pOc/onmJsJDe/RAjMn4aXLgRvWB/YKwYDP
         VYQYSC8U9VQjSyx2GXiOSDQ271JOWJ6wp2G3s0ofgwvl8P5m22gY/Z6QpMmJs5x0VShW
         14wSspIzOnYZIwwrkQ6Q0bFiCQb6qf+1FsIyHIhE7/RyCQelp6KRCpcFFIh466ScHX/a
         gNlw==
Content-Disposition: inline
In-Reply-To: <20211118202840.1001787-5-Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
Cc: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jiri Olsa <jolsa-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel@vger.

On Thu, Nov 18, 2021 at 03:28:40PM -0500, Kenny Ho wrote:
> @@ -245,6 +256,21 @@ static int compute_effective_progs(struct cgroup *cgrp,
>  	if (!progs)
>  		return -ENOMEM;
>  
> +	if (atype == CGROUP_TRACEPOINT) {
> +		/* TODO: only create event for cgroup that can have process */
> +
> +		attr.config = bpf_attach_subtype;
> +		attr.type = PERF_TYPE_TRACEPOINT;
> +		attr.sample_type = PERF_SAMPLE_RAW;
> +		attr.sample_period = 1;
> +		attr.wakeup_events = 1;
> +
> +		rc = perf_event_create_for_all_cpus(&attr, cgrp,
> +				&cgrp->bpf.per_cg_events);
> +		if (rc)
> +			goto err;
> +	}
...
> +int perf_event_create_for_all_cpus(struct perf_event_attr *attr,
> +				struct cgroup *cgroup,
> +				struct list_head *entries)
> +{
> +	struct perf_event **events;
> +        struct perf_cgroup *perf_cgrp;
> +	int cpu, i = 0;
> +
> +	events = kzalloc(sizeof(struct perf_event *) * num_possible_cpus(),
> +			GFP_KERNEL);
> +
> +	if (!events)
> +		return -ENOMEM;
> +
> +	for_each_possible_cpu(cpu) {
> +		/* allocate first, connect the cgroup later */
> +		events[i] = perf_event_create_kernel_counter(attr, cpu, NULL, NULL, NULL);

This is a very heavy hammer for this task.
There is really no need for perf_event to be created.
Did you consider using raw_tp approach instead?
It doesn't need this heavy stuff.
Also I suspect in follow up you'd be adding tracepoints to GPU code?
Did you consider just leaving few __weak global functions in GPU code
and let bpf progs attach to them as fentry?
I suspect the true hierarchical nature of bpf-cgroup framework isn't necessary.
The bpf program itself can filter for given cgroup.
We have bpf_current_task_under_cgroup() and friends.
I suggest to sprinkle __weak empty funcs in GPU and see what
you can do with it with fentry and bpf_current_task_under_cgroup.
There is also bpf_get_current_ancestor_cgroup_id().
