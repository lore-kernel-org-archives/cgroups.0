From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 3/3] mm: memcg: use non-unified stats flushing for
 userspace reads
Date: Mon, 28 Aug 2023 17:47:13 +0200
Message-ID: <ZOzBgfzlGdrPD4gk@dhcp22.suse.cz>
References: <20230821205458.1764662-4-yosryahmed@google.com>
 <ZOR6eyYfJYlxdMet@dhcp22.suse.cz>
 <CAJD7tka13M-zVZTyQJYL1iUAYvuQ1fcHbCjcOBZcz6POYTV-4g@mail.gmail.com>
 <ZOW2PZN8Sgqq6uR2@dhcp22.suse.cz>
 <CAJD7tka34WjtwBWfkTu8ZCEUkLm7h-AyCXpw=h34n4RZ5qBVwA@mail.gmail.com>
 <ZOcDLD/1WaOwWis9@dhcp22.suse.cz>
 <CAJD7tkZby2enWa8_Js8joHqFx_tHB=aRqHOizaSiXMUjvEei4g@mail.gmail.com>
 <CAJD7tkadEtjK_NFwRe8yhUh_Mdx9LCLmCuj5Ty-pqp1rHTb-DA@mail.gmail.com>
 <ZOhSyvDxAyYUJ45i@dhcp22.suse.cz>
 <CAJD7tkYPyb+2zOKqctQw-vhuwYRg85e6v2Y44xWJofHZ+F+YQw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1693237634; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wgffJfTbN2hrM2LfawRv94KbFXBSWdoYhh+f+YXVzXA=;
        b=j9QKq8c9xmscDVZf6LzoNgCsUfGNvGMoqZlKWzlvV1liR+juWKDkG/lLU4xNc5qBs/MW+x
        uyeKOP+bAwmg6pleKvqb1/El8aRPFEFsnNGdwa/rM1xNFzsehyP9P939blDXfum1VRnruS
        +NjieNHQc211STH1b2HQt6KFCWRUK/Q=
Content-Disposition: inline
In-Reply-To: <CAJD7tkYPyb+2zOKqctQw-vhuwYRg85e6v2Y44xWJofHZ+F+YQw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Done my homework and studied the rstat code more (sorry should have done
that earlier).

On Fri 25-08-23 08:14:54, Yosry Ahmed wrote:
[...]
> I guess what I am trying to say is, breaking down that lock is a major
> surgery that might require re-designing or re-implementing some parts
> of rstat. I would be extremely happy to be proven wrong. If we can
> break down that lock then there is no need for unified flushing even
> for in-kernel contexts, and we can all live happily ever after with
> cheap(ish) and accurate stats flushing.

Yes, this seems like a big change and also over complicating the whole
thing. I am not sure this is worth it.

> I really hope we can move forward with the problems at hand (sometimes
> reads are expensive, sometimes reads are stale), and not block fixing
> them until we can come up with an alternative to that global lock
> (unless, of course, there is a simpler way of doing that).

Well, I really have to say that I do not like the notion that reading
stats is unpredictable. This just makes it really hard to use. If
the precision is to be sarificed then this should be preferable over
potentially high global lock contention. We already have that model in
place of /proc/vmstat (configurable timeout for flusher and a way to
flush explicitly). I appreciate you would like to have a better
precision but as you have explored the locking is really hard to get rid
of here.

So from my POV I would prefer to avoid flushing from the stats reading
path and implement force flushing by writing to stat file. If the 2s
flushing interval is considered to coarse I would be OK to allow setting
it from userspace. This way this would be more in line with /proc/vmstat
which seems to be working quite well.

If this is not accaptable or deemed a wrong approach long term then it
would be good to reonsider the current cgroup_rstat_lock at least.
Either by turning it into mutex or by dropping the yielding code which
can severly affect the worst case latency AFAIU.

> Sorry for the very long reply :)

Thanks for bearing with me and taking time to formulate all this!
-- 
Michal Hocko
SUSE Labs
