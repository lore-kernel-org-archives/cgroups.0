From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2] mm: memcg: use rstat for non-hierarchical stats
Date: Wed, 26 Jul 2023 11:20:55 -0400
Message-ID: <20230726152055.GC1365610@cmpxchg.org>
References: <20230726002904.655377-1-yosryahmed@google.com>
 <20230726002904.655377-2-yosryahmed@google.com>
 <ZMCBzUH7qIdc3Y2X@P9FQF9L96D>
 <CAJD7tkZDpni+VM61i-jUgvn=TkZ5CySotTmUAFQPwMSjDfOEWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20221208.gappssmtp.com; s=20221208; t=1690384857; x=1690989657;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TR6oQPY6JNSBn86BXUT6Jb7RsPiu2t8ttrP3Qk1ckmA=;
        b=kEYIf12WH7QjPdNoSCv0WUSbARvQjmtVxX7NfaQzrYxV1/+nRefphJ/BTVVpb3PI3k
         tDFiu/YtGXzrb7LxUR36pX2VIcIE4gHAqkuNB3cwZSL76h5iTQjva8lKEpiF5mixmS9j
         zB/QcNjxJqpZs0gjpSEB7cQ4TxsEnvvfcOAkvF72PHHpzXrX5hHIncAuMkUoFmSw29aN
         JZcwXccKyQocpVHQG72luYQIe6XFkG0KPfRT9NwyYpkFvDisRm1YB/A5Egv0H0ixL38b
         OZ54MHmoHTmvqEI8a/dnmJJEjpzdkkfjyjwLJuB4INwzRuRMAb3gXkjvoN4j4vRJw8KA
         vfGQ==
Content-Disposition: inline
In-Reply-To: <CAJD7tkZDpni+VM61i-jUgvn=TkZ5CySotTmUAFQPwMSjDfOEWQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, Jul 25, 2023 at 07:20:02PM -0700, Yosry Ahmed wrote:
> On Tue, Jul 25, 2023 at 7:15=E2=80=AFPM Roman Gushchin <roman.gushchin-fx=
UVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
> >
> > On Wed, Jul 26, 2023 at 12:29:04AM +0000, Yosry Ahmed wrote:
> > > Currently, memcg uses rstat to maintain hierarchical stats. Counters =
are
> > > maintained for hierarchical stats at each memcg. Rstat tracks which
> > > cgroups have updates on which cpus to keep those counters fresh on the
> > > read-side.
> > >
> > > For non-hierarchical stats, we do not maintain counters. Instead, the
> >                                                 global?
>=20
> Do you mean "we do not maintain global counters"? I think "global" is
> confusing, because it can be thought of as all cpus or as including
> the subtree (as opposed to local for non-hierarchical stats).

"global" seems fine to me, I don't think it's ambiguous in the direct
comparison with per-cpu counts.

Alternatively, rephrase the whole thing? Something like:

"Non-hierarchical stats are currently not covered by rstat. Their
per-cpu counters are summed up on every read, which is expensive."
