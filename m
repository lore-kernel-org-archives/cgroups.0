From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v3 2/7] mm/lruvec: add irqsave flags into lruvec struct
Date: Fri, 15 Nov 2019 22:31:22 -0800
Message-ID: <CALvZod5xuetOb8Vunhgjp69-HcrnHgGHZKKyjVBo3tmoc3WqaA@mail.gmail.com>
References: <1573874106-23802-1-git-send-email-alex.shi@linux.alibaba.com> <1573874106-23802-3-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mpODNTcWa+A401urYWGM84SXXQR7l3TKPlFdQmVBzs0=;
        b=gF5tsuVznJqnYWo56MgDxdPAGHHFgIvh1vwSch7ES7KJAJagvN85gQi55vmuMMjr8g
         fAl9TmJtGOhmH9KI53u2YV33HKDJ8GTzQJbR3olwc6IyhHVNXyxed7HTw3rcbH4O5lXg
         DFBWyLdLVZMA+dXLRbjIYwehUYEqK7HGAZdwGwaXyMuFMJEDQbOtHMaVrIC4JoOFEdrD
         FtnKLpPZy5bsGy7UUfNuL1Tdyd/MRvKuAOQJSQIf8kI9Mmr9deFM9R29KE4nATXS8TTA
         T9Afm2+ns3B0dWXdhrrPyZZ0VPSd/wl9QL8b4RH2Lv7wLMh5fKb1HP5Vpcak//Q3Ps9F
         jZoA==
In-Reply-To: <1573874106-23802-3-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Daniel Jordan <daniel.m.jordan@oracle.com>, Yang Shi <yang.shi@linux.alibaba.com>, Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, Dan Williams <dan.j.williams@intel.com>, Michal Hocko <mhocko@suse.com>, Wei Yang <richard.weiyang@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Arun KS <arunks@codeaurora.org>, Rong Chen <rong.a.chen@intel.com>

On Fri, Nov 15, 2019 at 7:15 PM Alex Shi <alex.shi@linux.alibaba.com> wrote:
>
> We need a irqflags vaiable to save state when do irqsave action, declare
> it here would make code more clear/clean.
>
> Rong Chen <rong.a.chen@intel.com> reported the 'irqflags' variable need
> move to the tail of lruvec struct otherwise it causes 18% regressions of
> vm-scalability testing on his machine. So add the flags and lru_lock to
> both near struct tail, even I have no clue of this perf losing.

Regressions compared to what? Also no need to have a separate patch.

>
> Originally-from: Hugh Dickins <hughd@google.com>
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: Wei Yang <richard.weiyang@gmail.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Arun KS <arunks@codeaurora.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> CC: Rong Chen <rong.a.chen@intel.com>
> Cc: cgroups@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  include/linux/mmzone.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index a13b8a602ee5..9b8b8daf4e03 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -269,6 +269,8 @@ struct lruvec {
>         unsigned long                   flags;
>         /* per lruvec lru_lock for memcg */
>         spinlock_t                      lru_lock;
> +       /* flags for irqsave */
> +       unsigned long                   irqflags;
>  #ifdef CONFIG_MEMCG
>         struct pglist_data *pgdat;
>  #endif
> --
> 1.8.3.1
>
