From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>
Subject: Re: [patch 12/13] mm: memcontrol: rewrite charge API
Date: Mon, 23 Jun 2014 08:15:26 +0200
Message-ID: <20140623061526.GH13440@pengutronix.de>
References: <1403124045-24361-1-git-send-email-hannes@cmpxchg.org>
 <1403124045-24361-13-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1403124045-24361-13-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel@pengutronix.de

Hello,

On Wed, Jun 18, 2014 at 04:40:44PM -0400, Johannes Weiner wrote:
> The memcg charge API charges pages before they are rmapped - i.e. have
> an actual "type" - and so every callsite needs its own set of charge
> and uncharge functions to know what type is being operated on.  Worse,
> uncharge has to happen from a context that is still type-specific,
> rather than at the end of the page's lifetime with exclusive access,
> and so requires a lot of synchronization.
> ...

this patch made it into next-20140623 as 5e49555277df (mm: memcontrol: re=
write
charge API) and it makes efm32_defconfig (ARCH=3Darm) fail with:

  CC      mm/swap.o
mm/swap.c: In function 'lru_cache_add_active_or_unevictable':
mm/swap.c:719:2: error: implicit declaration of function 'TestSetPageMloc=
ked' [-Werror=3Dimplicit-function-declaration]
  if (!TestSetPageMlocked(page)) {
  ^
cc1: some warnings being treated as errors
scripts/Makefile.build:257: recipe for target 'mm/swap.o' failed
make[3]: *** [mm/swap.o] Error 1
Makefile:1471: recipe for target 'mm/swap.o' failed

imx_v4_v5_defconfig works, so probably the thing that makes
efm32_defconfig fail is CONFIG_MMU=3Dn.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig          =
  |
Industrial Linux Solutions                 | http://www.pengutronix.de/  =
|

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
