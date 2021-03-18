From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] memcg: set page->private before calling swap_readpage
Date: Wed, 17 Mar 2021 18:59:59 -0700
Message-ID: <20210318015959.2986837-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=v1M50zVO+qfyX8hHQPyP5qHNesgD9s9P1xyKpHxr+O4=;
        b=cbLMc8ExTKSMcFjJxmr7HW9m23mlVR3fNMnWGPh4+DjYZqiKhZUFQ4qcdVtPpzE/aA
         8mzuAfy1Q0Y7qSpp/xGenI6FdRQWsuCmLqLHAF1mcTH7SZsy6c4b5+2jf6nJ4d07Cbfq
         4v4LbsEel7zJtXZb2uQdbeUh1djn/FduBWLT8vHUZCzCeLdMhqzuFMfuR2MJROscijad
         cQ4Qt4Yu9kV7InlNKAAj+USa8pz9YiawXTdgmUDfXxvo13msqrp/Tk04Bqk0ldaoqsYw
         v7/o8ImE6egm/TTuhWC01bt5tIoIsowp7eUL6ELQhTEBEGO3lNsPjtUir0f1vCIdlEHf
         AvDQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>

The function swap_readpage() (and other functions it call) extracts swap
entry from page->private. However for SWP_SYNCHRONOUS_IO, the kernel
skips the swapcache and thus we need to manually set the page->private
with the swap entry before calling swap_readpage().

Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Reported-by: Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
---

Andrew, please squash this into "memcg: charge before adding to
swapcache on swapin" patch.

 mm/memory.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index aefd158ae1ea..b6f3410b5902 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3324,7 +3324,11 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 					workingset_refault(page, shadow);
 
 				lru_cache_add(page);
+
+				/* To provide entry to swap_readpage() */
+				set_page_private(page, entry.val);
 				swap_readpage(page, true);
+				set_page_private(page, 0);
 			}
 		} else {
 			page = swapin_readahead(entry, GFP_HIGHUSER_MOVABLE,
-- 
2.31.0.rc2.261.g7f71774620-goog

