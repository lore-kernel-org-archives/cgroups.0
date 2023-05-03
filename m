From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 34/40] lib: code tagging context capture support
Date: Wed, 3 May 2023 09:35:58 +0200
Message-ID: <ZFIO3tXCbmTn53uv@dhcp22.suse.cz>
References: <20230501165450.15352-1-surenb@google.com>
 <20230501165450.15352-35-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-arch-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1683099359; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i3Hzbp6Fc0h0hj5rYtAeMr0Bup0FedFGgjm/ljEsba4=;
        b=A1RUCh5ESqnCmqQHykA4qtiRA0TnekVST89bVweUc4YoOPAxXPAgcnp/rVynH6+pRPkp+z
        0FzTPxhVUa0WAN3v90MiKxX/mhoNEqn2v/EhT/wx95G56Ej/zpg/VQwdKLa255ScGTYoBo
        r9VjFKfCEoqB/4FmnoBqhK5sAhIi958=
Content-Disposition: inline
In-Reply-To: <20230501165450.15352-35-surenb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hughd@google.com, andreyknvl@gmail.com, keescook@chr

On Mon 01-05-23 09:54:44, Suren Baghdasaryan wrote:
[...]
> +static inline void add_ctx(struct codetag_ctx *ctx,
> +			   struct codetag_with_ctx *ctc)
> +{
> +	kref_init(&ctx->refcount);
> +	spin_lock(&ctc->ctx_lock);
> +	ctx->flags = CTC_FLAG_CTX_PTR;
> +	ctx->ctc = ctc;
> +	list_add_tail(&ctx->node, &ctc->ctx_head);
> +	spin_unlock(&ctc->ctx_lock);

AFAIU every single tracked allocation will get its own codetag_ctx.
There is no aggregation per allocation site or anything else. This looks
like a scalability and a memory overhead red flag to me.

> +}
> +
> +static inline void rem_ctx(struct codetag_ctx *ctx,
> +			   void (*free_ctx)(struct kref *refcount))
> +{
> +	struct codetag_with_ctx *ctc = ctx->ctc;
> +
> +	spin_lock(&ctc->ctx_lock);

This could deadlock when allocator is called from the IRQ context.

> +	/* ctx might have been removed while we were using it */
> +	if (!list_empty(&ctx->node))
> +		list_del_init(&ctx->node);
> +	spin_unlock(&ctc->ctx_lock);
> +	kref_put(&ctx->refcount, free_ctx);
-- 
Michal Hocko
SUSE Labs
