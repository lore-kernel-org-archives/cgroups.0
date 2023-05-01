From: Kent Overstreet <kent.overstreet@linux.dev>
Subject: Re: [PATCH 01/40] lib/string_helpers: Drop space in
 string_get_size's output
Date: Mon, 1 May 2023 17:16:59 -0400
Message-ID: <ZFAsS5f6eGSyxF/+@moria.home.lan>
References: <20230501165450.15352-1-surenb@google.com>
 <20230501165450.15352-2-surenb@google.com>
 <ouuidemyregstrijempvhv357ggp4tgnv6cijhasnungsovokm@jkgvyuyw2fti>
 <ZFAUj+Q+hP7cWs4w@moria.home.lan>
 <CAHp75VeJ_a6j3uweLN5-woSQUtN5u36c2gkoiXhnJa1HXJdoyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1682975831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WS5IfKwTPa1bKv8dROPMPn7bpsB6bxr/+mMUnulbyXo=;
        b=lW6pMkkITA3yRW/sjDAKtYtv7Nl+AYeAS5qW1/WcLz5hQIZOXhmptquOd9Uo4YjlLQagEj
        l8KwsV9hdfnmKeThBO+Hem6g0VYZI6AYnyFLRYZNX5+S78AIIBPNkxPLEdu52Lb7u0ovlq
        VCSzQAFEVndS+FYqBuYKLLIDbnpmrsU=
Content-Disposition: inline
In-Reply-To: <CAHp75VeJ_a6j3uweLN5-woSQUtN5u36c2gkoiXhnJa1HXJdoyQ@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, mhocko@suse.com, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hughd@google.com, andreyknvl@gmail.com, k

On Mon, May 01, 2023 at 10:57:07PM +0300, Andy Shevchenko wrote:
> On Mon, May 1, 2023 at 10:36=E2=80=AFPM Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> >
> > On Mon, May 01, 2023 at 11:13:15AM -0700, Davidlohr Bueso wrote:
> > > On Mon, 01 May 2023, Suren Baghdasaryan wrote:
> > >
> > > > From: Kent Overstreet <kent.overstreet@linux.dev>
> > > >
> > > > Previously, string_get_size() outputted a space between the number =
and
> > > > the units, i.e.
> > > >  9.88 MiB
> > > >
> > > > This changes it to
> > > >  9.88MiB
> > > >
> > > > which allows it to be parsed correctly by the 'sort -h' command.
>=20
> But why do we need that? What's the use case?

As was in the commit message: to produce output that sort -h knows how
to parse.

> > > Wouldn't this break users that already parse it the current way?
> >
> > It's not impossible - but it's not used in very many places and we
> > wouldn't be printing in human-readable units if it was meant to be
> > parsed - it's mainly used for debug output currently.
> >
> > If someone raises a specific objection we'll do something different,
> > otherwise I think standardizing on what userspace tooling already parses
> > is a good idea.
>=20
> Yes, I NAK this on the basis of
> https://english.stackexchange.com/a/2911/153144

Not sure I find a style guide on stackexchange more compelling than
interop with a tool everyone already has installed :)
