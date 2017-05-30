From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/6] mm: vmscan: delete unused pgdat_reclaimable_pages()
Date: Tue, 30 May 2017 18:02:38 -0400
Message-ID: <20170530220238.GA7731@cmpxchg.org>
References: <20170530181724.27197-1-hannes@cmpxchg.org>
 <20170530181724.27197-2-hannes@cmpxchg.org>
 <20170530145029.59cef9048c3c254c9357eff1@linux-foundation.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3xn4KcEW9fAuciTW+0O7iULysRAtJ0LaG7+qjkAEpP0=; b=Gunj2S9WM05RdM6S8rCQ4hExUZ
	0RtnudV+asrX2KOEb63Vs05S26Y649PMFieul189s4vfE6o7era9J6tHgGaxA5qCayK69v1Yzrx9o
	BDMVcCRuLgQGxIcZTU+2dO5AtDU79GmrJE8qnP8mM3SNJKX/XjMcFOzhd1dEbrN03OeI=;
Content-Disposition: inline
In-Reply-To: <20170530145029.59cef9048c3c254c9357eff1@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Josef Bacik <josef@toxicpanda.com>, Michal Hocko <mhocko@suse.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Rik van Riel <riel@redhat.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, May 30, 2017 at 02:50:29PM -0700, Andrew Morton wrote:
> On Tue, 30 May 2017 14:17:19 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > -extern unsigned long pgdat_reclaimable_pages(struct pglist_data *pgdat);
> 
> Josef's "mm: make kswapd try harder to keep active pages in cache"
> added a new callsite.

Ah yes, I forgot you pulled that in. The next version of his patch
shouldn't need it anymore.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
