From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] mm: memcg: use rstat for non-hierarchical stats
Date: Wed, 2 Aug 2023 01:11:53 -0700
Message-ID: <CAJD7tkY4hTTCfqSGa_XexbH=WSTJ4WXWeMXSU+6KW8qfr7agfQ@mail.gmail.com>
References: <20230726153223.821757-1-yosryahmed@google.com>
 <20230726153223.821757-2-yosryahmed@google.com> <ZMkXDuwD8RFRKnNQ@dhcp22.suse.cz>
 <CAJD7tkbb8AWR-duWb+at-S9MMz48b0JqnM+b5ok83TzvXvPb+A@mail.gmail.com>
 <CAJD7tkbZi16w4mYngVK8qA84FMijmHvwzMjHfrJiCsV=WjixOA@mail.gmail.com> <ZMoIYLwITUZzXp4C@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690963950; x=1691568750;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mbfWfMV50AarvWD5inw6HeTT4LJutE3Rh+ubSQUN7nw=;
        b=A7CXYSrzdB5JXUD+7TCbtjYXqsDsijx1Qdih2Ww0e826+V/wI+JeaBTYRRV/cOs7yL
         15UHOQr5FA1Sx0dmaVxVTdw+klq5kFNneo6tqFVCNM4hFZLZCKgk2utxHXdGIvlPgZLa
         3dEZUaL+11e8wHIVj5u5stdyVVQM22KYzS/H4AYYeyTqrtkdVY76SxyKBSvcEEXB2sJu
         QUE2bQoTGJXp4/Gw1pzCfyUMM8pEEBvcN/Xg3y3sJrL56Me5G8XV4GI9Auc269FYZD4V
         0WwHsAbVbENXuGd6QRWFeGdXWdSGTGshDHcFjYRwqbkvlUFwGwJKWgwsXKuxzbI0+hWa
         Iecg==
In-Reply-To: <ZMoIYLwITUZzXp4C-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, Aug 2, 2023 at 12:40=E2=80=AFAM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrot=
e:
>
> On Tue 01-08-23 10:29:39, Yosry Ahmed wrote:
> > On Tue, Aug 1, 2023 at 9:39=E2=80=AFAM Yosry Ahmed <yosryahmed@google.c=
om> wrote:
> [...]
> > > > Have you measured any potential regression for cgroup v2 which coll=
ects
> > > > all this data without ever using it (AFAICS)?
> > >
> > > I did not. I did not expect noticeable regressions given that all the
> > > extra work is done during flushing, which should mostly be done by th=
e
> > > asynchronous worker, but can also happen in the stats reading context=
.
> > > Let me run the same script on cgroup v2 just in case and report back.
> >
> > A few runs on mm-unstable with this patch:
> >
> > # time cat /sys/fs/cgroup/cg*/memory.stat > /dev/null
>
> Is this really representative test to make? I would have expected the
> overhead would be mostly in mem_cgroup_css_rstat_flush (if it is visible
> at all of course). This would be more likely visible in all cpus busy
> situation (you can try heavy parallel kernel build from tmpfs for
> example).


I see. You are more worried about asynchronous flushing eating cpu
time rather than the synchronous flushing being slower. In fact, my
test is actually not representative at all because probably most of
the cgroups either do not have updates or the asynchronous flusher got
to them first.

Let me try a workload that is more parallel & cpu intensive and report
back. I am thinking of parallel reclaim/refault loops since both
reclaim and refault paths invoke stat updates and stat flushing.

>
> [...]
>
> > It looks like there are no regressions on cgroup v2 when reading the
> > stats. Please let me know if you want me to send a new version with
> > the cgroup v2 results as well in the commit log -- or I can just send
> > a new commit log. Whatever is easier for Andrew.
>
> Updating the changelog should be good enough.
> --
> Michal Hocko
> SUSE Labs
