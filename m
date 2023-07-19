From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH] blk-iocost: fix seq_printf compile type mismatch error
Date: Wed, 19 Jul 2023 08:57:32 +0000
Message-ID: <2b4540aadc3c4449a192aeed6211f232@AcuMS.aculab.com>
References: <20230717141852.153965-1-carlos.bilbao@amd.com>
 <ZLWNHuTGk0fy8pjE@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <ZLWNHuTGk0fy8pjE@slm.duckdns.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: 'Tejun Heo' <tj@kernel.org>, Carlos Bilbao <carlos.bilbao@amd.com>
Cc: "josef@toxicpanda.com" <josef@toxicpanda.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, amd <amd@localhost.localdomain>

From: Tejun Heo
> Sent: 17 July 2023 19:49
> 
> On Mon, Jul 17, 2023 at 09:18:52AM -0500, Carlos Bilbao wrote:
> > From: amd <amd@localhost.localdomain>
> >
> > Fix two type mismatch errors encountered while compiling blk-iocost.c with
> > GCC version 13.1.1 that involved constant operator WEIGHT_ONE. Cast the
> > result of the division operation to (unsigned int) to match the expected
> > format specifier %u in two seq_printf invocations.
> 
> Can you detail the warnings? Was that on 32bit compiles?

The problem is caused by gcc 13 changing the types of the
constants inside an enum to be all the same.

The best fix is (probably) to replace all the enum used to
define unrelated constants with #defines.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

