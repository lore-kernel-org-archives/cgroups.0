From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 3/4] sock: Consider memcg pressure when raising sockmem
Date: Mon, 29 May 2023 21:12:05 +0000
Message-ID: <20230529211205.6clthjyt37c4opju@google.com>
References: <20230522070122.6727-1-wuyun.abel@bytedance.com>
 <20230522070122.6727-4-wuyun.abel@bytedance.com> <20230525012259.qd6i6rtqvvae3or7@google.com>
 <73b1381e-6a59-26fe-c0b6-51ea3ebf60f8@bytedance.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685394727; x=1687986727;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SNIbMRRuukreAZUC2GpTXXJapIJH6ZTqRY6eETcu5do=;
        b=a58aF0yeP61zDhlUOfNZLdoceiGGu26FxV3w360cVEX5mXHSCikCT9QZERrFOn+Wgg
         PQV3rmSuBZyWY7RJpxGCaweRtPtOGXNtJcQhRUc2Iiihmavwag/sytmxBLigXGwWZ5lk
         MLQoJyIYLb64f3BZPnDxbbiLlxkUMoohc9b/lJFrsKSBEmQDa4uuUXrKl0lWOYjJlass
         Vm9R7gNJl0aoBHuFj+eLnN5KovJ8X9KpPljEMIAznmET2jGKoJR2W7ks9R7Zl7Kw+ity
         mkmUkdCwuo7zJwvR5vpEgDRs5datWM1md9+4+SU5d4GrZlIohZop23cGF+rwOMxEyoPR
         NYUw==
In-Reply-To: <73b1381e-6a59-26fe-c0b6-51ea3ebf60f8-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


+linux-mm and cgroups

On Mon, May 29, 2023 at 07:58:45PM +0800, Abel Wu wrote:
> Hi Shakeel, thanks for reviewing! And sorry for replying so late,
> I was on a vocation :)
> 
> On 5/25/23 9:22 AM, Shakeel Butt wrote:
> > On Mon, May 22, 2023 at 03:01:21PM +0800, Abel Wu wrote:
> > > For now __sk_mem_raise_allocated() mainly considers global socket
> > > memory pressure and allows to raise if no global pressure observed,
> > > including the sockets whose memcgs are in pressure, which might
> > > result in longer memcg memstall.
> > > 
> > > So take net-memcg's pressure into consideration when allocating
> > > socket memory to alleviate long tail latencies.
> > > 
> > > Signed-off-by: Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> > 
> > Hi Abel,
> > 
> > Have you seen any real world production issue which is fixed by this
> > patch or is it more of a fix after reading code?
> 
> The latter. But we do observe one common case in the production env
> that p2p service, which mainly downloads container images, running
> inside a container with tight memory limit can easily be throttled and
> keep memstalled for a long period of time and sometimes even be OOM-
> killed. This service shows burst usage of TCP memory and I think it
> indeed needs suppressing sockmem allocation if memcg is already under
> pressure. The memcg pressure is usually caused by too many page caches
> and the dirty ones starting to be wrote back to slow backends. So it
> is insane to continuously receive net data to consume more memory.
> 

We actually made an intentional decision to not throttle the incoming
traffic under memory pressure. See 720ca52bcef22 ("net-memcg: avoid
stalls when under memory pressure"). If you think the throttling
behavior is preferred for your application, please propose the patch
separately and we can work on how to enable flexible policy here.

> > 
> > This code is quite subtle and small changes can cause unintended
> > behavior changes. At the moment the tcp memory accounting and memcg
> > accounting is intermingled and I think we should decouple them.
> 
> My original intention to post this patchset is to clarify that:
> 
>   - proto pressure only considers sysctl_mem[] (patch 2)
>   - memcg pressure only indicates the pressure inside itself
>   - consider both whenever needs allocation or reclaim (patch 1,3)
> 
> In this way, the two kinds of pressure maintain purer semantics, and
> socket core can react on both of them properly and consistently.

Can you please resend you patch series (without patch 3) and Cc to
linux-mm, cgroups list and memcg maintainers as well?
