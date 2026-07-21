Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B969400E1A;
	Tue, 21 Jul 2026 02:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784602389; cv=none; b=DT+QiwDwMQmhZnPWi5nS83eLnySv2C5HzecZ0Up0SuM5h6NHPBCM8JdV/O3W9IUSx9qgQjhklaZmSc+c6SRoAjnWk6TDDUg9k036/n2RGsBmtF/CtoKOS2wJ34wQ1908NOji9JgzRSFnxWyLUeVMSwx9sgdoy4UYr+KoVITsVUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784602389; c=relaxed/simple;
	bh=9xYXc8cFALwl2scnPkDmoIcwhk2eGPLl2JPUNmDY2d0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DqDEw9bJ12Zz6+ytt+N367tFeDpipL8XW+Gd69CpI3obQ+9oZu92g9mdB+o9L1/IjSQatTN9YxnHdQbW8w1HCRkj/5jl7xmCSw9xQbZArQGjJvIIAg5se208xPkLHh6Ax5YgnnyWyBVulG27X6WHcpZV3rv9x3PNDAQt+lsRyWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RU5nIEo7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RU5nIEo7"
Received: by smtp.kernel.org (Postfix) with ESMTPS id ED0F2C2BCC9;
	Tue, 21 Jul 2026 02:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784602389;
	bh=9xYXc8cFALwl2scnPkDmoIcwhk2eGPLl2JPUNmDY2d0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=RU5nIEo7oWGGETmhUfdKPLm20rS3ih3Lz3nx7dwAbmJpFMYKLmt1sbPxm8M2BdFSb
	 p+qcEBcKlKCYBeGTbYZvCWk0+kdvFH9uvPlxo+HCrjvzfA3TxKn/TSf+lvQK01A1dG
	 6bCBamepBRssAXw7K2FZqZE+8Pq1xa652OychT7XIwjDIyD9SfXYw04rOq0bNNF1kL
	 fY0DPpYdi2kqYt6agKYJjpZBpnTg75KDWOxMZ1teiVfjCiYXeav3kklKOSKGInqqeF
	 KMnOIr1LMuDTplYR35a/9ljd8NETimAmPoZiEBsL5JeRUAahmv6rCmmCODVa3gC9rc
	 018p7QpijnZRw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCCBFC44524;
	Tue, 21 Jul 2026 02:53:08 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Mon, 20 Jul 2026 17:25:05 -0700
Subject: [PATCH v3 02/13] mm: hugetlb: Return -ENOSPC on memcg charge
 failure
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-hugetlb-alloc-failure-fixes-v3-2-7d2a169aa9ee@google.com>
References: <20260720-hugetlb-alloc-failure-fixes-v3-0-7d2a169aa9ee@google.com>
In-Reply-To: <20260720-hugetlb-alloc-failure-fixes-v3-0-7d2a169aa9ee@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
 jthoughton@google.com, Mike Kravetz <mike.kravetz@oracle.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Ackerley Tng <ackerleytng@google.com>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784602387; l=2183;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=nuUhbZqkwDE9Ph8fILa8cD4bi/Ma9wFUhfWLAJKiQgk=;
 b=j57evNN0B3aJE2bGo4aYEop42SQgenXTgRg2PUpxRSDxLbx80RSNC2CSSJi9kG5+6PcjtSdOX
 U3od4V1MktRAPv3uMaKCMouffdnKbebP9hZr5h1kP/nwAVICniSzxVg
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com

From: Ackerley Tng <ackerleytng@google.com>

When mem_cgroup_charge_hugetlb() fails with -ENOMEM, alloc_hugetlb_folio()
currently propagates this error. This results in the page fault handler
returning VM_FAULT_OOM.

Because HugeTLB allocations are high-order and use __GFP_RETRY_MAYFAIL,
they bypass the OOM killer. Returning VM_FAULT_OOM to the #PF handler
without triggering the OOM killer (or having it make progress) leads to
an infinite loop of retrying the fault.

Avoid this loop by returning -ENOSPC when charging fails, which maps to
VM_FAULT_SIGBUS, terminating the process cleanly.

Make mem_cgroup_charge_hugetlb() fault handling use a common error handling
path, the same handling used for hugetlb_cgroup_uncharge_cgroup{,_rsvd}(),
which also don't trigger the OOM killer and hence opt to terminate the
process with a SIGBUS.

Fixes: 991135774c0e0 ("memcg/hugetlb: introduce mem_cgroup_charge_hugetlb")
Cc: stable@vger.kernel.org
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
---
 mm/hugetlb.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index eef9610a0593c..b32735b092a0a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2997,7 +2997,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 	if (ret == -ENOMEM) {
 		free_huge_folio(folio);
-		return ERR_PTR(-ENOMEM);
+		goto err;
 	}
 
 	return folio;
@@ -3022,6 +3022,17 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 out_end_reservation:
 	if (map_chg != MAP_CHG_ENFORCED)
 		vma_end_reservation(h, vma, addr);
+err:
+	/*
+	 * Return -ENOSPC when this function fails to allocate or
+	 * charge a huge page. If a standard (PAGE_SIZE) page
+	 * allocation fails, the OOM killer is given a chance to run,
+	 * which may resolve the failure on retry. However, for
+	 * HugeTLB allocations, the OOM killer is not triggered.
+	 * Returning -ENOMEM (or anything resulting in VM_FAULT_OOM)
+	 * would leak to the #PF handler, causing it to loop
+	 * indefinitely retrying the fault.
+	 */
 	return ERR_PTR(-ENOSPC);
 }
 

-- 
2.55.0.229.g6434b31f56-goog


