Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794616205;
	b=wy3S8zqvWFt+puxZWV7ld9KH4qAavvCwe2ZlEml2wG5k2/dVr89II9pIvjAr5p7mb5F0
	 h8tBLQP3wGvUyrRg5BLDJ/twSqsgIEYKQABrYGGP87GpDxKq/2LB7AicjO1nilOAu9I2V
	 xSIOuSj4zFasuzlKkD94jrcQbZVSvq/+16BSiGd8VGPfM3oIvsk4ixDw332hp0RUCu18z
	 K7I1voMo+mbbWzIr5u/9xlJm6F/A2fSFnj1jpluGbGFKGKPcm/mMIZf8rVluxtbEacTWp
	 nkDANf8e3bBj4F0keeC8Ps1SHjVEJBAbKWPoGCQ8vQmwXN9WW2XWeSYtC7AnJb1N71g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794616205;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AolziNO7wrlcNMetD7JvJr3jJHx3WRU9EZSr3HZdTJ8=;
	b=xZlmr2TrQ6lQxerULUvZdKLiySU2VyvdnSLvRsjXx3riKTxF6UB0P6iFdvFc2yo4xdZB
	 2yqz+EvKwFS+DF/xPBYrcsOC/3XwkLNdKzz9/+5ewmQLFW7ZKHIx20lmJ29kIzdSi9jZ+
	 so83mddXz2bJ/dblvDvElVcR8UW/KpC4XX9wUNOOG6GhBEFVU7nVobOz43mgzuLfyl/sl
	 ynjd5ztVGLhgRMSjQZwlMldYvEIoPxZK4SzGsmH+uIsFg4TiY7uuy0bSnwE8aT3ytCFMr
	 X6hXCnzWH21E97DJGXIX/I56wlDg+d2kSvbKRCrZOnC+Ezek3WDcz3qNfDxqgdBFfzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=K6oDv0kR;
	arc=none smtp.remote-ip=74.125.224.44
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF0C606A32E
	for <cgroups@vger.kernel.org>; Sat, 14 Nov 2026 00:30:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6AF0C606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=K6oDv0kR
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-67bec5dc8d4so1046752d50.0
        for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 16:30:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794616203; x=1795221003; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AolziNO7wrlcNMetD7JvJr3jJHx3WRU9EZSr3HZdTJ8=;
        b=K6oDv0kRAbUHNXnNHYXfSocr/aH1yru4KtdgSDGpd4G25ChwQPLaBip6EEkUK3PG1d
         TwklkYOLr83QBuPsODnvfr9lSCB9jSjZcGMb9TEhiW7f3S6p62WUYwpsaU62Rb06dA7Z
         efn8hUXvuLFDhde/3ve6lbQNbN/GkU+WzxyTKISWlL8Lo2iSTczNXrtfByxGBICMKj9E
         HtDz/coempXbDvXf4Ectl88ll5iyA2NlCgoRH2yTbpiCQ2zx4R+FT26aymuIy5TU9+Kw
         4eOI+hiT6M5/OxGuxsEaeoO6SboEkKT3uqhMjmGc/YvA8DkGDm2m8ExwmRJ7flDF1JX/
         sEiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794616203; x=1795221003;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AolziNO7wrlcNMetD7JvJr3jJHx3WRU9EZSr3HZdTJ8=;
        b=aFBmxySGamHbyMzC2OK3/cjrMWBCQf8ydlcSdKYyt2/8U1kk3mhn1OZ/oWmEy1LwtO
         MAI54bMMx7KB+QeblFgd7KOEL/o/NzoMgzvKDvNWVBTbMdi1IWzrhMV+5NEtkvTRZyWi
         aOv2VTVbF4ge3nVuZbQ7K2BIL/AltcYlKHBNy/biiA352sembCtZU7uOumkk88K7MmdW
         F/+RcSnkMor9w7TJVONhwhC3tDrfmAqG7bint7/ln6B6Cf3plXSOotgnAW+swxIL2tCI
         dC0RgMD8nAfom/quml7VGHdllAMFCFReqj97er9E8kZqlHdyOtH44N7eLAgkKKfI+QgM
         WRxQ==
X-Forwarded-Encrypted: i=1; AL+hErFvsJ2Hu1c7BBy6cH8fyEG/xWfkknGCO/lIumV9Ote4C1FL/98uw+APtTLSyrD9sblgbGvlSAZf@vger.kernel.org
X-Gm-Message-State: APuU4Z9g/PQpPf0M3CFKPWSi9Omm2bTva++11vUBTzKSILHV7UVfdttV
	KjK96U2EeEWmKoQMsCWAKv69U7yuaW/rVtIcwwovnzrINEbNvWKe+TEP
X-Gm-Gg: AYBFou0raEv8oyiZMU62Saf2BHST7nNHV+SE74MFIrcvuDYx8TXE9drht3Fz1Ip+cE+
	5JOkEYUsMPxEOgjzQF2WY32I51pW0GBwFqd8Emor0UbJTwg+WVXGx7/Ori6N9sRcdbiZoUeH14y
	KL2wuM1QLvass8l86EMUUHM5+FEsJdJcjD2N9+3NGZfqsGhODrTHKvnAkQ2Sk5ewxFXPi/5Dqcs
	ZmgUFikA1Wk4wxpxZpgJtnPEFGbA2wKK0CD8Z/64R5S6eJjS9uSr0UkE5stVkM0YbzMssvAGZjD
	Dv99flZ5Wd43oO1DRnoxoeM9a6Phl3OFS+4oucWMmbmMeehOXwN/P5vdisyuBMQQEW/a196b3J6
	lImKYjsQ4x+RVA52Rhr/rcHz0yt97nfYSswVBbYNAOA7FZiRVZZcEm0RM09u0CEQ2DbomSOfWJo
	0j5p9OY/lZsUFkJo27acM+J5H3JO7uciKKVd2uYaG1o+YNy7/lzQAgo0oPNJM2wy9bQLWxXXLcP
	5hlQRnVklg2JQaxurbIQTrPJy4Dsy0w4GajGI7n8jyupGN9F/PuUYVoD3nA566sLXr9QiQ1PhOU
	yzIqbxQ6G0UueGopOTQb+kt+bEEmeu/stvTPyXBWJzBvU9kNGQb2MAzlpiyxX2B3OqR8X8Rebh+
	ve4IS5g==
X-Received: by 2002:a05:690e:130e:b0:675:1102:ffa5 with SMTP id 956f58d0204a3-67d8933e768mr2424694d50.3.1794616203430;
        Fri, 13 Nov 2026 16:30:03 -0800 (PST)
Received: from localhost ([2a03:2880:ff:50::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67d8a55b09esm3473161d50.6.2026.11.13.16.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 16:30:02 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: yosry@kernel.org,
	mkoutny@suse.com,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	sj@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev
Subject: [PATCH v3 4/4] mm/damon/core: use node counters instead of flushing the root memcg
Date: Fri, 13 Nov 2026 16:28:22 -0800
Message-ID: <20261114002822.1043378-5-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.1
In-Reply-To: <20261114002822.1043378-1-joannelkoong@gmail.com>
References: <20261114002822.1043378-1-joannelkoong@gmail.com>
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

Reviewed-by: SJ Park <sj@kernel.org>
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
2.52.1

