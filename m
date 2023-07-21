From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 0/8] memory recharging for offline memcgs
Date: Fri, 21 Jul 2023 08:26:28 -1000
Message-ID: <ZLrN1BE42Tsybm6j@slm.duckdns.org>
References: <20230720070825.992023-1-yosryahmed@google.com>
 <20230720153515.GA1003248@cmpxchg.org>
 <ZLmRlTej8Tm82kXG@slm.duckdns.org>
 <CAJD7tkYhu3g9u7HkUTFBtT3Q4edVZ2g1TWV1FDcyM9srrYCBLg@mail.gmail.com>
 <ZLmxLUNdxMi5s2Kq@slm.duckdns.org>
 <CAJD7tkZKo_oSZ-mQc-knMELP8kiY1N7taQhdV6tPsqN0tg=gog@mail.gmail.com>
 <ZLm1ptOYH6F8fGHT@slm.duckdns.org>
 <CAJD7tkbDxw-hqG8i85NhnjxmXFMbR5OaSW5dHDVYfdA=ZnPAEw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689963991; x=1690568791;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+nDLHNSovJBpy7GRacDMrAtqiXNHt1dAkEqDxo04+EA=;
        b=byfrvwVRXmfGcyKN0KQNikPRt347H2lBT+iMj0kENUcWDzoABxw2A1ju6iy+Q2GQMc
         7q4YHsL7QX6EC58wN8XJAKbLpmTB0tYiZi/mNH+UYz2ZlHLJlRtD+M9pctqgDpqsJwg2
         tbUp1cXMC6ADjVdFvQmS7GDyfZJ6aQZukkkYLUeTTOjQ20JnB3Z/yScrbSUiwBadHWIv
         rGS5FD8XV3pn6yHnleEwQCsgvfcPn1eOCbg81jEHC8934W+iElMm7hkxa+K+PxDONGBj
         YQFP4HzpB0eck75pBEN2A+0N918Eq2NtywUkigZa5YV6Hpt7vq70Ea1UKYJEtSuIEY3d
         SMzg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJD7tkbDxw-hqG8i85NhnjxmXFMbR5OaSW5dHDVYfdA=ZnPAEw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Iurii Zaikin <yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Fri, Jul 21, 2023 at 11:15:21AM -0700, Yosry Ahmed wrote:
> On Thu, Jul 20, 2023 at 3:31=E2=80=AFPM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROf=
E0A@public.gmane.org> wrote:
> > memory at least in our case. The sharing across them comes down to thin=
gs
> > like some common library pages which don't really account for much these
> > days.
>=20
> Keep in mind that even a single page charged to a memcg and used by
> another memcg is sufficient to result in a zombie memcg.

I mean, yeah, that's a separate issue or rather a subset which isn't all
that controversial. That can be deterministically solved by reparenting to
the parent like how slab is handled. I think the "deterministic" part is
important here. As you said, even a single page can pin a dying cgroup.

> > > Keep in mind that the environment is dynamic, workloads are constantly
> > > coming and going. Even if find the perfect nesting to appropriately
> > > scope resources, some rescheduling may render the hierarchy obsolete
> > > and require us to start over.
> >
> > Can you please go into more details on how much memory is shared for wh=
at
> > across unrelated dynamic workloads? That sounds different from other use
> > cases.
>=20
> I am trying to collect more information from our fleet, but the
> application restarting in a different cgroup is not what is happening
> in our case. It is not easy to find out exactly what is going on on

This is the point that Johannes raised but I don't think the current
proposal would make things more deterministic. From what I can see, it
actually pushes it towards even less predictability. Currently, yeah, some
pages may end up in cgroups which aren't the majority user but it at least
is clear how that would happen. The proposed change adds layers of
indeterministic behaviors on top. I don't think that's the direction we want
to go.

> machines and where the memory is coming from due to the
> indeterministic nature of charging. The goal of this proposal is to
> let the kernel handle leftover memory in zombie memcgs because it is
> not always obvious to userspace what's going on (like it's not obvious
> to me now where exactly is the sharing happening :) ).
>
> One thing to note is that in some cases, maybe a userspace bug or
> failed cleanup is a reason for the zombie memcgs. Ideally, this
> wouldn't happen, but it would be nice to have a fallback mechanism in
> the kernel if it does.

I'm not disagreeing on that. Our handling of pages owned by dying cgroups
isn't great but I don't think the proposed change is an acceptable solution.

Thanks.

--=20
tejun
