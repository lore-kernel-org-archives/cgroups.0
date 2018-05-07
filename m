From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] mm: memcontrol: drain memcg stock on force_empty
Date: Mon, 07 May 2018 20:19:08 +0000
Message-ID: <CALvZod7gktckGdTRCmTQTACXZKbtpCJqqovxFvSqG1uDa07ocg@mail.gmail.com>
References: <20180507201651.165879-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6B79UXVx2OQMUmngKz1oWKKbCI/BueS8MO60X3sDimg=;
        b=s4+LxNcLR/d6hCroziyJt9e6Zjkgxk4yzSa7GqJD9Cisb+F/2ei/sEufciG6ngvRpL
         SEugL4qXxl8P1Y1J1qG60+qwpS5Wyb2FRXMKWcbj9oY5T+qoqNyIHjln2nAIgFQ/bstt
         xaOV8sNiLb+yta4hoC880q11luENCV0qCWGx85jTCOYoAadehwV8DfqDoxeSsNECou4C
         j5aQNzd0Xk3NV6DMg+7JYHx/2Uy/l3Gdr+CXESgpnur90B81km72g9J1cmdHpkJ48hF9
         u7UDAxkJPLMFp3G/K4926JsMcW6lvkN24EWJ2ARKseB6oya/M7DXHRtIq0u0+EbgAgpo
         h4Mw==
In-Reply-To: <20180507201651.165879-1-shakeelb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Junaid Shahid <junaids@google.com>, Junaid Shahid <juanids@google.com>

On Mon, May 7, 2018 at 1:16 PM Shakeel Butt <shakeelb@google.com> wrote:

> From: Junaid Shahid <junaids@google.com>

> The per-cpu memcg stock can retain a charge of upto 32 pages. On a
> machine with large number of cpus, this can amount to a decent amount
> of memory. Additionally force_empty interface might be triggering
> unneeded memcg reclaims.

> Signed-off-by: Junaid Shahid <juanids@google.com>

This should be "Junaid Shahid <junaids@google.com>".

> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> ---
>   mm/memcontrol.c | 3 +++
>   1 file changed, 3 insertions(+)

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e2d33a37f971..2c3c69524b49 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2841,6 +2841,9 @@ static int mem_cgroup_force_empty(struct mem_cgroup
*memcg)

>          /* we call try-to-free pages for make this cgroup empty */
>          lru_add_drain_all();
> +
> +       drain_all_stock(memcg);
> +
>          /* try to free all pages in this cgroup */
>          while (nr_retries && page_counter_read(&memcg->memory)) {
>                  int progress;
> --
> 2.17.0.441.gb46fe60e1d-goog
