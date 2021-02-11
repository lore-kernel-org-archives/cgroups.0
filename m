From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2] mm: page-writeback: simplify memcg handling in
 test_clear_page_writeback()
Date: Wed, 10 Feb 2021 19:33:00 -0500
Message-ID: <YCR7PMk4RAM1uVeM@cmpxchg.org>
References: <20210209214543.112655-1-hannes@cmpxchg.org>
 <alpine.LSU.2.11.2102092058290.7553@eggly.anvils>
 <alpine.LSU.2.11.2102100813050.8131@eggly.anvils>
 <YCQbYAWg4nvBFL6h@cmpxchg.org>
 <CALvZod6vgYcpgskf7NaRagH999L6VkfnVtD1UDb+JhQceCuUEA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FI7efxdLkrLWQRe2h+l+IMlmkcYgyIFOXgeNuZLjvTM=;
        b=bycQ5yJtXDWmNNXRP0PrIO2BHNarVUWpIj1Op4PnadIWfTeHUhFPgAVAcbNAQ64VpH
         gxfTtVSlBVO097jFW+zhdqSttQpMsvicByCNN7ar5id9u5oAPtspAY74GFvlnmfEHmhC
         t8nupXeSt7Clnsv4DhVPcmUssp3sYyq0AsWT54E4hPYnU/koqUJzG/qwNWS7vPgXQQN3
         YWn2m/e8g1FiLlSmgRgP3MF4D1d3AnGrxVkUC/yuiewY42CF582D/0HpJXSjfKINY+GG
         aznJdtOMmyCCHd6oHMiKgq5Dik+4n3pRGtSCdoMQnrDnBZbDWZpcoxLRCFe2ZPWjsB/A
         wG9g==
Content-Disposition: inline
In-Reply-To: <CALvZod6vgYcpgskf7NaRagH999L6VkfnVtD1UDb+JhQceCuUEA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>, Arjun Roy <arjunroy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Wed, Feb 10, 2021 at 02:59:32PM -0800, Shakeel Butt wrote:
> On Wed, Feb 10, 2021 at 9:44 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> > From 5bcc0f468460aa2670c40318bb657e8b08ef96d5 Mon Sep 17 00:00:00 2001
> > From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > Date: Tue, 9 Feb 2021 16:22:42 -0500
> > Subject: [PATCH] mm: page-writeback: simplify memcg handling in
> >  test_clear_page_writeback()
> >
> > Page writeback doesn't hold a page reference, which allows truncate to
> > free a page the second PageWriteback is cleared. This used to require
> > special attention in test_clear_page_writeback(), where we had to be
> > careful not to rely on the unstable page->memcg binding and look up
> > all the necessary information before clearing the writeback flag.
> >
> > Since commit 073861ed77b6 ("mm: fix VM_BUG_ON(PageTail) and
> > BUG_ON(PageWriteback)") test_clear_page_writeback() is called with an
> > explicit reference on the page, and this dance is no longer needed.
> >
> > Use unlock_page_memcg() and dec_lruvec_page_state() directly.
> >
> > This removes the last user of the lock_page_memcg() return value,
> > change it to void. Touch up the comments in there as well. This also
> > removes the last extern user of __unlock_page_memcg(), make it
> > static. Further, it removes the last user of dec_lruvec_state(),
> > delete it, along with a few other unused helpers.
> >
> > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> The patch looks fine. I don't want to spoil the fun but just wanted to
> call out that I might bring back __unlock_page_memcg() for the memcg
> accounting of zero copy TCP memory work where we are uncharging the
> page in page_remove_rmap().

That shouldn't be an issue. Just add it back if/when you need it and
we have a legitimate in-tree user for it again. It still helps to
remove it now; if someboy later goes through the git log to identify
dependencies, they'll find your patch adding it and can stop looking.

Thanks for the review!
