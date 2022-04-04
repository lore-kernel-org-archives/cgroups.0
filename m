From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH resend] memcg: introduce per-memcg reclaim interface
Date: Mon, 4 Apr 2022 10:14:36 -0700
Message-ID: <CALvZod466jLN8Bb67X9=iF5TvjOo-oEsHA-mGhpHnywGCP+WvA@mail.gmail.com>
References: <YkdrEG5FlL7Gq2Vi@cmpxchg.org> <243A0156-D26A-47C9-982A-C8B0CDD69DA2@linux.dev>
 <Ykdz7fiMFZeFltYy@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9G0a90Ep/Bz5OOoDZhbBO26Y5kHqZZt4pCiJoHTyyw4=;
        b=dbsKFhi7Qrtq/Rq9OZDWGOfaDFXlehFA5Dvy8IhvRrLeU0T4wP85YNiBqYaU9XUcaR
         eUVN69DjjMnifijLW25m+YKzc/I0odbx2wV1tPCdU+KBxslLKSqFwvkD4pVvTF50IUQa
         +QaIH7XLXTeNMaw7eguYI4S17J2ihOJkhUqbubb0twU+NF44WOBEs4KEZwuyI2cQ1OWg
         DjvmsdfzKYHIffEOCxLZBCluUxcZ7//A9FO1lCcnt+AcAMATqSVWgw8Xu0BUE/Jl7VQw
         rtUspdPnkhbICsCmzGy+IMML4dl30xRIEscdXvevjnn2tvTt7h6mqDEkiKuyZ7Z/UY9Z
         FpEA==
In-Reply-To: <Ykdz7fiMFZeFltYy@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Yosry Ahmed <yosryahmed@google.com>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Cgroups <cgroups@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Jonathan Corbet <corbet@lwn.net>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Wei Xu <weixugc@google.com>, Greg Thelen <gthelen@google.com>

On Fri, Apr 1, 2022 at 2:51 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> On Fri, Apr 01, 2022 at 02:21:52PM -0700, Roman Gushchin wrote:
> > > On Apr 1, 2022, at 2:13 PM, Johannes Weiner <hannes@cmpxchg.org> wrot=
e:
> > >
> > > =EF=BB=BFOn Fri, Apr 01, 2022 at 11:39:30AM -0700, Roman Gushchin wro=
te:
> > >> The interface you're proposing is not really extensible, so we'll li=
kely need to
> > >> introduce a new interface like memory.reclaim_ext very soon. Why not=
 create
> > >> an extensible API from scratch?
> > >>
> > >> I'm looking at cgroup v2 documentation which describes various inter=
face files
> > >> formats and it seems like given the number of potential optional arg=
uments
> > >> the best option is nested keyed (please, refer to the Interface File=
s section).
> > >>
> > >> E.g. the format can be:
> > >> echo "1G type=3Dfile nodemask=3D1-2 timeout=3D30s" > memory.reclaim
> > >
> > > Yeah, that syntax looks perfect.
> > >
> > > But why do you think it's not extensible from the current patch? We
> > > can add those arguments one by one as we agree on them, and return
> > > -EINVAL if somebody passes an unknown parameter.
> > >
> > > It seems to me the current proposal is forward-compatible that way
> > > (with the current set of keyword pararms being the empty set :-))
> >
> > It wasn=E2=80=99t obvious to me. We spoke about positional arguments an=
d then it wasn=E2=80=99t clear how to add them in a backward-compatible way=
. The last thing we want is a bunch of memory.reclaim* interfaces :)
> >
> > So yeah, let=E2=80=99s just describe it properly in the documentation, =
no code changes are needed.
>
> Sounds good to me!

To summarize for next version:

1) Add selftests.
2) Add documentation for potential future extension, so whoever adds
those features in future should follow the key-value format Roman is
suggesting.

Yosry, once we have agreement on the return value, please send the
next version resolving these three points.
