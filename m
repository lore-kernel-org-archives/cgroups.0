From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] sched/fair: Filter by css_is_dying() in the last
 tg_unthrottle_up()
Date: Mon, 29 Nov 2021 06:39:35 -1000
Message-ID: <YaUCR4a0kes5XvF4@slm.duckdns.org>
References: <20211126130619.30730-1-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=uN2SDh1OpNAmwOV7/X9bwxMmpaiYU2WulSlLqtLkQkY=;
        b=KK4Dw2fMZbfFmVV6q17Pao6/+8xYHausH2l199e4NYZgTZVnoLqC4hb9YmsqEviUME
         lsMzIDH3kTgDBKYo0FSwi7y/khD9Oi6Snyc8BOjJLVmdDVBFYZKiT9tX0oof2fVn78Td
         CEtOJpLA0+Ucaq8lW2DUoJRed8CZzP8kngbXXiaU9LewFmRAAel019T2AgVXZjfvQ0Yr
         yZQRRElxoAy8PXgjTNNFPazB6/W9imiFRJMYVJiR1pVdJbU+G6s9M5QMy/3S439s8uLd
         umtxOw5ja4oKXXyaq+6X92gzcngC9Jo5tGDhmNPwgDE5gOZuv4A0claZyUAZ7JKHsaby
         6tBA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20211126130619.30730-1-mkoutny-IBi9RG/b67k@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, minipli-JNS0hek0TMl4qEwOxq4T+Q@public.gmane.org, Valentin.Schneider-5wv7dgnIgG8@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kevin.tanguy-Rm6v+N6rxxBWk0Htik3J/w@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, odin-RObV4cXtwVA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, spender-JNS0hek0TMl4qEwOxq4T+Q@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org

Hello,

On Fri, Nov 26, 2021 at 02:06:19PM +0100, Michal Koutn=FD wrote:
> As explained in the message, this relies on the RCU GP between css_is_dyi=
ng()
> returning false and the potential .css_offline() call.=20
> This is stated in the css_is_dying() documentation:
>=20
> > the actual offline operations are RCU delayed and this test returns %tr=
ue
> > also when @css is scheduled to be offlined.
>=20
> On the other hand the documentation of the underlying
> percpu_ref_kill_and_confirm() says (to discourage relying on GP):
>=20
> > There are no implied RCU grace periods between kill and release.
>=20
> This seems to discord with each other at first thought. (That's why I mar=
ked
> this RFC.)
>=20
> However, if one takes into account that percpu_refs as used by css are ne=
ver
> switched to atomic besides the actual killing (and they start in per-cpu =
mode),
> the GP (inserted in __percpu_ref_switch_to_atomic()) is warranted.

IIRC, one reason why I didn't want to make the implied RCU "official" was
that there were different RCU types and cgroup was using the less common
preempt variant. Now that the RCU types are unified, it may be okay to
guarantee that e.g. percpu ref offlining has a guaranteed GP and then
propagate that guarantee to the users. It may still be a bit brittle tho in
that we may force the percpu ref to atomic mode for e.g. reference leak
debugging. It'd be great if we can trigger a warning if we end up missing a
GP for whatever reason.

Thanks.

--=20
tejun
