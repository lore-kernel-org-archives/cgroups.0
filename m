From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH mm v2] memcg: notify about global mem_cgroup_id space depletion
Date: Mon, 27 Jun 2022 11:23:07 +0800
Message-ID: <CAMZfGtWQEFmyuDngPfg59D-+b9sf58m9qhGoVPSQ_jAGmgT+sg@mail.gmail.com>
References: <Yre8tNUY8vBrO0yl@castle> <97bed1fd-f230-c2ea-1cb6-8230825a9a64@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eN+xoYA+ksKDeeujf53jiHGUJcOQVzh6cwSiG0r1JZ0=;
        b=VZASWp/K3Xzse8hHey4MhbH+j2n8icJllf/NFc2ri+vgIMu/2qvY/TvM0CReGMQIhk
         Q9NnMpdtXy5gdBtd8D/QZD4cNqcJNwU2DaqQBUAw10Gl3yqmRO3Oo4EEICu7bCzJOFis
         kPApaPYwsunYb2di9uQWNejNAF+g44cfP48iFaSCYQ7LopQiWLOTgTKMl2fJE5Dagibr
         vF0dfCSEVPbA1ZEOrLKDTn1JlPhyI4mw2F4rdz/MVmvFq+ZsXm3NxqUOUo4+1mUPdnBW
         D23Q9O3xlZ9IfSdolmXs7aC0lExuB//NN7EkVklnUIYUPwIVpotTJ74mu6HjXw2DKmWj
         BHVA==
In-Reply-To: <97bed1fd-f230-c2ea-1cb6-8230825a9a64-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Jun 27, 2022 at 10:11 AM Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
>
> Currently, the host owner is not informed about the exhaustion of the
> global mem_cgroup_id space. When this happens, systemd cannot start a
> new service and receives a unique -ENOSPC error code.
> However, this can happen inside this container, persist in the log file
> of the local container, and may not be noticed by the host owner if he
> did not try to start any new services.
>
> Signed-off-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> ---
> v2: Roman Gushchin pointed that idr_alloc() should return unique -ENOSPC

If the caller can know -ENOSPC is returned by mkdir(), then I
think the user (perhaps systemd) is the best place to throw out the
error message instead of in the kernel log. Right?

Thanks.

>     if no free IDs could be found, but can also return -ENOMEM.
>     Therefore error code check was added before message output and
>     patch descriprion was adopted.
> ---
>  mm/memcontrol.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d4c606a06bcd..ffc6b5d6b95e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5317,6 +5317,8 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
>                                  1, MEM_CGROUP_ID_MAX + 1, GFP_KERNEL);
>         if (memcg->id.id < 0) {
>                 error = memcg->id.id;
> +               if (error == -ENOSPC)
> +                       pr_notice_ratelimited("mem_cgroup_id space is exhausted\n");
>                 goto fail;
>         }
>
> --
> 2.36.1
>
