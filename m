From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] bfq: Fix use-after-free with cgroups
Date: Mon, 13 Dec 2021 14:46:31 +0100
Message-ID: <20211213134631.GB14044@quack2.suse.cz>
References: <20211201133439.3309-1-jack@suse.cz>
 <28ded939-6339-c9e1-c0a3-ff84fb197eed@applied-asynchrony.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1639403191; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UyolFaM14P3cDEhuPoRNdfQMUKwyv7gy6T2mO+pB6xQ=;
        b=yl41LBoGbpRPzv8MWlVP/S7tRtKgZDXkZBgCoeG85vG7FuG3gjQYUIwF26c29dYJm8sbPR
        YLrT9c9xWsiRbxlIxxsPP55lYRe2vedNbZFXqpfvgpb9KNLX3Qewk/GNL0XPIlQNCsFmDT
        2GUZipePriaBQtnjklCUhmoeML/u58Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1639403191;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UyolFaM14P3cDEhuPoRNdfQMUKwyv7gy6T2mO+pB6xQ=;
        b=jsQdHM62n6CiQzQryvCuAGb4jgn+x0EJXupvcFt2HxjHrap6ixb9OWlbosUZXfw6kxIQo6
        OuHQWfteTdVU38Cw==
Content-Disposition: inline
In-Reply-To: <28ded939-6339-c9e1-c0a3-ff84fb197eed-yRdLqooqVXZ9NkuW+OO3NY3UfPj+9hkl@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?= <holger-yRdLqooqVXZ9NkuW+OO3NY3UfPj+9hkl@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, fvogt-l3A5Bk7waGM@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Fabian Vogt <fvogt-IBi9RG/b67k@public.gmane.org>

On Tue 07-12-21 15:53:54, Holger Hoffst=E4tte wrote:
>=20
> On 2021-12-01 14:34, Jan Kara wrote:
> > BFQ started crashing with 5.15-based kernels like:
> >=20
> > BUG: KASAN: use-after-free in rb_erase (lib/rbtree.c:262 lib/rbtr
> > Read of size 8 at addr ffff888008193098 by task bash/1472
> [snip]
>=20
> This does not compile when CONFIG_BFQ_GROUP_IOSCHED is disabled.
> I know the patch is meant for the case where it is enabled, but still..
>=20
> block/bfq-iosched.c: In function 'bfq_init_bfqq':
> block/bfq-iosched.c:5362:51: error: 'struct bfq_group' has no member name=
d 'children'
>  5362 |         hlist_add_head(&bfqq->children_node, &bfqg->children);
>       |                                                   ^~
> make[1]: *** [scripts/Makefile.build:277: block/bfq-iosched.o] Error 1
>=20
> Probably just needs a few more ifdefs :)

Yep, already fixed that up locally. Thanks for notice.

								Honza

--=20
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
