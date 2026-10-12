Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAFC4E2F09
	for <cgroups@vger.kernel.org>; Mon, 12 Oct 2026 20:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791835712; cv=none; b=Hj8cU9cvMR0wUVCrRfX9Ql07VdYlwkpk1R3wwoYUW4CaYWqfXfWuvtHI1DurWo3IbRW4W8ezuZEMUQMmCcqQd5H0C+hy8akhjdJOJ/vOxvQI2sU0DpfNaMMsZ7SFAzlHapG5Sc4xz+VE+pea1xeebh88SFmqmqdkKm8O5FtIHzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791835712; c=relaxed/simple;
	bh=tge+8N4eSTSVxeb5T2g4NYzIYsLGM11CHJPIBUanVCo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RnsCQYlVysQNhgERiJr9XO4Y/8cFltFegh4oYABOqWp/Cv/wdizlp7WQbaMCSOXNOedt2NH3GmJUr//SG6CroB9eG0LzL1QNt1LoGbJ/2gbDwvDOQyLZXToV+Igkd6KxP3umNt3kk+snETweQ214p9dW+teLRE2ZJeKG7LjG7N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=utexas.edu; spf=pass smtp.mailfrom=utexas.edu; dkim=pass (2048-bit key) header.d=utexas.edu header.i=@utexas.edu header.b=M9fkdbg9; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=utexas.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=utexas.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=utexas.edu header.i=@utexas.edu header.b="M9fkdbg9"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-49de8ea072cso899149fac.3
        for <cgroups@vger.kernel.org>; Mon, 12 Oct 2026 13:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=utexas.edu; s=google; t=1791835706; x=1792440506; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=C5VkKI5ZAzJ6cEJcZ3ResShuIP8Oeib9ArzUWA2J4tg=;
        b=M9fkdbg9oiUR9MvmIL5n3SoAp88IGIoCOqSXpJe6wHoxkP3iB6yYIDx/UqQuM/qLNZ
         a5JZhiriVPhZqGxO4bNwFmt46vvXT9e078ZdPz/XTg3qUbgv74CiNdSDdNHGIqW9A2k9
         kza3Qpe2AoKHpJF9yPqHooXmZKzYRS21SaHrUlkUcP7Fb06s0KFN8HRp7fT8Lfk7MOLr
         prkgDYkwAE6IAeas/1hIXWazbaBGcg+48I8b8cg1nMCAcYfyHM09n/hxc6timQtzRE2c
         CQXJMvFHO3MK30fiQK5rGGVxE98d/bVB/y4AoCzKZ5uHqfO8eiMQsa9IVJbGwU8I3ABc
         c/NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791835706; x=1792440506;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C5VkKI5ZAzJ6cEJcZ3ResShuIP8Oeib9ArzUWA2J4tg=;
        b=hC7ZxvdZeRtRq7AGVI9V+9vqBHeCVTL/to3QoIMPa7Q0I08TB1OvfP+kKCi+LIRmo3
         ikhXzZIks8exzi/QyNzhWqhNSvm3jfTsu2jMO0LrJpTUQwTkT8hD0khXoYyC5zvaK52a
         0o6BqxhCE/RtYtoLYdoafCIl9em0swSKeAZQPukzqPBrp+I07BWRS2/5Rqzi6/IRqU0U
         wdop/f0RUVlwgTrF0Qw0Q47o8IAYKgufbXFCO/H4BI9I8IAF3zOsub518Sug9EEHJe1f
         XfUdRu3fcJmzhUgROjIp9yiN2z8MkX6UkuGHWft6d+aMhhQ2pxteI2/kJI1tamkqgL7Q
         X+ZQ==
X-Forwarded-Encrypted: i=1; AKwUvByQtGto8XxF0F4j8RFsYNExbhJzavkao/KRooU2zEtpfYsvkwxehMiozVO0JcuW3iIJx63SHj+t@vger.kernel.org
X-Gm-Message-State: AFq9FYLby4eRggrCcOMh4p9uem5vTeje1/KOU5UCPm+Vx1QIw2UI+MU0
	5b6sCY7bdJ2Q+zBsThbVt/iQGnma9mDP1LpnPUWgGk+7vZOe2nhAEdhPEQRsi8ZBY18=
X-Gm-Gg: AYBFou0vvqHAINcwnCud/msdBwpqI80TsL2UzPIbfNdk5E4pI6ake1/XyKoNy8HQ2ND
	VYw09Vm9taG6X6d3E+Y08J+IGmJetH7v3oyXYjOu22CnAxJhlcL4oK7F3UyyAqA/GvgrROjmtff
	jsyHO6st5pr3EMjq6bhPRyNXSrZr6b34dDoNX3ZrivSgzf1QXGNx+fIFs6C6CfzE0WdB/4c5wjh
	KBAn5kIKZhjDAx/sM/RbjV1Nn49TZMBYqrlxF/qQIXprJJ7BnXljdMI+5psMRxH6qtVTM8sYslm
	qLN1rsQHh2pX9FurXKpZNSakBCF3nM2xd94FYIgLVhY/ncHgYmnbBdZ52kMde3M39hPiQWJTC+3
	r8pcMJVtzW53+AWP+huWVul/GZHpDwwlrA+V3DJFbyw/IZMzQxFYQmOrCb+vd4z8qSh+OR8iJSz
	IPPVAq5h+2Fy72am/T7IQCYX8artQd9p0F1ODA4pw41W0vwi9NG6T/dyHX3T04/TeiH7qGlnfc0
	8mEyIu4LdzHeLVglG9k8Q==
X-Received: by 2002:a05:6870:63aa:b0:493:ab63:38b2 with SMTP id 586e51a60fabf-4a2a8b0cf44mr8930726fac.57.1791835706237;
        Mon, 12 Oct 2026 13:08:26 -0700 (PDT)
Received: from paizhang-U9.taila8073d.ts.net ([70.116.71.224])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4a6aca4711csm2166166fac.4.2026.10.12.13.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 13:08:25 -0700 (PDT)
From: Peizhe Liu <peizheliu@utexas.edu>
To: Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	iommu@lists.linux.dev,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] iommu/sva: Charge IOPF allocations to the faulting mm's memcg
Date: Mon, 12 Oct 2026 15:08:23 -0500
Message-ID: <20261012200823.699316-1-peizheliu@utexas.edu>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

iommu_sva_handle_mm() runs from the IOPF workqueue and calls
handle_mm_fault() for the faulting mm, but does not set the active
memcg. File-backed faults can allocate page cache through
mem_cgroup_charge(folio, NULL, gfp), which falls back to the root memcg
when the worker has neither an active memcg nor a current->mm. Page
cache faulted in by a device is therefore charged to root and escapes
the task's memory.max.

Set the active memcg to the one associated with the faulting mm while
handling the fault, and restore the previous value afterwards.

Fixes: fc36479db74e ("iommu: Add a page fault handler")
Signed-off-by: Peizhe Liu <peizheliu@utexas.edu>
---
Tested on a Xeon Gold 5512U with Intel DSA, based on iommu/next.
Before/after testing confirmed that the block-on-fault case charges
the page cache to the task's memcg after this change and is subject
to memory.max.

 drivers/iommu/iommu-sva.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
index 9827cb804363..9a825fac61a5 100644
--- a/drivers/iommu/iommu-sva.c
+++ b/drivers/iommu/iommu-sva.c
@@ -2,6 +2,7 @@
 /*
  * Helpers for IOMMU drivers implementing SVA
  */
+#include <linux/memcontrol.h>
 #include <linux/mmu_context.h>
 #include <linux/mmu_notifier.h>
 #include <linux/mutex.h>
@@ -220,6 +221,7 @@ iommu_sva_handle_mm(struct iommu_fault *fault, struct mm_struct *mm)
 	unsigned int access_flags = 0;
 	unsigned int fault_flags = FAULT_FLAG_REMOTE;
 	struct iommu_fault_page_request *prm = &fault->prm;
+	struct mem_cgroup *memcg, *old_memcg;
 	enum iommu_page_response_code status = IOMMU_PAGE_RESP_INVALID;
 
 	if (!(prm->flags & IOMMU_FAULT_PAGE_REQUEST_PASID_VALID))
@@ -255,7 +257,11 @@ iommu_sva_handle_mm(struct iommu_fault *fault, struct mm_struct *mm)
 		/* Access fault */
 		goto out_put_mm;
 
+	memcg = get_mem_cgroup_from_mm(mm);
+	old_memcg = set_active_memcg(memcg);
 	ret = handle_mm_fault(vma, prm->addr, fault_flags, NULL);
+	set_active_memcg(old_memcg);
+	mem_cgroup_put(memcg);
 	status = ret & VM_FAULT_ERROR ? IOMMU_PAGE_RESP_INVALID :
 		IOMMU_PAGE_RESP_SUCCESS;
 

base-commit: c233d59828627bfaab750ec5546e81970475f951
-- 
2.53.0

