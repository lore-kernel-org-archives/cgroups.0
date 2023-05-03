From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 35/40] lib: implement context capture support for tagged
 allocations
Date: Wed, 3 May 2023 09:39:06 +0200
Message-ID: <ZFIPmnrSIdJ5yusM@dhcp22.suse.cz>
References: <20230501165450.15352-1-surenb@google.com>
 <20230501165450.15352-36-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-arch-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1683099546; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vE/ZqILzfvZWd4rot3GcUptJ3pMzFJC66caayH1dCe0=;
        b=tncfUpOeuf22PZWsQOZPjfGxENPQ6bWeS5Zzg0KWVa6nByIXgrM/jXad5KRjyoMOq9cTRa
        WpcrDCHFNLiXhmlPc0lNRWDLzFfikMFdjsBDSF6ZkSOyK8WMPI6FOfRJkSLZupbbrFLolo
        +Rlvt8SIDl9dbU55U0aIZiVhpfhfHjs=
Content-Disposition: inline
In-Reply-To: <20230501165450.15352-36-surenb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hughd@google.com, andreyknvl@gmail.com, keescook@chr

On Mon 01-05-23 09:54:45, Suren Baghdasaryan wrote:
[...]
> +struct codetag_ctx *alloc_tag_create_ctx(struct alloc_tag *tag, size_t size)
> +{
> +	struct alloc_call_ctx *ac_ctx;
> +
> +	/* TODO: use a dedicated kmem_cache */
> +	ac_ctx = kmalloc(sizeof(struct alloc_call_ctx), GFP_KERNEL);

You cannot really use GFP_KERNEL here. This is post_alloc_hook path and
that has its own gfp context.
-- 
Michal Hocko
SUSE Labs
