From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] mm: memcg: use non-unified stats flushing for
 userspace reads
Date: Tue, 29 Aug 2023 08:44:23 -1000
Message-ID: <ZO48h7c9qwQxEPPA@slm.duckdns.org>
References: <20230821205458.1764662-1-yosryahmed@google.com>
 <20230821205458.1764662-4-yosryahmed@google.com>
 <ZOR6eyYfJYlxdMet@dhcp22.suse.cz>
 <CAJD7tka13M-zVZTyQJYL1iUAYvuQ1fcHbCjcOBZcz6POYTV-4g@mail.gmail.com>
 <ZOW2PZN8Sgqq6uR2@dhcp22.suse.cz>
 <CAJD7tka34WjtwBWfkTu8ZCEUkLm7h-AyCXpw=h34n4RZ5qBVwA@mail.gmail.com>
 <ZOcDLD/1WaOwWis9@dhcp22.suse.cz>
 <CAJD7tkZby2enWa8_Js8joHqFx_tHB=aRqHOizaSiXMUjvEei4g@mail.gmail.com>
 <CAJD7tkadEtjK_NFwRe8yhUh_Mdx9LCLmCuj5Ty-pqp1rHTb-DA@mail.gmail.com>
 <ZOhSyvDxAyYUJ45i@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693334666; x=1693939466; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8wRQp/5cBNehRizqtkTinmdKAq2BLV1uZRrSduBoGzQ=;
        b=eO3giI69gA6zCVBejdv1IiMWcFUWtOYFqcwri4XyLvhwMhJLoL64qD0pT6tIPchAH1
         MOFcBD2MkA/8nQjQsa0a/wa9veeDWnaUfKnc/mad86OjQ73leWKtlgnoU8u90jiAWVcu
         8JnJx+w2tQ9ZQnKLMah6N493MKPoMJlxvDZ2jIsEAvinTjftCUZX9587Hu1azKhfQJUU
         TL2yLsQ3McrnQQDOSwwR5x20hWW17gh6P1B3YgyfzBDjuvySmLoKAp7rgDHcbQssWzHs
         FxOiMijq7gnmJ79gFXBcpx95jUTEedU4wyddKuhbE1xX7p2CxXfnCeuRYtnFL7fqvElX
         /zxQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ZOhSyvDxAyYUJ45i-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Fri, Aug 25, 2023 at 09:05:46AM +0200, Michal Hocko wrote:
> > > I think that's how it was always meant to be when it was designed. The
> > > global rstat lock has always existed and was always available to
> > > userspace readers. The memory controller took a different path at some
> > > point with unified flushing, but that was mainly because of high
> > > concurrency from in-kernel flushers, not because userspace readers
> > > caused a problem. Outside of memcg, the core cgroup code has always
> > > exercised this global lock when reading cpu.stat since rstat's
> > > introduction. I assume there hasn't been any problems since it's still
> > > there.
> 
> I suspect nobody has just considered a malfunctioning or adversary
> workloads so far.
> 
> > > I was hoping Tejun would confirm/deny this.
> 
> Yes, that would be interesting to hear.

So, the assumptions in the original design were:

* Writers are high freq but readers are lower freq and can block.

* The global lock is mutex.

* Back-to-back reads won't have too much to do because it only has to flush
  what's been accumulated since the last flush which took place just before.

It's likely that the userspace side is gonna be just fine if we restore the
global lock to be a mutex and let them be. Most of the problems are caused
by trying to allow flushing from non-sleepable and kernel contexts. Would it
make sense to distinguish what can and can't wait and make the latter group
always use cached value? e.g. even in kernel, during oom kill, waiting
doesn't really matter and it can just wait to obtain the up-to-date numbers.

Thanks.

-- 
tejun
