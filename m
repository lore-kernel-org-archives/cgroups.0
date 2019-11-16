From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v3 1/7] mm/lru: add per lruvec lock for memcg
Date: Fri, 15 Nov 2019 22:28:34 -0800
Message-ID: <CALvZod77568+TozRXpERDDap__jbj+oJBY8zD=UBd40XNJC2zg@mail.gmail.com>
References: <1573874106-23802-1-git-send-email-alex.shi@linux.alibaba.com> <1573874106-23802-2-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x6J0isZQHyJs2DrQydkqyktOVewrDtoAG6sLNljnc8o=;
        b=ds/yTXh6/ej0deTlmg0Wf+HJq81afq++LbAIEYRM1Io96xJ1ODG3OqvHeBWHEo/T4z
         VfTFsAUv3uuHun2bhemwzDi/b38W+LPrMfTK5Jp4QR5O1vp6FQkBjWuYX6DRVNMUVlpg
         pGlhm2Ln8qOyjhYoMS7ObVBR+eOZ/ampFt04oQFB02vv3mbRm9Wp3grLqtgSXBgQD/ZI
         33QsdPlRHlq/68ChvEMO7PgA8fCDWU3WG4RnVUqvlqjcY97h5D+vkvDi2obaO0dzz7db
         RRev2gKBaWw/p8OYK3k/1s/tnj8k1wg0+55J3eeV+ck2KgFXOU31HceFgAUDxi+x4yMZ
         33Zw==
In-Reply-To: <1573874106-23802-2-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Daniel Jordan <daniel.m.jordan@oracle.com>, Yang Shi <yang.shi@linux.alibaba.com>, Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, Dan Williams <dan.j.williams@intel.com>, Michal Hocko <mhocko@suse.com>, Wei Yang <richard.weiyang@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Arun KS <arunks@codeaurora.org>

On Fri, Nov 15, 2019 at 7:15 PM Alex Shi <alex.shi@linux.alibaba.com> wrote:
>
> Currently memcg still use per node pgdat->lru_lock to guard its lruvec.
> That causes some lru_lock contention in a high container density system.
>
> If we can use per lruvec lock, that could relief much of the lru_lock
> contention.
>
> The later patches will replace the pgdat->lru_lock with lruvec->lru_lock
> and show the performance benefit by benchmarks.

Merge this patch with actual usage. No need to have a separate patch.

>
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: Wei Yang <richard.weiyang@gmail.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Arun KS <arunks@codeaurora.org>
> Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: cgroups@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  include/linux/mmzone.h | 2 ++
>  mm/mmzone.c            | 1 +
>  2 files changed, 3 insertions(+)
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 07b784ffbb14..a13b8a602ee5 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -267,6 +267,8 @@ struct lruvec {
>         unsigned long                   refaults;
>         /* Various lruvec state flags (enum lruvec_flags) */
>         unsigned long                   flags;
> +       /* per lruvec lru_lock for memcg */
> +       spinlock_t                      lru_lock;
>  #ifdef CONFIG_MEMCG
>         struct pglist_data *pgdat;
>  #endif
> diff --git a/mm/mmzone.c b/mm/mmzone.c
> index 4686fdc23bb9..3750a90ed4a0 100644
> --- a/mm/mmzone.c
> +++ b/mm/mmzone.c
> @@ -91,6 +91,7 @@ void lruvec_init(struct lruvec *lruvec)
>         enum lru_list lru;
>
>         memset(lruvec, 0, sizeof(struct lruvec));
> +       spin_lock_init(&lruvec->lru_lock);
>
>         for_each_lru(lru)
>                 INIT_LIST_HEAD(&lruvec->lists[lru]);
> --
> 1.8.3.1
>
