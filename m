Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794827070;
	b=RgQ1mWqp3nRaN+6i1iIGokmlWz4eE7xFb6pTTaQ32gs2y6rOjr+XtwlPHFZhfWYcuplm
	 qoXBiDs8ZtbLlf0Gxj/k534mo6vdqVsKlpR/nbSMxbRzkXKv58GtrV/lOhco1XnppcrAr
	 /DTZvkzOy6cE/yFrAwHjCs11Szfr/cJi5giJr+x5v1DdrWEU941jOqq3dJLRaLenvRNH1
	 ISGb5LwJICN9rSa20fhbPLnnaZpSZArFGSP0LlFjBOBIOu+az43SAzqYvWld7GiBOOnzh
	 dkyN0eJFqKIZRr4DuELoEEsc/WN+aDw1Pf2otaiWR/tTh+W5cW7yeUTIBRerbT/A2yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794827070;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=de7uWRaoa1siS6iLR0pU/Ia14wz6HbTA+F0jrLsvNd8=;
	b=0LMpK0x5ftdwfyYQus3G/6CNncKGhZPUcXj39gULkwI2s5QccfM/mqDntMC8Ru1hPW4Y
	 ZJMiMhZaOz51gTxRnpw2Bfuu1Rt3kYuYX1H43HeeWkzBRH62U/GgjXpzWR/lEFLshlvfD
	 JNR0INb+K0ED16nZTGT6KoaeWiBe013TZZjSrv5nbR3knKvG+JHcwFKYCXCEJuSxdQw7s
	 AiJmEso/2nzkFj/FI6YELznC4zGpU7k24V58UwXmBoy9khao1aStghdSFVV2QcIP3eHEm
	 J8jTQhgjfIEQVwIypCHhaGOm8dZAlVTWyKUlhyBuSPzOK9SRCjLC0kNRe4PnqvwkvJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ibJAJtbb;
	arc=none smtp.remote-ip=74.125.82.47
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2B9606A8B9
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 11:04:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF2B9606A8B9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ibJAJtbb
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-1a2761c69fbso4462458c88.0
        for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 03:04:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794827069; x=1795431869; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=de7uWRaoa1siS6iLR0pU/Ia14wz6HbTA+F0jrLsvNd8=;
        b=ibJAJtbbIcCUBdtIoLRGx6CFmDNCRopaCWZBlDlXOvKpbGxlDj5rpUXO6jCszQizOn
         IrNKEJG5z/O1kYOYOgC2MW7as+fIB2ZgKrNRzuSsmagX3J1tZGV8R9BRkH8sCQ8h9CaR
         LPD21Tg+mJUYdmtWnuk/qYn7GAbySopb+45f8OibRIJ3/I9Y03w9CP0ahX0uptAERBCc
         BLUn35h1bsp83vYs63GBxDHYfkJIkEMgq8o5+Klp/DosYSy8fTI7V0A2H4Vo6+8qWGWu
         RfW2nSlV1J2IQQSWR1JSYJwoPPd1Oh6F4EOuhz4b6Rqr1fLOxG1E7DRqirDj68aO2eCO
         ULMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794827069; x=1795431869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=de7uWRaoa1siS6iLR0pU/Ia14wz6HbTA+F0jrLsvNd8=;
        b=1TOit8D4uWvEbdWe2Deaa9RTgaju2R786BjeVJP12GZDph1JLqnIFoA/PAWInRj76D
         OOgy8ZOHJE//sLiM11DzW+y/jwJRqxCb+r5HAaBMqXHe/BPYOiphy7Nye0hdpsh8oW7Z
         zwt9bam1GT+1DYKAqqVQSlVOuuBmqtuPOV4ESSgmIoA8UuAGj28fi1cPIq/Kj+ZqdDYx
         i1q/zTQbbakZ3mF7RfZOnSkjjODCehrc4wr3r9N/xgDduMMDBEtyvsLNYd+nDFka3vIY
         RAg4KsnOip2T0ByMUfP3gUi1H5YA+qAocrVa52zSw0uKi9r357VOG1nUzdYsyq4vYWKw
         uHLg==
X-Forwarded-Encrypted: i=1; AL+hErFi2xP5hAYDJtdmZ1VhoRc+BOp0nCS/oWWbJde3wcf/eAEA4YHhJaVo6ZsVAa5YGsm2YH5WZvAL@vger.kernel.org
X-Gm-Message-State: APuU4Z+gwCkEgYDCRZ5XRRl7eEq6/kSQVE4QBNHQRRzuT5kH/OYgSFbs
	V0eyWJDh2IJOm29BgYshNQrwvyN1nUx8u42Dz9HZMKiXfbajUCcbOpv6
X-Gm-Gg: AYBFou3WhXKWe9N0U34dM4PTQeSJwg/b9PyrKxb2pzUA/pBCIE8oKbP0ELGrV1dMYgz
	vJc9LFGGZ4OJQvDxghFXr2x0xOyk0jGztHedaeY9CbwzrI67hsLrkgnGhehJ+3ujXjAAW+D/OgN
	M+0DAu2kOEQ6yRADN7SYJzjNWIIbnCz6LRpwiRxkSpHwpJuFyax8GvrJvMLYQPAMUUKhSLdlzZH
	AcNIOHXoo61M+6wN801qDcvGqMgG4src9KVD0e369YdwhfgKQmvDtztqlkwvzg8tPvEK1WkzKil
	W4hgkV3esSSi7kY0eowXd47PJOSK3/t3tW49aIEOf2K6FdyfsPZJecGB2/mk0wPNLfXWkQv1mFA
	MgM9GCgo6it4QX6fMzttP+8Nz5wGBsSNPHNnu115P8o8Huk/3euq7bmfSQCypxkZN7Mrfit7QyR
	bT/iv3NjaNQ+8xXjkoTLuO6hIcFsO4xpL4algNlSd4AypzWr4hZFeEdRZBcTl9bY+Y+M5N6v5a2
	d3vRsAGcMsqjcNCplL90x+qy/HM+Gc+VMyAv9zPFrUioSeq9gHVzOuV10e2ruSPqW9zDlYj/Qfm
	lWXn5jURQjN46+DqBCoAEOmquIyEADFkonXxuv8LdTJpCoI=
X-Received: by 2002:a05:7022:b881:b0:174:cf1b:235c with SMTP id a92af1059eb24-1b5031b37cfmr9037773c88.43.1794827068735;
        Mon, 16 Nov 2026 03:04:28 -0800 (PST)
Received: from naki-PC.localdomain ([203.175.14.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031918c7sm42999260c88.9.2026.11.16.03.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 03:04:28 -0800 (PST)
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
Subject: [RFC PATCH 10/16] mm: memcomp: queue restored large folios for splitting
Date: Mon, 16 Nov 2026 19:01:16 +0800
Message-ID: <20261116110122.309748-11-nakixii@gmail.com>
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

Register a successfully restored multi-page anonymous folio with the
deferred split queue before installing its PTEs. Keep the existing
single-page, failed-load and rollback paths unchanged.

Signed-off-by: nakixii <nakixii@gmail.com>
---
 mm/memcomp/fault.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/memcomp/fault.h b/mm/memcomp/fault.h
index b83ee7011aedf754173dd90034be3d6d25536414..afdde325c0e5f442868e9354d9abc84ae354bb0a 100644
--- a/mm/memcomp/fault.h
+++ b/mm/memcomp/fault.h
@@ -218,10 +218,12 @@ static inline vm_fault_t mc16_load(struct vm_fault *vmf, bool *locked)
 	folio_add_new_anon_rmap(folio, vma, start_addr, RMAP_EXCLUSIVE);
 	folio_add_lru_vma(folio, vma);
 	folio_ref_add(folio, nr_pages - 1);
-	if (nr_pages > 1)
+	if (nr_pages > 1) {
+		deferred_split_folio(folio, false);
 		set_ptes(vma->vm_mm, start_addr, install_pte, pte, nr_pages);
-	else
+	} else {
 		set_pte_at(vma->vm_mm, vmf->address, vmf->pte, pte);
+	}
 	arch_do_swap_page_nr(vma->vm_mm, vma, start_addr, pte, pte, nr_pages);
 	update_mmu_cache_range(vmf, vma, start_addr, install_pte, nr_pages);
 	folio_unlock(folio);
