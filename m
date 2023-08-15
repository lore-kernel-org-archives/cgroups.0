From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH] mm: memcg: provide accurate stats for userspace reads
Date: Mon, 14 Aug 2023 17:50:46 -0700
Message-ID: <CAJD7tkYgCySTX28zK9GZiWwsabR4nv7M2hQ57y12si-fqtv7zg@mail.gmail.com>
References: <CAJD7tkYZxjAHrodVDK=wmz-sULJrq2VhC_5ecRP7T-KiaOcTuw@mail.gmail.com>
 <CALvZod46Cz_=5UgiyAKM+VgKyk=KJCqDqXu91=9uHy7-2wk53g@mail.gmail.com>
 <CAJD7tkY-ezyYebvcs=8Z_zrw2UVW8jf2WvP1G8tu2rT=2sMnAA@mail.gmail.com>
 <CALvZod5fH9xu_+6x85K38f63GfKGWD1LqtD2R4d09xmDtLB7ew@mail.gmail.com>
 <ZNdEaw2nktq1NfmH@dhcp22.suse.cz> <CAJD7tkaFHgc3eN1K1wYsQFWMLu4+Frf9DJ-5HOja2nC20Es9Dw@mail.gmail.com>
 <ZNrDWqfjXtAYhnvT@slm.duckdns.org> <CAJD7tkYBFz-gZ2QsHxUMT=t0KNXs66S-zzMPebadHx9zaG0Q3w@mail.gmail.com>
 <ZNrITZVTf2EILRJq@slm.duckdns.org> <CAJD7tkaXwoF-faApweAmm7Db7jAuS3EO7hVvdyVtqW_rE+T9Vg@mail.gmail.com>
 <ZNrLO5PAEZw4yjI9@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692060683; x=1692665483;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5DF8cCN5c46hMXv7mfXAxrDIYQabUgmS1Hsrig0V+jQ=;
        b=OqEkid6LHJUv/dnnZQeNSbgPrTga2p1Rg7hC4lce9ysXWPFOb965ybIH11k9KozkYE
         ++Q/tf1K5gcbbTOpBJwvPUu+khrw9WL0zXKRU4T1sQYBO+GIfKqNstu2m4fOKzHPFVgh
         RslMiu059PrSxFkvqcBGE1uAJDrfm0+aWeoRRFjPern7kCkCL+ND9+b1+vbUuFEDgSoc
         POSYw0EN/F5RdTEAizBNUBDtNI5MRiAM2MT58N9sYEAsV/LE7ATMssVAb1qDBfos1d0l
         5wm9zSdVQFwAZ7hw1vwuzDQA8dyBkeIA9spid8dBeJp17yeTcCVoEN5n9StLcr3vFIOa
         /cOQ==
In-Reply-To: <ZNrLO5PAEZw4yjI9@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeelb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Mon, Aug 14, 2023 at 5:48=E2=80=AFPM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Mon, Aug 14, 2023 at 05:39:15PM -0700, Yosry Ahmed wrote:
> > I believe dropping unified flushing, if possible of course, may fix
> > both problems.
>
> Yeah, flushing the whole tree for every stat read will push up the big O
> complexity of the operation. It shouldn't be too bad because only what's
> updated since the last read will need flushing but if you have a really b=
ig
> machine with a lot of constantly active cgroups, you're still gonna feel =
it.
> So, yeah, drop that and switch the global lock to mutex and we should all=
 be
> good?

I hope so, but I am not sure.

The unified flushing was added initially to mitigate a thundering herd
problem from concurrent in-kernel flushers (e.g. concurrent reclaims),
but back then flushing was atomic so we had to keep the spinlock held
for a long time. I think it should be better now, but I am hoping
Shakeel will chime in since he added the unified flushing originally.

We also need to agree on what to do about stats_flushing_threshold and
flush_next_time since they're both global now (since all flushing is
global).

>
> Thanks.
>
> --
> tejun
