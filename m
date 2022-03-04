From: Ivan Babrou <ivan@cloudflare.com>
Subject: Re: [PATCH] memcg: sync flush only if periodic flush is delayed
Date: Fri, 4 Mar 2022 10:53:20 -0800
Message-ID: <CABWYdi0t6W4269g5OMLuLG=SWESDDEDPF-1kv1OKnzua=6=mBQ@mail.gmail.com>
References: <20220304184040.1304781-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bEOxM9dCTwOgx3v/sybpuLomdOANvZM0pQSflYOHu1w=;
        b=i652L4F2GnSj5foPdKPemlgr6xx94ua5Ic9XEX8NWr98rE/J8kp3lucWhLtM4AOES3
         T9r1sjUabt2iScIDVpUdwI7AvcDZFK6NUnb+i966anXeK79MKuuIqPU7cQfPEN83otOC
         mKwkhFqmQ0lI9vTrYAN1FaKXTRwQdjLTY1yTk=
In-Reply-To: <20220304184040.1304781-1-shakeelb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Frank Hofmann <fhofmann@cloudflare.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, Linux MM <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>, Daniel Dao <dqminh@cloudflare.com>, stable@vger.kernel.org

On Fri, Mar 4, 2022 at 10:40 AM Shakeel Butt <shakeelb@google.com> wrote:
>
> Daniel Dao has reported [1] a regression on workloads that may trigger
> a lot of refaults (anon and file). The underlying issue is that flushing
> rstat is expensive. Although rstat flush are batched with (nr_cpus *
> MEMCG_BATCH) stat updates, it seems like there are workloads which
> genuinely do stat updates larger than batch value within short amount of
> time. Since the rstat flush can happen in the performance critical
> codepaths like page faults, such workload can suffer greatly.
>
> This patch fixes this regression by making the rstat flushing
> conditional in the performance critical codepaths. More specifically,
> the kernel relies on the async periodic rstat flusher to flush the stats
> and only if the periodic flusher is delayed by more than twice the
> amount of its normal time window then the kernel allows rstat flushing
> from the performance critical codepaths.
>
> Now the question: what are the side-effects of this change? The worst
> that can happen is the refault codepath will see 4sec old lruvec stats
> and may cause false (or missed) activations of the refaulted page which
> may under-or-overestimate the workingset size. Though that is not very
> concerning as the kernel can already miss or do false activations.
>
> There are two more codepaths whose flushing behavior is not changed by
> this patch and we may need to come to them in future. One is the
> writeback stats used by dirty throttling and second is the deactivation
> heuristic in the reclaim. For now keeping an eye on them and if there is
> report of regression due to these codepaths, we will reevaluate then.
>
> Link: https://lore.kernel.org/all/CA+wXwBSyO87ZX5PVwdHm-=dBjZYECGmfnydUicUyrQqndgX2MQ@mail.gmail.com [1]
> Fixes: 1f828223b799 ("memcg: flush lruvec stats in the refault")
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Reported-by: Daniel Dao <dqminh@cloudflare.com>
> Cc: <stable@vger.kernel.org>
> ---

See my testing results here:
https://lore.kernel.org/linux-mm/CABWYdi2usrWOnOnmKYYvuFpE=yJmgtq4a7u6FiGJGJkskv+eVQ@mail.gmail.com/

Tested-by: Ivan Babrou <ivan@cloudflare.com>
