Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721BC2253EC
	for <cgroups@vger.kernel.org>; Sun, 22 Feb 2026 08:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771750163; cv=none; b=AcIDXbp570LjmE+auHHOC8wNg4yK8JB8fWXxTH74OhZorjaT4OY9stjXrPnCroyO1FMpr3yjLHg7/oH3eQYyRAEzbgHUB5VRkE+Kj5Yxmgz5E2jjmNp5xuVGEKxIn13eSIVK7ILm2p9UkjA+lHvkVuViMp0oP20OH3s2dhCXdNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771750163; c=relaxed/simple;
	bh=jf3GUNQpUN4vGLRS51AgKk9FOMZj8wdoohrYEV9xOxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u24iZM5NgzAF3bK0wLXyuXetSzg99NaYWf9XBX4Czy6o4TayJ5/x09DTWu5R7nK1UU1l1cHCaOXTb2ow+MOCKyYN8lW2tqnCniNX+ZBOTzi+knbdDLolOEpstu+izVLgQw+64LqkCP1wr8jOFNY06mOqq1LTljRwB2Cnohc/rqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=UGeeUTJw; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="UGeeUTJw"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-896ff127650so58107146d6.3
        for <cgroups@vger.kernel.org>; Sun, 22 Feb 2026 00:49:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1771750161; x=1772354961; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RDpP2syoLUpQf1rGH2VYZ/yb+Dz8+coRcRrod2PSFvg=;
        b=UGeeUTJwiQER+0ro1zaXxxycPonoYrXk+jz/qtSww85AwgOw1cjnVqo2Yx4Q1tVfyS
         JNSNkQBHGkacb6POOFhrc5ee2k8bmY9nlP4zm7KJTCZnHtqU/6YcPI0f/iHkz2RrRWve
         zAeFy3xUe1D1zEky+bRiJRGvY6c++Z3iHDMp8hr6juGPOqviCBaiSBNj6ceq3NnHN0Pr
         bxQ6Aduefo49DvephWs+JsZx7KNy0/nfghuFDYwUFO6YUAbJ4tv6oJHseIGEYbVXSjUk
         yKkYx4SENU1M2TCFCm2dRvqKTOrtZEaI6zCgikqQSmTk5ayuSGBkwrq+TOiofvq9mFvi
         6YOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771750161; x=1772354961;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RDpP2syoLUpQf1rGH2VYZ/yb+Dz8+coRcRrod2PSFvg=;
        b=bXQAREgBmYMiIS0v8u+AlNRvNET6HU8MZo1K4jgs47ttJ0b3XckFwLmnVYbnAHwTPk
         HN4u8yx7GIYVI4aCyGW4SrG0wJrt3sAx96OfDB/XdBHUzXO0y4T2eb5edcQH+GUdtWMX
         0BYAdNXDSj+KuEEiP8Lt2/3v+ZD5m4IwioAyxrQ4NeTZv5YT4lPRnnFEEbSf8+UxRicU
         T/pU6W+OUYWka2sPpFv4sJ38AUpKkwMhh4UxRoeOXmtM1CUYeDM/QA8UTuzlo5zHeyaX
         58dSPRJ/KFhWFI/azbJ43Wuqs2VDi8WP6PJsgTvo0Yf/g5ZWoMHpBaNyON8Ho1jAaa1f
         XN9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWnKvD192eWl5+T9ybw40R6RYHhDoncLUKEjQ6moOH4g2hoqQmPDVxZzMSauNEl/Tg951WuBxAl@vger.kernel.org
X-Gm-Message-State: AOJu0YxFu7BarFpN3AstJhik5jzUl6ABGYByChxKv6DhQXC13RwN+r8S
	uoKVhGnteiga7tc2FO5Yot357H8wFNSqLy+ETUT7Enids59VQhGVqQbdTft4twfN+5M=
X-Gm-Gg: AZuq6aKdrSccuHEpkjyycovji1rZzO/a+oxePDntCw3BYnf3qZZA3wnh9P78/8XrI4k
	29CmshanzQeyW3D0U+5OEa4rGvtAyN8u0tIBkCiS0NQAYLlGnbUlcigybC5cv1WhEGHvth+pcU6
	YxJ5XYOtXv7CgdBh52Mybn5hJV6bo4VHUWDz7jWMSCA5j3nlcR/Lln900jyfkLHjpTcKnu0oV+m
	WbsjkZjRtDLPnJuNx7Y87lv83+K61GgD6/1FCT54RM2X7T1fttYDMyJQ1NCN22nBliUEADfMhqp
	uqXRrHIWdja6dHmwE8zxQmT1XZW5eB+QyxoMa/7Vns064lXybQSEp+xAGJ9YnNlmY8gLnjLdJHU
	/n3JsHZNeqD3cTzbe05WJ+PimiQaN8jroOrBZvf+ACd02pMqeAAzgxJS9dPuuJKg8aFSPx3hlKx
	Q4/Hckskr4Lb2aTYM0W4Xhl0gQ1kexhLCWcsn3E1euJKS6m6c+1voLKNxwfo3rJogwRC/bhqEKO
	HLoJ6lz1lqQuhQXCAm5Ia0dkQ==
X-Received: by 2002:a05:6214:c4b:b0:87f:fecf:17b2 with SMTP id 6a1803df08f44-89979db90eamr79397046d6.64.1771750161345;
        Sun, 22 Feb 2026 00:49:21 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d53f0fcsm38640631cf.9.2026.02.22.00.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Feb 2026 00:49:20 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: lsf-pc@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	longman@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	jackmanb@google.com,
	sj@kernel.org,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	muchun.song@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	jannh@google.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	pfalcato@suse.de,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	harry.yoo@oracle.com,
	cl@gentwo.org,
	roman.gushchin@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	zhengqi.arch@bytedance.com,
	terry.bowman@amd.com
Subject: [RFC PATCH v4 07/27] mm/madvise: skip madvise for managed-memory folios
Date: Sun, 22 Feb 2026 03:48:22 -0500
Message-ID: <20260222084842.1824063-8-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260222084842.1824063-1-gourry@gourry.net>
References: <20260222084842.1824063-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Private node folios are managed by device drivers and should not be
subjectto madvise cold/pageout/free operations that would interfere
with the driver's memory management.

Extend the existing zone_device check to cover private nodes.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/madvise.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index b617b1be0f53..3aac105e840b 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -32,6 +32,7 @@
 #include <linux/leafops.h>
 #include <linux/shmem_fs.h>
 #include <linux/mmu_notifier.h>
+#include <linux/node_private.h>
 
 #include <asm/tlb.h>
 
@@ -475,7 +476,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			continue;
 
 		folio = vm_normal_folio(vma, addr, ptent);
-		if (!folio || folio_is_zone_device(folio))
+		if (!folio || unlikely(folio_is_private_managed(folio)))
 			continue;
 
 		/*
@@ -704,7 +705,7 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 		}
 
 		folio = vm_normal_folio(vma, addr, ptent);
-		if (!folio || folio_is_zone_device(folio))
+		if (!folio || unlikely(folio_is_private_managed(folio)))
 			continue;
 
 		/*
-- 
2.53.0

