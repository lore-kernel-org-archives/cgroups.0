From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] blk-iocost: don't make all constants unsigned long long
Date: Wed, 4 Jan 2023 12:17:13 -1000
Message-ID: <Y7X66RDNGhB45rzZ@slm.duckdns.org>
References: <20221220201819.1497577-1-ydroneaud@opteya.com>
 <20221222135855.GC20830@blackbody.suse.cz>
 <Y7X6ajqnPrtFAL0C@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mBdR1OYvv5zIjW+hrNHEjqsBYdzTVZarSCYttdRP9P0=;
        b=QMHC+W+cPdzEvzu7OmXQnPcvd3ozAn24UBAx+NJZqCwKaCIFamFDpMO5+0fusnSF32
         7rMEcXxCkh4xwbepxkxjCAqOfToVfBsCo5T4Zhh1dfX2BqcKbKxuLLFRvRk+KozCh6mx
         PiCfloJVXYuGwuqkgKdvzg966p0QrHBmHM/DBZD5gJ4Ko0FRf6GQKmkum04ZTwYAA9cE
         driK/F8H6DubpL+VDkSG5dj/M2uRgMqzRORN7tTGUotYlF33zztJk2LStCylCgiyWQTH
         E2UEA+UtPJK0jAs+7pXInfPnzlYTC2Q7qiiRVolqUUgI1DbrVvUN8MvIboES+bgyLdJg
         tq2w==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <Y7X6ajqnPrtFAL0C@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Yann Droneaud <ydroneaud@opteya.com>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Jan 04, 2023 at 12:15:06PM -1000, Tejun Heo wrote:
> On Thu, Dec 22, 2022 at 02:58:55PM +0100, Michal Koutn=FD wrote:
> > On Tue, Dec 20, 2022 at 09:18:19PM +0100, Yann Droneaud <ydroneaud@opte=
ya.com> wrote:
> > > +enum {
> > >  	/* switch iff the conditions are met for longer than this */
> > >  	AUTOP_CYCLE_NSEC	=3D 10LLU * NSEC_PER_SEC,
> > > +};
> >=20
> > This looks gratuitous.
> >=20
> > What about indivudial #defines with typed literals instead of the "lazy
> > splitting"?
>=20
> enums are so much better for debugging and tracing. This is a gcc caused
> problem where there's no other way to generate the same code between two =
gcc
> versions without splitting the enum definitions. I'm kinda baffled that t=
his
> is what they chose to do but can't think of a better way to work around i=
t.

I thought this was the other patch addressing this issue. The proposed patch
is rather painful to look at. The other one splits it into two groups.

Thanks.

--=20
tejun
