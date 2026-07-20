Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD561481644
	for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 19:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576128; cv=none; b=hBr1ki5MksEHeBTVGMJLGyj0u9ERjyd87AbOGYBeoDs8OTM6TMmECLSr0YJfDkSbUJgz5rujUpvytshtGeCa5z+Zg3tSb9WY6wlFmYU4nsBRI/UBEjqZRG0FvROggWTg8UgC7xypRTDEDKoDD73Vm+7+H8YgI4WZXAc7eYjzf+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576128; c=relaxed/simple;
	bh=AclVB29m5XEXwT6jfLm+y0Vje/ATQlFgKmkw+sbjY3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DOABTSn9hPfEBZemrnsHh7IUezs+QEgyt4M30GV61ufLjEIfMVQcf4KQdMNpwH5q5KFKevDw1xI9RDuKY8RFVynD+99Ja6QpZ2KSAIaQeAngnv2PYAOBS8UlEPKI7++iY+yfnZeXOXYAAHQKCF7G7rwIyIiUddLr8jaInuGvyfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=KTYLBPs3; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="KTYLBPs3"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8efec2c28f8so47236596d6.2
        for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 12:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576123; x=1785180923; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v2LDhxlVOpgNtSXDCdv8imM0ubGsvF9EJ4oiPoX2j2c=;
        b=KTYLBPs3dWcRB5tNY5Y315YJNYwSMrSW38ozrn7zBlvcl5Bgj0pNovXwYuhmdviEr6
         vGvh5Tm6m6ydUQi82zIG49v7mWgnbI4X0h3X9mabjFu39jmqmc0ad6N6+0VTgyeMRySg
         U67Thqs1ToMZc0ZR+8TgO8LsSqcKGdmBEkEQHgfrraLsi0CXj8Ba77QZxDY5AKvlIRFi
         6q/dihXzF+eQ9FAgtleDsSd4cK5HY0uc5r/y6rh1gmcA1PS8AAV7YHcb3xRC5QQMheCa
         vFx1oCPPO8nV4G83ZDlOcBlYxLNa8TfGyggXhkeXkCtRXY8EycNoBEI8uEixfJ4mDjdy
         lU1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576123; x=1785180923;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=v2LDhxlVOpgNtSXDCdv8imM0ubGsvF9EJ4oiPoX2j2c=;
        b=Z9QURniKZ3xQqLrATBkZdh3zcVxPPAk64tqAXiw5phjJcuDQdcq3M21yNQ6qJTLMD9
         k87I1O38ab3bPfuKhLsrLlpzXONIQP+d+DL93gpp5NRJ469uHYa5IqQ1vhcCxaCuf6CM
         BTIZjLgf5VSADDkSIkiWfNKKvO0ANWlgEzgKwqpuhOzqXUQkZq0tWpnsfr9Xkn3RQNbN
         ltB3I7oEzSdjCKxdxKZHp97Gy7gZQRCsg2V4PAWQglNTdfPqOfe6EiBJ1NCh5mzj8/fp
         HxiuaBJIvVu3OBhOeXM7CFoon/FeB+dQVXs9w03ggT57XnWZo4h8IdO18LdQvYCyLIAV
         V8cg==
X-Forwarded-Encrypted: i=1; AHgh+RrUs7FKZCKyeite6tTczGPDf7SOi38ObII3lZAkpwAaLTkKzhvoq1XTdkLMaRUBe1VsNcgSgZkc@vger.kernel.org
X-Gm-Message-State: AOJu0YzCqWAUrf6xhSvAjs0KIyAQrXJw9qJTWmRxyVRsWDdB7MkgfXYL
	aT7lk9kQ/CTGYhtnqsL8W1DkO5GgpOYyGQ9d8tGQ93bbCmTVzcCa4HAQgjDl+H3E3qs=
X-Gm-Gg: AfdE7clDgHIkJYK31cR7MOPeSbcLm2zkhP4h+a6745OBfdagfFB4xUe4GgXqgFLD74b
	WmkncwrLQQ4KTudvFh1zPIHdh7W8qSAUEobPoe5P+yhqWwusazC80H8aFicYSoTaCdtLNMkymNr
	4G9FE0BYSuYhHf2un5aoL1rKb0ZfFZ7LcPH2o510BngtcvO5FqOhB0dngEWs23IcHpT8cE+94kw
	sDhFSP/fsI/3k2pZ9/1xhzGkLcjC9rXB+Odx5bggZebJ2XW0c0CT0P/9WsAt1EHJs0v8Kf9Eag0
	oWC0gujM+GpTtGG4kupx56bchkyxJViUXAbr3Y0Kdr5F34RMMbj/Zjjh0KQ9QXJhedi8cdEX/iT
	X9LnlKv6Jkwtqz+rJuqsy6OsXcZ5rN/XD08DTDc9nu6jei1VYtlNSlR0WPQnH9fyiPKIKolG5D8
	ITE3zFNiBfn/hk7ANpvWcp2Wbh8jBmcrGJfEboAg7VbRm6ey9RcWQ9nGgwZ20RGBagANH/aZR4W
	w==
X-Received: by 2002:a05:620a:288a:b0:92e:f3ca:2ec8 with SMTP id af79cd13be357-930b3e4b8a0mr1508481385a.19.1784576122786;
        Mon, 20 Jul 2026 12:35:22 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:22 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 17/36] mm/vmscan: disallow reclaim of private node memory
Date: Mon, 20 Jul 2026 15:34:11 -0400
Message-ID: <20260720193431.3841992-18-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Private nodes do not support reclaim by default, so prevent all
reclaimers from operating on private nodes.

shrink_node() is the common chokepoint for most reclaimers (direct,
kswapd, proactive, mglru, etc), so it's the best place to filter.

DAMON's proactive pageout bypasses shrink_node() entirely, so we
disable DAMON in a separate commit as its own discrete service.

Other reclaim entry points are already covered - e.g. MGLRU's debugfs
interface rejects nids that are not N_MEMORY (N_MEMORY_PRIVATE is
mutually exclusive), and madvise pageout/cold skips private nodes.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/vmscan.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index e26c6931f5fde..86b2334c23b98 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6141,6 +6141,13 @@ static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 	struct lruvec *target_lruvec;
 	bool reclaimable = false;
 
+	/*
+	 * Private nodes do not support reclaim by default, filtering here
+	 * captures all normal reclaim paths that may attempt eviction.
+	 */
+	if (node_is_private(pgdat->node_id))
+		return;
+
 	if ((lru_gen_enabled() || lru_gen_switching()) && root_reclaim(sc)) {
 		memset(&sc->nr, 0, sizeof(sc->nr));
 		lru_gen_shrink_node(pgdat, sc);
-- 
2.53.0-Meta

