From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 4/8] proc: Optimise smaps for shmem entries
Date: Wed, 19 Aug 2020 19:48:46 +0100
Message-ID: <20200819184850.24779-5-willy@infradead.org>
References: <20200819184850.24779-1-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=6FEH2RzEKpeGkw1ry8PIMFPV7YWAJWwmC36GZdEh8I8=; b=mpxwSwSBY6UqYCwG+sE65V35BB
 J8yzFZhDe0QRMl1ZP/nlpb2+WKDQLYNkDnz76pIkiUTqTr189msFIwBJ8Mr8+Fb5eKxFjMBlC264q
 MFMM2mcRXQAZBJw4EqOpTiDhiJTFSkQjlg6ucjHSbR1dPWYPrVqiLTTEa+IgaEziprwqMjqE/2vJN
 8HJKcVy+CFy9D2tDrJzoPrvYKkIeAngzZupTTfRif0cbwdr6/FFFFOSjbC7q0zK/5WOG5hKulHIBH
 VFCsPpPgHZOLoqSynTDkWtpsghEfDw6rADRHNjdQRwN5rhOkDtE0OXzWVqUtA/fsw+CJSKW2WX9+8
 OaTNPKkg==;
In-Reply-To: <20200819184850.24779-1-willy@infradead.org>
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
Cc: intel-gfx@lists.freedesktop.org, Huang Ying <ying.huang@intel.com>, Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>, William Kucharski <william.kucharski@oracle.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Alexey Dobriyan <adobriyan@gmail.com>, Matthew Auld <matthew.auld@intel.com>

Avoid bumping the refcount on pages when we're only interested in the
swap entries.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/proc/task_mmu.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 5066b0251ed8..e42d9e5e9a3c 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -520,16 +520,10 @@ static void smaps_pte_entry(pte_t *pte, unsigned long addr,
 			page = device_private_entry_to_page(swpent);
 	} else if (unlikely(IS_ENABLED(CONFIG_SHMEM) && mss->check_shmem_swap
 							&& pte_none(*pte))) {
-		page = find_get_entry(vma->vm_file->f_mapping,
+		page = xa_load(&vma->vm_file->f_mapping->i_pages,
 						linear_page_index(vma, addr));
-		if (!page)
-			return;
-
 		if (xa_is_value(page))
 			mss->swap += PAGE_SIZE;
-		else
-			put_page(page);
-
 		return;
 	}
 
-- 
2.28.0
