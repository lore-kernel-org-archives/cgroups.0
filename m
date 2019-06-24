From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] mm: fix page cache convergence regression
Date: Tue, 25 Jun 2019 05:52:00 +0800
Message-ID: <CAHk-=wjcO7WjWyAoBmXDWcn7spfJbbgF_tXaHrqANVqEH8DGmQ@mail.gmail.com>
References: <20190524153148.18481-1-hannes@cmpxchg.org> <20190524160417.GB1075@bombadil.infradead.org>
 <20190524173900.GA11702@cmpxchg.org> <20190530161548.GA8415@cmpxchg.org>
 <20190530171356.GA19630@bombadil.infradead.org> <20190624151923.GA10572@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o2TgnyjeWoDT8cizs+0926CcrBI/Czk7Q1OwFweZT40=;
        b=YW+HL5IBGifOF6jZu1p6PtaguBQyhJkmQ9YMn7Jji10endO+CCULhFAsaLYdbA85HU
         bFUAnpfdTAsZ1Gvy96tlCor3QNdK05lm3AEeLiJmDqpEr3l1mXaGi+f50BoXwSjtl9UA
         vNVPNKHu+JCKTKrlQwc17yT7GYO7Y66TTo8Mw=
In-Reply-To: <20190624151923.GA10572@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, kernel-team@fb.com

On Mon, Jun 24, 2019 at 11:19 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> Hey, it's three weeks later and we're about to miss 5.2.
>
> This sucks, Matthew.

Yes.

And I do think that having a real gfp field there would be better than
the very odd xa_flags that is *marked* as being gfp_t, but isn't
really a gfp_t at all.

So how about we apply Johannes' patch, and then work on making that
xa_flags field be a proper type of its own. Because it really isn't a
gfp_t, and never has been, even if there might be some very limited
and hacky overlap right now.

Alternatrively, the subset of bits that _can_ be used as a gfp should
actually be used as such, in xas_alloc/xas_nomem. So that you can do

    xa_init_flags(&mapping->i_pages, XA_FLAGS_LOCK_IRQ | __GFP_ACCOUNT);

in __address_space_init_once() and it would do what it is supposed to do.

Willy?

               Linus
