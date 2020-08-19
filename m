From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 1/8] mm: Factor find_get_swap_page out of
 mincore_page
Date: Wed, 19 Aug 2020 20:21:09 +0100
Message-ID: <20200819192109.GI17456@casper.infradead.org>
References: <20200819184850.24779-1-willy@infradead.org>
 <20200819184850.24779-2-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=KY/ct6DqDgE0xj6ePem8K1ZoSkwZfEz10n8fdqExt64=; b=ZjgtOAiMlD359oZ7PFqMt7m/N/
 HsV4xtxiFIMnMzoxngiRO9ToNhKnv+UqlargZIB9w8jJqXk/dqR9dfqj4tNwNFP5CTQkepb8vQLYd
 N6edGz+ukH9jxmgqOu+htrf4lkXBUtKapGiqzye8JfwY6EW+FDYiOi0ZBCowk7p28IJHqU2YdYM9Z
 N8xN1Pxiw6OAKzEqtWpYx9FTR1tDWShrK0WIO7VUupr7ifwcRs75x6fTzuXimm3s/Gh+R3mKKNZwL
 JXxo/oXSSodiI2qvrWAzPpqT89upwfqcvAYv1QajyLDfP9rE7MFO+DAyBvBsaEz4zb53yYXFjw6z3
 V7MxvCGw==;
Content-Disposition: inline
In-Reply-To: <20200819184850.24779-2-willy@infradead.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: linux-mm@kvack.org
Cc: intel-gfx@lists.freedesktop.org, Huang Ying <ying.huang@intel.com>, Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>, William Kucharski <william.kucharski@oracle.com>, Matthew Auld <matthew.auld@intel.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Alexey Dobriyan <adobriyan@gmail.com>

On Wed, Aug 19, 2020 at 07:48:43PM +0100, Matthew Wilcox (Oracle) wrote:
> Provide this functionality from the swap cache.  It's useful for
> more than just mincore().

The build bot showed I was missing this for some configs:

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 986b4e3d3bad..92a1f40be589 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -21,6 +21,7 @@
 #include <linux/vmalloc.h>
 #include <linux/swap_slots.h>
 #include <linux/huge_mm.h>
+#include <linux/shmem_fs.h>
 #include "internal.h"
 
 /*

I'll wait for more feedback before reposting the series in ~24 hours.
