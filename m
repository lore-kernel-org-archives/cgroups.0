From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH] block/blk-iocost (gcc13): cast enum members to int in
 prints
Date: Wed, 2 Nov 2022 08:35:34 +0000
Message-ID: <2b975ee3117e45aaa7882203cf9a4db8@AcuMS.aculab.com>
References: <20221031114520.10518-1-jirislaby@kernel.org>
 <Y1++fLJXkeZgtXR2@infradead.org> <Y2AMcSPAJpj6obSA@slm.duckdns.org>
 <d833ad15-f458-d43d-cab7-de62ff54a939@kernel.org>
 <Y2FNa4bGhJoevRKT@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <Y2FNa4bGhJoevRKT@slm.duckdns.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: 'Tejun Heo' <tj@kernel.org>, Jiri Slaby <jirislaby@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Martin Liska <mliska@suse.cz>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>

From: Tejun Heo
> Sent: 01 November 2022 16:47
> 
> Hello,
> 
> On Tue, Nov 01, 2022 at 06:46:56AM +0100, Jiri Slaby wrote:
> > Yes. The real problem is that using anything else then an INT_MIN <= x <=
> > INT_MAX _constant_ in an enum is undefined in ANSI C < 2x (in particular, 1
> > << x is undefined too). gcc manual defines unsigned int on the top of that
> > as defined too (so this holds for our -std=g*).
> >
> > > I suppose the most reasonable thing to do here is just splitting them into
> > > separate enum definitions. Does anyone know how this behavior change came to
> > > be?
> >
> > C2x which introduces un/signed long enums. See the bug I linked in the
> > commit log:
> > https://gcc.gnu.org/bugzilla/show_bug.cgi?id=36113
> 
> I see. So, it was an extension but the new standard is defined differently
> and we're gonna end up with that behavior.
> 
> > The change is also turned on in < C2x on purpose. AIUI, unless there is too
> > much breakage. So we'd need to sort it out in (rather distant) future anyway
> > (when we come up to -std=g2x).
> 
> The part that the new behavior applying to <C2x feels like an odd decision.
> I'm having a hard time seeing the upsides in doing so but maybe that's just
> me not knowing the area well enough.
> 
> > > Do we know whether clang is gonna be changed the same way?
> >
> > In C2x, Likely. In < C2x, dunno what'd be the default.
> 
> It looks like we can do one of the following two:
> 
> * If gcc actually changes the behavior for <c2x, split the enums according
>   to their sizes. This feels rather silly but I can't think of a better way
>   to cater to divergent compiler behaviors.
> 
> * If gcc doesn't change the behavior for <c2x, there's nothing to do for the
>   time being. Later when we switch to -std=g2x, we can just change the
>   format strings to use the now larger types.
> 
> Does the above make sense?

I think the enums have to be split.
There will be other side effects of promoting the constants to 64bit
that are much more difficult to detect than the warnings from printf.

I'm also not sure whether the type is even consistent for 32bit
and 64bit builds.
Casts are (sort of) horrid.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

