From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH] mm: Remove usages of ACCESS_ONCE
Date: Tue, 24 Mar 2015 07:32:23 -0700
Message-ID: <1427207543.2412.14.camel@stgolabs.net>
References: <1427150680.2515.36.camel@j-VirtualBox>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1427150680.2515.36.camel@j-VirtualBox>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jason Low <jason.low2@hp.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Christoph Lameter <cl@linux.com>, Linus Torvalds <torvalds@linux-foundation.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Aswin Chandramouleeswaran <aswin@hp.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>, Minchan Kim <minchan@kernel.org>, Rik van Riel <riel@redhat.com>

On Mon, 2015-03-23 at 15:44 -0700, Jason Low wrote:
> Commit 38c5ce936a08 converted ACCESS_ONCE usage in gup_pmd_range() to
> READ_ONCE, since ACCESS_ONCE doesn't work reliably on non-scalar types.
> 
> This patch removes the rest of the usages of ACCESS_ONCE, and use
> READ_ONCE for the read accesses. This also makes things cleaner,
> instead of using separate/multiple sets of APIs.
> 
> Signed-off-by: Jason Low <jason.low2@hp.com>

Acked-by: Davidlohr Bueso <dave@stgolabs.net>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
