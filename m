From: Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net-memcg: pass in gfp_t mask to
 mem_cgroup_charge_skmem()
Date: Wed, 12 Oct 2022 20:49:41 -0700
Message-ID: <20221012204941.3223d205@kernel.org>
References: <20210817194003.2102381-1-weiwan@google.com>
        <20221012163300.795e7b86@kernel.org>
        <CALvZod5pKzcxWsLnjUwE9fUb=1S9MDLOHF950miF8x8CWtK5Bw@mail.gmail.com>
        <20221012173825.45d6fbf2@kernel.org>
        <20221013005431.wzjurocrdoozykl7@google.com>
        <20221012184050.5a7f3bde@kernel.org>
        <20221012201650.3e55331d@kernel.org>
        <CAEA6p_CqqPtnWjr_yYr1oVF3UKe=6RqFLrg1OoANs2eg5_by0A@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665632982;
        bh=K3+Spu2EH3logPqr6cSQ4UYLEL0vGrnyEj+WmuJ3JBg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Unfvd/ba7xDuF/KobnJt1U+LcAN7ZarvrDzLSuU/wW4Ws67soEe9x2YoNTxfn6NVH
         WhonJ5zXVbly3kfiG2sU6O6X9LCr/pmVrWwZCsI9E7LOAKeeLevoCy/iO0sHje6fXF
         fsEhn/xJyCGNMLLWKkiqNsNCzeyXoV48qWUGH0FpeNASXvY4xk9wDV4hXEJ4kMSvwd
         rHolzENWpMMfx5r7ebhZcjwG/NkrYOXXsfzRxXdJHtHXwRAweb8AWQu4BrkyPSFo3i
         xns1kWtwdcFO1ESO7Hfzq/TX1M8T7KDC8ycu9TniAG40FNFf5hBj39e7rApYjIepdK
         mxQZNNUgXRvnw==
In-Reply-To: <CAEA6p_CqqPtnWjr_yYr1oVF3UKe=6RqFLrg1OoANs2eg5_by0A@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Wei Wang <weiwan@google.com>
Cc: Shakeel Butt <shakeelb@google.com>, Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>, cgroups@vger.kernel.org, linux-mm@kvack.org, Roman Gushchin <roman.gushchin@linux.dev>

On Wed, 12 Oct 2022 20:34:00 -0700 Wei Wang wrote:
> > I pushed this little nugget to one affected machine via KLP:
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 03ffbb255e60..c1ca369a1b77 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -7121,6 +7121,10 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
> >                 return true;
> >         }
> >
> > +       if (gfp_mask == GFP_NOWAIT) {
> > +               try_charge(memcg, gfp_mask|__GFP_NOFAIL, nr_pages);
> > +               refill_stock(memcg, nr_pages);
> > +       }
> >         return false;
> >  }
> >  
> AFAICT, if you force charge by passing __GFP_NOFAIL to try_charge(),
> you should return true to tell the caller that the nr_pages is
> actually being charged.

Ack - not sure what the best thing to do is, tho. Always pass NOFAIL 
in softirq?

It's not clear to me yet why doing the charge/uncharge actually helps,
perhaps try_to_free_mem_cgroup_pages() does more when NOFAIL is passed?

I'll do more digging tomorrow.

> Although I am not very sure what refill_stock() does. Does that
> "uncharge" those pages?

I think so, I copied it from mem_cgroup_uncharge_skmem().
