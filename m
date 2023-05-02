From: Petr =?UTF-8?B?VGVzYcWZw61r?= <petr@tesarici.cz>
Subject: Re: [PATCH 06/40] lib/string.c: strsep_no_empty()
Date: Tue, 2 May 2023 14:37:37 +0200
Message-ID: <20230502143737.1e11f1ac@meshulam.tesarici.cz>
References: <20230501165450.15352-1-surenb@google.com>
        <20230501165450.15352-7-surenb@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tesarici.cz; s=mail;
        t=1683031059; bh=Qr2tHIsVv3G7WfyCHA01MAqL8W2MA7ATI0zo3p6+vZU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IfEosdQDdG0KdbWIE2Mw4kYzXULwRWeCrunMA9KeSj7bgHgVvejlazncQaRUsj4mk
         cPzKmfMyWBF/pneu0+Wz1Tc79OAteXzmBVIF+laGLG7fMedy5/+rKBRUG4JXa0brek
         j/mHCba0NDf+g5QrNCJ9oA++o7fZWNj5XJR8Ww/uOsU1/r1cRL+Ym3szeVpEkot+SQ
         CPmLY5/NwlfZlklEXZtJMyzmEttSqfpVGGYiYbY1oZJU5at7AavuZZVsxFPid36vj1
         A5riKtEpBa2mW2yWvT3lFoq/3exjrCXn7nmPFY3STEqu5coB+Uro028za0ObQL3JYi
         4+VPt2d2SqCBg==
In-Reply-To: <20230501165450.15352-7-surenb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, mhocko@suse.com, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hughd@google.com, andreyknvl@gmail.

On Mon,  1 May 2023 09:54:16 -0700
Suren Baghdasaryan <surenb@google.com> wrote:

> From: Kent Overstreet <kent.overstreet@linux.dev>
> 
> This adds a new helper which is like strsep, except that it skips empty
> tokens.
> 
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  include/linux/string.h |  1 +
>  lib/string.c           | 19 +++++++++++++++++++
>  2 files changed, 20 insertions(+)
> 
> diff --git a/include/linux/string.h b/include/linux/string.h
> index c062c581a98b..6cd5451c262c 100644
> --- a/include/linux/string.h
> +++ b/include/linux/string.h
> @@ -96,6 +96,7 @@ extern char * strpbrk(const char *,const char *);
>  #ifndef __HAVE_ARCH_STRSEP
>  extern char * strsep(char **,const char *);
>  #endif
> +extern char *strsep_no_empty(char **, const char *);
>  #ifndef __HAVE_ARCH_STRSPN
>  extern __kernel_size_t strspn(const char *,const char *);
>  #endif
> diff --git a/lib/string.c b/lib/string.c
> index 3d55ef890106..dd4914baf45a 100644
> --- a/lib/string.c
> +++ b/lib/string.c
> @@ -520,6 +520,25 @@ char *strsep(char **s, const char *ct)
>  EXPORT_SYMBOL(strsep);
>  #endif
>  
> +/**
> + * strsep_no_empt - Split a string into tokens, but don't return empty tokens
                ^^^^
Typo: strsep_no_empty

Petr T
