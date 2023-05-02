From: Petr =?UTF-8?B?VGVzYcWZw61r?= <petr-hIRrMMry8ebtwjQa/ONI9g@public.gmane.org>
Subject: Re: [PATCH 09/40] mm: introduce __GFP_NO_OBJ_EXT flag to
 selectively prevent slabobj_ext creation
Date: Tue, 2 May 2023 14:50:14 +0200
Message-ID: <20230502145014.24b28e64@meshulam.tesarici.cz>
References: <20230501165450.15352-1-surenb@google.com>
        <20230501165450.15352-10-surenb@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tesarici.cz; s=mail;
        t=1683031817; bh=7Jx1V6HXo4qXXJ5gzNb9WgNbQl2iBAjQx92+mbN9mcI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LdYat1pxvtqHcsyEsr0xSmJ80I9UQQAdwuWNsIlmRhcDv+RP+JqFNQRT+nYc9G7uP
         dXPpgO79Zyo5DI2T6iRH+RieaWMoILvCo+t0ga1IpmjPazX2dudxt9IHa/Q1eVW8Rh
         npJAxuinpIG3jaAdl3urTCU5KvJB8xckJUgufKO4oRJxNsCTGApQSCpiehfAf9XW2g
         55qZn04dxosxPP6JwtR/XcAxhlpiWK6SFfOBMCcvmnxf+hMduxm0neIM19D6X3o7mp
         /hFiYxv9D35v34aGYGGZPSYkcyumwUEB7pS25ZX4SffsQ4FOhXKIFk8+GhJJd8+bil
         9cEFx4TVmGUMg==
In-Reply-To: <20230501165450.15352-10-surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, liam.howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ldufour-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pasha.tatashin-2EmBfe737+LQT0dZR+AlfA@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, andreyknvl@gmail.

On Mon,  1 May 2023 09:54:19 -0700
Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> Introduce __GFP_NO_OBJ_EXT flag in order to prevent recursive allocations
> when allocating slabobj_ext on a slab.
> 
> Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  include/linux/gfp_types.h | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
> index 6583a58670c5..aab1959130f9 100644
> --- a/include/linux/gfp_types.h
> +++ b/include/linux/gfp_types.h
> @@ -53,8 +53,13 @@ typedef unsigned int __bitwise gfp_t;
>  #define ___GFP_SKIP_ZERO	0
>  #define ___GFP_SKIP_KASAN	0
>  #endif
> +#ifdef CONFIG_SLAB_OBJ_EXT
> +#define ___GFP_NO_OBJ_EXT       0x4000000u
> +#else
> +#define ___GFP_NO_OBJ_EXT       0
> +#endif
>  #ifdef CONFIG_LOCKDEP
> -#define ___GFP_NOLOCKDEP	0x4000000u
> +#define ___GFP_NOLOCKDEP	0x8000000u

So now we have two flags that depend on config options, but the first
one is always allocated in fact. I wonder if you could use an enum to
let the compiler allocate bits. Something similar to what Muchun Song
did with section flags.

See commit ed7802dd48f7a507213cbb95bb4c6f1fe134eb5d for reference.

>  #else
>  #define ___GFP_NOLOCKDEP	0
>  #endif
> @@ -99,12 +104,15 @@ typedef unsigned int __bitwise gfp_t;
>   * node with no fallbacks or placement policy enforcements.
>   *
>   * %__GFP_ACCOUNT causes the allocation to be accounted to kmemcg.
> + *
> + * %__GFP_NO_OBJ_EXT causes slab allocation to have no object
> extension. */
>  #define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE)
>  #define __GFP_WRITE	((__force gfp_t)___GFP_WRITE)
>  #define __GFP_HARDWALL   ((__force gfp_t)___GFP_HARDWALL)
>  #define __GFP_THISNODE	((__force gfp_t)___GFP_THISNODE)
>  #define __GFP_ACCOUNT	((__force gfp_t)___GFP_ACCOUNT)
> +#define __GFP_NO_OBJ_EXT   ((__force gfp_t)___GFP_NO_OBJ_EXT)
>  
>  /**
>   * DOC: Watermark modifiers
> @@ -249,7 +257,7 @@ typedef unsigned int __bitwise gfp_t;
>  #define __GFP_NOLOCKDEP ((__force gfp_t)___GFP_NOLOCKDEP)
>  
>  /* Room for N __GFP_FOO bits */
> -#define __GFP_BITS_SHIFT (26 + IS_ENABLED(CONFIG_LOCKDEP))
> +#define __GFP_BITS_SHIFT (27 + IS_ENABLED(CONFIG_LOCKDEP))

If the above suggestion is implemented, this could be changed to
something like __GFP_LAST_BIT (the enum's last identifier).

Petr T
