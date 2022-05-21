From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH mm v2 9/9] memcg: enable accounting for percpu allocation
 of struct rt_rq
Date: Sat, 21 May 2022 14:37:08 -0700
Message-ID: <CALvZod6+R9XpAz7_2QSc=fNO4w_revhr9MvCrByHCWWjnQwOhA@mail.gmail.com>
References: <Yn6aL3cO7VdrmHHp@carbon> <d7094aa2-1cd0-835c-9fb7-d76003c47dad@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zUHlY6J9Sffp4UlBWr1Ple6zvDOi7bfuxN73Sst2ROw=;
        b=ra8coKkYaI+nTpa/3tURJsZMGvzuQdyoQqh8jFxXJS7g0+8e01V8X9PBbCiPrE1FE6
         Yzcm7D4kVznWFOyoJbAXwA0JksMwuxSeRKJHaepGZUl8lYbYFZgIG8Oi3E1d+6xIR/Sc
         O9wApVFLDj/uVKWe5ig9oA3BYUdXFeSE8Y1ocXJS1c7EiMbev7w5BL/bErmsf7p9aJl/
         Ga9Uv5M/1wjbL+MLI3hBN5tyLtXCO3jyPshHGXAdVzvkrmR2TN14mpXOD3I1H4Ng8ii1
         CyhknimccTj5ODRjBe/dfaGnat48A0Qkf0U68Lcxtde6yS4vHqKa0+SDw738gp0RWhGo
         pSYg==
In-Reply-To: <d7094aa2-1cd0-835c-9fb7-d76003c47dad-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Sat, May 21, 2022 at 9:39 AM Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
>
> If enabled in config, alloc_rt_sched_group() is called for each new
> cpu cgroup and allocates a huge (~1700 bytes) percpu struct rt_rq.
> This significantly exceeds the size of the percpu allocation in the
> common part of cgroup creation.
>
> Memory allocated during new cpu cgroup creation
> (with enabled RT_GROUP_SCHED):
> common part:    ~11Kb   +   318 bytes percpu
> cpu cgroup:     ~2.5Kb  + ~2800 bytes percpu
>
> Accounting for this memory helps to avoid misuse inside memcg-limited
> contianers.

*containers

>
> Signed-off-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>

Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
