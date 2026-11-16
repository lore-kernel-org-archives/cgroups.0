Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794827023;
	b=I00KBdgLL/wotjc9d1mQbR4Ag5v4uaaSC1EOAXtCV+xE2Y2yI/a8lm91DtiITApAlmnK
	 B+ed9DL+c0w1YfUEiKpuuMz3zUlonczPNPlET5nkFvu2ENfEinMo0e6amIAl6ijlkSDdU
	 fZ12BEoGYiCr3q6NOJagS6BytjjccCk2nuDNYg8kcrvNpkb0Zgg1l9XI7ytt77ylhBOkx
	 ilUhCJ6XuI9eYJmRlqPnby0zrIkkrg9l+9TMKxj4oER/mTKQD01D89xYvcbu6nt2lcwWN
	 fHFPYP1jhR4iLQqUADT+aCPKdXRyXfTYk0xgO+4vvdbClpDrO+sWJ238YBVhrnfM6jQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794827023;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PH/J5T/Zisv/IuxWjVJ1q31kRUwi5lZVkNYG9k7l4V4=;
	b=TZXJN4qyl+ZLAP8soKwZQyjFXoEkr1nTQL4RdhzLgMazdRNaMuNyTEaPGIXhT+L040QL
	 IQVa1R3y7PKvQIsGN7ZMkqtUmD/tJrekUXG4jUeB/1sA9XQupY0BFgZ7evyyZSJRovKlx
	 LdlPyhNtvquXTvevxfhkMlgkEhlancq2AJ5FW7S2iNZVR3S0rsO4ORlYChKjbfUvi/Btf
	 98N6qqY56pWKA3UKIMc534cpjd7HH9wSeSQaXlQloqqOxA0FPV03R6/iz7WeEz/RZ7rxT
	 tEyODyYugY/ABhDiBgZ4T9GqAy/YA5MiS9HDV4nj8VCpM0S3LAaH5HvoduhcjR5Qn0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WzLlwiXw;
	arc=none smtp.remote-ip=74.125.82.45
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F349A606A32C
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 11:03:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F349A606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WzLlwiXw
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-1b3acec6677so4476210c88.1
        for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 03:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794827022; x=1795431822; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PH/J5T/Zisv/IuxWjVJ1q31kRUwi5lZVkNYG9k7l4V4=;
        b=WzLlwiXwSJesxpDgNP8GiSABYjAz/kkKupDW+ww5fs0Tfftvggo1yPlFTj+IeF2j78
         +zSSw0/n7Q5vECREW4KYJL4gELfTzjBghQneUHjgIV4JuDxJMfjhVaSqaKYLveyGsFH1
         GPnokFormyFyrcw2I5u8+VuST9CnJOyy0QQzMc3etrac6jpwzxzl4/h5AMKjSbZWT9Yj
         UytOijH5RgUSwkIsBrQR0MtGx4gCNgSZkWDPcHKns+NLbY7SShm4z4jmHxb5j2kvGP1a
         5eAOaQHB/nI4k9XkEGpoJlDTysxK7AFrIRgziDFW2NEMuZYwJWp+h3BQKHvr8vA2ZfXi
         hQ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794827022; x=1795431822;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PH/J5T/Zisv/IuxWjVJ1q31kRUwi5lZVkNYG9k7l4V4=;
        b=xh8WmLUgC2N2OKJiCxTsN/zHmaZ/flIFoAodN5bJXrLtM03oLFguyrCVxFm3VjR1VA
         8aT3wsIENuwjpTxWRK+s1tBr2Nd5MEdRq7fffEStcSyUchdTm5iAti8Yx16Xdqox90sB
         AbLD1cenAO70dNFLWY9F7HPa7soCWzNwIPkbr7HZ2XQ8cLnqu3CUQHc4rRTi+bS5LPMY
         zgUjP7Zzw1Tvg9gNfcwKiaPi3dZRl3mNCIYB58JpSscLVgoyT94M/6FPE0Ne9bH0/rJC
         bsVOkh/+1YYkXTkZJVT1Y7Oe+lrx7f/Fpx4M9h3kJk79oR4DPg3irpQU45G0taZUiQv1
         /qYA==
X-Forwarded-Encrypted: i=1; AL+hErGZ9r6rajZI3dhc0lWYtdFZ1eI9VjQSy8Lp/yscWOcnbtboOlmdllErXZIOH3FpHqxsdNFjWJf5@vger.kernel.org
X-Gm-Message-State: APuU4Z9brTwrdeEPYlIlgFXF3hmVGQ31Jl0GpcabDmhpLVgWgEfAw6jL
	OHbRXHX1nua7U3OpLq28vhI2lkcsms9rOHMhjFYAjqhrWeagKGraXWLR
X-Gm-Gg: AYBFou3nUi/GW3vT7FG/6R1h2Dw1jw9B/7bx5l82a3GAl+xT9VXjZvpqkGlqsOT8W1q
	LvcUHWeyuuHJ7duyF10mL2pqNlvds1hJA1n4VyBAvhflKkoTB0nEWUWiCfVBGbT6YWDVru/UTQf
	YMPHJR7I1cWpTCsugheXCHdMGJF+h4oN+n7Q0VOlfySoG0DHThYlGVhquxoJhWnJjq7a3gYSQCT
	/MWqFe5amBIGWQGheHJE+nVkuHEeUXh3y2RISXvYGrouCJ8y+scugvm6dO8MJdGA2SA1nGFEltl
	FtkRue9Zqoyf06FXf5GJGWa5P221AshOStbOpws3xUpke8rXofp4xnAMIQ8ufa3ypk7e0fXavI2
	N8Z5ibu5y0qep+7xT5qj26GPf0CaZakDog2fWevZ5rh+KWGRhjiATA7DNutUhx3eEYGjQSMC7Om
	oOyaco3f9JjGucZ66QDjIwYoAYGzrmpI2oO1a+HZHUgoMJo4kvPvKS5AjHMt1RrzlOijMJwdcqF
	1pHqm4H/Nnp/Zgqw62BSVpxEZ/QB83CEduSXSz369CtEmsEuUNvlR50LY1rysK4T3Vugkeo9OWX
	aAH0P8lUt6EcaxJMyTgDgWNLEMtHa7rQqMkh0XoAraRL2B1J5KDS2A48WXHT6gOhhsxM
X-Received: by 2002:a05:701b:271c:b0:1b2:43b0:4794 with SMTP id a92af1059eb24-1b5030d4941mr7826513c88.9.1794827021837;
        Mon, 16 Nov 2026 03:03:41 -0800 (PST)
Received: from naki-PC.localdomain ([203.175.14.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031918c7sm42999260c88.9.2026.11.16.03.03.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 03:03:41 -0800 (PST)
From: nakixii <nakixii@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Barry Song <baohua@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: [RFC PATCH 01/16] mm: userfaultfd: check the exclusivity of the page being moved
Date: Mon, 16 Nov 2026 19:01:07 +0800
Message-ID: <20261116110122.309748-2-nakixii@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116110122.309748-1-nakixii@gmail.com>
References: <20261116110122.309748-1-nakixii@gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

UFFDIO_MOVE checks PageAnonExclusive on the first page of the source
folio even when the source PTE maps another page of that folio. This can
reject a move whose mapped page is still exclusive.

try_to_unmap_one() can replace earlier pages with swap entries before
folio_try_share_anon_rmap_pte() refuses a later page, for example
because of a concurrent GUP-fast pin. The first page can then lose its
exclusive flag while a later mapped page remains exclusive. Checking the
first page incorrectly returns -EBUSY for a move of that later page.

Look up the page mapped by the source PTE, check that page's exclusive
flag and derive the folio from it. Preserve the existing folio locking,
reference counting and split handling. This applies to ordinary swap
unmapping without requiring an additional page-storage backend.

Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")

Signed-off-by: nakixii <nakixii@gmail.com>
---
 mm/userfaultfd.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 080a00d916f6b696ef326b6e76e205970a94fa8b..d8a699981d097ae393a981a33cede5f5ce6e2725 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1225,6 +1225,7 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 		 */
 		if (!src_folio) {
 			struct folio *folio;
+			struct page *page;
 			bool locked;
 
 			/*
@@ -1238,8 +1239,20 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 				goto out;
 			}
 
-			folio = vm_normal_folio(src_vma, src_addr, orig_src_pte);
-			if (!folio || !PageAnonExclusive(&folio->page)) {
+			/*
+			 * Check the page to be moved, not the first of its
+			 * folio.  try_to_unmap() unshares a large folio page
+			 * by page into swap entries, so while
+			 * reclaim holds it, or after reclaim gave up partway,
+			 * the first page can have lost its exclusive flag
+			 * when this one has not.  While reclaim still holds
+			 * the folio, the trylock below sends a large one back
+			 * with -EAGAIN; once the folio is split they are the
+			 * same.
+			 */
+			page = vm_normal_page(src_vma, src_addr, orig_src_pte);
+			folio = page ? page_folio(page) : NULL;
+			if (!folio || !PageAnonExclusive(page)) {
 				spin_unlock(src_ptl);
 				err = -EBUSY;
 				goto out;
