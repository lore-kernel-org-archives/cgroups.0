From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Subject: Re: [PATCH v3 4/8] memcg: replace stats_flush_lock with an atomic
Date: Tue, 4 Apr 2023 19:32:09 +0200
Message-ID: <20230404173209.fuw2wdbhbzdgszc6@blackpad>
References: <20230330191801.1967435-1-yosryahmed@google.com>
 <20230330191801.1967435-5-yosryahmed@google.com>
 <20230404165258.ie6ttxobbmgn62hs@blackpad>
 <CALvZod5Y+quOS1XQvVBTvv7FRs3455j_79f0GoR+FqCFzbwkuA@mail.gmail.com>
 <CALvZod7Ao-VmB4as+VHsR+awW1jmOA18uVM7qk21mVsXTOYC2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="tp4kmk7uybolwv2d"
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1680629531; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZDEd2ByE3RJ/GX+wDkyEgy/kSR273UEz9enEYcMy1b8=;
        b=Rh0Y4PUmouQ4RsBeXmVM0zyk9aO9dNgz5lgJqiRROymxTIcq8mepaxm62rz47eD78YSCc8
        N+f4YDtLQYOmbbnkmJLBZP1k25oDPW/cmNAkStneuDO2Rlp100x2xAs4rxoMS5ADGQHO/1
        ESZfTdSKMrdNwWs8pTyYiI7mPWHJeys=
Content-Disposition: inline
In-Reply-To: <CALvZod7Ao-VmB4as+VHsR+awW1jmOA18uVM7qk21mVsXTOYC2A@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
To: Shakeel Butt <shakeelb@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, Michal Hocko <mhocko@suse.com>


--tp4kmk7uybolwv2d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 04, 2023 at 10:21:33AM -0700, Shakeel Butt <shakeelb@google.com> wrote:
> > Yes indeed it is. Basically we want to avoid unconditional cache
> > dirtying. This pattern is also used at other places in the kernel like
> > qspinlock.

Thanks for confirmation.

(I remembered the commit 873f64b791a2 ("mm/memcontrol.c: remove the
redundant updating of stats_flush_threshold"). But was slightly confused
why would it be open-coded every time.)

> Oh also take a look at
> https://lore.kernel.org/all/20230404052228.15788-1-feng.tang@intel.com/

Thanks for the link.

Michal

--tp4kmk7uybolwv2d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZCxfFAAKCRAkDQmsBEOq
ubDdAP9UYeeNxfHY8xeftxD/DsD9BcOlaSaQPTOhztUjOJOmEwD+PjYu9+lFlKNJ
In8lwXw/ZwMTHOjEVMnHwxc+TNnpwQk=
=LYWU
-----END PGP SIGNATURE-----

--tp4kmk7uybolwv2d--
