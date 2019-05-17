From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2] memcg: make it work on sparse non-0-node systems
Date: Fri, 17 May 2019 05:13:29 -0700
Message-ID: <CALvZod4w3Hfs1WBsNchp3J_Ymvuni=Ap-rBpaS=iXwd2P+5w5g@mail.gmail.com>
References: <20190517080044.tnwhbeyxcccsymgf@esperanza> <20190517114204.6330-1-jslaby@suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M3s5onH4EKHtLRHaMdmA6OtBScYx3vU5FV884xFkNgc=;
        b=DmsorBzXRDvon/8kG4JcRIox8FFPMnHLt2Pa3GMNzeTIrY3kOQXjVd2VBrPODbpCa3
         n050y2TXrw9wMMLA9KR+e/iqa+pf3SLfhWqrKyNx7sVQ7aFg4wnAf8t7TldJrIe152o3
         UNUCQC+vFQINNOPNJu1oYLW9PArZO3q0eoBIvwOWWnWrjBvnq3k2LJnsCjMZfI6trr1V
         UztxEjymcEYDQ32K/E4lRBDnX5v4Q0uH61h3RMK7mjXq4FZ4NTgtTEEsn2fqODJkLm7U
         SyyiGFcg9Tv0i1o4OTp7AbUrzF3DplnUdd5spgSdeF2Jeur5HMIkKz1gvcu1hJF/hmiL
         1U9w==
In-Reply-To: <20190517114204.6330-1-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Cgroups <cgroups@vger.kernel.org>, Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

On Fri, May 17, 2019 at 4:42 AM Jiri Slaby <jslaby@suse.cz> wrote:
>
> We have a single node system with node 0 disabled:
>   Scanning NUMA topology in Northbridge 24
>   Number of physical nodes 2
>   Skipping disabled node 0
>   Node 1 MemBase 0000000000000000 Limit 00000000fbff0000
>   NODE_DATA(1) allocated [mem 0xfbfda000-0xfbfeffff]
>
> This causes crashes in memcg when system boots:
>   BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
>   #PF error: [normal kernel read fault]
> ...
>   RIP: 0010:list_lru_add+0x94/0x170
> ...
>   Call Trace:
>    d_lru_add+0x44/0x50
>    dput.part.34+0xfc/0x110
>    __fput+0x108/0x230
>    task_work_run+0x9f/0xc0
>    exit_to_usermode_loop+0xf5/0x100
>
> It is reproducible as far as 4.12. I did not try older kernels. You have
> to have a new enough systemd, e.g. 241 (the reason is unknown -- was not
> investigated). Cannot be reproduced with systemd 234.
>
> The system crashes because the size of lru array is never updated in
> memcg_update_all_list_lrus and the reads are past the zero-sized array,
> causing dereferences of random memory.
>
> The root cause are list_lru_memcg_aware checks in the list_lru code.
> The test in list_lru_memcg_aware is broken: it assumes node 0 is always
> present, but it is not true on some systems as can be seen above.
>
> So fix this by avoiding checks on node 0. Remember the memcg-awareness
> by a bool flag in struct list_lru.
>
> [v2] use the idea proposed by Vladimir -- the bool flag.
>
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>

Reviewed-by: Shakeel Butt <shakeelb@google.com>

> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Suggested-by: Vladimir Davydov <vdavydov.dev@gmail.com>
> Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: <cgroups@vger.kernel.org>
> Cc: <linux-mm@kvack.org>
> Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> ---
>  include/linux/list_lru.h | 1 +
>  mm/list_lru.c            | 8 +++-----
>  2 files changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
> index aa5efd9351eb..d5ceb2839a2d 100644
> --- a/include/linux/list_lru.h
> +++ b/include/linux/list_lru.h
> @@ -54,6 +54,7 @@ struct list_lru {
>  #ifdef CONFIG_MEMCG_KMEM
>         struct list_head        list;
>         int                     shrinker_id;
> +       bool                    memcg_aware;
>  #endif
>  };
>
> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index 0730bf8ff39f..d3b538146efd 100644
> --- a/mm/list_lru.c
> +++ b/mm/list_lru.c
> @@ -37,11 +37,7 @@ static int lru_shrinker_id(struct list_lru *lru)
>
>  static inline bool list_lru_memcg_aware(struct list_lru *lru)
>  {
> -       /*
> -        * This needs node 0 to be always present, even
> -        * in the systems supporting sparse numa ids.
> -        */
> -       return !!lru->node[0].memcg_lrus;
> +       return lru->memcg_aware;
>  }
>
>  static inline struct list_lru_one *
> @@ -451,6 +447,8 @@ static int memcg_init_list_lru(struct list_lru *lru, bool memcg_aware)
>  {
>         int i;
>
> +       lru->memcg_aware = memcg_aware;
> +
>         if (!memcg_aware)
>                 return 0;
>
> --
> 2.21.0
>
