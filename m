Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793945151;
	b=ebHufbORolCLqAhiLoZqubuL57bEZcxKEb7Jw6RyqAzq6yuJVCc3TokXN4iZ1vfMKD+h
	 du+H2ahkjjZIODHgJAchuLbVhdvw4stLxM1X/f/7AnfGypf2kRc7xGHepR/txmia+P1HX
	 0BakCTzd5+nhGHlBNqmI8Po98XKf6GoIcYZq9HnXHT86gM3O06yJIVpP/W+L2FHr17B8W
	 ebcpvggiOJ/pH1ITkwnQRhJVIbWfPINbXDl1ipb2mBuAXzg9yEMszbKO1X+jT7TRHKBe/
	 zjRYXesYlDkNvqIv1YUlT163meM6lnqUXXwjE03v719hHL45q4yoWNSoi9AbEIMsv4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793945151;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=QYzpgT5zWntgfM1mnEHxsXKCCGNOpHFfMxgWgIGdnmY=;
	b=pSaKXVIg6WpAtTzFD8xVBIwlszecoFEEzlz39BINfQRPkfUhZooJrpqshSt1sI1Tan2u
	 xCAaVEYGYVefetJEHNzDsaMDr8kdpNN35cUqa2EtOZjCY8GaxE7TppL4ytNrSnd5LM7M2
	 /ugfmGxskxCzMoeSKrPrZL+GdZnZrjWwdhHj/CwGNmCs14BO3oX7gKnSflKAvBjpHSSCG
	 8kVyVk8WougRzNr+OxW9Ajxx7ly1wzSyL67wfCVNsXZTECV8SGZd5zQwPF88phQAMSFnR
	 hwogYKn8VZF+m8mZa0OyYbxr73Z/+g/3V3DBbYf3o8LzanHYRdM+FXhkA7OziJeCVrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UitchYbS;
	arc=none smtp.remote-ip=209.85.215.181
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830C2606A329
	for <cgroups@vger.kernel.org>; Fri,  6 Nov 2026 06:05:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 830C2606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UitchYbS
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cc4be0e5351so100859a12.0
        for <cgroups@vger.kernel.org>; Thu, 05 Nov 2026 22:05:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793945150; x=1794549950; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QYzpgT5zWntgfM1mnEHxsXKCCGNOpHFfMxgWgIGdnmY=;
        b=UitchYbS6lfBJSDhPoHzzUIm8XiykMpS6zDi9o+dMNbpgt5926amZaAMpeFhdg2PFD
         Lm3hHkq8Th4Swk9bv78b04vYgmc0bdIcbQ62YAqrEo1Gm/mbjVsr1AoQfLZiG18R6uWl
         t+2fFaaTHNleC7ZcuWwE2+0+tglJzEL1q5sxYCl16O10mxeaGew2n25PT/VkLLHJmHcs
         i9VtEEzuUZmJwyAtRLpdfyUHX6veDO67r6HqSKfxuQiY0oQlXJdpBtRzVlVJc3g5JoP3
         LoB1LzBjEhaecbDDxmELnEnfw2TLFFRTiR2Fh9PN9sJE9ZneWDVC+GAO4VfU7YpQ05es
         Blfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793945150; x=1794549950;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QYzpgT5zWntgfM1mnEHxsXKCCGNOpHFfMxgWgIGdnmY=;
        b=UUnhnVKRzphYYSWwXXqP+Oi6Dqom9zZ7PjRHmPkzx9eB5km3PpGip7iSERqInWj3qX
         94wi34zI6yDFIcXJzXh6OWyURYSOAKyO49IK3yL9fx8KXzo89dM7qH/zstluGsMEgway
         7m4NxcTdpLNGO5A94B1/JUTdgWJ4/tyfXeYLV6y0onUo2i1+wPmiyD3PWN5RpU2/YypF
         QFL5abSQyY1Qe8zKueRNke6pyH3Q62F5alAt6TgGU+Q344xO/rHOFpt9wcwCbF8SviRu
         dJIo3USqcSH5cy0Q34ScuT21UHEdV6PwC+Eg4I68lny5aOx0k1FmacFUNhQqDQVj1GcR
         ++kQ==
X-Forwarded-Encrypted: i=1; AKwUvBzH4Q09Kfq1pArtEarfIhysXs9XckzNpjvQPyyAROLA7N7WEhko7kpeRoNOFaPVuRkvjj9fuIm2@vger.kernel.org
X-Gm-Message-State: APuU4Z9BI7nK87o8cxYsNeVxwB69OE42sYb/j0D5npaGv7dSX7HvXfTY
	CnotAnB9hHOugyF9aEPUCMCAzKyGx2x5bjHhdFHYEdFPiqwXGqq404vT
X-Gm-Gg: AYBFou3kzzuWJe8+aHmXtvP8vsTWzgoLdr09wZRUFl7y7jf5eTz0+0RGvZQPm1p8sUC
	mucp/yDsZNiA0ejqOnc153AbEoP+c06+opO0K3+3Jzq7eDzVDFZ1TqiqmOfsFpQpW3ihhcREfta
	hpxR9fAW79y5oKb7675zFrj2P2fYQJvFCjFbwkf9Q0Py56akDmnm1yUXe3wjOfeWuZESS/VbERM
	jaR07rTw5Sc/s4Vk4bY/7kfs/c+fqWgQwpp5IrZaAnWoFEqFaX0TfTrOVSPkHdUbpH/fhf1WNGv
	qqnLwzqMMInZ0Xi4vmrrY8P4DU2lG7AC1OkAWZUbp6nKMJePmWFbExKB7S3Yqdy2uC7XlCBSDi4
	L4cKiIUdmTsFs1aBKeJJ+LCE0AllQQ1DCPtMgFR8vFOiCMQYad9nWMm0uFmi2tnXVLj5S47HcqY
	FxAHTfcLehY/jgAbbK0nMxk2N6awfSn8/qUbRkOx+IZdY8yglCJy73souYyK2xKkyNxurrNdC4D
	DwLAxSKZ4R8+3rwrTrpipzHEaPFOHLC+f+3tBcyt1ks3TKoOgkm+nai/TfofozkM1BnZwrCmNf5
	3sFNVdvPz2iZEkM7fxWMgAPyRvuS6lZKaM0QozQsMg==
X-Received: by 2002:a05:6a20:9e97:b0:3eb:ace1:4b4a with SMTP id adf61e73a8af0-3ebb2addc3cmr1804269637.71.1793945149791;
        Thu, 05 Nov 2026 22:05:49 -0800 (PST)
Received: from ancienth-X870E-Nova-WiFi ([125.186.72.2])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdb70661c74sm241209a12.10.2026.11.05.22.05.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 22:05:49 -0800 (PST)
From: Daehyeon Ko <4ncienth@gmail.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org
Cc: david@kernel.org,
	tj@kernel.org,
	hongfu.li@linux.dev,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	4ncienth@gmail.com
Subject: [PATCH v2 RESEND] mm/hugetlb_cgroup: prevent use-after-free during cgroup offlining
Date: Fri,  6 Nov 2026 15:03:47 +0900
Message-ID: <20261106060347.637480-1-4ncienth@gmail.com>
X-Mailer: git-send-email 2.55.0
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

A normal hugetlb charge obtains the current task's hugetlb cgroup with
css_tryget(), charges its page counter, and drops the CSS reference before
the folio is committed under hugetlb_lock.

The task can be migrated while the allocation is in progress.  If the old
CSS is then offlined, its final active-folio scan can finish before the
charge becomes visible.  The allocation can subsequently charge that dying
CSS and commit its pointer to the folio.  Once the CSS is freed, uncharging
the folio accesses the freed hugetlb_cgroup, including its page counter and
per-node usage.

Keep the reference acquired by the charge until commit or cancellation.  At
commit time, while holding hugetlb_lock, move an uncommitted charge out of
each dying CSS to the first live ancestor.  The hierarchical charge already
includes every ancestor, so moving it only requires canceling each dying
CSS's local count.

This orders commit against the offline active-folio scan: either the scan
runs after commit and reparents the folio, or commit observes the dying CSS
after the scan and selects a live ancestor.  The retained reference also
keeps the originally selected hugetlb_cgroup alive through this decision.
Reservation charges retain their existing CSS lifetime and are not
reparented.

On an unmodified v7.3 kernel with a 128-page 2 MiB pool, a
capability-free uid 1000 allocator racing administrator rmdir reproduced
KASAN writes to a freed hugetlb_cgroup in three of three boots.  Controller
disable reproduced the same fault.  With this change, 5,000 rmdir rounds
with over 1 million successful faults and 2,000 controller-disable rounds
with over 1.6 million successful faults completed without KASAN, LOCKDEP,
page-counter, or refcount reports.

AI-assisted source review was used to identify the race and to help draft
the reproducer and fix.  The interleaving and the resulting allocation,
free, and use-after-free stacks were verified with tracefs and KASAN.

Fixes: da1def55919f ("hugetlb/cgroup: add support for cgroup removal")
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
---
V2 RESEND:
- Resend v2 unchanged as a standalone thread for easier tracking, as
  suggested by Hongfu Li.

V1 -> V2:
- Remove the redundant disabled-controller check from uncharge, as requested
  by Andrew Morton.

v2: https://lore.kernel.org/r/20261022022146.506005-1-4ncienth@gmail.com
v1: https://lore.kernel.org/r/20261020100345.1677643-1-4ncienth@gmail.com

 mm/hugetlb_cgroup.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index 3fb41311e4c7dc..6921b185726662 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -310,11 +310,10 @@ static int __hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
 		css_put(&h_cg->css);
 		goto done;
 	}
-	/* Reservations take a reference to the css because they do not get
-	 * reparented.
+	/*
+	 * Hold the CSS reference until commit. Reservations keep it longer
+	 * because they are not reparented.
 	 */
-	if (!rsvd)
-		css_put(&h_cg->css);
 done:
 	*ptr = h_cg;
 	return ret;
@@ -337,9 +336,26 @@ static void __hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
 					   struct hugetlb_cgroup *h_cg,
 					   struct folio *folio, bool rsvd)
 {
+	struct hugetlb_cgroup *charged_h_cg = h_cg;
+
 	if (hugetlb_cgroup_disabled() || !h_cg)
-		return;
+		goto out;
 	lockdep_assert_held(&hugetlb_lock);
+
+	/*
+	 * A task can be migrated after selecting h_cg. Once offlining starts,
+	 * redirect the uncommitted charge to a live ancestor. hugetlb_lock
+	 * serializes this decision with the offline scan, which reparents
+	 * earlier commits.
+	 */
+	if (!rsvd) {
+		while (css_is_dying(&h_cg->css)) {
+			page_counter_cancel(&h_cg->hugepage[idx], nr_pages);
+			/* The root CSS never dies. */
+			h_cg = parent_hugetlb_cgroup(h_cg);
+		}
+	}
+
 	__set_hugetlb_cgroup(folio, h_cg, rsvd);
 	if (!rsvd) {
 		unsigned long usage =
@@ -352,6 +368,9 @@ static void __hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
 		WRITE_ONCE(h_cg->nodeinfo[folio_nid(folio)]->usage[idx],
 			   usage + nr_pages);
 	}
+out:
+	if (!rsvd && charged_h_cg)
+		css_put(&charged_h_cg->css);
 }
 
 void hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
@@ -419,15 +438,14 @@ static void __hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
 					     struct hugetlb_cgroup *h_cg,
 					     bool rsvd)
 {
-	if (hugetlb_cgroup_disabled() || !h_cg)
+	if (!h_cg)
 		return;
 
 	page_counter_uncharge(__hugetlb_cgroup_counter_from_cgroup(h_cg, idx,
 								   rsvd),
 			      nr_pages);
 
-	if (rsvd)
-		css_put(&h_cg->css);
+	css_put(&h_cg->css);
 }
 
 void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
