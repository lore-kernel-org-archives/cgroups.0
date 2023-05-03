From: Kent Overstreet <kent.overstreet@linux.dev>
Subject: Re: [PATCH 01/40] lib/string_helpers: Drop space in
 string_get_size's output
Date: Tue, 2 May 2023 22:07:20 -0400
Message-ID: <ZFHB2ATrPIsjObm/@moria.home.lan>
References: <20230501165450.15352-1-surenb@google.com>
 <20230501165450.15352-2-surenb@google.com>
 <ouuidemyregstrijempvhv357ggp4tgnv6cijhasnungsovokm@jkgvyuyw2fti>
 <ZFAUj+Q+hP7cWs4w@moria.home.lan>
 <b6b472b65b76e95bb4c7fc7eac1ee296fdbb64fd.camel@HansenPartnership.com>
 <ZFCA2FF+9MI8LI5i@moria.home.lan>
 <CAHp75VdK2bgU8P+-np7ScVWTEpLrz+muG-R15SXm=ETXnjaiZg@mail.gmail.com>
 <ZFCsAZFMhPWIQIpk@moria.home.lan>
 <CAHp75VdvRshCthpFOjtmajVgCS_8YoJBGbLVukPwU+t79Jgmww@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683079654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cpRynykubcluzGzuthbmrNkuNIeg8BzMwNks1+1YuhA=;
        b=v2LisaB7EAiYUc1+uIQeLvUn9sUnaliIsnvchC6IYmBRNpj565Pcae8UgINnbfoPSrDzf1
        dhyCKwDr9an9QOzJ3GvxlEwxpH2prnH3+mWfvk7cXKMy3v56CXygiL+SUSayiuSFsOEU6I
        BkOshCOA3yKQ/GtZDDIOPbmb5F9macw=
Content-Disposition: inline
In-Reply-To: <CAHp75VdvRshCthpFOjtmajVgCS_8YoJBGbLVukPwU+t79Jgmww@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, mhocko@suse.com, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowe

On Tue, May 02, 2023 at 06:19:27PM +0300, Andy Shevchenko wrote:
> On Tue, May 2, 2023 at 9:22=E2=80=AFAM Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> > On Tue, May 02, 2023 at 08:33:57AM +0300, Andy Shevchenko wrote:
> > > Actually instead of producing zillions of variants, do a %p extension
> > > to the printf() and that's it. We have, for example, %pt with T and
> > > with space to follow users that want one or the other variant. Same
> > > can be done with string_get_size().
> >
> > God no.
>=20
> Any elaboration what's wrong with that?

I'm really not a fan of %p extensions in general (they are what people
reach for because we can't standardize on a common string output API),
but when we'd be passing it bare integers the lack of type safety would
be a particularly big footgun.

> God no for zillion APIs for almost the same. Today you want space,
> tomorrow some other (special) delimiter.

No, I just want to delete the space and output numbers the same way
everyone else does. And if we are stuck with two string_get_size()
functions, %p extensions in no way improve the situation.
