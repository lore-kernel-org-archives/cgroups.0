From: Zi Yan <zi.yan@sent.com>
Subject: [PATCH v3 2/7] mm/page_owner: use order instead of nr in split_page_owner()
Date: Mon,  3 Apr 2023 16:18:34 -0400
Message-ID: <20230403201839.4097845-3-zi.yan@sent.com>
References: <20230403201839.4097845-1-zi.yan@sent.com>
Reply-To: Zi Yan <ziy@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sent.com; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:reply-to:sender:subject:subject:to:to; s=fm2; t=
        1680553144; x=1680639544; bh=0+1ccQx8AuLgSqfkQ9qAEQMi/lCcYIby1X8
        SrOj7vms=; b=KUwl7e1aBsGFQzG5D0syDzxeWbJ3GF3fvksO8O/36dURW8FqYMv
        SZmNQeib2JGKzildDgbeERIuwZu+26p3d5QGEMmQLqnbTgdbRtGECgXXZ4R1y4f7
        G5LavpoRwEp5Me3Ov0l6eM6zMpcRj5OTFUUuG1A5NHmVuQTS5Vh3PMSSsYLusCMa
        9xLD7t4TNL+IZBKoI7BB+cqubyRv/opGyrQyeYTx2n5SDve5SCbWTHgi1ATf5h5E
        LFRzjk+tkSmVdnujGmCNvrqKW/XYpCWCWWMTFXZe9Py4pgqZ97R8zFuxL0GF5AxG
        gQVRC/CejfgmQW8A1yjsYXroTbXvrNSnHqQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
        1680553144; x=1680639544; bh=0+1ccQx8AuLgSqfkQ9qAEQMi/lCcYIby1X8
        SrOj7vms=; b=H1/eBrevt0g1ytaLRjDooVqSD9DjKANjiNur8QMCYBINWoRKxAM
        wav5DMHaX3kn6pl8Xh3A9XcfMNeATpKNRSU4Llq+Fm1pC+f0IT2AMLvBUO3/jkYD
        KcILNwTsTu0YBLszjyQhHNAb8XNM0C0vWoAdo6PBjz+PT1qwwJlzRAkN9LeiRtaC
        fKd5PlLQI14MgXjnnRGBUiRWTKUgaGGd7k/3QwPxo5fZcDb/fBEy7Cuz6lcSrRg2
        Ac3xfSiB5kDm6eQrFul6iQyFkISdftmQfbhidUFwBtoLvV0pdTvnq3BaDJdMhhyk
        dTqdvWK7XYpUy7rnUlvCLDgjwlyVC/tT3CQ==
In-Reply-To: <20230403201839.4097845-1-zi.yan@sent.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Yang Shi <shy828301@gmail.com>, Yu Zhao <yuzhao@google.com>, linux-mm@kvack.org
Cc: Zi Yan <ziy@nvidia.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Ryan Roberts <ryan.roberts@arm.com>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, Zach O'Keefe <zokeefe@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org

From: Zi Yan <ziy@nvidia.com>

We do not have non power of two pages, using nr is error prone if nr
is not power-of-two. Use page order instead.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 include/linux/page_owner.h | 8 ++++----
 mm/huge_memory.c           | 2 +-
 mm/page_alloc.c            | 4 ++--
 mm/page_owner.c            | 3 ++-
 4 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/linux/page_owner.h b/include/linux/page_owner.h
index 119a0c9d2a8b..d7878523adfc 100644
--- a/include/linux/page_owner.h
+++ b/include/linux/page_owner.h
@@ -11,7 +11,7 @@ extern struct page_ext_operations page_owner_ops;
 extern void __reset_page_owner(struct page *page, unsigned short order);
 extern void __set_page_owner(struct page *page,
 			unsigned short order, gfp_t gfp_mask);
-extern void __split_page_owner(struct page *page, unsigned int nr);
+extern void __split_page_owner(struct page *page, int order);
 extern void __folio_copy_owner(struct folio *newfolio, struct folio *old);
 extern void __set_page_owner_migrate_reason(struct page *page, int reason);
 extern void __dump_page_owner(const struct page *page);
@@ -31,10 +31,10 @@ static inline void set_page_owner(struct page *page,
 		__set_page_owner(page, order, gfp_mask);
 }
=20
-static inline void split_page_owner(struct page *page, unsigned int nr)
+static inline void split_page_owner(struct page *page, int order)
 {
 	if (static_branch_unlikely(&page_owner_inited))
-		__split_page_owner(page, nr);
+		__split_page_owner(page, order);
 }
 static inline void folio_copy_owner(struct folio *newfolio, struct folio *=
old)
 {
@@ -60,7 +60,7 @@ static inline void set_page_owner(struct page *page,
 {
 }
 static inline void split_page_owner(struct page *page,
-			unsigned short order)
+			int order)
 {
 }
 static inline void folio_copy_owner(struct folio *newfolio, struct folio *=
folio)
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 3bb003eb80a3..a21921c90b21 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2557,7 +2557,7 @@ static void __split_huge_page(struct page *page, stru=
ct list_head *list,
 	unlock_page_lruvec(lruvec);
 	/* Caller disabled irqs, so they are still disabled here */
=20
-	split_page_owner(head, nr);
+	split_page_owner(head, order);
=20
 	/* See comment in __split_huge_page_tail() */
 	if (PageAnon(head)) {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d84b121d1e03..d537828bc4be 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2780,7 +2780,7 @@ void split_page(struct page *page, unsigned int order)
=20
 	for (i =3D 1; i < (1 << order); i++)
 		set_page_refcounted(page + i);
-	split_page_owner(page, 1 << order);
+	split_page_owner(page, order);
 	split_page_memcg(page, order);
 }
 EXPORT_SYMBOL_GPL(split_page);
@@ -4996,7 +4996,7 @@ static void *make_alloc_exact(unsigned long addr, uns=
igned int order,
 		struct page *page =3D virt_to_page((void *)addr);
 		struct page *last =3D page + nr;
=20
-		split_page_owner(page, 1 << order);
+		split_page_owner(page, order);
 		split_page_memcg(page, order);
 		while (page < --last)
 			set_page_refcounted(last);
diff --git a/mm/page_owner.c b/mm/page_owner.c
index 31169b3e7f06..64233b5b09d5 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -211,11 +211,12 @@ void __set_page_owner_migrate_reason(struct page *pag=
e, int reason)
 	page_ext_put(page_ext);
 }
=20
-void __split_page_owner(struct page *page, unsigned int nr)
+void __split_page_owner(struct page *page, int order)
 {
 	int i;
 	struct page_ext *page_ext =3D page_ext_get(page);
 	struct page_owner *page_owner;
+	unsigned int nr =3D 1 << order;
=20
 	if (unlikely(!page_ext))
 		return;
--=20
2.39.2

