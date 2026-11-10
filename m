Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794270209;
	b=VgfFXm39l/QkDiEzLjEFe/tE/jPZaM3HvbiAPds+R45u5zO3bglPonaBJG+f8bii2myu
	 rT610KRPoLixyLKs3+7v3KcFwh9PINJpzX236Q4OeRjiBtIXUuCXSC2hR6z4HdXM9VxXT
	 cnV9AJ1uMNWSQMSSH6bjwLa1+LThl2J3GXzlIld2htAuT7jKEI/+lUuOS4bUNVgtyMuJ3
	 Fk3TDFfXVUWpFzB97utwwPDwJC3MZYcGVSpCCaNp/9DZoJLrploBVQBzaNslIw38m9kK/
	 CwY4gfkezeTfrOlC8AlF95LQh+DOUz9DnvD+3/TQ5Fs1ewMmSvCXbn8o3d0EbN9k14w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794270209;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=Or/iwEJV3s6/OZb+G94Yla/RPMj3Q8ZsEYH3A6tdUpY=;
	b=360wO0qfLBRvc0rhScF3/xroMU2EyhqYfFOqqzvpW9BIZRBqDw/Ygbxjl5T/hK0EAzEN
	 X9QnA3ms9UR/hk45n67924Hs8UAcubEcOZkln04xUTQ8ZhAN2ssRLjd+zrscNdBWzGCZ1
	 ML9FAWS+jaC2+EkCAg47JAQp8wr9aR4XVcg9m0Kc3kqu07F5PDznEeuIsO2TbcBBDJ1TN
	 V0EFsA9MQhFFMzKrv0rIRdCB2L5l7VaUqOsFdWop2/8Aea/djWGNDEYbyNh4w/WdFVWYy
	 vFmz17IR9WN8w+wvcRBlx87uppLrLlbiDeqqMxcJHP+cyFGOoSvSnRcWxCNnNwPLYgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gINnAD2O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF63B606A321;
	Tue, 10 Nov 2026 00:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gINnAD2O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AFEF1F008A2;
	Tue, 10 Nov 2026 00:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794270208;
	bh=Or/iwEJV3s6/OZb+G94Yla/RPMj3Q8ZsEYH3A6tdUpY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=gINnAD2O6rE5FAzCv2/fDxSlenMynl3hkBpwj6TR7CLiVWp0H7UZwY8fxSgt7o+j6
	 NsuZro4PlPsnIG7yIZu7YGjdNXd8v9jI7dVMBfQMkEkycWL7Ky72sR8RpznLOLG5PY
	 eeZTWRwZcOu7MeeO/st4JcoP4f34QlO1yPrnKGZE=
Date: Mon, 9 Nov 2026 16:23:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Mani Tofigh <mt4022@columbia.edu>, Zi Yan
 <ziy@nvidia.com>, Mike Kravetz <mike.kravetz@oracle.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Miaohe Lin <linmiaohe@huawei.com>, Naoya
 Horiguchi <nao.horiguchi@gmail.com>, Frank van der Linden
 <fvdl@google.com>, Chris Down <chris@chrisdown.name>, Joshua Hahn
 <joshua.hahnjy@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Kaitao Cheng
 <chengkaitao@kylinos.cn>
Subject: Re: [PATCH v3 0/4] Subject: [PATCH v3 0/4] mm/hugetlb: Fix CMA
 parsing, flags and usage accounting
Message-Id: <20261109162327.f1477705ec4374b5a243068d@linux-foundation.org>
In-Reply-To: <20261106100521.30099-1-kaitao.cheng@linux.dev>
References: <20261106100521.30099-1-kaitao.cheng@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri,  6 Nov 2026 18:05:17 +0800 Kaitao Cheng <kaitao.cheng@linux.dev> wrote:

> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> This series fixes three independent HugeTLB issues reported by Sashiko
> and includes a follow-up cleanup of NR_HUGETLB accounting.

Thanks, I've updated mm.git's mm-unstable branch to this version.

> Changes in v3:
> - Retain patch 3/3 from v1.
> - Fix code alignment.
> 

Here's how v3 altered mm.git:

 mm/hugetlb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~b
+++ a/mm/hugetlb.c
@@ -1450,9 +1450,9 @@ void add_hugetlb_folio(struct hstate *h,
 
 	/* Callers must clear transient flags before returning to the pool. */
 	VM_WARN_ON_ONCE_FOLIO((unsigned long)folio->private &
-			     ~(BIT(HPG_vmemmap_optimized) |
-			       BIT(HPG_raw_hwp_unreliable) |
-			       BIT(HPG_cma)), folio);
+			      ~(BIT(HPG_vmemmap_optimized) |
+				BIT(HPG_raw_hwp_unreliable) |
+				BIT(HPG_cma)), folio);
 
 	INIT_LIST_HEAD(&folio->lru);
 	h->nr_huge_pages++;
_

