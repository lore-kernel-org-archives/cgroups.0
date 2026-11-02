Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.123
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793589071;
	b=QXRHkITscJkLn63RxyDHaMWxz4QlkD6OtDXpkCzj4U7aEpf0Vt/K8MYKIlESWVB9UEyt
	 9ayAB1LGHrji6C51ylxUJL2e7Lvvkc0rCOyK/SdxzYzNRDusKEAoGt7Hbyn5NHcPwigH5
	 8xIHNIKaDfwZ9k28qva5DklWLj7OYXQ2fo35cx78DUJmHvKV4NVnwuBVhAEcozS0RIxNq
	 2EKbISlFgix2D5nLvFXAX3XoO30UeQ2i4JUm7rVzHAB/qESYyc3WGbvWZVAX9FFVKSa2x
	 ISUZgSUU58//YlfhWNsL1JqWzAH5lmDrs7yoWXiWZ0a50bXGy2p0yv4ISt02Ou9qdqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793589071;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Content-Type:Mime-Version:Subject:From:
	 In-Reply-To:Date:Cc:Content-Transfer-Encoding:Message-Id:References:
	 To:X-Mailer;
	bh=HDhZoiU2k7hzH5EQ8QltiF8pnal5BaZYHkxarnC+U5E=;
	b=zUa8NbMgWq9ZFs+tGH/LWr2BB8tIT6dsa6NItPwybUBcvFLT5AxRTq1+qryeSqyVSRtA
	 1xfbdTPj0i+rNG9SSO6h13BXxajLNuL7MzrXFyP4E5Y2kpbACIHpGoHeEHcn4hFMJr1bb
	 QVvC9KU/xMbzBj2mYBBqE59Pi31Z8QNZAab6ogY/ePMQRVMYnRXYYiHfPt4VLvTonZ5ku
	 O2sjoZHvV68y81Z9pxZdkhEPUU/5qa4PE27LK0Zl1xwNfN96CWqx/3Z0upwaSKvC7MStf
	 FfMV73dNFVa8mnIKZqTuvudtFbQN/ldOPbfkMOE421EK8iIJUv6JZGWH/EpnyiMfruQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=n0k3Hqlr;
	arc=none smtp.remote-ip=95.215.58.123
Received: from mta1.migadu.com (out-123.mta1.migadu.com [95.215.58.123])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BAFD606A324
	for <cgroups@vger.kernel.org>; Mon,  2 Nov 2026 03:11:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2BAFD606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=n0k3Hqlr
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=2ep7chL4yiYBSxOtKkATYD7E9Kan5MnJyt74PbsbY2s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793589067; v=1; x=1794193867;
 b=n0k3HqlrjwV2Tsu/afxxjlV4pD44YtWJfaVfNxqkf9f5BRb34TxDBhYIPNPv3UVWsbdtWpzv
 nDY1ZRbtXmCXX/EiHWE91drrqkdYXLA1t2WmPrqsfw75Lx6z5Vd+3cOAqiCXrqIBDsAChjqAXdA
 0N4xoivwgBDZlGU5lKOUjChM=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 13887cf09f90baa8;
	Mon, 02 Nov 2026 03:11:07 +0000
X-Mizu-Trace-ID: 13887cf09f90baa8
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2 2/3] mm/hugetlb: Preserve persistent flags when
 returning folios to the pool
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261102024910.31486-3-kaitao.cheng@linux.dev>
Date: Mon, 2 Nov 2026 11:10:47 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Mani Tofigh <mt4022@columbia.edu>,
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
Content-Transfer-Encoding: quoted-printable
Message-Id: <80F17A68-8C3B-4BA5-9E70-838846BFAAB2@linux.dev>
References: <20261102024910.31486-1-kaitao.cheng@linux.dev>
 <20261102024910.31486-3-kaitao.cheng@linux.dev>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
X-Mailer: Apple Mail (2.3901.200.71.1.16)



> On Nov 2, 2026, at 10:49, Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
>=20
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>=20
> add_hugetlb_folio() returns a folio to the HugeTLB pool when vmemmap
> restoration fails. It clears folio->private and restores only
> HPG_vmemmap_optimized, losing other flags that must survive the =
rollback.
>=20
> Clearing HPG_cma causes a later free to bypass the CMA release path,
> leaving the CMA allocation bitmap set. Clearing HPG_raw_hwp_unreliable
> loses the indication that the locations of poisoned subpages are =
unknown,
> undermining the checks that prevent freeing or unpoisoning such =
folios.
>=20
> Preserve the existing flags instead of resetting folio->private. =
Callers
> already clear HPG_restore_reserve, HPG_migratable and HPG_freed before
> returning a folio to the pool. Clear HPG_temporary in =
free_huge_folio()
> before attempting to free a temporary folio, so a failed vmemmap =
restore
> does not leave that flag set on a folio returned as surplus.
>=20
> Add a VM_WARN_ON_ONCE_FOLIO() check for flags other than
> HPG_vmemmap_optimized, HPG_raw_hwp_unreliable and HPG_cma to detect
> incomplete transient flag cleanup.
>=20
> Fixes: 161df60e9e89 ("mm, hwpoison, hugetlb: support saving mechanism =
of raw error pages")
> Fixes: d2d786714080 ("mm/hugetlb: enable bootmem allocation from CMA =
areas")
> Closes: =
https://sashiko.dev/#/bug/linux-5363eb09-9c3c-4f8b-9f3c-a998a8c4b258
> Suggested-by: David Hildenbrand <david@kernel.org>
> Suggested-by: Muchun Song <muchun.song@linux.dev>
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>

Acked-by: Muchun Song <muchun.song@linux.dev>

But,

> ---
> mm/hugetlb.c | 10 +++++++---
> 1 file changed, 7 insertions(+), 3 deletions(-)
>=20
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 4a008afaedf9..931ca3a30773 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1443,6 +1443,12 @@ void add_hugetlb_folio(struct hstate *h, struct =
folio *folio,
>=20
> 	lockdep_assert_held(&hugetlb_lock);
>=20
> +	/* Callers must clear transient flags before returning to the =
pool. */
> +	VM_WARN_ON_ONCE_FOLIO((unsigned long)folio->private &
> +			     ~(BIT(HPG_vmemmap_optimized) |

It looks like the parameters aren't aligned. A space missing before "~"?

Thanks.

> +			       BIT(HPG_raw_hwp_unreliable) |
> +			       BIT(HPG_cma)), folio);
> +
> 	INIT_LIST_HEAD(&folio->lru);
> 	h->nr_huge_pages++;
> 	h->nr_huge_pages_node[nid]++;
> @@ -1453,9 +1459,6 @@ void add_hugetlb_folio(struct hstate *h, struct =
folio *folio,
> 	}
>=20
> 	__folio_set_hugetlb(folio);
> -	/* Clear all folio->private flags except =
hugetlb_vmemmap_optimized. */
> -	folio->private =3D NULL;
> -	folio_set_hugetlb_vmemmap_optimized(folio);
>=20
> 	arch_clear_hugetlb_flags(folio);
> 	enqueue_hugetlb_folio(h, folio);
> @@ -1743,6 +1746,7 @@ void free_huge_folio(struct folio *folio)
> 		h->resv_huge_pages++;
>=20
> 	if (folio_test_hugetlb_temporary(folio)) {
> +		folio_clear_hugetlb_temporary(folio);
> 		remove_hugetlb_folio(h, folio, false);
> 		spin_unlock_irqrestore(&hugetlb_lock, flags);
> 		update_and_free_hugetlb_folio(h, folio, true);
> --=20
> 2.54.0 (Apple Git-157)
>=20

