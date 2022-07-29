From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 cgroup/for-5.20] cgroup: Replace
 cgroup->ancestor_ids[] with ->ancestors[]
Date: Fri, 29 Jul 2022 13:02:10 -1000
Message-ID: <YuRm8s/CFmGKYPc1@slm.duckdns.org>
References: <YuQvcCrcgNWbtndU@slm.duckdns.org>
 <YuRJ7uzKY5/fokH5@slm.duckdns.org>
 <YuRiQc35guAWcbjt@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc;
        bh=yzM0hFgBu1xt2XGwoIjXneNwzi+RimX6tpHZJOB2AP0=;
        b=ir7GiNB0OtmgqVQSXzwqVX4judqnkcrnIfnBM7W7//ath+Cf1M9QQr/nih9LwFKQhd
         Xa4dOdcLKH8PZYbt4jwaD8IxZge85e0vQBo1HoGBeCy0J7BiW1VeySTnbOVYrkoKX+6A
         7+0JYNE4fig26gCwwxYFXn+qMSK1nzbz0xe2LB7wSIoSRGW9ueeAsfCfUhormv1+RLqo
         LswZMbiHTtZQuUUrL7PB4EvbYbY9X5obMCdQfUCL2+toUnPip+XOfakHrnwvbAiZL2Ix
         Urh2Os7d4+lQrYQRdzS0KgOU/Ic+0mJ2o30wS16tCE9fM1uwsSN6rTl+ps9VgczAo/2l
         gTAQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YuRiQc35guAWcbjt@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pablo Neira Ayuso <pablo-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org>

On Sat, Jul 30, 2022 at 12:42:09AM +0200, Michal Koutn=FD wrote:
> On Fri, Jul 29, 2022 at 10:58:22AM -1000, Tejun Heo <tj-DgEjT+Ai2ygdnm+yR=
OfE0A@public.gmane.org> wrote:
> > @@ -520,8 +520,8 @@ struct cgroup_root {
> >  	/* The root cgroup.  Root is destroyed on its release. */
> >  	struct cgroup cgrp;
> > =20
> > -	/* for cgrp->ancestor_ids[0] */
> > -	u64 cgrp_ancestor_id_storage;
> > +	/* for cgrp->ancestors[0] */
> > +	u64 cgrp_ancestor_storage;
>=20
> Just noticed, this member is (and was AFAICS) superfluous.

I should have changed the type to struct cgroup * but that's the space into
which cgroup_root->cgrp->ancestors[] stretch into.

Thanks.

--=20
tejun
