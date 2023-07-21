From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 0/8] memory recharging for offline memcgs
Date: Fri, 21 Jul 2023 11:15:21 -0700
Message-ID: <CAJD7tkbDxw-hqG8i85NhnjxmXFMbR5OaSW5dHDVYfdA=ZnPAEw@mail.gmail.com>
References: <20230720070825.992023-1-yosryahmed@google.com>
 <20230720153515.GA1003248@cmpxchg.org> <ZLmRlTej8Tm82kXG@slm.duckdns.org>
 <CAJD7tkYhu3g9u7HkUTFBtT3Q4edVZ2g1TWV1FDcyM9srrYCBLg@mail.gmail.com>
 <ZLmxLUNdxMi5s2Kq@slm.duckdns.org> <CAJD7tkZKo_oSZ-mQc-knMELP8kiY1N7taQhdV6tPsqN0tg=gog@mail.gmail.com>
 <ZLm1ptOYH6F8fGHT@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689963358; x=1690568158;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DbiSd66ZEYldEsKq2+kLG6VPo4CXuGCRaRM8MBpM8Ys=;
        b=7lthhZbiCbAg+8o7AWikQQeL7kc0nK7f0kSWrhFn+Uk3O4d+QHm5apyHLvYunpj5Pr
         RT6vE4go1HnVactpi+4QeK+kPu/SMjinRiATW2sJCLQzw5Nwog0ZWpAgYDsAy33HI/m9
         t8lsH3NVAvbwFbHzm6HFxPs52tx2wFKqLNgkmafOp2a7eZT2yceiH2jhPAM0TSj3al2E
         Xa4Md8rmmxAqFLCkAuEX+fMciv6rc+BqzH11Z7U2nMhd/9rS0t+SWXuURLmd+OpIdDKK
         LSGcvacvyOvoBQE9AWYKNfbH6guORoZCjXpkjdSVZfrrJnkNbVk+9912cpmwvziVB108
         EKmg==
In-Reply-To: <ZLm1ptOYH6F8fGHT-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Iurii Zaikin <yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jul 20, 2023 at 3:31=E2=80=AFPM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Hello,
>
> On Thu, Jul 20, 2023 at 03:23:59PM -0700, Yosry Ahmed wrote:
> > > On its own, AFAICS, I'm not sure the scope of problems it can actuall=
y solve
> > > is justifiably greater than what can be achieved with simple nesting.
> >
> > In our use case nesting is not a viable option. As I said, in a large
> > fleet where a lot of different workloads are dynamically being
> > scheduled on different machines, and where there is no way of knowing
> > what resources are being shared among what workloads, and even if we
> > do, it wouldn't be constant, it's very difficult to construct the
> > hierarchy with nesting to keep the resources confined.
>
> Hmm... so, usually, the problems we see are resources that are persistent
> across different instances of the same application as they may want to sh=
are
> large chunks of memory like on-memory cache. I get that machines get
> different dynamic jobs but unrelated jobs usually don't share huge amount=
 of

I am digging deeper to get more information for you. One thing I know
now is that different instances of the same job are contained within a
common parent, and we even use our previously proposed memcg=3D mount
option for tmpfs to charge their shared resources to a common parent.
So restarting tasks is not the problem we are seeing.

> memory at least in our case. The sharing across them comes down to things
> like some common library pages which don't really account for much these
> days.

Keep in mind that even a single page charged to a memcg and used by
another memcg is sufficient to result in a zombie memcg.

>
> > Keep in mind that the environment is dynamic, workloads are constantly
> > coming and going. Even if find the perfect nesting to appropriately
> > scope resources, some rescheduling may render the hierarchy obsolete
> > and require us to start over.
>
> Can you please go into more details on how much memory is shared for what
> across unrelated dynamic workloads? That sounds different from other use
> cases.

I am trying to collect more information from our fleet, but the
application restarting in a different cgroup is not what is happening
in our case. It is not easy to find out exactly what is going on on
machines and where the memory is coming from due to the
indeterministic nature of charging. The goal of this proposal is to
let the kernel handle leftover memory in zombie memcgs because it is
not always obvious to userspace what's going on (like it's not obvious
to me now where exactly is the sharing happening :) ).

One thing to note is that in some cases, maybe a userspace bug or
failed cleanup is a reason for the zombie memcgs. Ideally, this
wouldn't happen, but it would be nice to have a fallback mechanism in
the kernel if it does.

>
> Thanks.
>
> --
> tejun
