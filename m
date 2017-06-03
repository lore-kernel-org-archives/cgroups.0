From: Vladimir Davydov <vdavydov.dev@gmail.com>
Subject: Re: [PATCH 6/6] mm: memcontrol: account slab stats per lruvec
Date: Sat, 3 Jun 2017 20:54:10 +0300
Message-ID: <20170603175410.GF15130@esperanza>
References: <20170530181724.27197-1-hannes@cmpxchg.org>
 <20170530181724.27197-7-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fSC0IuiSnxXQ5VAs+JiNoJEOtgL92rQxpEDXaqa2/rM=;
        b=s1elld+8ymHSbJENabTnmO+gS3cZzTFhfm3aAAvE0KOIzqTxBXwjjAaSZS8DUAgwew
         X0QCGEfdzpkUPLHBQlynrc5UKBqw6AzN6Rwg6Glw/jbb+gRMnLU7tDSvpB628ncSp6Tt
         kBAzhAzOKgDtoZz6m82lmje4YMqO+7fobVhcRjzN99h6vQgonHINmsO4nTSo9WBi8DuY
         /Gfg6OB4XTgSQDe729P8SjNm4geqFTtnRrGAMkVK1t7pttNSEMp01dSZVrYw7RR9fWyv
         i9+Y09KDrvT5yEox/d7wrr8glkZLNSJzV3/QDdSGHFfG1KYcqo1DkOWPlcAVG8JfAiU3
         jyOQ==
Content-Disposition: inline
In-Reply-To: <20170530181724.27197-7-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, May 30, 2017 at 02:17:24PM -0400, Johannes Weiner wrote:
> Josef's redesign of the balancing between slab caches and the page
> cache requires slab cache statistics at the lruvec level.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/slab.c | 12 ++++--------
>  mm/slab.h | 18 +-----------------
>  mm/slub.c |  4 ++--
>  3 files changed, 7 insertions(+), 27 deletions(-)

Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
