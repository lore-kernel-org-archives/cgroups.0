From: Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>
Subject: Re: Low TCP throughput due to vmpressure with swap enabled
Date: Tue, 22 Nov 2022 10:11:41 -0800
Message-ID: <CABWYdi2TWJej806yif9hi7cxD9P9-EpMB9EU_72wWw9fFqtt4g@mail.gmail.com>
References: <CABWYdi0G7cyNFbndM-ELTDAR3x4Ngm0AehEp5aP0tfNkXUE+Uw@mail.gmail.com>
 <CANn89iLzARPp6jW1xS0rf+-wS_RnwK-Kfgs9uQFYan2AHPRQFA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uTQ93Z87A52MpnvZoEIsory772cnGzPzKryozV7ZFMk=;
        b=eXRoXvJRiBCc4ufq2quAPTpY36052Qmg9ynJmmqrrDvdULqV2GyhSyyCXRtHLfReA0
         UZ4uYA3R18WWgJQym+RjkpAA9QLjlQe9RkctGzZLf2CLo2m5Yjei/K0Gw+4PLUG7YH+C
         SieK0NVoP0S46kpu/NZHdkdeARBmklooxECdQ=
In-Reply-To: <CANn89iLzARPp6jW1xS0rf+-wS_RnwK-Kfgs9uQFYan2AHPRQFA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux Kernel Network Developers <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team <kernel-team-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>

On Tue, Nov 22, 2022 at 10:01 AM Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Mon, Nov 21, 2022 at 4:53 PM Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org> wrote:
> >
> > Hello,
> >
> > We have observed a negative TCP throughput behavior from the following commit:
> >
> > * 8e8ae645249b mm: memcontrol: hook up vmpressure to socket pressure
> >
> > It landed back in 2016 in v4.5, so it's not exactly a new issue.
> >
> > The crux of the issue is that in some cases with swap present the
> > workload can be unfairly throttled in terms of TCP throughput.
>
> I guess defining 'fairness' in such a scenario is nearly impossible.
>
> Have you tried changing /proc/sys/net/ipv4/tcp_rmem  (and/or tcp_wmem) ?
> Defaults are quite conservative.

Yes, our max sizes are much higher than the defaults. I don't see how
it matters though. The issue is that the kernel clamps rcv_sshtrehsh
at 4 x advmss. No matter how much TCP memory you end up using, the
kernel will clamp based on responsiveness to memory reclaim, which in
turn depends on swap presence. We're seeing it in production with tens
of thousands of sockets and high max tcp_rmem and I'm able to
replicate the same issue in my vm with the default sysctl values.

> If for your workload you want to ensure a minimum amount of memory per
> TCP socket,
> that might be good enough.

That's not my goal at all. We don't have a problem with TCP memory
consumption. Our issue is low throughput because vmpressure() thinks
that the cgroup is memory constrained when it most definitely is not.
