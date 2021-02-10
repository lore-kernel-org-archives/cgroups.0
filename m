From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: page-writeback: simplify memcg handling in test_clear_page_writeback()
Date: Wed, 10 Feb 2021 05:46:51 -0800
Message-ID: <CALvZod7Tf+KBhT=3WCQ_uWa7_mZad6-L8wQJghxPRL_tVyQ8Cw@mail.gmail.com>
References: <20210209214543.112655-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x7AQuIHqlGeDKdDmQaoPxTGljXqoMuKxFCh/+vT0i5k=;
        b=nOGKWwErjCXi0YFKi585FYnDqp7VZktLvttuvqdhK0nRwzl46aW1e6ZK2y4GhoJ9i8
         KpIxBAdYnb+08xigU5i30VZuFTrxH9hEDGhvwYEsy/vXJ20y3z8qmZGxB570y+8nwDXr
         KqRlvpUxKhal/kP45OJ60gFtDUeeffZe8T1LC5rRY+O2Fx+sJ5NgQqI1K5vhBdjd2A6B
         qJw8QKEDXZMZlFJvt+pc5moGlNUZkY9BSRYZmVwipRgXbnYqLGFJEc+CMn2+gVC3m7gE
         4OfOhMBxuIem8mVWHVp+YR/xI5Pyv3MgEexPFS4XvAKqbFwqVEoJy6zxsM+1KZMJkXNM
         BJVw==
In-Reply-To: <20210209214543.112655-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

On Tue, Feb 9, 2021 at 1:45 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> Page writeback doesn't hold a page reference, which allows truncate to
> free a page the second PageWriteback is cleared. This used to require
> special attention in test_clear_page_writeback(), where we had to be
> careful not to rely on the unstable page->memcg binding and look up
> all the necessary information before clearing the writeback flag.
>
> Since commit 073861ed77b6 ("mm: fix VM_BUG_ON(PageTail) and
> BUG_ON(PageWriteback)") test_clear_page_writeback() is called with an
> explicit reference on the page, and this dance is no longer needed.
>
> Use unlock_page_memcg() and dec_lruvec_page_stat() directly.
>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
