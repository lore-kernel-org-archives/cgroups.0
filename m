From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH] block/blk-iocost (gcc13): cast enum members to int in
 prints
Date: Tue, 13 Dec 2022 08:30:08 +0000
Message-ID: <f5220f08bd7f45248d718f1919503261@AcuMS.aculab.com>
References: <20221031114520.10518-1-jirislaby@kernel.org>
 <Y1++fLJXkeZgtXR2@infradead.org> <Y2AMcSPAJpj6obSA@slm.duckdns.org>
 <d833ad15-f458-d43d-cab7-de62ff54a939@kernel.org>
 <Y2FNa4bGhJoevRKT@slm.duckdns.org>
 <2b975ee3117e45aaa7882203cf9a4db8@AcuMS.aculab.com>
 <Y2Kaghnu/sPvl0+g@slm.duckdns.org> <Y2KePvYRRMOrqzOe@slm.duckdns.org>
 <320c939e-a3f0-1b1e-77e4-f3ecca00465d@kernel.org>
 <Y5ehU524daymEKgf@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <Y5ehU524daymEKgf@slm.duckdns.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: 'Tejun Heo' <tj@kernel.org>, Jiri Slaby <jirislaby@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Martin Liska <mliska@suse.cz>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>

From: Tejun Heo <htejun@gmail.com> On Behalf Of 'Tejun Heo'
> Sent: 12 December 2022 21:47
> To: Jiri Slaby <jirislaby@kernel.org>
> Cc: David Laight <David.Laight@ACULAB.COM>; Christoph Hellwig <hch@infradead.org>; linux-
> kernel@vger.kernel.org; Martin Liska <mliska@suse.cz>; Josef Bacik <josef@toxicpanda.com>; Jens Axboe
> <axboe@kernel.dk>; cgroups@vger.kernel.org; linux-block@vger.kernel.org
> Subject: Re: [PATCH] block/blk-iocost (gcc13): cast enum members to int in prints
> 
> On Mon, Dec 12, 2022 at 01:14:31PM +0100, Jiri Slaby wrote:
> > > If so, my suggestion is just sticking with the old behavior until we switch
> > > to --std=g2x and then make one time adjustment at that point.
> >
> > So is the enum split OK under these circumstances?
> 
> Oh man, it's kinda crazy that the compiler is changing in a way that the
> same piece of code can't be compiled the same way across two adjoining
> versions of the same compiler. But, yeah, if that's what gcc is gonna do and
> splitting enums is the only way to be okay across the compiler versions,
> there isn't any other choice we can make.

It is also a silent code-breaker.
Compile this for 32bit x86:

enum { a = 1, b = ~0ull};
extern int foo(int, ...);
int f(void)
{
    return foo(0, a, 2);
}

gcc13 pushes an extra zero onto the stack between the 1 and 2.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

