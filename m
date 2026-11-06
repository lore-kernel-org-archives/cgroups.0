Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.147
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793959561;
	b=1Sli+5ro5P2TAbafFJl2paAXWDOaXpxxddd2MTmxTUSkcwy8e9MuXjYtVi6CT2u/FA5A
	 vcs6s1moNfF8cTJ8kaD/9z7fQpUUNmfhhgP47O3KSGYTolNlv4NudoYzsldT4V+bfjsQS
	 7n/fhwCkPPQ/0v+pYqlDGExlHA0orJhrq5lNlMT+mwGU5m03WQzn1erHEmmOb2SNGjd8X
	 ZrGUaoXnod/6Sq81Iesteh7iBranUQPGdglRzSRQIpmajESYQb/RJKD1C3mpldbAd3DqU
	 RVg1JZwyxlTh+KIDfUKQ/0R1aN+6r3KOuD6N+G2UdOyxB6t2kob+NdZ0s8EHUf0R/Hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793959561;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7FWvjRm5VHt/o3Fu51zLztgQLTfGfWw2bGFo45jXROo=;
	b=LDPq304EIzpENv4gw8mEB7sv0tGAeeumgTaugb6H4ZxUWQcNUP1GZNv5juzgPfePFMYr
	 +dJZ1ZVlc/3WlZsAS/gUj/v0f/Jw8zaIQ90HrMr12rVeQGCewvP8wSDsyj6I1F583yDKZ
	 kTK054KonmqF9T1pDLrp8S3U3f44AZPSx3LtLRJceNAZrs0O09/pQFvhNDIWdVrR5PO2k
	 IiqXby1SFhZDQ2SEV2uBXGmzLhmRMgqB4GauPgbMqxIIZozGswS0CPKQo0vT2VaSuSDJ1
	 k3u4P4M614ny1L1iTFoJPY0AAADC5P++ZVxTsWTkvpO7PuC3zIiL/6Rn5PusIp36NkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pJrwF2pq;
	arc=none smtp.remote-ip=95.215.58.147
Received: from mta1.migadu.com (out-147.mta1.migadu.com [95.215.58.147])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06CE606A32C
	for <cgroups@vger.kernel.org>; Fri,  6 Nov 2026 10:06:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E06CE606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pJrwF2pq
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=gmhp/zhGP3DAO+86b4RAlsAtIQ84L/beRI6uM3dmLu4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793959559; v=1; x=1794564359;
 b=pJrwF2pqbjdw01C/gZ2ueKzvCk+VjkI6WCrAjOe966atQmcFeQ5qTY83Ko/GNz69lvpZ1dZ9
 s/XbXa8Ooy0luIOXcSZ8j+KGPwSltxDFf0p++OS8HmXbnmmVmS7KC2PNmNKgvzxSiz7g2tkGP6t
 vuudGTR3+4arUemMHnTriZz8=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a67021b1b9df2a3e;
	Fri, 06 Nov 2026 10:05:58 +0000
X-Mizu-Trace-ID: a67021b1b9df2a3e
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
Subject: [PATCH v3 1/4] mm/hugetlb_cma: fix incorrect hugetlb_cma_size assignment on malformed input
Date: Fri,  6 Nov 2026 18:05:18 +0800
Message-ID: <20261106100521.30099-2-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261106100521.30099-1-kaitao.cheng@linux.dev>
References: <20261106100521.30099-1-kaitao.cheng@linux.dev>
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
index 80b2407e9f07..cd6a64986278 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -165,6 +165,9 @@ static int __init cmdline_parse_hugetlb_cma(char *p)
 		} else {
 			char *next;
 
+			if (s != p)
+				return -EINVAL;
+
 			tmp = memparse(p, &next);
 			if (*next == '%') {
 				if (tmp > 100) {
-- 
2.53.0

