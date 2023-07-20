From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] blk-iocost: fix seq_printf compile type mismatch error
Date: Thu, 20 Jul 2023 10:05:26 -1000
Message-ID: <ZLmThnoXvEqlgf_q@slm.duckdns.org>
References: <20230717141852.153965-1-carlos.bilbao@amd.com>
 <ZLWNHuTGk0fy8pjE@slm.duckdns.org>
 <7044d6b3-a5d1-572d-a755-74f8d4fd31c5@amd.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689883529; x=1690488329;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ShySli6sDETZMpAPGpGb5lvBBzti4dS5P6Lg1E17Uvs=;
        b=hz1Cuka5AmWn4oFd8xD3RyAUehliZu/h3GyLa0qEvCBnGPlUAswENy+LknBCwgcDrO
         aHzNRzQ7Jg4PVCAY/Z9r940jKGI4UClejTJhA0b3L+424a6HsmiaZOSaJeI2Ok1hqqdC
         Ip9e+0/GWLafW040QyOXl1teqgCifhoZLPLaazK47F93L7fVLWOWZoM8VlLLbjRdl6my
         tZXqV/2B9pQGYWhkccYFgJuEbZ9kf1eSMISBb73DopoLsxEQbi1RE9va1oh7PChiGb2B
         L+qUsVBtXpQSxWsENguGaaLb5qtr7udDE5SOgcrpWn9yFbCZ9lF7RIrIo5ov+YksX1ld
         1GdQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <7044d6b3-a5d1-572d-a755-74f8d4fd31c5@amd.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Carlos Bilbao <carlos.bilbao@amd.com>
Cc: josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, amd <amd@localhost.localdomain>

On Tue, Jul 18, 2023 at 10:37:23AM -0500, Carlos Bilbao wrote:
> On 7/17/23 13:49, Tejun Heo wrote:
> > On Mon, Jul 17, 2023 at 09:18:52AM -0500, Carlos Bilbao wrote:
> > > From: amd <amd@localhost.localdomain>
> > > 
> > > Fix two type mismatch errors encountered while compiling blk-iocost.c with
> > > GCC version 13.1.1 that involved constant operator WEIGHT_ONE. Cast the
> > > result of the division operation to (unsigned int) to match the expected
> > > format specifier %u in two seq_printf invocations.
> > 
> > Can you detail the warnings? Was that on 32bit compiles?
> 
> The concrete error was: "format ‘%u’ expects argument of type ‘unsigned
> int’, but argument 3 has type ‘long unsigned int’". If I run:
> 
> $ echo | cpp -dM | grep __LP64__
> #define __LP64__ 1
> 
> which makes me believe it is not 32 bits.

So, we broke up the enum definitions so that WEIGHT_ONE doesn't end up being
a ulong. Which kernel are you building? Can you plesae try the current
linus#master?

Thanks.

-- 
tejun
