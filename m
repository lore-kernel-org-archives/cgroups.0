From: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 0/8] memory recharging for offline memcgs
Date: Thu, 20 Jul 2023 16:24:02 -0700
Message-ID: <CABdmKX0JETkXpOSfCUZ3jaZv1JxRzbTP+Se4i3HMKjP3PNZ8Qg@mail.gmail.com>
References: <20230720070825.992023-1-yosryahmed@google.com>
 <20230720153515.GA1003248@cmpxchg.org> <ZLmRlTej8Tm82kXG@slm.duckdns.org>
 <CAJD7tkYhu3g9u7HkUTFBtT3Q4edVZ2g1TWV1FDcyM9srrYCBLg@mail.gmail.com>
 <ZLmxLUNdxMi5s2Kq@slm.duckdns.org> <CAJD7tkZKo_oSZ-mQc-knMELP8kiY1N7taQhdV6tPsqN0tg=gog@mail.gmail.com>
 <ZLm1ptOYH6F8fGHT@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689895454; x=1690500254;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wla3efE6JyGPdqvNC8P15XtJgOh6q0zRuJGb6WkYFkU=;
        b=ZyqL/pfs56dYsjzgW1sC88OX6ea1yYxnkLNnDI3qkpD1FfBIuqlzveXINQdKsv5k/L
         b2hWGu0BSe43eg7hgztFXLBLiWGR5sElL2WlIU8IWQba5lCaD4QHi2h585ZS79ells+d
         EyYJPYuffXS94IYaIaFx2HapRRKi7Fq8ooPOzLLb2POx0evTUdrmNqgOETvS6AbjTz7Z
         c7qnuP55qbCcv2pgvn6TUwH+46rb4fwqMSdQUAgZYHLo13hDnxfK38H5hjC2TMZl6ldF
         /QRVPbyCjd+D1wZv8SxRGevdUw+z00sMJyXtuRO414Fp54C7WEsXKxMEiB2sLuiW18fE
         uFEg==
In-Reply-To: <ZLm1ptOYH6F8fGHT-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Iurii Zaikin <yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

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
> memory at least in our case. The sharing across them comes down to things
> like some common library pages which don't really account for much these
> days.
>
This has also been my experience in terms of bytes of memory that are
incorrectly charged (because they're charged to a zombie), but that is
because memcg doesn't currently track the large shared allocations in
my case (primarily dma-buf). The greater issue I've seen so far is the
number of zombie cgroups that can accumulate over time. But my
understanding is that both of these two problems are currently
significant for Yosry's case.
