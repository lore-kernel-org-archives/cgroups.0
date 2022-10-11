From: Martin KaFai Lau <martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH v2 2/2] bpf: cgroup_iter: support cgroup1 using cgroup fd
Date: Tue, 11 Oct 2022 09:46:27 -0700
Message-ID: <2ba0ee79-2e7e-6807-3312-1a2c5ef3bae0@linux.dev>
References: <20221011003359.3475263-1-yosryahmed@google.com>
 <20221011003359.3475263-3-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1665506792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fSpHFQ/t+wVXLc+3hNEAK/z5TCpUZCMKJcQhLnBO7pA=;
        b=VZXczMB1/0cXDlJrV4Hl9sjqWKt4jiyPljBV9WZxUvzdbwjoKUqh1lDfvqbGk8Z/cPGbuU
        VrlszEalWaKYs9+1ekJ60k4dB7wYy6bqb7n9IIKJ3baP+C7ioDlkDKwAQWkwmQEmMU0mZB
        JamUEiyRsoy6dCO7N4Vlwh+lNYYHkwM=
Content-Language: en-US
In-Reply-To: <20221011003359.3475263-3-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jiri Olsa <jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On 10/10/22 5:33 PM, Yosry Ahmed wrote:
> Use cgroup_v1v2_get_from_fd() in cgroup_iter to support attaching to
> both cgroup v1 and v2 using fds.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>   kernel/bpf/cgroup_iter.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/cgroup_iter.c b/kernel/bpf/cgroup_iter.c
> index 0d200a993489..9fcf09f2ef00 100644
> --- a/kernel/bpf/cgroup_iter.c
> +++ b/kernel/bpf/cgroup_iter.c
> @@ -196,7 +196,7 @@ static int bpf_iter_attach_cgroup(struct bpf_prog *prog,
>   		return -EINVAL;
>   
>   	if (fd)
> -		cgrp = cgroup_get_from_fd(fd);
> +		cgrp = cgroup_v1v2_get_from_fd(fd);

Acked-by: Martin KaFai Lau <martin.lau-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Tejun, patch 1 should depend on a recent revert that is not in the bpf tree yet. 
  Do you want to take this set to the cgroup tree?

>   	else if (id)
>   		cgrp = cgroup_get_from_id(id);
>   	else /* walk the entire hierarchy by default. */

