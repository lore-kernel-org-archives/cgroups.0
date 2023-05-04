From: Petr =?UTF-8?B?VGVzYcWZw61r?= <petr@tesarici.cz>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Thu, 4 May 2023 10:00:02 +0200
Message-ID: <20230504100002.3d410939@meshulam.tesarici.cz>
References: <ZFIVtB8JyKk0ddA5@moria.home.lan>
        <ZFKNZZwC8EUbOLMv@slm.duckdns.org>
        <20230503180726.GA196054@cmpxchg.org>
        <ZFKlrP7nLn93iIRf@slm.duckdns.org>
        <ZFKqh5Dh93UULdse@slm.duckdns.org>
        <ZFKubD/lq7oB4svV@moria.home.lan>
        <ZFKu6zWA00AzArMF@slm.duckdns.org>
        <ZFKxcfqkUQ60zBB_@slm.duckdns.org>
        <CAJuCfpEPkCJZO2svT-GfmpJ+V-jSLyFDKM_atnqPVRBKtzgtnQ@mail.gmail.com>
        <ZFK6pwOelIlhV8Bm@slm.duckdns.org>
        <ZFK9XMSzOBxIFOHm@slm.duckdns.org>
        <CAJuCfpE4YD_BumqFf2-NC8KS9D+kq0s_o4gRyWAH-WK4SgqUbA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tesarici.cz; s=mail;
        t=1683187204; bh=14yIEEd7A8I6Tu7lFvLcP+c0d1kvUNzGycGQrBMqaec=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i7U3c2nW7tDZIQt+x9yz3m1gnOLRMA9C6yJT6Lzxj+dxqDistyX+bd+0n320wEwJP
         mG2SyfCNE02FKthsBOaBd1l8X2sl7oLvrB/qCQMI9TdxqtZ39wha4fpP0ZE3+zeKkK
         k0trzdHlCZJa68SOs/TaUtBngoBADHokTtRxc0S9tbNJ2CGCzrCU1Scif9VY4vZMaG
         4N0HqGKW74zhhnlGRus1U5tjOoHSH8T2YLQCYURrBpLx1c6/Vj9FoN6/WcaiorzJev
         vQPIWwTXe3QxIxMc/r7IVrjtPa9xgEwraQ4rTZJf6649purGXb5q61XhugqznFqKR8
         fSbA318uN2Nlg==
In-Reply-To: <CAJuCfpE4YD_BumqFf2-NC8KS9D+kq0s_o4gRyWAH-WK4SgqUbA@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, akpm@linux-foundation.org, vbabka@suse.cz, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzh

On Wed, 3 May 2023 13:14:57 -0700
Suren Baghdasaryan <surenb@google.com> wrote:

> On Wed, May 3, 2023 at 1:00=E2=80=AFPM Tejun Heo <tj@kernel.org> wrote:
> >
> > Hello,
> >
> > On Wed, May 03, 2023 at 09:48:55AM -1000, Tejun Heo wrote: =20
> > > > If so, that's the idea behind the context capture feature so that we
> > > > can enable it on specific allocations only after we determine there=
 is
> > > > something interesting there. So, with low-cost persistent tracking =
we
> > > > can determine the suspects and then pay some more to investigate th=
ose
> > > > suspects in more detail. =20
> > >
> > > Yeah, I was wondering whether it'd be useful to have that configurabl=
e so
> > > that it'd be possible for a user to say "I'm okay with the cost, plea=
se
> > > track more context per allocation". Given that tracking the immediate=
 caller
> > > is already a huge improvement and narrowing it down from there using
> > > existing tools shouldn't be that difficult, I don't think this is a b=
locker
> > > in any way. It just bothers me a bit that the code is structured so t=
hat
> > > source line is the main abstraction. =20
> >
> > Another related question. So, the reason for macro'ing stuff is needed =
is
> > because you want to print the line directly from kernel, right? =20
>=20
> The main reason is because we want to inject a code tag at the
> location of the call. If we have a code tag injected at every
> allocation call, then finding the allocation counter (code tag) to
> operate takes no time.

Another consequence is that each source code location gets its own tag.
The compiler can no longer apply common subexpression elimination
(because the tag is different). I have some doubts that there are any
places where CSE could be applied to allocation calls, but in general,
this is one more difference to using _RET_IP_.

Petr T

> > Is that
> > really necessary? Values from __builtin_return_address() can easily be
> > printed out as function+offset from kernel which already gives most of =
the
> > necessary information for triaging and mapping that back to source line=
 from
> > userspace isn't difficult. Wouldn't using __builtin_return_address() ma=
ke
> > the whole thing a lot simpler? =20
>=20
> If we do that we have to associate that address with the allocation
> counter at runtime on the first allocation and look it up on all
> following allocations. That introduces the overhead which we are
> trying to avoid by using macros.
>=20
> >
> > Thanks.
> >
> > --
> > tejun =20
>=20

