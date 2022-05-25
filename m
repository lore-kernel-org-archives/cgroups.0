From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH v3 5/5] selftests: memcg: Factor out common parts of
 memory.{low,min} tests
Date: Tue, 24 May 2022 19:26:05 -0700
Message-ID: <Yo2TvWr/0Y6s9SE2@carbon>
References: <20220524162955.8635-1-mkoutny@suse.com>
 <20220524162955.8635-6-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1653445571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eXx4F9wUjqDqnxItlogKlV+6bSU2C37UciSDkRX2OcU=;
        b=cltERvpd9/BsbbrUHUBYK9fauukniigpOChcjUlKIHJPRgAc6yjyz3akEdweV6Xi4OJZyj
        xwcrNb/oUv0hkOCAg+rPrlPKRX6J+lb11T+AN+CraLePT67cbn9CIDG/2th4mL0KM4KPah
        4gjfewLE7dCTdZVEzTWN+toba5BPeQ0=
Content-Disposition: inline
In-Reply-To: <20220524162955.8635-6-mkoutny@suse.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, Richard Palethorpe <rpalethorpe@suse.de>, Muhammad Usama Anjum <usama.anjum@collabora.com>

On Tue, May 24, 2022 at 06:29:55PM +0200, Michal Koutny wrote:
> The memory protection test setup and runtime is almost equal for
> memory.low and memory.min cases.
> It makes modification of the common parts prone to mistakes, since the
> protections are similar not only in setup but also in principle, factor
> the common part out.
>=20
> Past exceptions between the tests:
> - missing memory.min is fine (kept),
> - test_memcg_low protected orphaned pagecache (adapted like
>   test_memcg_min and we keep the processes of protected memory running).
>=20
> The evaluation in two tests is different (OOM of allocator vs low events
> of prot=E9g=E9s), this is kept different.
>=20
> Signed-off-by: Michal Koutn=FD <mkoutny@suse.com>

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
