From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] blk-iocost: don't make all constants unsigned long long
Date: Wed, 4 Jan 2023 12:15:06 -1000
Message-ID: <Y7X6ajqnPrtFAL0C@slm.duckdns.org>
References: <20221220201819.1497577-1-ydroneaud@opteya.com>
 <20221222135855.GC20830@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+kzAyESGIRnB6ZoSVhFAu0vNg+AUYHAiTR9t3Vdi7JU=;
        b=Sm7k5yc8eAeCWJuIWszMzn0BI6Xk9vvIxlP99m51CZibkPqgb8elOeZc+T9mUlBitS
         edlD7jRkd3DA/q8mxg6/HyqAL/6jk/0lW27/1T85ruIg5A4wDlAmsU/67pdL66/UTQiZ
         rdS4lX+t3IhGQj4dk5LPZgatM3yoEXkAJn7skS9Z0UbJOAzqMARu3xFse8xSZ5BeWNU/
         tcdTOBTQH+yD/AdIA+1zkQjz6Ij/GMzHceHAgWPUtPDhGofk9yVI2IamUUxKEbHS/EI/
         JgV67fFIprq5ljOHqEOcuRnWPic/BbU8T6QuU+E0pgzQr6WZIvCzoUMFbbMxkhCJQBLJ
         bYvw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20221222135855.GC20830@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Yann Droneaud <ydroneaud@opteya.com>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Dec 22, 2022 at 02:58:55PM +0100, Michal Koutn=FD wrote:
> On Tue, Dec 20, 2022 at 09:18:19PM +0100, Yann Droneaud <ydroneaud@opteya=
.com> wrote:
> > +enum {
> >  	/* switch iff the conditions are met for longer than this */
> >  	AUTOP_CYCLE_NSEC	=3D 10LLU * NSEC_PER_SEC,
> > +};
>=20
> This looks gratuitous.
>=20
> What about indivudial #defines with typed literals instead of the "lazy
> splitting"?

enums are so much better for debugging and tracing. This is a gcc caused
problem where there's no other way to generate the same code between two gcc
versions without splitting the enum definitions. I'm kinda baffled that this
is what they chose to do but can't think of a better way to work around it.

Thanks.

--=20
tejun
