From: Joel Savitz <jsavitz@redhat.com>
Subject: Re: [PATCH v2] cgroup/cpuset: Improve cpuset_css_alloc() description
Date: Thu, 17 Nov 2022 11:03:56 -0400
Message-ID: <CAL1p7m4MeYbccde1rPKuxcbtj6Tm+sa4Ro_REAMBmWszyWJ3_w@mail.gmail.com>
References: <20221117071557.165742-1-kamalesh.babulal@oracle.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668697455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3/pZzLYRJIJU5BHs9Uc1Vomcy9mjzdUIDjXX/Oi2kCE=;
        b=DObzXfYg2wNgX+LpPwhYTzrOyyz5KP15fUcJ+zIXKaQISWCSQs7wSdm2qgqSEpALDmU0/G
        rmLTpUcfar2KnB2juAShGN0ZA1SNN9tIy8Kfn39/DBAqG4mcA7NeRw19jZQ2fCE0n1UITW
        4T8oVb5BJ/4RK9NJQpKKk988M6L/FWk=
In-Reply-To: <20221117071557.165742-1-kamalesh.babulal@oracle.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamalesh Babulal <kamalesh.babulal@oracle.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Waiman Long <longman@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tom Hromatka <tom.hromatka@oracle.com>

On Thu, Nov 17, 2022 at 3:18 AM Kamalesh Babulal
<kamalesh.babulal@oracle.com> wrote:
>
> Change the function argument in the description of cpuset_css_alloc()
> from 'struct cgroup' -> 'struct cgroup_subsys_state'.  The change to the
> argument type was introduced by commit eb95419b023a ("cgroup: pass
> around cgroup_subsys_state instead of cgroup in subsystem methods").
> Also, add more information to its description.
>
> Signed-off-by: Kamalesh Babulal <kamalesh.babulal@oracle.com>
> ---
> v2: Reworded the description to be more accurate, as suggested
>     by Waiman Long
>
>  kernel/cgroup/cpuset.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index b474289c15b8..ce789e1b2a2f 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -3046,11 +3046,15 @@ static struct cftype dfl_files[] = {
>  };
>
>
> -/*
> - *     cpuset_css_alloc - allocate a cpuset css
> - *     cgrp:   control group that the new cpuset will be part of
> +/**
> + * cpuset_css_alloc - Allocate a cpuset css
> + * @parent_css: Parent css of the control group that the new cpuset will be
> + *              part of
> + * Return: cpuset css on success, -ENOMEM on failure.
> + *
> + * Allocate and initialize a new cpuset css, for non-NULL @parent_css, return
> + * top cpuset css otherwise.
>   */
> -
>  static struct cgroup_subsys_state *
>  cpuset_css_alloc(struct cgroup_subsys_state *parent_css)
>  {
> --
> 2.34.3
>

Acked-by: Joel Savitz <jsavitz@redhat.com>

