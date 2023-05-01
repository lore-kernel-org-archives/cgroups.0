From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: Re: [PATCH 01/40] lib/string_helpers: Drop space in
 string_get_size's output
Date: Mon, 1 May 2023 17:33:49 -0400
Message-ID: <20230501213349.bvbf6i72eepcd56m@revolver>
References: <20230501165450.15352-1-surenb@google.com>
 <20230501165450.15352-2-surenb@google.com>
 <ouuidemyregstrijempvhv357ggp4tgnv6cijhasnungsovokm@jkgvyuyw2fti>
 <ZFAUj+Q+hP7cWs4w@moria.home.lan>
 <CAHp75VeJ_a6j3uweLN5-woSQUtN5u36c2gkoiXhnJa1HXJdoyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2023-03-30;
 bh=oIqIKkV+mXN+M+KlVC9soascZOdeXUNT3GbUh7j2yUQ=;
 b=ZtSqL/rwysSUc+Z/iLkf3oDc7pxGVmdX2sEAStDgCl6NqrrrDV6w6xaD3sPhLGO1OPr/
 B5q7cIyiqukZAayPRHfBKdjM1iett9hWg0vPe5vfOv0G6ED9RdHNL+RmLtob/UbARkQ+
 VFAiLU1VWuUU4CmIjQFE06kIIwFIQDk6y0Ie6suOUNpuv8BU1gorPHEs6YyTAEUIV8Iw
 /AFPjfEiOO6AXiQpVMmdy6dHsY1Bn+F5Q7VDl33ngLilOw5O3o7WgWaA6116rToRAALw
 PovPCpKBYcdpGcVUTYf/JEQONKceB/AmdFZA/X/VUaYcFBOIJJJ+xizEsGjoQ1m75rVR 3Q== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oIqIKkV+mXN+M+KlVC9soascZOdeXUNT3GbUh7j2yUQ=;
 b=O5/4W4m0+Ggf3f9QnQbNsrn47d3ukIq8xn4AWf41WmwLfiY2ER1pcdMMDq64i8YnftfqlCibrhbqXKb9i2PPvLgy8mASCBkznJQCgdM8RguKEw1UBVnmUr68J3MO+8D+i2e3mEpdmEpciNkeNiYMLjctZevJFDXTk0csKsO6RUo=
Content-Disposition: inline
In-Reply-To: <CAHp75VeJ_a6j3uweLN5-woSQUtN5u36c2gkoiXhnJa1HXJdoyQ@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, mhocko@suse.com, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, willy@infradead.org, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hughd@google.com

* Andy Shevchenko <andy.shevchenko@gmail.com> [230501 15:57]:
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
>=20
> > > Wouldn't this break users that already parse it the current way?
> >
> > It's not impossible - but it's not used in very many places and we
> > wouldn't be printing in human-readable units if it was meant to be
> > parsed - it's mainly used for debug output currently.
> >
> > If someone raises a specific objection we'll do something different,
> > otherwise I think standardizing on what userspace tooling already parse=
s
> > is a good idea.
>=20
> Yes, I NAK this on the basis of
> https://english.stackexchange.com/a/2911/153144

This fixes the output to be better aligned with:
the output of ls -sh
the input expected by find -size

Are there counter-examples of commands that follow the SI Brochure?

Thanks,
Liam
