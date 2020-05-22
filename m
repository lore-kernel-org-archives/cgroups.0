From: Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: Re: [PATCH v3 2/2] mm, memcg: Decouple e{low,min} state mutations
 from protection checks
Date: Fri, 22 May 2020 21:11:53 +0530
Message-ID: <CA+G9fYvw+oY-EK1+FYCUAD5-UGD4MhBGJHasjF+L5nLtzL2GLQ@mail.gmail.com>
References: <20200505084127.12923-1-laoar.shao@gmail.com> <20200505084127.12923-3-laoar.shao@gmail.com>
 <CA+G9fYseWc_7yq0M5Onju_HxbFid6DbuuaEFf-KUpqfxdF-QTg@mail.gmail.com> <20200522114544.GA1112005@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oOYVOHpaIS+oIho1dCUDLjlIT96AiPQqcbd2UVpV+2w=;
        b=xc5YNUMinAG4CGXABpBRi7fN1jT3RAq5g34Fsehb7FeGfXYItR+jv9zdzFUbWBZgED
         LmniBIdug9ZVwtsM86rfNB4Ym0c53ixm9EKzBW+98lrn+8iymUA1pl2rPFTIORF5gQ62
         S7DQ9GAYdIyD0+h/PDFxltIl+vny9nvjNZwtDFWooA9AaFqDP1f1M3b8WEMP5ciTcCjp
         W9NaNLJ0XScz6f3UhpDiAU5ZGmdgvxMde4+OxowuByFtU+aSTB2XW+29FZ21ruR/AtlZ
         X2z7XizfkhRaPFBSCM5YrIriiEQ/BuEbJkBwj+XeDUcSN1pBzeruIIxoHJrH2wvAAVgG
         WYVA==
In-Reply-To: <20200522114544.GA1112005@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris@chrisdown.name>
Cc: Yafang Shao <laoar.shao@gmail.com>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, linux-mm <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org

On Fri, 22 May 2020 at 17:15, Chris Down <chris@chrisdown.name> wrote:
>
> Naresh Kamboju writes:
> >This patch is causing oom-killer while running mkfs -t ext4 on i386 kernel
> >running on x86_64 machine version linux-next 5.7.0-rc6-next-20200521.
>
> I think I see what's wrong here -- if we bail out early, memory.e{min,low}
> might be uninitialised.
>
> Does this patch fix it, by any chance?
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d3b23c57bed4..aa902b9cbb79 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5046,6 +5046,9 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
>                         memory_cgrp_subsys.broken_hierarchy = true;
>         }
>
> +       memcg->memory.emin = 0;
> +       memcg->memory.elow = 0;
> +
>         /* The following stuff does not apply to the root */
>         if (!parent) {
>   #ifdef CONFIG_MEMCG_KMEM

This patch did not fix the problem.
The test log showing oom-killer link,
https://lkft.validation.linaro.org/scheduler/job/1445128#L1194

Build images:
https://builds.tuxbuild.com/YqW37GVsCHf8ndxOT2z1iQ/

- Naresh
