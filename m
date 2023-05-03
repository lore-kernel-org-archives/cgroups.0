From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH 01/40] lib/string_helpers: Drop space in string_get_size's output
Date: Wed, 3 May 2023 09:30:11 +0300
Message-ID: <CAHp75VdH07gTYCPvp2FRjnWn17BxpJCcFBbFPpjpGxBt1B158A@mail.gmail.com>
References: <20230501165450.15352-1-surenb@google.com> <20230501165450.15352-2-surenb@google.com>
 <ouuidemyregstrijempvhv357ggp4tgnv6cijhasnungsovokm@jkgvyuyw2fti>
 <ZFAUj+Q+hP7cWs4w@moria.home.lan> <b6b472b65b76e95bb4c7fc7eac1ee296fdbb64fd.camel@HansenPartnership.com>
 <ZFCA2FF+9MI8LI5i@moria.home.lan> <CAHp75VdK2bgU8P+-np7ScVWTEpLrz+muG-R15SXm=ETXnjaiZg@mail.gmail.com>
 <ZFCsAZFMhPWIQIpk@moria.home.lan> <CAHp75VdvRshCthpFOjtmajVgCS_8YoJBGbLVukPwU+t79Jgmww@mail.gmail.com>
 <ZFHB2ATrPIsjObm/@moria.home.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-arch-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683095448; x=1685687448;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NSWUOSuqVLpIOWgszk2VW3MzVdJnM+9N5Gz+a5oZIik=;
        b=FwxsWECu6Vmz2nS2N36nqdmqGUy6EtTWCwQbQH8C4yyx7S50D7jj6hwfI3pG4WOWTe
         J5Ac/nm/4jjf2uonNwEk7kkgqGFkqqOlCnFifWxFhM5HBLHG5/+yNdwPcGRQZD8xyZgY
         y564jPge77bFOjQ7/C7PbIZo2J/D/9HIgWm1qaK+/JMqtAHJacp7Y7p+jXsMBKVPwiay
         de3olKWgxT5zQQmgR6+1vlYmLMhp7LATVC+UKYup+7gpwYRYwOXn88552r8N8+SfOO97
         mz3mbEB+LcrH93Ca5jn3i5g7nB6tCk4YfB1Kz47lyE0ZxPdxng7OE8IRGtE3NBhEpUXq
         C5Vw==
In-Reply-To: <ZFHB2ATrPIsjObm/@moria.home.lan>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, mhocko@suse.com, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowe

On Wed, May 3, 2023 at 5:07=E2=80=AFAM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
> On Tue, May 02, 2023 at 06:19:27PM +0300, Andy Shevchenko wrote:
> > On Tue, May 2, 2023 at 9:22=E2=80=AFAM Kent Overstreet
> > <kent.overstreet@linux.dev> wrote:
> > > On Tue, May 02, 2023 at 08:33:57AM +0300, Andy Shevchenko wrote:
> > > > Actually instead of producing zillions of variants, do a %p extensi=
on
> > > > to the printf() and that's it. We have, for example, %pt with T and
> > > > with space to follow users that want one or the other variant. Same
> > > > can be done with string_get_size().
> > >
> > > God no.
> >
> > Any elaboration what's wrong with that?
>
> I'm really not a fan of %p extensions in general (they are what people
> reach for because we can't standardize on a common string output API),

The whole story behind, for example, %pt is to _standardize_ the
output of the same stanza in the kernel.

> but when we'd be passing it bare integers the lack of type safety would
> be a particularly big footgun.

There is no difference to any other place in the kernel where we can
shoot into our foot.

> > God no for zillion APIs for almost the same. Today you want space,
> > tomorrow some other (special) delimiter.
>
> No, I just want to delete the space and output numbers the same way
> everyone else does. And if we are stuck with two string_get_size()
> functions, %p extensions in no way improve the situation.

I think it's exactly for the opposite, i.e. standardize that output
once and for all.

--=20
With Best Regards,
Andy Shevchenko
