From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH bpf-next 0/8] bpf, cgroup: Add bpf support for cgroup
 controller
Date: Fri, 22 Sep 2023 06:52:18 -1000
Message-ID: <ZQ3GQmYrYyKAg2uK@slm.duckdns.org>
References: <20230922112846.4265-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695401541; x=1696006341; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=seU9shViMhY31gmIUtGee7cdWlwMOHkiBVOkqV5wiBM=;
        b=no5DHhq49rd/cEV4zYOSrQFvbA+lx6OEZ6f7pjPCjFrrxZlba1YNgeTV3dZs3eTOOx
         GfhwRhK80sR0yfIwpS0J+8Ib7TDqsQS3hb/9bdtc9/7+0JIi5rGoncK1ZS76JOIqC7KD
         6pfjnSBMV4E/14ToJfZ4GJY5R3HLKYrVQXOl5mvsIWEScBrKs/iz3ll+Q0g52L3NsbTm
         X3XKlSQ/9sjkFFWbGlKqvIbweUY9XNy+M+BwzoRYi7YJsBoCb0dMUdvZ6ABpAO2QEAnR
         me37/3+ev9zbmEVPpgyhzGvO5cwaeYWt3+pcZ7jX2XddYPeAS5/vt8JbVPL3RpyyhIKg
         lxUQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230922112846.4265-1-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yonghong.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Fri, Sep 22, 2023 at 11:28:38AM +0000, Yafang Shao wrote:
> - bpf_cgroup_id_from_task_within_controller
>   Retrieves the cgroup ID from a task within a specific cgroup controller.
> - bpf_cgroup_acquire_from_id_within_controller
>   Acquires the cgroup from a cgroup ID within a specific cgroup controller.
> - bpf_cgroup_ancestor_id_from_task_within_controller
>   Retrieves the ancestor cgroup ID from a task within a specific cgroup
>   controller.
> 
> The advantage of these new BPF kfuncs is their ability to abstract away the
> complexities of cgroup hierarchies, irrespective of whether they involve
> cgroup1 or cgroup2.

I'm afraid this is more likely to bring the unnecessary complexities of
cgroup1 into cgroup2.

> In the future, we may expand controller-based support to other BPF
> functionalities, such as bpf_cgrp_storage, the attachment and detachment
> of cgroups, skb_under_cgroup, and more.

I'm okay with minor / trivial quality of life improvements to cgroup1 but
this goes much beyond that and is starting to complications to cgroup2
users, which I think is a pretty bad idea long term. I'm afraid I'm gonna
have to nack this approach.

Thanks.

-- 
tejun
