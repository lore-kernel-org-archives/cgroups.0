From: 'Tejun Heo' <tj@kernel.org>
Subject: Re: [PATCH] block/blk-iocost (gcc13): cast enum members to int in
 prints
Date: Wed, 2 Nov 2022 06:27:46 -1000
Message-ID: <Y2Kaghnu/sPvl0+g@slm.duckdns.org>
References: <20221031114520.10518-1-jirislaby@kernel.org>
 <Y1++fLJXkeZgtXR2@infradead.org>
 <Y2AMcSPAJpj6obSA@slm.duckdns.org>
 <d833ad15-f458-d43d-cab7-de62ff54a939@kernel.org>
 <Y2FNa4bGhJoevRKT@slm.duckdns.org>
 <2b975ee3117e45aaa7882203cf9a4db8@AcuMS.aculab.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XOnTIwSkLdz0Y256VHM03IJIqS86treru+v0xLpx+F0=;
        b=TSWa57P1ikjpGFCx0r7ilDPFqEDtPVd3KC8p2+bfITDvY+qgxXOhl/TxGYJIPL8HKw
         1FAG5fB5ofC4QbMSaaU2lNl3GcDir6a2aQx/Z9Fu6JVPm894KAXlZvEJ+xsgusNCqqza
         NhDO1Mw9eSPwcyGqeebl2KKJ4x+2fpwGevQ8j22Do7C7344WtfBMf/EJDTg4QRgEWlGr
         qwhwF8T6Dd/42zvmmTRa47pRMCKV6mjfETEqrCWEc5cHFJhXsJeKsryaMPZsu/E5Nx8b
         jBviskxJiTgDjC3nxI/YYsC1dG8PZqpmRUyhK+9HaalZ6GWbSwlt0+qe4HBRsiqY96A6
         jqpg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <2b975ee3117e45aaa7882203cf9a4db8@AcuMS.aculab.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@aculab.com>
Cc: Jiri Slaby <jirislaby@kernel.org>, Christoph Hellwig <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Martin Liska <mliska@suse.cz>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>

On Wed, Nov 02, 2022 at 08:35:34AM +0000, David Laight wrote:
> I think the enums have to be split.
> There will be other side effects of promoting the constants to 64bit
> that are much more difficult to detect than the warnings from printf.

idk, I think I can just add LLU to everything and it should be fine.

> I'm also not sure whether the type is even consistent for 32bit
> and 64bit builds.
> Casts are (sort of) horrid.

Yeah, I don't think casts are the solution either. Lemme add LLU to
everything and see how it works.

Thanks.

-- 
tejun
