From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] cgroup: Print v1 cgroup.procs and tasks without
 pidlists
Date: Tue, 29 Aug 2023 11:01:59 -1000
Message-ID: <ZO5cx9UhqBzP2QX-@slm.duckdns.org>
References: <20230823174804.23632-1-mkoutny@suse.com>
 <20230823174804.23632-2-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693342922; x=1693947722; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RMyy3L586kb8cKfelvrLkGkpSHTkexvGQpQjE1LwdFo=;
        b=CyS5CPua06THdQxkbEFgECOylZrddrh+R/xL1V4Hgbp3Hp98GdIh394fmg3cEBkD4G
         31IuNUsJfa0D1IstYXy7U4jYmK5+fO0hXlKm6aWD/Tcu2lap9D55BoANYlnFxseYEGxS
         /caoQL8ZEsjObmP5rt/dgXpyl8bgoxPS8r3NpD6F7AEYq4DhYf03g/5zp98nmVY1kmvO
         CdcTRviQiLJAKOsbOXWzqhVsErGjFQFXVH8E5LaGeuI+TyDsO0OgXAjSnL+S04g67LnL
         2L4ufEIg+/53OGazOhUdQZNmPdXSL/2GsHeYoO4NFOw+jZF04peiGH0zNlmwEieLC34J
         W9nA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230823174804.23632-2-mkoutny@suse.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Firo Yang <firo.yang@suse.com>

Hello, Michal.

On Wed, Aug 23, 2023 at 07:48:03PM +0200, Michal Koutn=FD wrote:
> pidlists are structure that allows printing cgroup member tasks in
> sorted order and with proper pidns (in)visibility.
>=20
> The promise of sorted output was removed in the commit 7823da36ce8e
> ("cgroups: update documentation of cgroups tasks and procs files") (more
> than 13 years ago at the time of writing this).

While this is true, I'm not sure it'd be a good idea to change the behavior
after all these years. Whoever is still using cgroup1 likely doens't mean to
update their code at all and it's difficult to rule out odd-ball users that
might have been depending on the ordered output knowingly or unknowingly.

> On systems that still use v1 hierarchies (e.g. systemd in non-unified
> mode), pidlists are problematic because:
> a) their cache unnecessarily busies workqueues (cgroup_pidlist_destroy_wq)
> b) PID recycling [1] may lead to logging noise:
> > seq_file: buggy .next function kernfs_seq_next did not update position =
index

While I like the code reduction, I wonder whether the right course of action
is just fixing the warning here.

Thanks.

--=20
tejun
