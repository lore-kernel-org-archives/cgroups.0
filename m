From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 0/8] memory recharging for offline memcgs
Date: Thu, 20 Jul 2023 15:23:59 -0700
Message-ID: <CAJD7tkZKo_oSZ-mQc-knMELP8kiY1N7taQhdV6tPsqN0tg=gog@mail.gmail.com>
References: <20230720070825.992023-1-yosryahmed@google.com>
 <20230720153515.GA1003248@cmpxchg.org> <ZLmRlTej8Tm82kXG@slm.duckdns.org>
 <CAJD7tkYhu3g9u7HkUTFBtT3Q4edVZ2g1TWV1FDcyM9srrYCBLg@mail.gmail.com> <ZLmxLUNdxMi5s2Kq@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689891877; x=1690496677;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G0owsP3MW0e32jBov7KLN+DK+7a5lEoZ//WqOCREwlQ=;
        b=jd6zJsXD5mYj6yvKRyJH5NBquT74jAAnKJcxJxjtVugZ74xdKdKUA/Xqh2qycTBeFg
         vPln7NlfYVWD/ksCNMT/BFt0LQbv78OLE46EKPak+6l1I1wQxZ8TsalyBCa4/uy2UGfP
         4bQUMBpcGL0kubjXSaUgnImEDhLu8s2ELtZbAO8Vj9SBPIax+YSn04fWP2IBG5Yylr5X
         8aFVUOFXvi3d0ege/03nCH4/jH9luNjJE8Hnq5/xwKNoEVplwnFF+7KsZF2+GABq1CH7
         V2lajH7+XWj4nEhKf6uxSpT0wIJZS55VBvNUUqvbp2iLZnQ3ETD0dgV6lA42DVvyjOE4
         /+vQ==
In-Reply-To: <ZLmxLUNdxMi5s2Kq-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Iurii Zaikin <yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jul 20, 2023 at 3:12=E2=80=AFPM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Hello,
>
> On Thu, Jul 20, 2023 at 02:34:16PM -0700, Yosry Ahmed wrote:
> > > Or just create a nesting layer so that there's a cgroup which represe=
nts the
> > > persistent resources and a nested cgroup instance inside representing=
 the
> > > current instance.
> >
> > In practice it is not easy to know exactly which resources are shared
> > and used by which cgroups, especially in a large dynamic environment.
>
> Yeah, that only covers when resource persistence is confined in a known
> scope. That said, I have a hard time seeing how recharding once after cgr=
oup
> destruction can be a solution for the situations you describe. What if A
> touches it once first, B constantly uses it but C only very occasionally =
and
> after A dies C ends up owning it due to timing. This is very much possibl=
e
> in a large dynamic environment but neither the initial or final situation=
 is
> satisfactory.

That is indeed possible, but it would be more likely that the charge
is moved to B. As I said, it's not perfect, but it is an improvement
over what we have today. Even if C ends up owning it, it's better than
staying with the dead A.

>
> To solve the problems you're describing, you actually would have to
> guarantee that memory pages are charged to the current majority user (or
> maybe even spread across current active users). Maybe it can be argued th=
at
> this is a step towards that but it's a very partial step and at least wou=
ld
> need a technically viable direction that this development can follow.

Right, that would be a much larger effort (arguably memcg v3 ;) ).
This proposal is focused on the painful artifact of the sharing/sticky
resources problem: zombie memcgs. We can extend the automatic charge
movement semantics later to cover more cases or be smarter, or ditch
the existing charging semantics completely and start over with
sharing/stickiness in mind. Either way, that would be a long-term
effort. There is a problem that exists today though that ideally can
be fixed/improved by this proposal.

>
> On its own, AFAICS, I'm not sure the scope of problems it can actually so=
lve
> is justifiably greater than what can be achieved with simple nesting.

In our use case nesting is not a viable option. As I said, in a large
fleet where a lot of different workloads are dynamically being
scheduled on different machines, and where there is no way of knowing
what resources are being shared among what workloads, and even if we
do, it wouldn't be constant, it's very difficult to construct the
hierarchy with nesting to keep the resources confined.

Keep in mind that the environment is dynamic, workloads are constantly
coming and going. Even if find the perfect nesting to appropriately
scope resources, some rescheduling may render the hierarchy obsolete
and require us to start over.

>
> Thanks.
>
> --
> tejun
