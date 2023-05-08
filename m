From: Petr =?UTF-8?B?VGVzYcWZw61r?= <petr@tesarici.cz>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Mon, 8 May 2023 18:09:13 +0200
Message-ID: <20230508180913.6a018b21@meshulam.tesarici.cz>
References: <20230501165450.15352-1-surenb@google.com>
        <ZFIMaflxeHS3uR/A@dhcp22.suse.cz>
        <CAJuCfpHxbYFxDENYFfnggh1D8ot4s493PQX0C7kD-JLvixC-Vg@mail.gmail.com>
        <ZFN1yswCd9wRgYPR@dhcp22.suse.cz>
        <ZFfd99w9vFTftB8D@moria.home.lan>
        <20230508175206.7dc3f87c@meshulam.tesarici.cz>
        <ZFkb1p80vq19rieI@moria.home.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tesarici.cz; s=mail;
        t=1683562155; bh=tZgheluO1aPVjg06yZiAFzLNKgO2HIpkAjGUkuoz+Xw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CADkuX60QMsFSs5K3h85ChAjshZd0+5QyWqLXjAQ5u35m53i5zXISvnd+ljlG5rW8
         3yfjn5cTtoMKzWJyMVk6cVz/NtUgY7fgdoS4Lh0LIxQNcHDhj0HSpdaF4B+jJ4EmMA
         5185N1LV9wkMWh/nAmI5f8IS5nYaeIOztE4g7FmmZN38FcuYByM/VlMF2byMx02IzO
         x7xCDbrZqC7ZiTvCVcnU/9QA9D8zIWHDYJDuqOaxAmw4//Gah5Zqccep8UubMR3MsW
         5sv9E3yE4y9cJgzxnJzn/sRvFqIs1IbT/NiGx03o8Sb1jC690ErN5b5lmVyIFNfb02
         FQ4gjDERvn0bg==
In-Reply-To: <ZFkb1p80vq19rieI@moria.home.lan>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com

On Mon, 8 May 2023 11:57:10 -0400
Kent Overstreet <kent.overstreet@linux.dev> wrote:

> On Mon, May 08, 2023 at 05:52:06PM +0200, Petr Tesa=C5=99=C3=ADk wrote:
> > On Sun, 7 May 2023 13:20:55 -0400
> > Kent Overstreet <kent.overstreet@linux.dev> wrote:
> >  =20
> > > On Thu, May 04, 2023 at 11:07:22AM +0200, Michal Hocko wrote: =20
> > > > No. I am mostly concerned about the _maintenance_ overhead. For the
> > > > bare tracking (without profiling and thus stack traces) only those
> > > > allocations that are directly inlined into the consumer are really
> > > > of any use. That increases the code impact of the tracing because a=
ny
> > > > relevant allocation location has to go through the micro surgery.=20
> > > >=20
> > > > e.g. is it really interesting to know that there is a likely memory
> > > > leak in seq_file proper doing and allocation? No as it is the speci=
fic
> > > > implementation using seq_file that is leaking most likely. There are
> > > > other examples like that See?   =20
> > >=20
> > > So this is a rather strange usage of "maintenance overhead" :)
> > >=20
> > > But it's something we thought of. If we had to plumb around a _RET_IP_
> > > parameter, or a codetag pointer, it would be a hassle annotating the
> > > correct callsite.
> > >=20
> > > Instead, alloc_hooks() wraps a memory allocation function and stashes=
 a
> > > pointer to a codetag in task_struct for use by the core slub/buddy
> > > allocator code.
> > >=20
> > > That means that in your example, to move tracking to a given seq_file
> > > function, we just:
> > >  - hook the seq_file function with alloc_hooks =20
> >=20
> > Thank you. That's exactly what I was trying to point out. So you hook
> > seq_buf_alloc(), just to find out it's called from traverse(), which
> > is not very helpful either. So, you hook traverse(), which sounds quite
> > generic. Yes, you're lucky, because it is a static function, and the
> > identifier is not actually used anywhere else (right now), but each
> > time you want to hook something, you must make sure it does not
> > conflict with any other identifier in the kernel... =20
>=20
> Cscope makes quick and easy work of this kind of stuff.

Sure, although AFAIK the index does not cover all possible config
options (so non-x86 arch code is often forgotten). However, that's the
less important part.

What do you do if you need to hook something that does conflict with an
existing identifier?

Petr T
