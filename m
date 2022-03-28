From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC bpf-next] Hierarchical Cgroup Stats Collection Using BPF
Date: Mon, 28 Mar 2022 02:16:53 -0700
Message-ID: <CAJD7tkaS0k9TVvsDDKP1XCahJ1TyJeSyRHGSM+NZygFwMD=wzQ@mail.gmail.com>
References: <CAJD7tkbQNpeX8MGw9dXa5gi6am=VNXwgwUoTd6+K=foixEm1fw@mail.gmail.com>
 <CAPhsuW6QTaCVekkT8Ah0N2K4JY7yiiO2wZjk6pVKuraEqjkoXQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kpQSKtdwNb3KC+dlFVYdgCuQmYu2WXrTtlnYf3fe1l8=;
        b=YCsQDYTMhVfFS4jUgjugN+EKYW2QiI11NiiFh/w4yzJf8k0v+rR+WcwnSZ1DS/RnKP
         7GkAeIFgVSZcYgH9yYPcRw1VQuH8wf6MSjnx31JR4bmwVt+N7EG5ssSn4iorRC9/5TaF
         nVsY1CNVZUcfifMRRoRcBAgXAK1dhD0FLbwGOFlGr87RFvJKSgpyNaYT4XugCWPs+KJz
         S/R7pigyNxrGJ5jGrhVrThjkD5V1lkqRGQBw1/u2heG1ewyU/y1jUYJKmHbLeE1QGjTI
         MJGui/dwhfeQX32BFZ3xZCjFv+eXoBGlci9kCOx5YWMJxIy/5mPiJFYPZyEUXdgaDDvU
         weKA==
In-Reply-To: <CAPhsuW6QTaCVekkT8Ah0N2K4JY7yiiO2wZjk6pVKuraEqjkoXQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Fri, Mar 18, 2022 at 12:59 PM Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Wed, Mar 9, 2022 at 12:27 PM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > Hey everyone,
> >
> > I would like to discuss an idea to facilitate collection of
> > hierarchical cgroup stats using BPF programs. We want to provide a
> > simple interface for BPF programs to collect hierarchical cgroup stats
> > and integrate with the existing rstat aggregation mechanism in the
> > kernel. The most prominent use case is the ability to extend memcg
> > stats (and histograms) by BPF programs.
> >
>
> + Namhyung,
>
> I forgot to mention this in the office hour. The aggregation efficiency
> problem is actually similar to Namhyung's work to use BPF programs
> to aggregate perf counters. Check:
>      tools/perf/util/bpf_skel/bperf_cgroup.bpf.c
>
> Namhyung's solution is to walk up the cgroup tree on cgroup switch
> events. This may not be as efficient as rstat flush logic, but I think it
> is good enough for many use cases (unless the cgroup tree is very
> deep). It also demonstrates how we can implement some cgroup
> logic in BPF.
>
> I hope this helps.
>
> Thanks,
> Song
>
> [...]

Hi Song,

Thanks so much for pointing this out. I have an idea of a less
intrusive and more generic way to directly use rstat flushing in BPF
programs, which basically makes BPF programs maintain their own stats
and flushing logic and only using helpers to make calls to rstat
(instead of a whole new rstat map). I will work on an RFC patch series
for this.

If this doesn't work out, I will probably fallback to handling the
flushing completely in the BPF programs, similar to the example you
provided (which is a lot of help, thanks!).
