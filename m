From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] cgroup/cpuset: Improve cpuset_css_alloc() description
Date: Thu, 17 Nov 2022 08:15:28 -0500
Message-ID: <6f619bb3-e5ff-73c3-6dcb-afa64aabc729@redhat.com>
References: <20221117071557.165742-1-kamalesh.babulal@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668690936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8+KNz2jWZW3hJMabpbKj/Uks1DudAWiqFYQrQhlfd2E=;
        b=g/Nme7GWJNmvUeNDhym2xRrWVB0CVUchBNqDp7eBUoiib7mgGilbDO3xuyT2zl98vWr++U
        UeH8jbjkt3YmxjG3Vd+nFLxUxhQKngRTkyDRlZvkPj9yiIi1zlsEbYW0hgkU114XyRvep8
        CqDWAiidp2opLdk+Bu9ckWIF/TGo4Tw=
Content-Language: en-US
In-Reply-To: <20221117071557.165742-1-kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tom Hromatka <tom.hromatka-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

On 11/17/22 02:15, Kamalesh Babulal wrote:
> Change the function argument in the description of cpuset_css_alloc()
> from 'struct cgroup' -> 'struct cgroup_subsys_state'.  The change to the
> argument type was introduced by commit eb95419b023a ("cgroup: pass
> around cgroup_subsys_state instead of cgroup in subsystem methods").
> Also, add more information to its description.
>
> Signed-off-by: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
> v2: Reworded the description to be more accurate, as suggested
>      by Waiman Long
>
>   kernel/cgroup/cpuset.c | 12 ++++++++----
>   1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index b474289c15b8..ce789e1b2a2f 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -3046,11 +3046,15 @@ static struct cftype dfl_files[] = {
>   };
>   
>   
> -/*
> - *	cpuset_css_alloc - allocate a cpuset css
> - *	cgrp:	control group that the new cpuset will be part of
> +/**
> + * cpuset_css_alloc - Allocate a cpuset css
> + * @parent_css: Parent css of the control group that the new cpuset will be
> + *              part of
> + * Return: cpuset css on success, -ENOMEM on failure.
> + *
> + * Allocate and initialize a new cpuset css, for non-NULL @parent_css, return
> + * top cpuset css otherwise.
>    */
> -
>   static struct cgroup_subsys_state *
>   cpuset_css_alloc(struct cgroup_subsys_state *parent_css)
>   {
Acked-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

