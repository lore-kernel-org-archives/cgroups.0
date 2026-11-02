Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.110
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793587785;
	b=f5bsw5D65Th/T/podzREKpEo/Pl7+kFLCb/aEpP7jVI33Or4pNd/ck14puEbBEMkL/XE
	 MU1+C8ks3YpqXXEFwjhYReaFSYN9FK3r1dZwcG6jFVIjVlHMQFT0ngT6FmDGNITSvGCx6
	 DCrAL3ZuhKJ1QdPSjZKovxOdE0yB5yJUYgruUXnEqUwB1SxXsXxTDwPh2nsrrp3o8bZwZ
	 y9LIuRzNbTt2e/lidQ15/50BSFGpAIm6/2+8JGYLJ1HcXErOITR/2VVHrMa5VdQDroqLu
	 z/fUkpH1UGGqnb/fYBmmFB31jW60uIUm1LHjIUR8VNJb2x8qGzbGmIhPsAWkM1LCETw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793587785;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=HYPCOH7nyOgzPYBliYS/2JtpB4PHhc5GiSJqiBbOPVw=;
	b=CeCDPOf1qJ5dd4NOHy1msTvhRPh1TRH4qp6TBrnoO2xjVaLUyroH6eIe/BH6DpZsvjLB
	 +qT9mV4LwTkFvaGdY1RlbXOXBDfshpQSrwonUOxu0C8fZVuHHrB9Mn8ABC2qPj9L0yeNq
	 qK84XduC5oBz/FyrvkE1vNR2vUxOqCXLU6JpYKuXuBVuahqR3+n9Q0JiW/y1mVaoET+NJ
	 efiHijN2Yg6eI7hPznJbJRHZJBDdggZpFmujqOCy6+FmuoyzsYdYKTAAaC/W3ixFmQMzK
	 ABW1OyIL7cHnQGV2xVlq5lbWADzDmiEathy9wfw41zqLEj4QqPQK47RP3cyIeFAhvmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=VfnYXBQ0;
	arc=none smtp.remote-ip=95.215.58.110
Received: from mta1.migadu.com (out-110.mta1.migadu.com [95.215.58.110])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2F3606A324
	for <cgroups@vger.kernel.org>; Mon,  2 Nov 2026 02:49:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D2F3606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=VfnYXBQ0
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Hqb5dpR6SO9lse5taSFwdMkdZpYAQoi2qmmKSFxQn94=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793587782; v=1; x=1794192582;
 b=VfnYXBQ01a7sVa5ydFtRlIT6q84NfQa+KhReIULOUdKEiLrSUyvWmlp74enHW7qFBqOqwGaJ
 yTma99ZcqhiRfCKJzznyBF6L5LDKR2ynY9tN5wju7SdJnBeTgbn8Tl8cVG5646Vtl/T/lEX91jF
 gzNhkk0Edft2a3OqqqvlWVrM=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8fe3ad59e5aaa9ab;
	Mon, 02 Nov 2026 02:49:42 +0000
X-Mizu-Trace-ID: 8fe3ad59e5aaa9ab
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Mani Tofigh <mt4022@columbia.edu>,
	Zi Yan <ziy@nvidia.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Frank van der Linden <fvdl@google.com>,
	Chris Down <chris@chrisdown.name>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH v2 1/3] mm/hugetlb_cma: fix incorrect hugetlb_cma_size assignment on malformed input
Date: Mon,  2 Nov 2026 10:49:08 +0800
Message-ID: <20261102024910.31486-2-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261102024910.31486-1-kaitao.cheng@linux.dev>
References: <20261102024910.31486-1-kaitao.cheng@linux.dev>
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

From: Kaitao Cheng <chengkaitao@kylinos.cn>

When hugetlb_cma contains a global size after node-specific entries,
cmdline_parse_hugetlb_cma() enters the global branch and reparses the
original parameter string. For hugetlb_cma=1:2G,4G, this interprets the
initial node ID as a one-byte global size and clears the 2 GiB reservation
recorded for node 1.

Global and node-specific formats cannot be mixed. Return -EINVAL when a
global entry follows a node-specific entry, before updating any settings.
This preserves the valid prefix, so the example retains node 1's 2 GiB
reservation and reports the malformed option.

Fixes: 38e719ab2673 ("hugetlb: support node specified when using cma for gigantic hugepages")
Closes: https://sashiko.dev/#/bug/linux-10f40d3e-3feb-4622-9da8-1fedecb2d0e2
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 mm/hugetlb_cma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index 95fd2d190f0d..8e6b20341fc4 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -167,6 +167,9 @@ static int __init cmdline_parse_hugetlb_cma(char *p)
 		} else {
 			char *next;
 
+			if (s != p)
+				return -EINVAL;
+
 			tmp = memparse(p, &next);
 			if (*next == '%') {
 				if (tmp > 100) {
-- 
2.54.0 (Apple Git-157)

