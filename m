From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Expensive memory.stat + cpu.stat reads
Date: Fri, 11 Aug 2023 19:33:54 -0700
Message-ID: <CALvZod65Y-dSkH6a=ASTDTK2oGznTd7Yts1csttxoP0w9jaQUw@mail.gmail.com>
References: <CABWYdi0c6__rh-K7dcM_pkf9BJdTRtAU08M43KO9ME4-dsgfoQ@mail.gmail.com>
 <20230706062045.xwmwns7cm4fxd7iu@google.com> <CABWYdi2pBaCrdKcM37oBomc+5W8MdRp1HwPpOExBGYfZitxyWA@mail.gmail.com>
 <d3f3a7bc-b181-a408-af1d-dd401c172cbf@redhat.com> <CABWYdi2iWYT0sHpK74W6=Oz6HA_3bAqKQd4h+amK0n3T3nge6g@mail.gmail.com>
 <CABWYdi3YNwtPDwwJWmCO-ER50iP7CfbXkCep5TKb-9QzY-a40A@mail.gmail.com>
 <CABWYdi0+0gxr7PB4R8rh6hXO=H7ZaCzfk8bmOSeQMuZR7s7Pjg@mail.gmail.com>
 <a052dffe-ed5e-6d22-8af8-0861e618f327@redhat.com> <CABWYdi0CXy2GZax_s6O-Xc0gvH+TGJzKwv_v6QqMty9P-ATJug@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691807646; x=1692412446;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bTLD/QdYHVpt+4scbNbRrg+8KO9/38zELxI1928BfJc=;
        b=UdPOJ9r4HII7NNEiN5YCqMDeu6BvUbS2vwkDURY9Vi5e0eAEJ7VRD1haOIydI+Ib+7
         ta1fdKZPPI1LTFwuiLyNY15TXJfATouhe8oZDdjIU1ZJs5/a6HUe1jv6A9NBzwO8Kez+
         2dU9q0qA6XuEdoQybkOjDZWLqRqBB1YV1JxL8ygLQ1tn17frZDK7VFkRcf+YmkbWHaJY
         HWs9tbWC3xenui2rP6kX0MFlB60LyMS5NfLN2AFTisRDNP9qM6Snpohl0mnKK57hQh1r
         HH1mpbjF0mqUoiZO3XlpiVHLkH1vlUIf9Galfiph8Pyhsz1aR38R7jOOLjp7gUKGAIu8
         oVSQ==
In-Reply-To: <CABWYdi0CXy2GZax_s6O-Xc0gvH+TGJzKwv_v6QqMty9P-ATJug-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, kernel-team <kernel-team-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Ivan,

(sorry for late response as I was away)

On Fri, Aug 11, 2023 at 3:35=E2=80=AFPM Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org> w=
rote:
[...]
> > > I spent some time looking into this and I think I landed on a fix:
> > >
> > > * https://github.com/bobrik/linux/commit/50b627811d54
> > >
> > > I'm not 100% sure if it's the right fix for the issue, but it reduces
> > > the runtime significantly.

In your patch, can you try to replace mem_cgroup_flush_stats() with
mem_cgroup_flush_stats_ratelimited() instead of cgroup_rstat_flush().
I wanted to see if you observe any stale stats issues.
