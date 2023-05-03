From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH 01/40] lib/string_helpers: Drop space in string_get_size's output
Date: Wed, 3 May 2023 12:12:12 +0300
Message-ID: <CAHp75Vd_VMOh1zxJvr0KqhxYBXAU1X+Ax7YA1sJ0G_abEpn-Dg@mail.gmail.com>
References: <20230501165450.15352-2-surenb@google.com> <ouuidemyregstrijempvhv357ggp4tgnv6cijhasnungsovokm@jkgvyuyw2fti>
 <ZFAUj+Q+hP7cWs4w@moria.home.lan> <b6b472b65b76e95bb4c7fc7eac1ee296fdbb64fd.camel@HansenPartnership.com>
 <ZFCA2FF+9MI8LI5i@moria.home.lan> <CAHp75VdK2bgU8P+-np7ScVWTEpLrz+muG-R15SXm=ETXnjaiZg@mail.gmail.com>
 <ZFCsAZFMhPWIQIpk@moria.home.lan> <CAHp75VdvRshCthpFOjtmajVgCS_8YoJBGbLVukPwU+t79Jgmww@mail.gmail.com>
 <ZFHB2ATrPIsjObm/@moria.home.lan> <CAHp75VdH07gTYCPvp2FRjnWn17BxpJCcFBbFPpjpGxBt1B158A@mail.gmail.com>
 <ZFIJeSv9xn9qnMzg@moria.home.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-arch-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683105170; x=1685697170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TEZd+b8sulXt8fKAN8kz+Gm51fXRGcBOvDO84eUPrqA=;
        b=lkpnSWbImRhXpMdXf/j2tYcHtARa7pZxpe80UwOhD4R61KpJDN5E6c3vkOZJZtEsdd
         NIOFyi6+CcEllvCmz+ezBqynxF+o1JnKK9z/EV67UWGPh2kFZbUVxyRHZCZkw1kqq8rz
         D1ODfYDy+ZvYfj3AH/q3S+H4OrTddDujLMLoFoZBIeqfcAukFwbiQa/sO0taRXV/GD4U
         O5s1H1vUGlkYsqkokTGq0Ace+9Jt9tMQ9MhYfRBameD9A6V7QtQlcyepsIhLTlDMhvcT
         QESiwW/ebN8bNURL5Wk9400Ojw9jq2OZaVXEW9BBl9Ohxc4ib4YptZaU3URY4a45BJzR
         laiQ==
In-Reply-To: <ZFIJeSv9xn9qnMzg@moria.home.lan>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, mhocko@suse.com, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowe

On Wed, May 3, 2023 at 10:13=E2=80=AFAM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
> On Wed, May 03, 2023 at 09:30:11AM +0300, Andy Shevchenko wrote:
> > On Wed, May 3, 2023 at 5:07=E2=80=AFAM Kent Overstreet
> > <kent.overstreet@linux.dev> wrote:
> > > On Tue, May 02, 2023 at 06:19:27PM +0300, Andy Shevchenko wrote:
> > > > On Tue, May 2, 2023 at 9:22=E2=80=AFAM Kent Overstreet
> > > > <kent.overstreet@linux.dev> wrote:
> > > > > On Tue, May 02, 2023 at 08:33:57AM +0300, Andy Shevchenko wrote:
> > > > > > Actually instead of producing zillions of variants, do a %p ext=
ension
> > > > > > to the printf() and that's it. We have, for example, %pt with T=
 and
> > > > > > with space to follow users that want one or the other variant. =
Same
> > > > > > can be done with string_get_size().
> > > > >
> > > > > God no.
> > > >
> > > > Any elaboration what's wrong with that?
> > >
> > > I'm really not a fan of %p extensions in general (they are what peopl=
e
> > > reach for because we can't standardize on a common string output API)=
,
> >
> > The whole story behind, for example, %pt is to _standardize_ the
> > output of the same stanza in the kernel.
>
> Wtf does this have to do with the rest of the discussion? The %p thing
> seems like a total non sequitar and a distraction.
>
> I'm not getting involved with that. All I'm interested in is fixing the
> memory allocation profiling output to make it more usable.
>
> > > but when we'd be passing it bare integers the lack of type safety wou=
ld
> > > be a particularly big footgun.
> >
> > There is no difference to any other place in the kernel where we can
> > shoot into our foot.
>
> Yeah, no, absolutely not. Passing different size integers to
> string_get_size() is fine; passing pointers to different size integers
> to a %p extension will explode and the compiler won't be able to warn.

This is another topic. Yes, there is a discussion to have a compiler
plugin to check this.

> > > > God no for zillion APIs for almost the same. Today you want space,
> > > > tomorrow some other (special) delimiter.
> > >
> > > No, I just want to delete the space and output numbers the same way
> > > everyone else does. And if we are stuck with two string_get_size()
> > > functions, %p extensions in no way improve the situation.
> >
> > I think it's exactly for the opposite, i.e. standardize that output
> > once and for all.
>
> So, are you dropping your NACK then, so we can standardize the kernel on
> the way everything else does it?

No, you are breaking existing users. The NAK stays.
The whole discussion after that is to make the way on how users can
utilize your format and existing format without multiplying APIs.


--=20
With Best Regards,
Andy Shevchenko
