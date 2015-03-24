From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH] mm: Remove usages of ACCESS_ONCE
Date: Tue, 24 Mar 2015 15:42:56 +0100
Message-ID: <551177F0.3070006@de.ibm.com>
References: <1427150680.2515.36.camel@j-VirtualBox>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1427150680.2515.36.camel@j-VirtualBox>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jason Low <jason.low2@hp.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Christoph Lameter <cl@linux.com>, Linus Torvalds <torvalds@linux-foundation.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Aswin Chandramouleeswaran <aswin@hp.com>, Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>, Minchan Kim <minchan@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>, Rik van Riel <riel@redhat.com>

Am 23.03.2015 um 23:44 schrieb Jason Low:
> Commit 38c5ce936a08 converted ACCESS_ONCE usage in gup_pmd_range() to
> READ_ONCE, since ACCESS_ONCE doesn't work reliably on non-scalar types.
> 
> This patch removes the rest of the usages of ACCESS_ONCE, and use
> READ_ONCE for the read accesses. This also makes things cleaner,
> instead of using separate/multiple sets of APIs.
> 
> Signed-off-by: Jason Low <jason.low2@hp.com>

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>

one remark or question:

> -	anon_mapping = (unsigned long) ACCESS_ONCE(page->mapping);
> +	anon_mapping = (unsigned long)READ_ONCE(page->mapping);

Were the white space changes intentional? IIRC checkpatch does prefer
it your way and you have changed several places - so I assume yes.
Either way, its probably fine to change that along.

Christian

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
