From: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] mm: Remove usages of ACCESS_ONCE
Date: Tue, 24 Mar 2015 10:39:55 -0400
Message-ID: <5511773B.6020103@redhat.com>
References: <1427150680.2515.36.camel@j-VirtualBox>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1427150680.2515.36.camel@j-VirtualBox>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jason Low <jason.low2@hp.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Christoph Lameter <cl@linux.com>, Linus Torvalds <torvalds@linux-foundation.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Aswin Chandramouleeswaran <aswin@hp.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>, Minchan Kim <minchan@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>

On 03/23/2015 06:44 PM, Jason Low wrote:
> Commit 38c5ce936a08 converted ACCESS_ONCE usage in gup_pmd_range() to
> READ_ONCE, since ACCESS_ONCE doesn't work reliably on non-scalar types.
> 
> This patch removes the rest of the usages of ACCESS_ONCE, and use
> READ_ONCE for the read accesses. This also makes things cleaner,
> instead of using separate/multiple sets of APIs.
> 
> Signed-off-by: Jason Low <jason.low2@hp.com>

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
