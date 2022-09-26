From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/4] mm: memcontrol: drop dead CONFIG_MEMCG_SWAP config symbol
Date: Mon, 26 Sep 2022 08:22:16 -0700
Message-ID: <CALvZod573J7wJgvvWMHnyL39b7S0TD7fbs2fohvRmSCHUanCqA@mail.gmail.com>
References: <20220926135704.400818-1-hannes@cmpxchg.org> <20220926135704.400818-5-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=qvRaYPYKDxzCfmvXG/5tfegDFwEt8aN7PLvlIvfXAQ8=;
        b=pStoVQWt8z1fKG46RrHzQ+sN31TSBbQ26LClitIomuBqoK2WB2xkeSUXpBiR/tZFPS
         ZDpUvIXb30o3RRyb586qMCs2Q+aQOJw7lbbI6PS44mBomAbcgUfLoksOaDJugCE7d+Kh
         DJYfs/0c/Ga9st0WzAfZIJFu4DF8IqUh15usUbL1dCXM2QiqHXk8ojNAhIy5vYeVGAcF
         yiAG1h4zC7pp6bxc3yAE+/mbXNSEvVQWLVZHPvCy8R6DPk46I2RwzMxgozOy7irYGciQ
         vBmUqB6XipPTnYgWdmuHwBVqqKSrEp2B6W5q06iRFMxMW6q+JcdP8i1p4vXqTZFiSo0p
         sU7g==
In-Reply-To: <20220926135704.400818-5-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Sep 26, 2022 at 6:57 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> Since 2d1c498072de ("mm: memcontrol: make swap tracking an integral
> part of memory control"), CONFIG_MEMCG_SWAP hasn't been a user-visible
> config option anymore, it just means CONFIG_MEMCG && CONFIG_SWAP.
>
> Update the sites accordingly and drop the symbol.
>
> [ While touching the docs, remove two references to CONFIG_MEMCG_KMEM,
>   which hasn't been a user-visible symbol for over half a decade. ]
>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
