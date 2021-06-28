From: Dan Schatzberg <schatzberg.dan@gmail.com>
Subject: Re: [PATCH 3/3] loop: Charge i/o to mem and blk cg
Date: Mon, 28 Jun 2021 10:17:18 -0400
Message-ID: <YNnZ7hIRIk9dJDry@dschatzberg-fedora-PC0Y6AEN>
References: <20210610173944.1203706-1-schatzberg.dan@gmail.com>
 <20210610173944.1203706-4-schatzberg.dan@gmail.com>
 <YNXvr81YFzbaTxCb@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=vAguyIyi4MmUNdlCWw+ELLDz19W9ZtG5NXhufd99HQU=;
        b=ou9qWijqI8+uRu9wJxljIWLESJnGibgJlZ1RbImShcDy9ys4gRS9l4WX13763vB6o1
         JYtM7iFmX6tYN1xnyCqvBwoh3DV1nEe9s8ExkS7XaCO+6bnVGIJk2/0zmzghc7V7BIPy
         52vif2t67eC4ft8m9AqigMctzHoCFjQmhqbj3vQSF4zC2GHEu5KT6up2sHp5z6YDQN0y
         eHhJWR0+P8S9SC9MqmnfSvuCOto5l6Y0RRxPdsx8B4xvemH3LvFiAzHk3i4G0pmhIAja
         jG3ZKv0SZKOXE5TxMKShSOdKq9czRuZ9nniTCuv85w8uglqMShEaWC/85HkJdvP/TFmx
         xw/Q==
Content-Disposition: inline
In-Reply-To: <YNXvr81YFzbaTxCb@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>, Jens Axboe <axboe@kernel.dk>

Hi Michal,

On Fri, Jun 25, 2021 at 05:01:03PM +0200, Michal Koutn=FD wrote:
> Hi.
>=20
> On Thu, Jun 10, 2021 at 10:39:44AM -0700, Dan Schatzberg <schatzberg.dan@=
gmail.com> wrote:
> > The current code only associates with the existing blkcg when aio is
> > used to access the backing file. This patch covers all types of i/o to
> > the backing file and also associates the memcg so if the backing file is
> > on tmpfs, memory is charged appropriately.
> >=20
> > This patch also exports cgroup_get_e_css and int_active_memcg so it
> > can be used by the loop module.
>=20
> Wouldn't it be clearer to export (not explicitly inlined anymore)
> set_active_memcg() instead of the int_active_memcg that's rather an
> implementation detail?

Agreed that exporting int_active_memcg is an implementation detail,
but would this prevent set_active_memcg from being inlined? Is that
desireable?

>=20
> > @@ -2111,13 +2112,18 @@ static blk_status_t loop_queue_rq(struct blk_mq=
_hw_ctx *hctx,
> >  	}
> > =20
> >  	/* always use the first bio's css */
> > +	cmd->blkcg_css =3D NULL;
> > +	cmd->memcg_css =3D NULL;
> >  #ifdef CONFIG_BLK_CGROUP
> > -	if (cmd->use_aio && rq->bio && rq->bio->bi_blkg) {
> > -		cmd->css =3D &bio_blkcg(rq->bio)->css;
> > -		css_get(cmd->css);
> > -	} else
> > +	if (rq->bio && rq->bio->bi_blkg) {
> > +		cmd->blkcg_css =3D &bio_blkcg(rq->bio)->css;
> > +#ifdef CONFIG_MEMCG
> > +		cmd->memcg_css =3D
> > +			cgroup_get_e_css(cmd->blkcg_css->cgroup,
> > +					&memory_cgrp_subsys);
> > +#endif
> > +	}
> >  #endif
> > -		cmd->css =3D NULL;
> >  	loop_queue_work(lo, cmd);
>=20
> I see you dropped the cmd->blkcg_css reference (while rq is handled). Is
> it intentional?

Yes it is intentional. All requests (not just aio) go through the loop
worker which grabs the blkcg reference in loop_queue_work() on
construction. So I believe grabbing a reference per request is
unnecessary.
