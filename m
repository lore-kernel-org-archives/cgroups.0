From: Zi Yan <zi.yan-vRdzynncJC4@public.gmane.org>
Subject: [PATCH v2 6/7] mm: truncate: split huge page cache page to a non-zero order if possible.
Date: Tue, 28 Mar 2023 21:17:11 -0400
Message-ID: <20230329011712.3242298-7-zi.yan@sent.com>
References: <20230329011712.3242298-1-zi.yan@sent.com>
Reply-To: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sent.com; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:reply-to:sender:subject:subject:to:to; s=fm2; t=
        1680052659; x=1680139059; bh=n0I3rKbVmW11Ko5MdyrWnLEXy5CTcBBnWUT
        tQZPt4TU=; b=AgPcQhKTNgGR+bE1G8EVwVYSsvXI5KtJXlVvtOKa5ATqXXwCf/6
        lZnsdHkTe/6rQFW7Orubpm/Guh937SkdusjMAmB6zRyoOKVx45v5/LbONp3y30w5
        ACTlWT/JBCu0JoviU/XMSw2gDSJdrc+LCx0AHUFu8XI1JL+7qnT5ZZ1a138JeE3G
        UVuEV5KecJKpzdcyiolNkSaQbkeOxomRSmgEgrOdguQaHmQb/8LXsyXlJNbvpqw+
        tL35C/RdeaPwMIf+hvzaOe1V8EpqdEmYe5Lqov0PZU26M6evaXf7ITBm6LA/K0aS
        WaPN5GGsrzi2rjGf/FG6mATsBsO9d52JvBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
        1680052659; x=1680139059; bh=n0I3rKbVmW11Ko5MdyrWnLEXy5CTcBBnWUT
        tQZPt4TU=; b=Cux0JaYsiE0eu7v9sa4P9tATX0d1RQyZLsw9Wh2WDAUsJtPiv++
        PAVUrKEsXvGON4AD2CEzWW4TGEVMWe3ZUHhG12Z5Kk9TCjUGuPBSFQy1GErCQar1
        oios7zs7juHKmcrWxX2VRwwAT0gv4jzvtEUDi3qNpw2ToejR8e/gU+SVl0ubX91I
        oplO9UOuXcEtu+hR4ynW3B/ecxkKD7myJRBAYAPhPUHwNWxObAF6ueubUcUk4MJg
        R0WcAyp5UHI4076+A6bZLGsA7VBwZN34/DmRBzeYE2wl+rY4hhrveFTmXuU+5nD7
        XBbnJ7s2rT0P1HE54qJ7WScWfZGcrNq9I+A==
In-Reply-To: <20230329011712.3242298-1-zi.yan-vRdzynncJC4@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ryan Roberts <ryan.roberts-5wv7dgnIgG8@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Zach O'Keefe <zokeefe-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>

To minimize the number of pages after a huge page truncation, we do not
need to split it all the way down to order-0. The huge page has at most
three parts, the part before offset, the part to be truncated, the part
remaining at the end. Find the greatest common divisor of them to
calculate the new page order from it, so we can split the huge
page to this order and keep the remaining pages as large and as few as
possible.

Signed-off-by: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
---
 mm/truncate.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index 86de31ed4d32..817efd5e94b4 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -22,6 +22,7 @@
 #include <linux/buffer_head.h>	/* grr. try_to_release_page */
 #include <linux/shmem_fs.h>
 #include <linux/rmap.h>
+#include <linux/gcd.h>
 #include "internal.h"
=20
 /*
@@ -211,7 +212,8 @@ int truncate_inode_folio(struct address_space *mapping,=
 struct folio *folio)
 bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_=
t end)
 {
 	loff_t pos =3D folio_pos(folio);
-	unsigned int offset, length;
+	unsigned int offset, length, remaining;
+	unsigned int new_order =3D folio_order(folio);
=20
 	if (pos < start)
 		offset =3D start - pos;
@@ -222,6 +224,7 @@ bool truncate_inode_partial_folio(struct folio *folio, =
loff_t start, loff_t end)
 		length =3D length - offset;
 	else
 		length =3D end + 1 - pos - offset;
+	remaining =3D folio_size(folio) - offset - length;
=20
 	folio_wait_writeback(folio);
 	if (length =3D=3D folio_size(folio)) {
@@ -236,11 +239,25 @@ bool truncate_inode_partial_folio(struct folio *folio=
, loff_t start, loff_t end)
 	 */
 	folio_zero_range(folio, offset, length);
=20
+	/*
+	 * Use the greatest common divisor of offset, length, and remaining
+	 * as the smallest page size and compute the new order from it. So we
+	 * can truncate a subpage as large as possible. Round up gcd to
+	 * PAGE_SIZE, otherwise ilog2 can give -1 when gcd/PAGE_SIZE is 0.
+	 */
+	new_order =3D ilog2(round_up(gcd(gcd(offset, length), remaining),
+				   PAGE_SIZE) / PAGE_SIZE);
+
+	/* order-1 THP not supported, downgrade to order-0 */
+	if (new_order =3D=3D 1)
+		new_order =3D 0;
+
+
 	if (folio_has_private(folio))
 		folio_invalidate(folio, offset, length);
 	if (!folio_test_large(folio))
 		return true;
-	if (split_folio(folio) =3D=3D 0)
+	if (split_huge_page_to_list_to_order(&folio->page, NULL, new_order) =3D=
=3D 0)
 		return true;
 	if (folio_test_dirty(folio))
 		return false;
--=20
2.39.2

