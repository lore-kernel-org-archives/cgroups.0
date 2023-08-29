From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] mm: memcg: use non-unified stats flushing for
 userspace reads
Date: Tue, 29 Aug 2023 10:12:52 -1000
Message-ID: <ZO5RROsZ1VESCsMG@slm.duckdns.org>
References: <ZOW2PZN8Sgqq6uR2@dhcp22.suse.cz>
 <CAJD7tka34WjtwBWfkTu8ZCEUkLm7h-AyCXpw=h34n4RZ5qBVwA@mail.gmail.com>
 <ZOcDLD/1WaOwWis9@dhcp22.suse.cz>
 <CAJD7tkZby2enWa8_Js8joHqFx_tHB=aRqHOizaSiXMUjvEei4g@mail.gmail.com>
 <CAJD7tkadEtjK_NFwRe8yhUh_Mdx9LCLmCuj5Ty-pqp1rHTb-DA@mail.gmail.com>
 <ZOhSyvDxAyYUJ45i@dhcp22.suse.cz>
 <ZO48h7c9qwQxEPPA@slm.duckdns.org>
 <CAJD7tkaQ1hD9HHyYTK_vfCQ9PCVZag7qMBueKyB+sEn=swvNJA@mail.gmail.com>
 <ZO5IuULSCXMe9_pN@slm.duckdns.org>
 <CAJD7tkYtnhemCLBqFqOVurfWEaCjKtyEM745JYRxFS0r5cpZwQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693339974; x=1693944774; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2c+nAeWfVQ1Bjfr8Iht6NC2EjfJ/cEr0+ZzRbynwAxk=;
        b=PKeJ3wv65Hxtbk9t9jwqLMwo41jPlQI/bEzBLZYuBxDXptwUr24208p2xvY6CA+3EG
         yli15LW0MnwR+QW7XpKaA8khOvp+KKpb2WsGXuGkzO2yj3ITQ1dYblxSDL0cSdMT7fbB
         lTR9RUQ+kCXoTXMz9N8AcbeGQLMRweuyGS436cI/RU4eNQZr6M0tO8ZKEAxQUvlk+c6+
         HK8W26grUmkCr9Ihinr9z2E42olcL9GVsaJOBHEBZbqbMlU8Cl3+p1ZKsg3GXTCAOZMM
         wVKxT0um3wcC9N0OKJ7do4BvG1Xyhd3dQMlZsvS0JSAoRvJe90209F+g0+ywZ5vf8kjt
         SrFw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJD7tkYtnhemCLBqFqOVurfWEaCjKtyEM745JYRxFS0r5cpZwQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Tue, Aug 29, 2023 at 12:54:06PM -0700, Yosry Ahmed wrote:
...
> > Maybe leave the global lock as-is and gate the userland flushers with a
> > mutex so that there's only ever one contenting on the rstat lock from
> > userland side?
> 
> Waiman suggested this as well. We can do that for sure, although I
> think we should wait until we are sure it's needed.
> 
> One question. If whoever is holding that mutex is either flushing with
> the spinlock held or spinning (i.e not sleepable or preemptable),
> wouldn't this be equivalent to just changing the spinlock with a mutex
> and disable preemption while holding it?

Well, it creates layering so that userspace can't flood the inner lock which
can cause contention issues for kernel side users. Not sleeping while
actively flushing is an side-effect too but the code at least doesn't look
as anti-patterny as disabling preemption right after grabbing a mutex.

I don't have a strong preference. As long as we stay away from introducing a
new user interface construct and can address the noticed scalability issues,
it should be fine. Note that there are other ways to address priority
inversions and contentions too - e.g. we can always bounce flushing to a
[kthread_]kworker and rate limit (or rather latency limit) how often
different classes of users can trigger flushing. I don't think we have to go
there yet but if the simpler meaures don't work out, there are still many
ways to solve the problem within the kernel.

Thanks.

-- 
tejun
