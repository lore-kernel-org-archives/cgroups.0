Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794827028;
	b=dNq/6geVCbTre8OykQ1yR8eHCcBVH5RokeZJ2+WD4L/cGB7X2seEof62RyWLuha/+/Tf
	 UZsx7oqSYxXHaFFt2k7mjkLSPer6p2vk/BPz7h/24wq1hpSX+9b2M5czLYGE8JVIKFc2R
	 C0DF646W2PoZpotVQ1ROIrIAWDdcXgZifNJdU3kAVl1r59AU43fSjWfNtwLaNQ0AdITFs
	 ACbI7nNHlL755At7vn7xQjoPZZ5V770yrOmoiDX6vt0e6/YcfbQ9bEuaq+FzIUhOEVIrH
	 t75mslcSrBtKXhvJpf7AWrkWFopvsm72txyMGrzpa32TFpmQ7p3JvLyqfW6hfVl2Qng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794827028;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FOfHSV/fi0rwB1D9NSo+2tobL9eqrpJMV7aIr3prIfc=;
	b=YRz0pa+Cie6pdi+UouxQgCCGPxQpie6TsEUJdvGNYhEzED5hUjB8QeCGF3y4yd2TmLi2
	 TlcYut/Thpph7ob0K4QpvmedRHK4ZQpvEmmQ7o1LIcqgnXHSGK9HyVGYkpNKXRGEtwKFD
	 duYvVcoGCjd+xYW9xMt4TUoDphi3943+Ih63QqrxU+bWD9j5s7G/HC3HvwUwNWQNmSCtp
	 98oIif/k5WSEniC84XfyxsR9miepuQaXM73abBWzGjQt3XbSNgaW7ecVjhjBZw6Kr3JoJ
	 EivSajKAjpI5HyKCJ5KKDYWbmMhJm3TlFa4Z+rhvT0AsEzK0+rqg+LjJU6QfcMFwDtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="FbkA6W/Z";
	arc=none smtp.remote-ip=74.125.82.176
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0692D606A33D
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 11:03:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0692D606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FbkA6W/Z
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-3791619605cso6335986eec.0
        for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 03:03:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794827027; x=1795431827; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FOfHSV/fi0rwB1D9NSo+2tobL9eqrpJMV7aIr3prIfc=;
        b=FbkA6W/Zrx+3P6WdyaHwt3qAkpv8j8EpWww73ArSuFyAtrTDr6BUDGTYWb1maTqmc/
         EHyD01p2UoSZ1B9eOwprgq7gqYIihyl+JszYjPhMJTu/NOsRIKsbOooywmf/r7wXaEHC
         vh2XXl1vuh3U/tIeBisrYGTSHy4LXT67S3bynS2TcHd7RTCKsHy5YeiRmhWRQnfAfJ/E
         MQKxbOgP7s+F+WOI29InDczLFe3iajLXTqPihUH1aC+YFSYGIXbf/+CSGXPXM6BYxlFc
         b4pp6Qzsoe09LRs0anS1BJeSMPATtEyajA1SCgUZ5MM4itSyMsspE4Z6gcHbXkHhPxRH
         sM2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794827027; x=1795431827;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FOfHSV/fi0rwB1D9NSo+2tobL9eqrpJMV7aIr3prIfc=;
        b=ACKAorEkv3QEB5zXTJTVCpvwVhyX0YDFanNFEeOwmoyFgTQ24g3VJ7FqJ8HOhiEEq3
         tX55ymU7hkRR+FTqEy4fFW/8FA3rWObXhw5K02PQs8+GRYRVlKUPpptOf35jYg26orWQ
         5k5XCWr4HJ4h8bMZcWosC0qobUe8iWMehOlVvRWB4TpriMyxLi+YtCzkGKKaknxHRvW8
         dnbL7rYsOQr3a4iKHlyxz0iok6w+oyhSPjgB/fO8VYs8cfj2lFca2eb+BRnIUQgJkp8q
         eSkfqPKf4PoO5B9evpLz/rpnGXmGud7vAc+98SSN5eaSlbrnaa883xwJA9fiLO9zSjq4
         bBxw==
X-Forwarded-Encrypted: i=1; AL+hErGqbIqnSoLIInS/FUE4jJD3ByOVXBZ79isAT6+66tIvHcEMNF/RmNl+ee3RpI578GZaEz5OkC7+@vger.kernel.org
X-Gm-Message-State: APuU4Z/ln8yg6ZJ+2R2Io9F/aTJsLeFYwkT9lCBUjVCPQ/GdF8PV4gFS
	/NTrfEDYLFSyPQq6JgE7e+ue+ei7VtQQgRrhlQ7ZYkiJRRm+PeIX6h2f
X-Gm-Gg: AYBFou00gEuLyHllDLBSmjK0daOb1mTCtunmb5WGxxk7k/9mpO9KA5uRsGQntJBdziA
	2W52yZubq/wE3IQ9Xml8DQBKGJGB5s5R4RbVGsVgjGHcTCJZcKaRPffQEJfWmGcbKjkpLW24y66
	fUq7FCP5euzjQ1VucMTLtw4b/am8uhwZIzUOlznqtl8ZguSt3leP772QmXAhNe74HUtgZ04wTy2
	IerY2VPVOLxncJ1rbAQIAKeu+RScNvziY9szWfm2xOCdA3iifDF6yMb+olgckk9R+c6yeuSSlhC
	WkN5njaeggoaLRBA7OinPeOyYLTx8CVJlh3pUa/tuM3cvtUJa9rpkAYYo5nL/4Uaib7n8JU7C3f
	vnbiLRv8nOgmcgn3K4ROiifSq3BHIpZXyK7LW1ZEOHFZn4fbpE/eE7jpdy9zDHjcA5t93x8pVu8
	FOFICSPGSEPNVdN7qopMDq8MJ3xp3jYwfCUnFNB/VmB19zT++ryVwJ1YKIC/dxJbegnZBUmgjaG
	sb9TrvUAjOetO+RqVqEUuiLG9he8cYMfRf+BMCuw4rTEEL8FnaAMaIi8s8HtEu4tq9ephvK1Dxo
	8T2FqFYGu98wjj+Savwp39IdvXkuCH+3vLf7ebOB2xInkhQ=
X-Received: by 2002:a05:7022:3a8b:b0:182:94d7:f76a with SMTP id a92af1059eb24-1b5031562c3mr10836837c88.43.1794827026953;
        Mon, 16 Nov 2026 03:03:46 -0800 (PST)
Received: from naki-PC.localdomain ([203.175.14.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031918c7sm42999260c88.9.2026.11.16.03.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 03:03:46 -0800 (PST)
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
Subject: [RFC PATCH 02/16] mm: add a swap entry type for in-memory compressed pages
Date: Mon, 16 Nov 2026 19:01:08 +0800
Message-ID: <20261116110122.309748-3-nakixii@gmail.com>
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

An in-memory compressed page has no swap device or swap offset. Encoding
its reference as an ordinary swap entry would direct faults to the swap
cache and allow swap-device lookup to interpret an unrelated token.

Reserve a non-swap entry type for memcomp and provide helpers to
construct and recognize it. Account for the reserved type when locating
PTE markers and computing the maximum number of swap areas, keeping
these encodings disjoint. A build without MEMCOMP reserves no additional
entry type.

Provide the disabled-backend interface needed by callers without sending
these entries through the ordinary swap-device paths. The compression
backend and its reclaim hooks are introduced separately.

Signed-off-by: nakixii <nakixii@gmail.com>
---
 MAINTAINERS             |  1 +
 include/linux/memcomp.h | 13 +++++++++++++
 include/linux/swap.h    | 13 +++++++++++--
 include/linux/swapops.h | 22 ++++++++++++++++++++++
 4 files changed, 47 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/memcomp.h

diff --git a/MAINTAINERS b/MAINTAINERS
index de04c7ba8571bdd79d564393847d32cc2f18a07d..dc29bbc6e53547cba9fc1763104463bb1091f7ec 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14852,6 +14852,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 T:	quilt git://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new
 F:	include/linux/gfp.h
 F:	include/linux/gfp_types.h
+F:	include/linux/memcomp.h
 F:	include/linux/memfd.h
 F:	include/linux/memory.h
 F:	include/linux/memory_hotplug.h
diff --git a/include/linux/memcomp.h b/include/linux/memcomp.h
new file mode 100644
index 0000000000000000000000000000000000000000..d399e76bd6b62fdbe377b905cd649960d802bcec
--- /dev/null
+++ b/include/linux/memcomp.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_MEMCOMP_H
+#define _LINUX_MEMCOMP_H
+
+#include <linux/types.h>
+
+/* The encoding reservation alone does not provide a compression backend. */
+static inline bool memcomp_available(void)
+{
+	return false;
+}
+
+#endif /* _LINUX_MEMCOMP_H */
diff --git a/include/linux/swap.h b/include/linux/swap.h
index f3e0ac20c2e8c91f75d1afd62d736cce113e5fad..83d188e927e0af6dd356d39c33026f860082056e 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -62,7 +62,8 @@ static inline int current_is_kswapd(void)
  */
 #define SWP_PTE_MARKER_NUM 1
 #define SWP_PTE_MARKER     (MAX_SWAPFILES + SWP_HWPOISON_NUM + \
-			    SWP_MIGRATION_NUM + SWP_DEVICE_NUM)
+			    SWP_MIGRATION_NUM + SWP_DEVICE_NUM + \
+			    SWP_MEMCOMP_NUM)
 
 /*
  * Unaddressable device memory support. See include/linux/hmm.h and
@@ -86,6 +87,14 @@ static inline int current_is_kswapd(void)
 #define SWP_DEVICE_NUM 0
 #endif
 
+#ifdef CONFIG_MEMCOMP
+#define SWP_MEMCOMP_NUM 1
+#define SWP_MEMCOMP (MAX_SWAPFILES + SWP_HWPOISON_NUM + \
+			 SWP_MIGRATION_NUM + SWP_DEVICE_NUM)
+#else
+#define SWP_MEMCOMP_NUM 0
+#endif
+
 /*
  * Page migration support.
  *
@@ -116,7 +125,7 @@ static inline int current_is_kswapd(void)
 
 #define MAX_SWAPFILES \
 	((1 << MAX_SWAPFILES_SHIFT) - SWP_DEVICE_NUM - \
-	SWP_MIGRATION_NUM - SWP_HWPOISON_NUM - \
+	SWP_MIGRATION_NUM - SWP_HWPOISON_NUM - SWP_MEMCOMP_NUM - \
 	SWP_PTE_MARKER_NUM)
 
 /*
diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index cb468e418ea11444ad0fe4be3b551787ba26947f..0327ccc7a6bc808b08780c6d3848d86dee59c213 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -109,6 +109,28 @@ static inline pgoff_t swp_offset(swp_entry_t entry)
 	return entry.val & SWP_OFFSET_MASK;
 }
 
+#ifdef CONFIG_MEMCOMP
+static inline bool is_memcomp_entry(swp_entry_t entry)
+{
+	return swp_type(entry) == SWP_MEMCOMP;
+}
+
+static inline swp_entry_t make_memcomp_entry(pgoff_t offset)
+{
+	return swp_entry(SWP_MEMCOMP, offset);
+}
+#else
+static inline bool is_memcomp_entry(swp_entry_t entry)
+{
+	return false;
+}
+
+static inline swp_entry_t make_memcomp_entry(pgoff_t offset)
+{
+	return swp_entry(0, 0);
+}
+#endif
+
 /*
  * This should only be called upon a pfn swap entry to get the PFN stored
  * in the swap entry.  Please refers to is_pfn_swap_entry() for definition
