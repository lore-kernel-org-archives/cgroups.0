From: Kent Overstreet <kent.overstreet@linux.dev>
Subject: Re: [PATCH 01/40] lib/string_helpers: Drop space in
 string_get_size's output
Date: Wed, 3 May 2023 03:12:57 -0400
Message-ID: <ZFIJeSv9xn9qnMzg@moria.home.lan>
References: <20230501165450.15352-2-surenb@google.com>
 <ouuidemyregstrijempvhv357ggp4tgnv6cijhasnungsovokm@jkgvyuyw2fti>
 <ZFAUj+Q+hP7cWs4w@moria.home.lan>
 <b6b472b65b76e95bb4c7fc7eac1ee296fdbb64fd.camel@HansenPartnership.com>
 <ZFCA2FF+9MI8LI5i@moria.home.lan>
 <CAHp75VdK2bgU8P+-np7ScVWTEpLrz+muG-R15SXm=ETXnjaiZg@mail.gmail.com>
 <ZFCsAZFMhPWIQIpk@moria.home.lan>
 <CAHp75VdvRshCthpFOjtmajVgCS_8YoJBGbLVukPwU+t79Jgmww@mail.gmail.com>
 <ZFHB2ATrPIsjObm/@moria.home.lan>
 <CAHp75VdH07gTYCPvp2FRjnWn17BxpJCcFBbFPpjpGxBt1B158A@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683097991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sa4OTZB5b+skGudhSwhmk32TbWUPA01HpPa43R3XypE=;
        b=houGGarhoR27PbchhA+QNGA0saxVkWBHqqLXWwcgql8ghPJpiqqLxuMJIsQYxFnIsotmiT
        R5cEBBWaIeU7VnAYAflrCrppJkt964UNglx6jVLEs7TCm33He/1Trw4Kd39bUM2JjWBSVm
        eV4n8fttF9Y1FM+uRWMMQaDs/kiMrwM=
Content-Disposition: inline
In-Reply-To: <CAHp75VdH07gTYCPvp2FRjnWn17BxpJCcFBbFPpjpGxBt1B158A@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, mhocko@suse.com, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowe

On Wed, May 03, 2023 at 09:30:11AM +0300, Andy Shevchenko wrote:
> On Wed, May 3, 2023 at 5:07 AM Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> > On Tue, May 02, 2023 at 06:19:27PM +0300, Andy Shevchenko wrote:
> > > On Tue, May 2, 2023 at 9:22 AM Kent Overstreet
> > > <kent.overstreet@linux.dev> wrote:
> > > > On Tue, May 02, 2023 at 08:33:57AM +0300, Andy Shevchenko wrote:
> > > > > Actually instead of producing zillions of variants, do a %p extension
> > > > > to the printf() and that's it. We have, for example, %pt with T and
> > > > > with space to follow users that want one or the other variant. Same
> > > > > can be done with string_get_size().
> > > >
> > > > God no.
> > >
> > > Any elaboration what's wrong with that?
> >
> > I'm really not a fan of %p extensions in general (they are what people
> > reach for because we can't standardize on a common string output API),
> 
> The whole story behind, for example, %pt is to _standardize_ the
> output of the same stanza in the kernel.

Wtf does this have to do with the rest of the discussion? The %p thing
seems like a total non sequitar and a distraction.

I'm not getting involved with that. All I'm interested in is fixing the
memory allocation profiling output to make it more usable.

> > but when we'd be passing it bare integers the lack of type safety would
> > be a particularly big footgun.
> 
> There is no difference to any other place in the kernel where we can
> shoot into our foot.

Yeah, no, absolutely not. Passing different size integers to
string_get_size() is fine; passing pointers to different size integers
to a %p extension will explode and the compiler won't be able to warn.

> 
> > > God no for zillion APIs for almost the same. Today you want space,
> > > tomorrow some other (special) delimiter.
> >
> > No, I just want to delete the space and output numbers the same way
> > everyone else does. And if we are stuck with two string_get_size()
> > functions, %p extensions in no way improve the situation.
> 
> I think it's exactly for the opposite, i.e. standardize that output
> once and for all.

So, are you dropping your NACK then, so we can standardize the kernel on
the way everything else does it?
