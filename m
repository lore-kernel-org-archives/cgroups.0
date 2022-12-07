From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: Low TCP throughput due to vmpressure with swap enabled
Date: Wed, 7 Dec 2022 13:53:00 +0100
Message-ID: <Y5CMrPMDxngMZWN8@cmpxchg.org>
References: <Y30rdnZ+lrfOxjTB@cmpxchg.org>
 <CABWYdi3PqipLxnqeepXeZ471pfeBg06-PV0Uw04fU-LHnx_A4g@mail.gmail.com>
 <CABWYdi0qhWs56WK=k+KoQBAMh+Tb6Rr0nY4kJN+E5YqfGhKTmQ@mail.gmail.com>
 <Y4T43Tc54vlKjTN0@cmpxchg.org>
 <CABWYdi0z6-46PrNWumSXWki6Xf4G_EP1Nvc-2t00nEi0PiOU3Q@mail.gmail.com>
 <CABWYdi25hricmGUqaK1K0EB-pAm04vGTg=eiqRF99RJ7hM7Gyg@mail.gmail.com>
 <Y4+RPry2tfbWFdSA@cmpxchg.org>
 <CANn89iJfx4QdVBqJ23oFJoz5DJKou=ZwVBNNXFNDJRNAqNvzwQ@mail.gmail.com>
 <Y4+rNYF9WZyJyBQp@cmpxchg.org>
 <20221206231049.g35ltbxbk54izrie@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SaZKvzrELtZk2moYXHTejAAx0pVU4ccKfYCaOf5kf6s=;
        b=Zn0bxdNAFoGshkFY4WWwXydY9YieUgDTNZ7UMeR67e3fjlwuS3bimPdqo+MlcClmlA
         fLNNhn7lOtPh3kHboREx0u0pavIRPoZ8MPQtUqmVWQhHoWMnG69jDb8GbMwd6C7GFJsQ
         NuSKOtY9XaouhxW8KB/Vri7ug8VeMKV2+LGU19xE5ea0m30ANCKbs/VGpcQEbVv40n9x
         I985ZKWJvAV1wo2PsPaLr88Rk9C81QmEfEhpUq5bQA8od3/kVF2kWGBu0xyDFcEgAESi
         qlcoV56MVSQKnM4xnFKdxcjsZ6xpA9yE+2XNVbWboluVsLgl9Hf4w/PNkj/u1euW8ww8
         DS2w==
Content-Disposition: inline
In-Reply-To: <20221206231049.g35ltbxbk54izrie@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Eric Dumazet <edumazet@google.com>, Ivan Babrou <ivan@cloudflare.com>, Linux MM <linux-mm@kvack.org>, Linux Kernel Network Developers <netdev@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, cgroups@vger.kernel.org, kernel-team <kernel-team@cloudflare.com>

On Tue, Dec 06, 2022 at 11:10:49PM +0000, Shakeel Butt wrote:
> On Tue, Dec 06, 2022 at 09:51:01PM +0100, Johannes Weiner wrote:
> > On Tue, Dec 06, 2022 at 08:13:50PM +0100, Eric Dumazet wrote:
> > > On Tue, Dec 6, 2022 at 8:00 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
> > > > @@ -1701,10 +1701,10 @@ void mem_cgroup_sk_alloc(struct sock *sk);
> > > >  void mem_cgroup_sk_free(struct sock *sk);
> > > >  static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
> > > >  {
> > > > -       if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_pressure)
> > > > +       if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->socket_pressure)
> > > 
> > > && READ_ONCE(memcg->socket_pressure))
> > > 
> > > >                 return true;
> > > >         do {
> > > > -               if (time_before(jiffies, READ_ONCE(memcg->socket_pressure)))
> > > > +               if (memcg->socket_pressure)
> > > 
> > > if (READ_ONCE(...))
> > 
> > Good point, I'll add those.
> > 
> > > > @@ -7195,10 +7194,10 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
> > > >                 struct page_counter *fail;
> > > >
> > > >                 if (page_counter_try_charge(&memcg->tcpmem, nr_pages, &fail)) {
> > > > -                       memcg->tcpmem_pressure = 0;
> > > 
> > > Orthogonal to your patch, but:
> > > 
> > > Maybe avoid touching this cache line too often and use READ/WRITE_ONCE() ?
> > > 
> > >     if (READ_ONCE(memcg->socket_pressure))
> > >       WRITE_ONCE(memcg->socket_pressure, false);
> > 
> > Ah, that's a good idea.
> > 
> > I think it'll be fine in the failure case, since that's associated
> > with OOM and total performance breakdown anyway.
> > 
> > But certainly, in the common case of the charge succeeding, we should
> > not keep hammering false into that variable over and over.
> > 
> > How about the delta below? I also flipped the branches around to keep
> > the common path at the first indentation level, hopefully making that
> > a bit clearer too.
> > 
> > Thanks for taking a look, Eric!
> > 
> 
> I still think we should not put a persistent state of socket pressure on
> unsuccessful charge which will only get reset on successful charge. I
> think the better approach would be to limit the pressure state by time
> window same as today but set it on charge path. Something like below:

I don't mind doing that if necessary, but looking at the code I don't
see why it would be.

The socket code sets protocol memory pressure on allocations that run
into limits, and clears pressure on allocations that succeed and
frees. Why shouldn't we do the same thing for memcg?

@@ -7237,6 +7235,9 @@ void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
        mod_memcg_state(memcg, MEMCG_SOCK, -nr_pages);
 
        refill_stock(memcg, nr_pages);
+
+       if (unlikely(READ_ONCE(memcg->socket_pressure)))
+               WRITE_ONCE(memcg->socket_pressure, false);
 }
