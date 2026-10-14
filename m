Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0EA4A841D
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 22:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792016706; cv=none; b=EFiArRH3ZZv5N75LhgI8kEBcyMbzyBsh07e88GfNEE5vP9Vyou6oSzpkLUPcWb4tKuV07h/1jXhzlGrQjkEbFDm2DKxY+deSygd+r2two3DNXkbih07esoNK+Vr080Ja53rmYuPhBlitIbsVaFsGkAsJ4RnMZnYMq53CmUu/XgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792016706; c=relaxed/simple;
	bh=O8dVvcYZ3JjruR9AA73DXMnZbADwOxkFaLPB3KQhiSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OkZhwkSuySbFvojMadVa4m8Mjp+W1pCti4sOmJznCQwnIHEAavglNISkSvJH8Oy8Y6OwdM0TbFdSneMIV5woECRLllErWxctJpmqBZJMH0ImJzGp2hZFbPoXo3CSIgltRDhMRVpmFGQLa3VFFn/RlepEt+FG+IblNb8s6u1HC+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=tMmxzYyn; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="tMmxzYyn"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-53606d2351aso9454971cf.3
        for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 15:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792016704; x=1792621504; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=te98JzwkVTzNC8wlHAwz+oxIJRYlTan8LuvBBWzhlSc=;
        b=tMmxzYynTlaf9mtZl31RoTePpkD5WNKKdFiLeZNqB2ZYGF9l6rRVMIm+ZkTtKDAR8o
         I7ahXW4cre4unYvqhHTKD80FhQRiMsQ1Rq6fYIZVXThSofzsuDuqh0GtEVwpjPlLogWB
         cSDnUhz3B/adw0YkpT7ZriZ23+UZa4rtsOAa60qNX/AlpdqpStpJhuaafhEgRZM6jnKX
         hlfZm8yn77UDR9xf4H3EOIww2BrMukPvjp6+q1SX/l6Tq3Kyo1KkKd7g/ytx7lSZ71OH
         HrL+CUumcble30eSAkwtGhA6lEs4DxyY7kVNCGS+gMeIE+7I2zfcvYxC+6SwoZ2/aI2G
         4YBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792016704; x=1792621504;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=te98JzwkVTzNC8wlHAwz+oxIJRYlTan8LuvBBWzhlSc=;
        b=SsuiRv90KhcNLEuwNsiawVYfAJl8q3cRR7GbeTdmoa+1HZ7iUZmObYQKQvBsir09hm
         eTJGO9T8lu1qlBWC/BpXqwZXuNXgUtbORyHAgEPM9LLu6ypK4xBnC5m1B1VW/2g0l6t0
         x6CEqbtzqArJhdIJr33WG7u/kgeyRvSZ3+XlrThRQQDnVCE9pcZoOFfI1h4nQFAiH9HH
         We3r+tceQK820ppdJ0ERMGAVcvNuS2EFE4plUlSkFgcUrsIz9n6vvC2pH3Wpl9awb4Qd
         IKTYSziblAqyh40bIk/HblRG5vGlBVsk8RN6zRXv51yioKlUua1nzMfdUItbp0X0LYWU
         TelA==
X-Forwarded-Encrypted: i=1; AKwUvBwts7OLw05/Ar1dtkAryuucNb4Ji6vOiTStBexZghx1oU3U+h+7xYrd3BpZeypHcTvQ3voHPsgF@vger.kernel.org
X-Gm-Message-State: AFq9FYLnpdbIgUDVPl3fx9yl+a7XVPlXF3n+gcYGwGSBPQOfa8+S7Rv5
	s2YR+ljRRIyutQ70CoQWkwB9Mww720o0xRY0Dhj2K9mpfH6sPWAZSaMhilURaHbSp60=
X-Gm-Gg: AYBFou2BQUazfmx7VMpPS5IOd+3Xab4pOdT0N+YKo2yuUUeHmGCO5OP6eYYMbvHqfwB
	3demw6DfubART5IviIRM/hzC5DV1kpZvQCik1TvvfLSUhfTOFBtbklPlwcja0ZoW6E1q5g3fx0i
	6fH2zGnsmy1GZhgEIuOoZSxsHki1NRuilPz8egglsnWbVXb+Nn/eq+jsOHq5wifrU7HXTFOBeSd
	7BNDiqAW5t35JsiW1QvjhVFRBuFwnS+2UvDXZWowmLmQCoX2bmvZ8jufkpJgJlMrdMc4Rhnagej
	eBoAvcOBI9nKWGffNfWk3YQo2u28VdVmBTurayuj81ufzp0iUVbkFo1MpLNUV4CYxS5iv/V4th0
	hD3JxGglyQXGmwL7A82Gmy1/WEUyB7ivMK39xHiZjyblfLWrcwRvQPusiOjnCuoMrMkcHsa6M6W
	gC8TTJv8zVmjxAjXzS/kqTCn2cZZkVVPbnM/sRHbTGrdES85wPFoCX+HPy3Lct7QZNykOxvCHwl
	cBXrUDtgvN0pi+ValXB29QQCwEhTcja6gTVU+UewGiTdzdzTwtmIH/MmybzRQ==
X-Received: by 2002:a05:622a:1ba0:b0:535:36d:dd8a with SMTP id d75a77b69052e-5359fb5bfe9mr296527481cf.36.1792016703841;
        Wed, 14 Oct 2026 15:25:03 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-536128418b2sm8652601cf.30.2026.10.14.15.25.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 15:25:02 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org,
	cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	ziy@nvidia.com,
	david@kernel.org,
	mgorman@techsingularity.net
Subject: [PATCH 1/2] mm/page_alloc: detect zonelist rebuilds from memory hot-add
Date: Wed, 14 Oct 2026 18:24:55 -0400
Message-ID: <20261014222456.2318284-2-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014222456.2318284-1-gourry@gourry.net>
References: <20261014222456.2318284-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The zonelist_update_seq retry was limited to CONFIG_MEMORY_HOTREMOVE,
presumably because only hot-remove takes zones out of a zonelist.

However, build_zonerefs_node() rewrites the zonelists in place, so
onlining the first block of a zone shifts the entries that follow it
in every zonelist containing that zone.  This can cause a spurious
allocation failure for a __GFP_THISNODE caller.

For a node with only ZONE_NORMAL, onlining its first ZONE_MOVABLE block
rewrites the node's ZONELIST_NOFALLBACK list as:

  [NORMAL, NULL] -> [MOVABLE, NULL] -> [MOVABLE, NORMAL, NULL]

A concurrent GFP_KERNEL | __GFP_THISNODE allocation can observe the
intermediate list, skip ZONE_MOVABLE, and find no eligible zone. With
CONFIG_MEMORY_HOTREMOVE=n, check_retry_zonelist() returns 0 and the
allocation fails even though the node has free ZONE_NORMAL memory.

Gate the sequence checks on CONFIG_MEMORY_HOTPLUG, which covers every
configuration that rebuilds zonelists after boot.

Fixes: 3d36424b3b58 ("mm/page_alloc: fix race condition between build_all_zonelists and page allocation")
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/page_alloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 7682aecc2c075..81db19f2ab551 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4425,7 +4425,7 @@ static DEFINE_SEQLOCK(zonelist_update_seq);
 
 static unsigned int zonelist_iter_begin(void)
 {
-	if (IS_ENABLED(CONFIG_MEMORY_HOTREMOVE))
+	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
 		return read_seqbegin(&zonelist_update_seq);
 
 	return 0;
@@ -4433,7 +4433,7 @@ static unsigned int zonelist_iter_begin(void)
 
 static unsigned int check_retry_zonelist(unsigned int seq)
 {
-	if (IS_ENABLED(CONFIG_MEMORY_HOTREMOVE))
+	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
 		return read_seqretry(&zonelist_update_seq, seq);
 
 	return seq;
-- 
2.53.0-Meta

