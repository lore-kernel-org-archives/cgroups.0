From: Mel Gorman <mgorman@techsingularity.net>
Subject: Re: [PATCH] mm: vmpressure: fix scan window after SWAP_CLUSTER_MAX
 increase
Date: Tue, 20 Oct 2015 08:47:00 +0100
Message-ID: <20151020074700.GB2629@techsingularity.net>
References: <1445278381-21033-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1445278381-21033-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vladimir Davydov <vdavydov@virtuozzo.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Oct 19, 2015 at 02:13:01PM -0400, Johannes Weiner wrote:
> mm-increase-swap_cluster_max-to-batch-tlb-flushes.patch changed
> SWAP_CLUSTER_MAX from 32 pages to 256 pages, inadvertantly switching
> the scan window for vmpressure detection from 2MB to 16MB. Revert.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

This was known at the time but it was not clear what the measurable
impact would be. VM Pressure is odd in that it gives strange results at
times anyway, particularly on NUMA machines. To be honest, it still isn't
clear to me what the impact of the patch is. With different base page sizes
(e.g. on ppc64 with some configs), the window is still large. At the time,
it was left as-is as I could not decide one way or the other but I'm ok
with restoring the behaviour so either way;

Acked-by: Mel Gorman <mgorman@techsingularity.net>

Out of curiosity though, what *is* the user-visible impact of the patch
though? It's different but I'm having trouble deciding if it's better
or worse. I'm curious as to whether the patch is based on a bug report
or intuition.

Thanks.

-- 
Mel Gorman
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
