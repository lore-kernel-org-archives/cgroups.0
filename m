From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] memcg rstat flushing optimization
Date: Wed, 5 Oct 2022 08:22:26 -1000
Message-ID: <Yz3LYoxhvGW/b9yz@slm.duckdns.org>
References: <CAJD7tkZQ+L5N7FmuBAXcg_2Lgyky7m=fkkBaUChr7ufVMHss=A@mail.gmail.com>
 <Yz2xDq0jo1WZNblz@slm.duckdns.org>
 <CAJD7tkawcrpmacguvyWVK952KtD-tP+wc2peHEjyMHesdM1o0Q@mail.gmail.com>
 <Yz3CH7caP7H/C3gL@slm.duckdns.org>
 <CAJD7tkY8gNNaPneAVFDYcWN9irUvE4ZFW=Hv=5898cWFG1p7rg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7kOunpUwcD5B3LDxquXvMevQ7y8E8fEOG4N0wZf8Bfk=;
        b=WpMwCgvgGsA0PuBsnwhYNtJ0CK98v4OtYMf88jz1gMNhlOCoJTZkzylvAsRYIFsECA
         moN8UIUNqopRtKF76bR2MQaZRo0AKL/m7neTmV/WJeyFe9i/sUGa9JMaAtDuNR/q+P1Y
         lrkxNcDnYdeF5DiFn7bvBC0lZpQbOGQ63z6xl7UuLV/LUJZUdSlE3s7yOih61aXEcGLO
         knTvvOAPH9/7p8jMvcn1wEMMlvTGN7iFuojaVGOMyvXFWoVvwlvKyKMWnnn8TM9ySBGd
         MyaIj7a82TPsH/h5af28QagxWU3CuwJoEx3GDOcNX8riHVd/ej6F9gnMKslv9VO8TT/T
         3OVw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJD7tkY8gNNaPneAVFDYcWN9irUvE4ZFW=Hv=5898cWFG1p7rg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hello,

On Wed, Oct 05, 2022 at 11:02:23AM -0700, Yosry Ahmed wrote:
> > I was thinking more that being done inside the flush function.
> 
> I think the flush function already does that in some sense if
> might_sleep is true, right? The problem here is that we are using

Oh I forgot about that. Right.

...
> I took a couple of crashed machines kdumps and ran a script to
> traverse updated memcgs and check how many cpus have updates and how
> many updates are there on each cpu. I found that on average only a
> couple of stats are updated per-cpu per-cgroup, and less than 25% of
> cpus (but this is on a large machine, I expect the number to go higher
> on smaller machines). Which is why I suggested a bitmask. I understand
> though that this depends on whatever workloads were running on those
> machines, and that in case where most stats are updated the bitmask
> will actually make things slightly worse.

One worry I have about selective flushing is that it's only gonna improve
things by some multiples while we can reasonably increase the problem size
by orders of magnitude.

The only real ways out I can think of are:

* Implement a periodic flusher which keeps the stats needed in irqsafe path
  acceptably uptodate to avoid flushing with irq disabled. We can make this
  adaptive too - no reason to do all this if the number to flush isn't huge.

* Shift some work to the updaters. e.g. in many cases, propagating per-cpu
  updates a couple levels up from update path will significantly reduce the
  fanouts and thus the number of entries which need to be flushed later. It
  does add on-going overhead, so it prolly should adaptive or configurable,
  hopefully the former.

Thanks.

-- 
tejun
