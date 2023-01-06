From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v3] blk-throtl: Introduce sync and async queues for
 blk-throtl
Date: Fri, 6 Jan 2023 16:38:13 +0100
Message-ID: <20230106153813.4ttyuikzaagkk2sc@quack3>
References: <20221226130505.7186-1-hanjinke.666@bytedance.com>
 <20230105161854.GA1259@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1673019494; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D7BVs+c1jJrTgfTP4y3v5/V0eGmeqdXDwPfl0iJaAd4=;
        b=3E3Lgs2aAGpDdYW5+AKcNWdB5l9w4zvWCacqafvED4WVf1Z7fBzgAfn2miDNOdc50rpRcF
        /gPnEqvTuPLTE8Kk9wNQfTkQquPSENw6dOkP6baW5IQ0Juhba85jdQ8Erk0oTWmTJT8+Cw
        TZV1dEMWE0AzpAAHzknBF1M3LaDLsbI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1673019494;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D7BVs+c1jJrTgfTP4y3v5/V0eGmeqdXDwPfl0iJaAd4=;
        b=1q0HHYB9DZXlBTx+ZpLaeAQje6jIDfq0gkybOD0Eto4yfx1n9s7rlKVsVBxz+DfiCkAVpl
        X4mbSYxsz7b2OeDg==
Content-Disposition: inline
In-Reply-To: <20230105161854.GA1259-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yinxin.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org

On Thu 05-01-23 17:18:54, Michal Koutn=FD wrote:
> Hello Jinke.
>=20
> On Mon, Dec 26, 2022 at 09:05:05PM +0800, Jinke Han <hanjinke.666-EC8Uxl6=
Npydl57MIdRCFDg@public.gmane.org> wrote:
> > In our test, fio writes a 100g file in sequential 4k blocksize in
> > a container with low bps limit configured (wbps=3D10M).
> > [...]
> > At the same time, the operation of saving a small file by vim will be
> > blocked amolst 140s.
>=20
> Could you please elaborate why is this specific to blk-throtl?
>=20
> I guess similar problem would arise for devices that are "naturally"
> slow.
> Then:
> a) it must have been solved elsewhere in the block layer (but it's
>    broken),
> b) it should be solved generically in the block layer (thus this is only
>    a partial solution).

Generally, problems are this are taken care of by IO schedulers. E.g. BFQ
has quite a lot of logic exactly to reduce problems like this. Sync and
async queues are one part of this logic inside BFQ (but there's more).

But given current architecture of the block layer IO schedulers are below
throttling frameworks such as blk-throtl so they have no chance of
influencing problems like this. So we are bound to reinvent the scheduling
logic IO schedulers are already doing. That being said I don't have a good
solution for this or architecture suggestion. Because implementing various
throttling frameworks within IO schedulers is cumbersome (complex
interactions) and generally the perfomance is too slow for some usecases.
We've been there (that's why there's cgroup support in BFQ) and really
the current architecture is much easier to reason about.

								Honza
--=20
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
