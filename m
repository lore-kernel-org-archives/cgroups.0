Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794275640;
	b=wbNCP4FpU0elz3ad8+U84kiefgYYQP92KyX+ka+lGowRVYIoT9hExuhyt06uGD+uKhlz
	 SuOCns0flIP1UTc1YYUnpVzUJKqEnkjgXW3M+fk9DGCTPQGMCelQB8syo4878gwALK27u
	 y6w7VHn4x2I3gIwBXkIulKZHW5aOh9gB7ouie/OM+VORmK9jzvMcdirXckqX4r2GeLQdV
	 6aazE2aqsoyBzHqNQrq53qVWbC2j9Gxlfa31/YLrnicBRch7tmfTqitSnmcVZBUnhYzSV
	 bSzX5lFnX/LFWuFWKmuW19pkuSY+ZH3nG2bqFGDcaTz2z1E0UaC+TdiNRt/RDhZ2Ozg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794275640;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BHlakyrx19DFI00OyTV3/5itJ6vPo7FNJRTP0VUFhsQ=;
	b=nIL+kLUwSo83MeASetrNI87vuRZ76AWhJdDhBOSduoJuj2rawRScI8sXxTNbg9MDbkFG
	 zKhWnMW/cd3kyRppZts0a2jUkbZSONAB0XKCXUu5HolLcdRXhB7qqveDOpNM3opSsuCOv
	 VGg2jEI6ZwdvL0Xkkey7sAK1XTBTv5chTCfiRC5bROeoG26+4N+nRZjYNwyQlCMGRpWOb
	 DiPfaVHAs1lz9GrL+3AaBeHZSIRj9cybIgGU1Vvuh4nK71sKgDnuXBaT23nZJ9q2YPOiU
	 hpbgwvEvaCo0Pc6vKw3llCi9RfR1ePvrOfv2OQfzyBijCXUsqtx7S8QWlJtIXmNtYmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XRFO+Qln;
	arc=none smtp.remote-ip=209.85.216.54
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F42606A325
	for <cgroups@vger.kernel.org>; Tue, 10 Nov 2026 01:53:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2F42606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XRFO+Qln
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3b12cb3c37bso777172a91.2
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 17:53:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794275639; x=1794880439; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BHlakyrx19DFI00OyTV3/5itJ6vPo7FNJRTP0VUFhsQ=;
        b=XRFO+QlnUqXHx9l01cCZXiAfGrvO9X/kE3tLXT13QI1/Qvw3orxZEUOIOSd21N757e
         kQjB4zcMy0Tah2sskZBUpYJgoAOrTmCsGVZdr6KsErCpzyANtybRU3hKLBXS8F9+qMwO
         Qi3lwhvt2+qFxK4P/BRz/3L88KxyluC6evvXOTa9lG06esb7HFntu+ys6ui2O1gKoPbY
         vCviFhuPDytT1V+M9CPcsyOCwZYyGbQWE0rhhmsdAI9ebsAfe7o2RGXJkiJcuruTnior
         eXWpcw6/1MjN/1oWsAdwPgWluT1y6rBYtEsKTwzrePniOfQR5fYjTEJhMvjBgLE7Bk9u
         N2zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794275639; x=1794880439;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BHlakyrx19DFI00OyTV3/5itJ6vPo7FNJRTP0VUFhsQ=;
        b=d590wyy3f7M2K1eooitgB/Rj5QP6XiDkDLQ/8dnDhrAJmBmWr9zvYyzIY7arCTUH1b
         8YFjtI7W3mvf3BwIchhRtcHTjaZfVRDBFsUXXv4Jdw4o5TRe6hJ+Qxl6ks784a4fwsnb
         am7VGXyJtn30wpEr9rBwjCWqbg0VrOfD1eL61gnTrtTduE38Q5m5KcyA/2/1bV+1i4BJ
         O21r4kRVHx4oPjvgUt3RHaESdxyU4xjR36La3X5A1af280JNClnjgp0KCZFyp9NQ5TUs
         qv6izaC214Mn8u0vH40XWSCWCnQpI7rnBVgM9wCLdxvRgNJjKEbZKiWBr8rfmxHUZ4Vv
         n9JA==
X-Forwarded-Encrypted: i=1; AL+hErEsaP3jDbUX3bhHoGslHivZZ8dDETgOHMvrb7WGo/XSM+ZLqXoyL5NZKEwSezjFHcAuxARVJJKm@vger.kernel.org
X-Gm-Message-State: APuU4Z/DAuuoFAOiBNnV+gD/BH+uvRnShG/BM2tduKpnSPMK7afXkNMI
	XINcwf05AUzbUrBteDPV8LZb86pPx+HP9tSAIfuGsPiuPS61JHqWqeoN
X-Gm-Gg: AYBFou1EGPTdFCvSQbi4eBpupAOMqDZoJi7Y/N13OwS9CWtfKwhui/FbHOydG9RmHLI
	HFHtm1BAEiSNMYwByLPgM+lt4Ow+9YkGfJ5np+XUtO96/bCwIipUe0pKxz8YZFyVclgPIQ0mbWc
	oyGT0rl5D/zuvX1M+cz3wCxeHuMIWnUD8dOXUJSIqDvmj2RoAWBghISqIcsZYFWPDfHcUF4HW6t
	jmo59nzyMDFLdkdY02aXpLQHPH5mlT9rNLZkr/a01jF5lOLw1Is6Bq0OW1P3WNfw32hRsRTjolZ
	1+bS1E5w2NBAZgykNrB9BGo1vdkBNVYMhpDl//NJIDkMTQqgtmtM+8W4dYsO4v0xID+hBi9Mq/i
	spX1on7phIsThnTTyrFvyF8RZxqtJGjlETKrxE3KJNEgUJDYNIKeVFNtoWunw/dEeDaHFecrsEA
	JsfXS0SOHJNuDjm9O4t8CjWp0NmpRX9QtZNBFYnF2ZmrlVuiQOR2nHVuVFWB+vbAu6ar8sahTvo
	CLDTSk0zO+gL99GANPYhyo6iJpSKv1QMFNQNZtQxxFfAW1woPSE0IMAyw3rXc4N89VJy6lQu7Wc
	HgWNv5z/p67G1pNRTuOmS43GRZaRZNORy1EpNwA8CgyHdWhagnoWoljWC4E3xDLm+KM0O2a3p1V
	VrCFoZOIwPR3YT85fQ57DlVtYpW4=
X-Received: by 2002:a17:90b:2d8a:b0:3ac:ea3b:f28b with SMTP id 98e67ed59e1d1-3b166ceb599mr1275045a91.24.1794275639153;
        Mon, 09 Nov 2026 17:53:59 -0800 (PST)
Received: from localhost ([2a03:2880:ff:45::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1690f4733sm552422a91.3.2026.11.09.17.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 17:53:58 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org
Cc: yosry@kernel.org,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	sj@kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev
Subject: [PATCH v2 4/4] mm/damon/core: use node counters instead of flushing the root memcg
Date: Mon,  9 Nov 2026 17:53:21 -0800
Message-ID: <20261110015321.611093-5-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261110015321.611093-1-joannelkoong@gmail.com>
References: <20261110015321.611093-1-joannelkoong@gmail.com>
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

damos_get_node_memcg_used_bp() flushes the memcg stats before reading
the LRU sizes of the goal's memcg on the goal's node. For the root
memcg, that flushes every cgroup in the system. The flush is not
ratelimited, which means it happens every time the goal is evaluated.

lruvec_page_state() now reads the LRU sizes of the root memcg from the
node counters, which are always up to date, so skip the flush for the
root memcg.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/damon/core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 0a056949604f..14f2a36c1025 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3057,7 +3057,12 @@ static unsigned long damos_get_node_memcg_used_bp(
 			return 10000;
 	}
 
-	mem_cgroup_flush_stats(memcg);
+	/*
+	 * The root memcg's LRU sizes are read directly from the node counters
+	 * (see lruvec_page_state()).
+	 */
+	if (!mem_cgroup_is_root(memcg))
+		mem_cgroup_flush_stats(memcg);
 	lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(goal->nid));
 	used_pages = lruvec_page_state(lruvec, NR_ACTIVE_ANON);
 	used_pages += lruvec_page_state(lruvec, NR_INACTIVE_ANON);
-- 
2.52.0

