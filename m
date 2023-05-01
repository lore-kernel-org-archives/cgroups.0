From: Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH 38/40] codetag: debug: mark codetags for reserved pages as empty
Date: Mon,  1 May 2023 09:54:48 -0700
Message-ID: <20230501165450.15352-39-surenb@google.com>
References: <20230501165450.15352-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682960195; x=1685552195;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uHz3gIMQ14LMAlJH3BHlupoStZ8/+BrUL09pT+1nDVs=;
        b=cL9ulyr1TZmloHcY9ZAQt2916/Hy8kFnLfCTiFsQOyXG21mKZDk2kVsVGS3swW/o9A
         lmsPI4V+ni8bJ2cDmSOvMhTe7jiZncm+a+dX+h32N0c6xUNbGxEO59xGx2raskwk+yE+
         EY40N2q/B5lxnqf+wqKkKUxKcIxmFMWDeQ/MPMZ5UoklVL3SBusyJB6cuGrGjrAev2jt
         I6daIpOCKx+oNZEO+zjvrtYAnmo4PPKmPdsrXndRo+l1Ieu4A+pt+fjUYtVugs+1Ncqh
         keNiqCygIJKFaCxV1denDbSpt/uk9T3I2i0PdEP0vYROV8UgAo/d+Ogm15HjT6dg+WeL
         DFBQ==
In-Reply-To: <20230501165450.15352-1-surenb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, mhocko@suse.com, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hughd@google.com, andreyknvl@gmail.com, keescook@chromium.org

To avoid debug warnings while freeing reserved pages which were not
allocated with usual allocators, mark their codetags as empty before
freeing.
Maybe we can annotate reserved pages correctly and avoid this?

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 include/linux/mm.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 27ce77080c79..f5969cb85879 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5,6 +5,7 @@
 #include <linux/errno.h>
 #include <linux/mmdebug.h>
 #include <linux/gfp.h>
+#include <linux/pgalloc_tag.h>
 #include <linux/bug.h>
 #include <linux/list.h>
 #include <linux/mmzone.h>
@@ -2920,6 +2921,13 @@ extern void reserve_bootmem_region(phys_addr_t start, phys_addr_t end);
 /* Free the reserved page into the buddy system, so it gets managed. */
 static inline void free_reserved_page(struct page *page)
 {
+	union codetag_ref *ref;
+
+	ref = get_page_tag_ref(page);
+	if (ref) {
+		set_codetag_empty(ref);
+		put_page_tag_ref(ref);
+	}
 	ClearPageReserved(page);
 	init_page_count(page);
 	__free_page(page);
-- 
2.40.1.495.gc816e09b53d-goog

