From: Wei Wang <weiwan@google.com>
Subject: Re: [PATCH net-next] net-memcg: pass in gfp_t mask to mem_cgroup_charge_skmem()
Date: Wed, 12 Oct 2022 20:34:00 -0700
Message-ID: <CAEA6p_CqqPtnWjr_yYr1oVF3UKe=6RqFLrg1OoANs2eg5_by0A@mail.gmail.com>
References: <20210817194003.2102381-1-weiwan@google.com> <20221012163300.795e7b86@kernel.org>
 <CALvZod5pKzcxWsLnjUwE9fUb=1S9MDLOHF950miF8x8CWtK5Bw@mail.gmail.com>
 <20221012173825.45d6fbf2@kernel.org> <20221013005431.wzjurocrdoozykl7@google.com>
 <20221012184050.5a7f3bde@kernel.org> <20221012201650.3e55331d@kernel.org>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XO+97KxgluoajPHIXHQ8Pu1WlMxATOZK61Q8UDagKn4=;
        b=rWdO99mDYoyhMfakQMEPK+uf/aAGfBGVGzyhKfSU439QvdifZ6wj/XKsaDLMWf3m4G
         gSj/kPWqNSLyiW6QqYw240jyn7R/0QUabcPB07lJGOK8aLXGBz1jd5EWYkpB6Cii6EQJ
         /pY6o5SS9Fd7QWhBHUPlSxKpV22NoDk9gZuZyuFY9/D4S5gzLQEBDwMIn5/QkKd81Byk
         aEllZFOX89wTs+RMadSWYZ4NnPYMlIQ9YkdjAz2XxpRvgNaewbamcUBS+20LQ9gUbe/1
         2ebrJ647KK/AEkw+B0k92jmpTH90B5+ksn1qBvT8zKZ/D2XsY0RgitAAUYRS+UfLJThk
         wZyQ==
In-Reply-To: <20221012201650.3e55331d@kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jakub Kicinski <kuba@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>, Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>, cgroups@vger.kernel.org, linux-mm@kvack.org, Roman Gushchin <roman.gushchin@linux.dev>

On Wed, Oct 12, 2022 at 8:16 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 12 Oct 2022 18:40:50 -0700 Jakub Kicinski wrote:
> > Did the fact that we used to force charge not potentially cause
> > reclaim, tho?  Letting TCP accept the next packet even if it had
> > to drop the current one?
>
> I pushed this little nugget to one affected machine via KLP:
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 03ffbb255e60..c1ca369a1b77 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -7121,6 +7121,10 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
>                 return true;
>         }
>
> +       if (gfp_mask == GFP_NOWAIT) {
> +               try_charge(memcg, gfp_mask|__GFP_NOFAIL, nr_pages);
> +               refill_stock(memcg, nr_pages);
> +       }
>         return false;
>  }
>
AFAICT, if you force charge by passing __GFP_NOFAIL to try_charge(),
you should return true to tell the caller that the nr_pages is
actually being charged. Although I am not very sure what
refill_stock() does. Does that "uncharge" those pages?


> The problem normally reproes reliably within 10min -- 30min and counting
> and the application-level latency has not spiked.
