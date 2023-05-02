From: Petr =?UTF-8?B?VGVzYcWZw61r?= <petr@tesarici.cz>
Subject: Re: [PATCH 03/40] fs: Convert alloc_inode_sb() to a macro
Date: Tue, 2 May 2023 14:35:30 +0200
Message-ID: <20230502143530.1586e287@meshulam.tesarici.cz>
References: <20230501165450.15352-1-surenb@google.com>
        <20230501165450.15352-4-surenb@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tesarici.cz; s=mail;
        t=1683030933; bh=20jqHRbdtEj8ppcmNyyd7rJFAO2W2GN7oe2dWzqRVvA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pvJgyuySDoLJG+kmwFC037D7WTQlrRk1f6tAP/S5DF4yRvNHQRW7/ahkCIvO3leti
         5pobEX0K/+x571RACLufXczVdwrcYtazeu1Un/KOB0R9qIQe+mbom2Tj1dGjq/4TLv
         dMPoj1HfCNA3A6O+iuXmXP2dOAaZTi2u5PLNFZA8btd9bxu/eJtNxHjRyjED7MKRCT
         TvmcQpmwIA0/Fl5ghTvDBzGW7yklDbxwUOtz8JQeVZryBJk3NhMCMDl5Vz+TXpCoch
         0RTOINsN038OoKKSythJat+YPJ8wlE0LZVvUegvmuhW+eFACY68/wfeoQtRtWKJXkt
         1DtPmRcDAWu7Q==
In-Reply-To: <20230501165450.15352-4-surenb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, mhocko@suse.com, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hughd@google.com, andreyknvl@gmail.

On Mon,  1 May 2023 09:54:13 -0700
Suren Baghdasaryan <surenb@google.com> wrote:

> From: Kent Overstreet <kent.overstreet@linux.dev>
> 
> We're introducing alloc tagging, which tracks memory allocations by
> callsite. Converting alloc_inode_sb() to a macro means allocations will
> be tracked by its caller, which is a bit more useful.
> 
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> ---
>  include/linux/fs.h | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 21a981680856..4905ce14db0b 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2699,11 +2699,7 @@ int setattr_should_drop_sgid(struct mnt_idmap *idmap,
>   * This must be used for allocating filesystems specific inodes to set
>   * up the inode reclaim context correctly.
>   */
> -static inline void *
> -alloc_inode_sb(struct super_block *sb, struct kmem_cache *cache, gfp_t gfp)
> -{
> -	return kmem_cache_alloc_lru(cache, &sb->s_inode_lru, gfp);
> -}
> +#define alloc_inode_sb(_sb, _cache, _gfp) kmem_cache_alloc_lru(_cache, &_sb->s_inode_lru, _gfp)

Honestly, I don't like this change. In general, pre-processor macros
are ugly and error-prone.

Besides, it works for you only because __kmem_cache_alloc_lru() is
declared __always_inline (unless CONFIG_SLUB_TINY is defined, but then
you probably don't want the tracking either). In any case, it's going
to be difficult for people to understand why and how this works.

If the actual caller of alloc_inode_sb() is needed, I'd rather add it
as a parameter and pass down _RET_IP_ explicitly here.

Just my two cents,
Petr T
