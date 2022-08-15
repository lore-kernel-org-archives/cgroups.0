From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH] mm: correctly charge compressed memory to its memcg
Date: Mon, 15 Aug 2022 14:52:56 +0800
Message-ID: <CAMZfGtViCehvPoADMZs-ceo3fnGU=_3vNu2i6tywGq0Cpt2meg@mail.gmail.com>
References: <20220811081913.102770-1-liliguang@baidu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=sT4Rmwp/q5F6bitQkSvyQ2IGtxsYD4gW1e3lvIrc3So=;
        b=PVJGB1kcTWLqtneoLcup/71OtYkgR6MTfpwPXChMx16SRUlh5drf3L+XQBVfhjiuhU
         ifoO/2Vx5JHkemKtOE+ubS2DzUUOol+0GczZXNhXIr/DQG63Z9YfqgL9Sx/rMqyNuduS
         6UlgvfmzRAqjqU1t0k8lTka3QS743t3FmMdgO4fgTHBSZtBG4Z95Zr6tu4TU24+lH7pY
         RKTtyfFcJMR3GzuC1N5LgJMKyqp6rcsk23rIMe2l91ptRsZU+ERpVo+jh3DaWygkyzoP
         qUSlE/N7wSFGgKtKWQKex/PWfIegJ3u4SCSMju5+9S8vF6cjHLkaZGzXjVNIVgfOdBGk
         BfRw==
In-Reply-To: <20220811081913.102770-1-liliguang-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: liliguang <liliguang-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Thu, Aug 11, 2022 at 4:19 PM liliguang <liliguang-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org> wrote:
>
> From: Li Liguang <liliguang-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>
>
> Kswapd will reclaim memory when memory pressure is high, the
> annonymous memory will be compressed and stored in the zpool
> if zswap is enabled. The memcg_kmem_bypass() in
> get_obj_cgroup_from_page() will bypass the kernel thread and
> cause the compressed memory not charged to its memory cgroup.
>
> Remove the memcg_kmem_bypass() and properly charge compressed
> memory to its corresponding memory cgroup.
>
> Signed-off-by: Li Liguang <liliguang-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>

Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Thanks.
