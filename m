From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH 01/40] lib/string_helpers: Drop space in string_get_size's output
Date: Mon, 1 May 2023 22:57:07 +0300
Message-ID: <CAHp75VeJ_a6j3uweLN5-woSQUtN5u36c2gkoiXhnJa1HXJdoyQ@mail.gmail.com>
References: <20230501165450.15352-1-surenb@google.com> <20230501165450.15352-2-surenb@google.com>
 <ouuidemyregstrijempvhv357ggp4tgnv6cijhasnungsovokm@jkgvyuyw2fti> <ZFAUj+Q+hP7cWs4w@moria.home.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682971064; x=1685563064;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9KWtLWCFndJNZE972x4UIl3VMb5lgPnWy05QC+e9YHQ=;
        b=H8s0D2PnStbB558QXUaT5ll4HgeOP3F3gveA5ZpgVXoGtOyCk7qdahHdBJG2qJuoFD
         0HqzyJ4Zg0siuJOE4NGOCejap5WAcKxJOUSig772mCh4QsCtjNTYhOT/LwicIJWE9bWs
         jrJT26m+1Bq+eQTAJu9XUgL54sZ3rBnmD1Wf3mgD63haBjTeb1LZFJOQGajyc8vpiEsQ
         V1w1TCUdZjhisRQlyxsFwexQ3NynHRek48vOQiL25dSyMrTfOeaKKLioUpoCHgP64K4R
         6askIQpetdUtujGGp4kZIUBJMb/jdkXxrQ9+K8YBjSjSjTr4VDS6Hh6nwnpHLOhwtPL5
         B5uA==
In-Reply-To: <ZFAUj+Q+hP7cWs4w@moria.home.lan>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, mhocko@suse.com, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hughd@google.com, andreyknvl@gmail.com, k

On Mon, May 1, 2023 at 10:36=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Mon, May 01, 2023 at 11:13:15AM -0700, Davidlohr Bueso wrote:
> > On Mon, 01 May 2023, Suren Baghdasaryan wrote:
> >
> > > From: Kent Overstreet <kent.overstreet@linux.dev>
> > >
> > > Previously, string_get_size() outputted a space between the number an=
d
> > > the units, i.e.
> > >  9.88 MiB
> > >
> > > This changes it to
> > >  9.88MiB
> > >
> > > which allows it to be parsed correctly by the 'sort -h' command.

But why do we need that? What's the use case?

> > Wouldn't this break users that already parse it the current way?
>
> It's not impossible - but it's not used in very many places and we
> wouldn't be printing in human-readable units if it was meant to be
> parsed - it's mainly used for debug output currently.
>
> If someone raises a specific objection we'll do something different,
> otherwise I think standardizing on what userspace tooling already parses
> is a good idea.

Yes, I NAK this on the basis of
https://english.stackexchange.com/a/2911/153144


--=20
With Best Regards,
Andy Shevchenko
