Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C3C190462
	for <cgroups@vger.kernel.org>; Thu, 12 Feb 2026 04:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770871892; cv=none; b=dZeTU1D66x+fazcXa9H8hkoc3Rg7p+X8GGE6VBn1PgWGyVhJ7DrD+09RG80H8+drdS4oQOL4bmPCqRQ0EX8kcSe+YK1MEVthxGXlbRXyZQa9g+QfcghLmBIgZ+qXTzChZCDGM8Q6plqgTjluXJHskcKqDFAJwRczJFpFs+WF+eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770871892; c=relaxed/simple;
	bh=8D94FTU3J7WbTPERy95OWvMbWad1oKdsojUUHZ3Rmak=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q3cvsPaqhoPU9J2qTinPwunUixJu1VSDN+wHPHO29b69lhq8LjJD4ejDbhhlkQLMOOXHjvMMzmX9PzthgeBjHQwxEZU/B3Qo07ni1MN7d/4zMC6tjFJp+U2wB0ON8S6IX3xNqtmy9JFXGSCm8J6j82I3Fmj7MpS2e2fDBKbRk9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UIDwZgpG; arc=none smtp.client-ip=74.125.82.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UIDwZgpG"
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-2ba94dbf739so2640689eec.1
        for <cgroups@vger.kernel.org>; Wed, 11 Feb 2026 20:51:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770871889; x=1771476689; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qoLkvcAtx2WTrKtSPpoAsMeiJqeenZRH0jOzHw3uF5Y=;
        b=UIDwZgpGC/4+mkYdO+GsY7hYvx5TmvPNjcQSJG6zDQYE2T1LZs3hGCuD0VSeUKKxv/
         x5jnUATjEV71mGb+Whvmmdi0rQj29T/KVkzj5bHfXeH3Bv/ETQ+pSSq7jckzmtMTnHRt
         UvEkxYL6lWYdHQPdoo+2fx+XZjMGnxnUeNz78WaHWogvhLi/8hZbDG3o0BKe2leuu/xY
         peVkXyxiCJQ3ufNQn2H+Sh0R6Fw3H1D7tndoH+hgk7tU4Mp1QM8X4yEHaLRr8nWI4lnb
         vCChWX4iMtcJw83KQhkgz3qtcoHLfN5cAN53gixRtHl3y8SeYDp70/xwnoWHx9qx5TDG
         MHWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770871889; x=1771476689;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qoLkvcAtx2WTrKtSPpoAsMeiJqeenZRH0jOzHw3uF5Y=;
        b=nio4fLP8miNVCkAUU7hu0KdhDXXiMTFVv5k4Ss9qBnplQ/YcOaWyLd0l7sSsEO72qL
         VzuSR12wYDF0bB9ciUPdf1sXNYk8WX+7mMnURTMrHIeVDgeaSq5vw1NnOjYK0R41nIPP
         NSljTQAZSZJup9ET3NuQXhDvzQHV2X3/gWlqlXLllQz8RczR2evvuJh/ajhgJXNV+992
         6ZKz0i1hvO8C+HDWyjRN3krXRYBEbikVBvDKUHDh//CgJ1SieIMa/mEZo6Wp16neT2we
         BDBc5llG9Rjo+1l1prbLwHuSo84WLupmD47e1ej0OYA5a4Hf5Ex10InWRju4vJvSmb5m
         d0XA==
X-Forwarded-Encrypted: i=1; AJvYcCX0ORzF1qw2JtrnjAFv/NKK9xPjtsFr99Ru7wV6wvLCM9qdJ3XbHJeese0gD1yPuOtSoUN8s9I9@vger.kernel.org
X-Gm-Message-State: AOJu0YxfhbWY/gzmL3yKa6c+vam7/VXliXqORo91HZAtdTboktTwBN+N
	4a9bJ+d1TKblTnCr6qneTevCY8o+jeZGKSKD6SKKzZul7uEHh7FD3OkK
X-Gm-Gg: AZuq6aLAr1dVLVGd+oLMt/YQkrdoQy+A5HndGo3W2UYyYaq3sLwokXkqkkdms9pXhfV
	OGESxAsRfpvdmlnPkXeUyzeKJHPoyvuFP6ClFK5KcS4rsjYQ6yFtMz7TP5D3yuwwFfdihpVofPv
	Z4o8sdyvrraKTgHFPSZzFMquM0gz22Ao34BKsJ7XlfohLF6FRjl7Yf4fN9PAMx7HCatnXxmHCbG
	IJnySOuZMaiqCw1YpyfOpwGUzd0bR0r6+swdO9JZ30PUpefqbMiAIak9lXGkainoH8GrdBO95s6
	78Mv4u9W9jCBRbmDb+HGHn3ujzMEjHcDSEYEOIVMvsAmu9qDAFFrqriyWooqjvU1M1vBR14pZnq
	//rVgA3q+mWIo8WwTcpIx4Y4TKm/52+lEOnZ99T1WV/uqgfeo61F59R50nJzqMk4LQnJQ+pBMtG
	/baxgHOj516UY3GPyTwFw7IXDJmoTlc327HK7sQ7I7JBDGo6ZCgA==
X-Received: by 2002:a05:7300:1907:b0:2ba:a3f2:958c with SMTP id 5a478bee46e88-2baac4769bfmr331153eec.0.1770871889305;
        Wed, 11 Feb 2026 20:51:29 -0800 (PST)
Received: from jpkobryn-fedora-PF5CFKNC.lan ([73.222.117.172])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ba9daa6151sm2878699eec.0.2026.02.11.20.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 20:51:29 -0800 (PST)
From: JP Kobryn <inwardvessel@gmail.com>
To: linux-mm@kvack.org
Cc: apopple@nvidia.com,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	david@kernel.org,
	eperezma@redhat.com,
	gourry@gourry.net,
	jasowang@redhat.com,
	hannes@cmpxchg.org,
	joshua.hahnjy@gmail.com,
	Liam.Howlett@oracle.com,
	linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com,
	mst@redhat.com,
	mhocko@suse.com,
	rppt@kernel.org,
	muchun.song@linux.dev,
	zhengqi.arch@bytedance.com,
	rakie.kim@sk.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	surenb@google.com,
	virtualization@lists.linux.dev,
	vbabka@suse.cz,
	weixugc@google.com,
	xuanzhuo@linux.alibaba.com,
	ying.huang@linux.alibaba.com,
	yuanchu@google.com,
	ziy@nvidia.com,
	kernel-team@meta.com
Subject: [PATCH 0/2] improve per-node allocation and reclaim visibility
Date: Wed, 11 Feb 2026 20:51:07 -0800
Message-ID: <20260212045109.255391-1-inwardvessel@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We sometimes find ourselves in situations where reclaim kicks in, yet there
is free memory available on the system. One possible explanation is that a
NUMA node under pressure has triggered the reclaim. This NUMA imbalance
scenario could be made easier to diagnose if we had better visibility.

This series aims to provide that visibility by accounting for the cause and
effect of the imbalance. First, the addition of new node stats allows for
tracking of allocations done on a per-policy basis. If a node is under
pressure, these stats can help reveal the cause of how it got there.
Second, the stats associated with reclaim are changed from vm_event_item to
node_stat_item. Having the pgsteal and pgscan counters tracked on a
per-node basis reveals the effect of any pressure, and allows us to quickly
narrow down the affected node(s).

JP Kobryn (2):
  mm/mempolicy: track page allocations per mempolicy
  mm: move pgscan and pgsteal to node stats

 drivers/virtio/virtio_balloon.c |  8 ++++----
 include/linux/mmzone.h          | 21 +++++++++++++++++++
 include/linux/vm_event_item.h   | 12 -----------
 mm/memcontrol.c                 | 36 ++++++++++++++++++---------------
 mm/mempolicy.c                  | 30 +++++++++++++++++++++++++--
 mm/vmscan.c                     | 32 +++++++++++------------------
 mm/vmstat.c                     | 33 +++++++++++++++++++-----------
 7 files changed, 106 insertions(+), 66 deletions(-)

-- 
2.47.3

