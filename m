From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [RFC] Add swappiness argument to memory.reclaim
Date: Tue, 17 May 2022 09:05:08 -0700
Message-ID: <YoPHtHXzpK51F/1Z@carbon>
References: <CAJD7tkbDpyoODveCsnaqBBMZEkDvshXJmNdbk51yKSNgD7aGdg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1652803513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QRscBrAyYKCcsJKeuDnK4iX4aYhS2tbsgqstU6o6r+0=;
        b=E3i7b2DvMjTaav2SXoJjrd4womnB85IlKuEu0WiUCqZOEn75QMduH1dscInT1mHh0d/X2H
        0jfXW0NcaUEoShRxWykTXdll8ZmIL2hasAGT/f1bR4rCjzHLRtw0/jnJJQshTVZLxaQqBF
        KkiCSxwcLLhNNQrn0+qH6cl7D3G9GSE=
Content-Disposition: inline
In-Reply-To: <CAJD7tkbDpyoODveCsnaqBBMZEkDvshXJmNdbk51yKSNgD7aGdg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chen Wandun <chenwandun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Mon, May 16, 2022 at 03:29:42PM -0700, Yosry Ahmed wrote:
> The discussions on the patch series [1] to add memory.reclaim has
> shown that it is desirable to add an argument to control the type of
> memory being reclaimed by invoked proactive reclaim using
> memory.reclaim.
> 
> I am proposing adding a swappiness optional argument to the interface.
> If set, it overwrites vm.swappiness and per-memcg swappiness. This
> provides a way to enforce user policy on a stateless per-reclaim
> basis. We can make policy decisions to perform reclaim differently for
> tasks of different app classes based on their individual QoS needs. It
> also helps for use cases when particularly page cache is high and we
> want to mainly hit that without swapping out.
> 
> The interface would be something like this (utilizing the nested-keyed
> interface we documented earlier):
> 
> $ echo "200M swappiness=30" > memory.reclaim

What are the anticipated use cases except swappiness == 0 and
swappiness == system_default?

IMO it's better to allow specifying the type of memory to reclaim,
e.g. type="file"/"anon"/"slab", it's a way more clear what to expect.

E.g. what
$ echo "200M swappiness=1" > memory.reclaim
means if there is only 10M of pagecache? How much of anon memory will
be reclaimed?

Thanks!
