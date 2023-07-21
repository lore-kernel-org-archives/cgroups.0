From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 0/8] memory recharging for offline memcgs
Date: Fri, 21 Jul 2023 13:59:55 -0700
Message-ID: <CAJD7tkaro0opThQaMTFr_8sAjiFFEsaZK9YzEjBaSiDJ93DOBg@mail.gmail.com>
References: <20230720070825.992023-1-yosryahmed@google.com>
 <20230720153515.GA1003248@cmpxchg.org> <ZLmRlTej8Tm82kXG@slm.duckdns.org>
 <CAJD7tkYhu3g9u7HkUTFBtT3Q4edVZ2g1TWV1FDcyM9srrYCBLg@mail.gmail.com>
 <ZLmxLUNdxMi5s2Kq@slm.duckdns.org> <CAJD7tkZKo_oSZ-mQc-knMELP8kiY1N7taQhdV6tPsqN0tg=gog@mail.gmail.com>
 <ZLm1ptOYH6F8fGHT@slm.duckdns.org> <CAJD7tkbDxw-hqG8i85NhnjxmXFMbR5OaSW5dHDVYfdA=ZnPAEw@mail.gmail.com>
 <ZLrN1BE42Tsybm6j@slm.duckdns.org> <CAJD7tkatz1JhKVj_iP9J0H7fPJnUSurZkCT1iJTJ=+qRen_nLQ@mail.gmail.com>
 <20230721204408.GA1033322@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689973232; x=1690578032;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JOgbHJec+Tti6Wru7OdTqH4+oMnk38DLOG9c4qJJzP8=;
        b=hkZ+D5g5lDrDl4A690EnFIQrEBWzd57RPaM7SaKw8Y1xk7u1cAMRN4ld2mJkGcGqTY
         /owNQyHKnflgKZIMZHrBc4AfSR3tYOaMOz+dYxvCdQz1ey2+U9QmjTviN0Qum0KxXOdw
         8SFQWbBe/mtcxHqLJFyQClCzU3YhFgrJb03GP0qsdY0KqtaR9x7Hx4Kq9tfA6JVlHuMC
         ypntCYhcJXE3lxIkq+N9LeOkrGyUDm31Kih652QMPZI12bzYmDTEAxVdi1OIoHwEX4uX
         mQtgA1yxQCz6Ur0+IYN0S57Jk3wDnFBAsv0rrUdhewR+YipnqPXBqEiLqMAQS7fN91mG
         kzeA==
In-Reply-To: <20230721204408.GA1033322-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Iurii Zaikin <yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jul 21, 2023 at 1:44=E2=80=AFPM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org=
> wrote:
>
> On Fri, Jul 21, 2023 at 11:47:49AM -0700, Yosry Ahmed wrote:
> > On Fri, Jul 21, 2023 at 11:26=E2=80=AFAM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrot=
e:
> > >
> > > Hello,
> > >
> > > On Fri, Jul 21, 2023 at 11:15:21AM -0700, Yosry Ahmed wrote:
> > > > On Thu, Jul 20, 2023 at 3:31=E2=80=AFPM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> w=
rote:
> > > > > memory at least in our case. The sharing across them comes down t=
o things
> > > > > like some common library pages which don't really account for muc=
h these
> > > > > days.
> > > >
> > > > Keep in mind that even a single page charged to a memcg and used by
> > > > another memcg is sufficient to result in a zombie memcg.
> > >
> > > I mean, yeah, that's a separate issue or rather a subset which isn't =
all
> > > that controversial. That can be deterministically solved by reparenti=
ng to
> > > the parent like how slab is handled. I think the "deterministic" part=
 is
> > > important here. As you said, even a single page can pin a dying cgrou=
p.
> >
> > There are serious flaws with reparenting that I mentioned above. We do
> > it for kernel memory, but that's because we really have no other
> > choice. Oftentimes the memory is not reclaimable and we cannot find an
> > owner for it. This doesn't mean it's the right answer for user memory.
> >
> > The semantics are new compared to normal charging (as opposed to
> > recharging, as I explain below). There is an extra layer of
> > indirection that we did not (as far as I know) measure the impact of.
> > Parents end up with pages that they never used and we have no
> > observability into where it came from. Most importantly, over time
> > user memory will keep accumulating at the root, reducing the accuracy
> > and usefulness of accounting, effectively an accounting leak and
> > reduction of capacity. Memory that is not attributed to any user, aka
> > system overhead.
>
> Reparenting has been the behavior since the first iteration of cgroups
> in the kernel. The initial implementation would loop over the LRUs and
> reparent pages synchronously during rmdir. This had some locking
> issues, so we switched to the current implementation of just leaving
> the zombie memcg behind but neutralizing its controls.

Thanks for the context.

>
> Thanks to Roman's objcg abstraction, we can now go back to the old
> implementation of directly moving pages up to avoid the zombies.
>
> However, these were pure implementation changes. The user-visible
> semantics never varied: when you delete a cgroup, any leftover
> resources are subject to control by the remaining parent cgroups.
> Don't remove control domains if you still need to control resources.
> But none of this is new or would change in any way!

The problem is that you cannot fully monitor or control all the
resources charged to a control domain. The example of common shared
libraries stands, the pages are charged on first touch basis. You
can't easily control it or monitor who is charged for what exactly.
Even if you can find out, is the answer to leave the cgroup alive
forever because it is charged for a shared resource?

> Neutralizing
> controls of a zombie cgroup results in the same behavior and
> accounting as linking the pages to the parent cgroup's LRU!
>
> The only thing that's new is the zombie cgroups. We can fix that by
> effectively going back to the earlier implementation, but thanks to
> objcg without the locking problems.
>
> I just wanted to address this, because your description/framing of
> reparenting strikes me as quite wrong.

Thanks for the context, and sorry if my framing was inaccurate. I was
more focused on the in-kernel semantics rather than user-visible
semantics. Nonetheless, with today's status or with reparenting, once
the memory is at the root level (whether reparented to the root level,
or in a zombie memcg whose parent is root), the memory has effectively
escaped accounting. This is not a new problem that reparenting would
introduce, but it's a problem that recharging is trying to fix that
reparenting won't.

As I outlined above, the semantics of recharging are not new, they are
equivalent to reclaiming and refaulting the memory in a more
accelerated/efficient manner. The indeterminism in recharging is very
similar to reclaiming and refaulting.

What do you think?
