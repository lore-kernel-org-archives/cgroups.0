From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH 3/4] memcg: enable accounting for struct cgroup
Date: Thu, 19 May 2022 18:31:50 -0700
Message-ID: <CALvZod5pFkm36r1nT2vmUX+Q1hy-MTKaGXOXpcT0Wra1oU=etw@mail.gmail.com>
References: <Ynv7+VG+T2y9rpdk@carbon> <a17be77f-dc3b-d69a-16e2-f7309959c525@openvz.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T/ssDZXDd7/eY1p7k+SveQN0HGUJT39mZvyN4cT8bOs=;
        b=MGDrvFhqVt1UaJVCqugH5mSYTS/PN5XNnCCEu83rTagPjTOjW5FKf8YAGySUgotOpx
         R3egCdeVk0b6TNnmJhK+OHqnSKgSaPkZTwuf4N28K1EclMUtZW2ngCNJ9GKWb1M09NNM
         p6yPYpspcTAIYLpqF9zbExjFFPXIWKrLwE6abB+MJ8B1ktXVMPJtQwAWYC8TOV0MK+vM
         AnXXkajSjSnTpVMukTlLUDEeG1339zUOhmlTBh0CiSenS7giG2aExVZH20O7ZMbfWKJg
         UShqmt0jZQaBtxnWY5z9PYRHcmdXTH3SaTwt0NOP8PeoCITIujj0O0klbRScpYOUoCfw
         6Dlg==
In-Reply-To: <a17be77f-dc3b-d69a-16e2-f7309959c525@openvz.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs@openvz.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, kernel@openvz.org, LKML <linux-kernel@vger.kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Cgroups <cgroups@vger.kernel.org>

On Fri, May 13, 2022 at 8:52 AM Vasily Averin <vvs@openvz.org> wrote:
>
> Creating each new cgroup allocates 4Kb for struct cgroup. This is the
> largest memory allocation in this scenario and is epecially important
> for small VMs with 1-2 CPUs.
>
> Accounting of this memory helps to avoid misuse inside memcg-limited
> containers.
>
> Signed-off-by: Vasily Averin <vvs@openvz.org>
> ---
>  kernel/cgroup/cgroup.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index adb820e98f24..7595127c5b3a 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -5353,7 +5353,7 @@ static struct cgroup *cgroup_create(struct cgroup *parent, const char *name,
>
>         /* allocate the cgroup and its ID, 0 is reserved for the root */
>         cgrp = kzalloc(struct_size(cgrp, ancestor_ids, (level + 1)),
> -                      GFP_KERNEL);
> +                      GFP_KERNEL_ACCOUNT);
>         if (!cgrp)
>                 return ERR_PTR(-ENOMEM);
>

Please include cgroup_rstat_cpu as well.
