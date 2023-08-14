From: Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>
Subject: Re: Expensive memory.stat + cpu.stat reads
Date: Mon, 14 Aug 2023 10:56:23 -0700
Message-ID: <CABWYdi2y+nsbum+0EnK4W_jF-8RNbNJJadiZH2Ofb_wnYjbrbA@mail.gmail.com>
References: <CABWYdi0c6__rh-K7dcM_pkf9BJdTRtAU08M43KO9ME4-dsgfoQ@mail.gmail.com>
 <20230706062045.xwmwns7cm4fxd7iu@google.com> <CABWYdi2pBaCrdKcM37oBomc+5W8MdRp1HwPpOExBGYfZitxyWA@mail.gmail.com>
 <d3f3a7bc-b181-a408-af1d-dd401c172cbf@redhat.com> <CABWYdi2iWYT0sHpK74W6=Oz6HA_3bAqKQd4h+amK0n3T3nge6g@mail.gmail.com>
 <CABWYdi3YNwtPDwwJWmCO-ER50iP7CfbXkCep5TKb-9QzY-a40A@mail.gmail.com>
 <CABWYdi0+0gxr7PB4R8rh6hXO=H7ZaCzfk8bmOSeQMuZR7s7Pjg@mail.gmail.com>
 <a052dffe-ed5e-6d22-8af8-0861e618f327@redhat.com> <CABWYdi0CXy2GZax_s6O-Xc0gvH+TGJzKwv_v6QqMty9P-ATJug@mail.gmail.com>
 <CALvZod65Y-dSkH6a=ASTDTK2oGznTd7Yts1csttxoP0w9jaQUw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1692035795; x=1692640595;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jeN/HGuUgCuQPe5kPvEPkK0pdFU40c32aDEDmB1vFRU=;
        b=eEoTsU2yEih/aF37TTSzmNf2+4o3WWF1X80OF2loX8zGBdBwW1B6vzzBdK1y20zH/r
         Sn4ahzedMLMHlay9fr3/eue4Hp1AwOn310a632QCVrN47BPnt+Ui5eBFBTUf6vVlWfFy
         LM6cmv43Q3SIto1Jjd8qhi9w9cYWGb0eYddco=
In-Reply-To: <CALvZod65Y-dSkH6a=ASTDTK2oGznTd7Yts1csttxoP0w9jaQUw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, kernel-team <kernel-team-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Aug 11, 2023 at 7:34=E2=80=AFPM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> =
wrote:
>
> Hi Ivan,
>
> (sorry for late response as I was away)
>
> On Fri, Aug 11, 2023 at 3:35=E2=80=AFPM Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>=
 wrote:
> [...]
> > > > I spent some time looking into this and I think I landed on a fix:
> > > >
> > > > * https://github.com/bobrik/linux/commit/50b627811d54
> > > >
> > > > I'm not 100% sure if it's the right fix for the issue, but it reduc=
es
> > > > the runtime significantly.
>
> In your patch, can you try to replace mem_cgroup_flush_stats() with
> mem_cgroup_flush_stats_ratelimited() instead of cgroup_rstat_flush().
> I wanted to see if you observe any stale stats issues.

We scrape cgroup metrics every 53s and at that scale I doubt we'd
notice any staleness. With 2s FLUSH_TIME it would be in the noise. We
can even remove any sort of flushing from memory.stat as long as
cpu.stat is read right before it as it does flushing for both.

I agree with Yosry that there's probably no reason to flush both cpu
and memory stats at the same time.

It doesn't seem right to use delayed flush for memory and direct flush
for cpu. Perhaps it doesn't matter as much to warrant a bigger rework
of how it's done, but maybe then my patch to use the same mechanism
between cpu and memory flushing makes sense?
