Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079413E8326
	for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 03:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789097385; cv=none; b=p8OitkMdM08aQETF63txwYjdjgUAeGLM1LTaLWBI+Z4NI+8827hpL9I5MWfgY0Gi3VC4izZG5rF/nWYPVBIH9vjD16x+XvuI0KF80fjgmmH2LapTVEaryKFiM9NUVuZMGJc7Dom0uaHGfBc02LZjULX3ux18jgwdX20BOAsOCvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789097385; c=relaxed/simple;
	bh=UsjXmoEjbBzqbhLO/TEnWeg/LcRkT8bmjI3edxRMtz0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hIf54L7+Vj1nbNihDIC1ztTPYNrhFgaLY+rSAe1xhqSOXU14QBzf1XjvGK7N0wHaOr5TSaMqmfXuGeA0cISsInxjzgnKyb9bNnDeJvBIhejsgQAcPsMzcoyCXyjIilzWgOno4EH0oE8AiH/6gDB7mBIvLwTTwgPcqH1AR//WqgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com; spf=pass smtp.mailfrom=shopee.com; dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.b=ccvYQL7y; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shopee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.b="ccvYQL7y"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2cc891373e0so4249455ad.2
        for <cgroups@vger.kernel.org>; Thu, 10 Sep 2026 20:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1789097383; x=1789702183; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=i0Kt7XnkPOmENiinuVzqr2b19eJklmr7Bc9jhStDXZA=;
        b=ccvYQL7yR5zWV/cH4Ca1v6Wp6KXvKghh7/vyD+d3asfHk/UpCrFK99kCOvWgHFARA5
         ZvDilRDWVy70gbHsT5ntIbGzcPUMcmegbmZXmWKbFiVsp4QyBKvCK7Yk0oN/jujxbUmS
         Lk4jSB2SR8wzYkzM/CZl3b7lUIvp9T4HSvUrYbM0eTcQmp7uEOsTTsxiL1hvVFFIGjmz
         5daUROP8uCl5VvW9qwRaS6FlwhKDLmmDWDNA3DSQu2KcVSsbs4M5KOMl5dAdONZKqix9
         rVqJZUjLXK1WeZIy9AS/Y2lm1t3jJqxnTWPjIEulPKHrU62sB8KOYHGkniIJcA9UrOaL
         5uaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789097383; x=1789702183;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i0Kt7XnkPOmENiinuVzqr2b19eJklmr7Bc9jhStDXZA=;
        b=fIzpdcohbKehJHRsVS1KFRhJyQ0ORekbphUMdtxPLcw6lhpBOMd4VnU7GeykktIA3i
         K/34Lue3j6ePHy1aC0YlnboGJCPyIo+4nD5AZ+l5JK6JP6H/XZ1XFe4IZpqKlBOMLqwJ
         Ghcpbfolg6J/Lw7Na7AYykEfX9OtZLw/1Bi3WTcWOlb4Fh2IG9r2+rY1mReT0/x5KvdX
         AHFH6MWvEC4uE1eb7cJSgKK1oFk6ZOtBjOKNSoHPi9c1dLVEGStApAdraP1l/ev8Wjq8
         ChgMzwFrAPf63Sdi9jCFUJtrWxj0WfaA8Ls7PbgmcY6l/YbJ1kiiCqmkvaBrB1+RGmsG
         B0JQ==
X-Forwarded-Encrypted: i=1; AKwUvBzbB6vI3Iq6cL0t8HXe4pHEypIuF5t0xYK/uC6lkPj+md4bm4bO7L92dotDnU1KrM6iI7flOoOa@vger.kernel.org
X-Gm-Message-State: AFuF++mW1q/RsvUyb9vgrQfO2zkTV94UomDKODBFDylat3I1zz4SNiF/
	FOY3PutiFkT0oUm8NwtzFtHPqtI5/ELHTi0XNqkCUr0XMIgYd3Elx6trRi1QSAicqko=
X-Gm-Gg: AYBFou3imzE02Y5z5ZSw/lDamSZNyyfuuwWY86eCFqUjums7wYxFPTswI/RlryN8M2p
	jlPGc9Fnqj/UHmwT+ZBjdPPM2YeHMYa2wJFWnk/L8PvRHwDMQzecxMgJfIg0U0iPwp4Tzm6VPDd
	CFNMD+5wh3MiT7JTGFcpiVK5jzPThFrhDX7XNENYIpLyGDR9ysFcPhh3J0kMFZ2otUufaQKnziN
	O4g/szewtwOy7BSobd4kqrxnaJgZkYWAY6GMRLwmqSHUTbuc+XYMGc9jf/7ZRQgHD+1VhFkkz89
	0hEbm4VSShgMCp8+snA+eupc4nOZt99WikDxuaxuAqnQtJmtF+/Uz4kRDrywRZ6k+LkfV9hoabR
	aq1x8A6TasgSvEEF322PoGBXJCF1cEMLUZvPfV6GOM2hhgbDcOP2dUXek5MpYcjLg2bTfRmDH8M
	NRZb7I5SATSTu1S6/W3xCNWX5QUyYNSGKUWfc0mUJ4t5cX/GqWZtIIS3fHaLrmTHvlB0N68y5OV
	VAiDr57jgyRU5y7hrxc2tRiy73WdoSI82H2Gmx1Kbg4MC6tdJj5ebnlQ5cKblkL17u2zY5Bz0GH
	6Dkvftk=
X-Received: by 2002:a17:90b:3a44:b0:381:cef1:11ac with SMTP id 98e67ed59e1d1-39d9bd923aamr3589455a91.10.1789097383267;
        Thu, 10 Sep 2026 20:29:43 -0700 (PDT)
Received: from LPMV6FJ9FM.cn.corp.seagroup.com (static-ip-254-9-104-152.rev.dyxnet.com. [152.104.9.254])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d9b2ae3adsm523859a91.1.2026.09.10.20.29.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 10 Sep 2026 20:29:42 -0700 (PDT)
From: Runli <mingyu.he@shopee.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosry@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	littleswimmingwhale@gmail.com,
	Runli <mingyu.he@shopee.com>
Subject: [PATCH] memcg: keep propagating stats updates to ancestors
Date: Fri, 11 Sep 2026 11:29:05 +0800
Message-Id: <20260911032905.63683-1-mingyu.he@shopee.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

memcg_rstat_updated() stops walking the ancestors when a memcg exceeds
the flush threshold. A concurrent flush can leave an ancestor below the
threshold, so the early exit prevents it from receiving further updates.

Consider root and leaf on a 4-CPU system, with a threshold of 256.
CPU 0 is flushing another CPU's stats after CPU 1's stats have already
been flushed. The counts below are shared stats_updates counters:

  CPU 0 (root flush)                CPU 1 (leaf updates)
  ------------------               --------------------
  clear leaf->stats_updates
                                   add 64 to leaf and root
  clear root->stats_updates
  finish flush
                                   leaf = 64, root = 0
                                   4 more batches of 64:
                                     leaf = 320, root = 256
                                   next update:
                                     leaf > threshold
                                     break; root is not updated

Root remains at the threshold, which is insufficient to trigger a flush,
while further leaf updates keep taking the early exit. The periodic
forced flush restores progress, but until then the root's aggregated
statistics can fall far behind. For example, page cache grows at rate of
1 GiB/s, a two-second wait can leave the reported usage about 2 GiB below
the actual usage.

Skip only the flushable node and continue walking its ancestors, so each
ancestor can accumulate updates until it exceeds the flush threshold.

Fixes: 60cada258dfe ("memcg: optimize memcg_rstat_updated")
Signed-off-by: Runli <mingyu.he@shopee.com>
---
Testing:
Based on commit 893e11787f78, with and without this patch,
  using 32 concurrent instances of:
  netperf -H 127.0.0.1 -p 12875 -t TCP_STREAM -l 60 \
          -T <client_cpu>,<server_cpu> -P 0 -v 0 -f m -- -m 1024

Both netperf and netserver ran in the same leaf memcg, directly below
root (root -> leaf), with memory bound to NUMA node 0.
Each kernel was tested for five 60-second runs after a 10-second warmup.

Median aggregate throughput decreased from 107.26 to 105.23 Gbit/s
(1.9%) with this change.

I think fixing the correctness issue is worth the roughly 2% throughput
cost.

 mm/memcontrol.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1271d390b617..4600d9c9244e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -729,12 +729,11 @@ static inline void memcg_rstat_updated(struct mem_cgroup *memcg, long val,
 	for (; statc_pcpu; statc_pcpu = statc->parent_pcpu) {
 		statc = this_cpu_ptr(statc_pcpu);
 		/*
-		 * If @memcg is already flushable then all its ancestors are
-		 * flushable as well and also there is no need to increase
-		 * stats_updates.
+		 * A concurrent flush may have reset an ancestor's counter.
+		 * Skip this node if flushable, but keep walking the ancestors.
 		 */
 		if (memcg_vmstats_needs_flush(statc->vmstats))
-			break;
+			continue;
 
 		stats_updates = this_cpu_add_return(statc_pcpu->stats_updates,
 						    abs(val));
-- 
2.43.0
