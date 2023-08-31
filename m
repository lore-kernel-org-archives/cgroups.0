From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 3/3] mm: memcg: use non-unified stats flushing for
 userspace reads
Date: Thu, 31 Aug 2023 11:05:37 +0200
Message-ID: <ZPBX4S6XKX+HsDdW@dhcp22.suse.cz>
References: <ZOcDLD/1WaOwWis9@dhcp22.suse.cz>
 <CAJD7tkZby2enWa8_Js8joHqFx_tHB=aRqHOizaSiXMUjvEei4g@mail.gmail.com>
 <CAJD7tkadEtjK_NFwRe8yhUh_Mdx9LCLmCuj5Ty-pqp1rHTb-DA@mail.gmail.com>
 <ZOhSyvDxAyYUJ45i@dhcp22.suse.cz>
 <ZO48h7c9qwQxEPPA@slm.duckdns.org>
 <CAJD7tkaQ1hD9HHyYTK_vfCQ9PCVZag7qMBueKyB+sEn=swvNJA@mail.gmail.com>
 <ZO5IuULSCXMe9_pN@slm.duckdns.org>
 <CAJD7tkYtnhemCLBqFqOVurfWEaCjKtyEM745JYRxFS0r5cpZwQ@mail.gmail.com>
 <ZO5RROsZ1VESCsMG@slm.duckdns.org>
 <CAJD7tkZn_7ppFB1B1V8tBEw12LXCnEOue2Beq6e19PkUAVHUSQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1693472737; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DujY6dkqedsXFZeiaLXoDY/sYyiJ8dFrPRvd9QhXe4U=;
        b=TQbe7rXxOquuL1eiRja1QjBmuTWQRynSoCpR94kHmbf3Tw7pzzFmN0XBlcVvgYoueYiyQZ
        EAuxq5zsTcDlPZA2bzGEcVIGn3riohjif4a+PCyY7jvWVrgmvzDzsMsNttjkkgrEGpfBJH
        4CsiLRzknMGJH4L/emjN7lQ08pLIzkU=
Content-Disposition: inline
In-Reply-To: <CAJD7tkZn_7ppFB1B1V8tBEw12LXCnEOue2Beq6e19PkUAVHUSQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 29-08-23 13:20:34, Yosry Ahmed wrote:
[...]
> I will add a mutex on the userspace read side then and spin a v3.
> Hopefully this addresses Michal's concern as well. The lock dropping
> logic will still exist for the inner lock, but when one userspace
> reader drops the inner lock other readers won't be able to pick it up.

Yes, that would minimize the risk of the worst case pathological
behavior.

> > I don't have a strong preference. As long as we stay away from introducing a
> > new user interface construct and can address the noticed scalability issues,
> > it should be fine. Note that there are other ways to address priority
> > inversions and contentions too - e.g. we can always bounce flushing to a
> > [kthread_]kworker and rate limit (or rather latency limit) how often
> > different classes of users can trigger flushing. I don't think we have to go
> > there yet but if the simpler meaures don't work out, there are still many
> > ways to solve the problem within the kernel.
> 
> I whole-heartedly agree with the preference to fix the problem within
> the kernel with minimal/none user space involvement.

Let's see. While I would love to see a solution that works for everybody
without explicit interface we have hit problems with locks involved in
stat files in the past.
-- 
Michal Hocko
SUSE Labs
