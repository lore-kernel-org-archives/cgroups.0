Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795506711;
	b=egMINqvzFRgZVeXB+Uh5w007F7MtJ+5PzdANsYjBCoiz+qOYlA0KcbhSar4Td4SbXOsr
	 gTFV0cOo/OfEDY2aDfQ6y9Dq1bdYvmlqPRv7qW4esgTxlBso02eT1p6ewHsBk+ffqScOU
	 Pz7Hh2NHElRawyu11Z9ghl6jAY7SsOtTRIeTC7qWI5u+gUopRArjPATRAwa0cgDXOlEJx
	 XJNuxRU7JIcxlBFFulDeewP9RF9AZ0E6icosDB0Vu15h5wuP2DFCBKjbG79m5G6NFsOdh
	 h1CRHRClFIaaxPUzFZdzpu+j2Tos/o3M/23RmhAKW9e011QFfvOexGuDHYyT93uX/Qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795506711;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer;
	bh=igrsq5xWsPbd0pphtLnGo2EhnP6aWBAghEe3lo+KjZM=;
	b=Hsy34Eyvit5HPp8P5XrpPGDln+aoetuBG5IU3bUK8QFHK+w8Cy5eA76sNYnZ89rAVb1A
	 2EOxD+riZ/VGj7Uyaz6Rm8H+7qVIppq5QYbVghi9mwTpUmY6o7Hj04TN07oYvd2/CYNkK
	 fBFpQfe5eE7U8QSmSj5MAEnjtvwEZ455KrCOlPjC1aQ11OZVLhjLXJAUOJBgGRSTyDqde
	 03lG74i2QbUdbh5tayweFzve6KjLY9+M0rMcOTemsZeZmBDtSbj41XIkz0unCkKvMsVrI
	 O3HxMwFw98z8Qbt2otoOvLG4dD5Gww+q49X95lUygIG02vTwFzRPkx6GOJ5ELZH8JXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hmokvp4g;
	arc=none smtp.remote-ip=74.125.82.181
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD048606A322
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 07:51:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD048606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hmokvp4g
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-384d59d1ee1so489108eec.2
        for <cgroups@vger.kernel.org>; Mon, 23 Nov 2026 23:51:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795506710; x=1796111510; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=igrsq5xWsPbd0pphtLnGo2EhnP6aWBAghEe3lo+KjZM=;
        b=hmokvp4g/seCN/ZTeRc0pKsFFQtsv5zJtV/w9ZxOFB9pfkpATJ5wbU0nsTIRWVpB+J
         TDhMDpDc6zCH/4SqOBim3lf7ruuIUL+eoKUlUyQcbRKLVFZUofni6mDkvQUdSE/ztMJX
         soYL6IeLAhUuI9K8tbrfKpZHAC1Eb0b82YS7ZfbvulH715wLFPGLZjWX5Br3K7L+LCPR
         PR068rT5HYS0bkSCsoYbyRrcIPfqGwqZWllK8PSBGbEoyj2IT4sh5Wll7nbhzBsiMFHS
         w9nEhdctyXGou2ODWauyzVwE991o7NqeHTihePfoHZl4fjDtkHFuGv7dsxbqzMIyE8Pd
         ijzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795506710; x=1796111510;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=igrsq5xWsPbd0pphtLnGo2EhnP6aWBAghEe3lo+KjZM=;
        b=GlCQnn+wyNVReQz1abSuz1Sv/Mss2szT4EZLFwtDnSd5UiyHip6Wpk3Qvl/OvTp+QM
         +EGIUtSjOVedgHfBSGdLJo01AspOi04b0QzptE785CsdinaCroGnu0ouf0ugBEERaizt
         GoM7ZJklrwmN0fbsHjD+nOZqJli4u6dvkGjek3HUo0aUB9BBef8cDOs7a8EyA67D4PDu
         jjI0ZE2dHYQKdkyUozHchSqrSyur8TeGWnRUEHp2COthpvjs61ktEk18GLl2kE8pDHCK
         3qw+uw5E7dmTEJkPkE2caCgPJZevSIv4zsjCgojLjU3k5VfH4zcsCoFlw/Ks7IM+S0UU
         DNaQ==
X-Gm-Message-State: APuU4Z9AIch/tb+xbBxBYRNoh41pKUedfJIXemnmV/aBeflaYUzm/KCI
	ETX4FtKZzjv7JENgfB/sFkpHKEYeMyb+Tk1BkkH9t1qO4nQWHOCtntZt
X-Gm-Gg: AZFdTZd3DATSPy0it9fBwKwRo1amAapn1OKbVjsnwB6tia5VwJXyvx6bgy8dzJoW3rI
	BSqRlFTJcyvZYx/uFqd3IO7+RO9m4j8OTHj3RO6yhjOV89x4UYGLuMH+0TeQ83Xs1Vj7Xq2Ug2W
	OgDFW6q/Ki7Dzc0GMyfBTydAQ5iVE/HtiguaOPUMw5lOw1+O5g75Xb7u+blgd++KpB+gLYZCcFy
	7iXpBSv5pHmUr3bcEHkt4ou9BPX2VLwc1aZkqyW9CX47IBYxcTDvdtQKo1OwaUCve+fOuR/Fv5u
	KXq72C9y90uBAcR2e9xEhfPG7o7E3JSOYBCdglXb41XYHh2YrhHTIXaYmOryd/PmM6Ih4HxEn9t
	mdOkUb5e0I4y6SNnty5S5YbZ17+75lAcWps6cdFwxUcFPJz0EcA+ZiZBdXSZqd7hV/xeVLRhxUe
	w467YpHq4UwXdrziWdCdHLA4aqd6HMDU7V8j+gGR+uDL8L1nrEntV5RzutbUIXfiWMsCcuJprrO
	iz/fUfksHY0TLAzxtKq9+W1zbp2CzmhnilH6yVd+iai1Gn7TfRrXQdu1uhy3guKHhruuRhq7Jm1
	ljIjeAT4VE6lBde+OCrH5Fq3h4hQWHcoPK47GZEA6LOL3TPDj2Uz8zf+7vDxM+ebG/k=
X-Received: by 2002:a05:7301:b8e:b0:377:d6e5:e642 with SMTP id 5a478bee46e88-3856e245b2fmr18869883eec.1.1795506709267;
        Mon, 23 Nov 2026 23:51:49 -0800 (PST)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385666e99fdsm53099098eec.5.2026.11.23.23.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 23:51:48 -0800 (PST)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
Date: Tue, 24 Nov 2026 15:51:27 +0800
Subject: [PATCH] mm/memcontrol: expose anon and file reclaim statistics in
 memory.stat
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-memcg-reclain-stat-v1-1-c6cb14b0d917@gmail.com>
X-B4-Tracking: v=1; b=H4sIAP5BBWsC/yXMQQrCMBBG4auUWTvQhFDQq4iLdPqnjtgomShC6
 d1Ndfkt3lvJUBRGp26lgreaPnKDO3Qk15hnsE7N5Hs/OOcDL1hk5gK5R81sNVZ2CGHy/ZiOSai
 Fz4Kkn9/0fPnbXuMNUvcTbdsXrmg443YAAAA=
X-Change-ID: 20261124-memcg-reclain-stat-1e44d20bf9fc
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Xueyuan Chen <xueyuan.chen21@gmail.com>
X-Mailer: b4 0.16.0

The aggregate reclaim counters in memory.stat do not show how reclaim
is split between the anonymous and file LRUs of a cgroup.

Expose the existing per-memcg scan and steal counters by LRU type so
userspace can measure reclaim balance and efficiency when evaluating
reclaim policy. Report the same counters per node in memory.numa_stat.
Both files report the counters in base pages.

Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 20 ++++++++++++++++++--
 mm/memcontrol.c                         |  8 ++++++++
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 9e3c67b02ae2..eeeaf635754c 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1726,6 +1726,22 @@ The following nested keys are defined.
 	  pgsteal_proactive (npn)
 		Amount of reclaimed pages proactively
 
+	  pgscan_anon
+		Number of base pages scanned for reclaim from the anonymous
+		LRU. With the multi-gen LRU, counts pages isolated for reclaim.
+
+	  pgscan_file
+		Number of base pages scanned for reclaim from the file LRU.
+		With the multi-gen LRU, counts pages isolated for reclaim.
+
+	  pgsteal_anon
+		Number of base pages reclaimed from the anonymous LRU,
+		including pages demoted to another node.
+
+	  pgsteal_file
+		Number of base pages reclaimed from the file LRU,
+		including pages demoted to another node.
+
 	  pgfault (npn)
 		Total number of page faults incurred
 
@@ -1829,11 +1845,11 @@ The following nested keys are defined.
 	application performance by combining this information with the
 	application's CPU allocation.
 
-	All memory amounts are in bytes.
+	All memory amounts are in bytes. Reclaim counters are in base pages.
 
 	The output format of memory.numa_stat is::
 
-	  type N0=<bytes in node 0> N1=<bytes in node 1> ...
+	  type N0=<value for node 0> N1=<value for node 1> ...
 
 	The entries are ordered to be human readable, and new entries
 	can show up in the middle. Don't rely on items remaining in a
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1ebc9330aeae..ac12ff69a633 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1647,10 +1647,14 @@ static const struct memory_stat memory_stats[] = {
 	{ "pgsteal_direct",		PGSTEAL_DIRECT		},
 	{ "pgsteal_khugepaged",		PGSTEAL_KHUGEPAGED	},
 	{ "pgsteal_proactive",		PGSTEAL_PROACTIVE	},
+	{ "pgsteal_anon",		PGSTEAL_ANON		},
+	{ "pgsteal_file",		PGSTEAL_FILE		},
 	{ "pgscan_kswapd",		PGSCAN_KSWAPD		},
 	{ "pgscan_direct",		PGSCAN_DIRECT		},
 	{ "pgscan_khugepaged",		PGSCAN_KHUGEPAGED	},
 	{ "pgscan_proactive",		PGSCAN_PROACTIVE	},
+	{ "pgscan_anon",		PGSCAN_ANON		},
+	{ "pgscan_file",		PGSCAN_FILE		},
 	{ "pgrefill",			PGREFILL		},
 #ifdef CONFIG_NUMA_BALANCING
 	{ "pgpromote_success",		PGPROMOTE_SUCCESS	},
@@ -1699,10 +1703,14 @@ static int memcg_page_state_output_unit(int item)
 	case PGSTEAL_DIRECT:
 	case PGSTEAL_KHUGEPAGED:
 	case PGSTEAL_PROACTIVE:
+	case PGSTEAL_ANON:
+	case PGSTEAL_FILE:
 	case PGSCAN_KSWAPD:
 	case PGSCAN_DIRECT:
 	case PGSCAN_KHUGEPAGED:
 	case PGSCAN_PROACTIVE:
+	case PGSCAN_ANON:
+	case PGSCAN_FILE:
 	case PGREFILL:
 #ifdef CONFIG_NUMA_BALANCING
 	case PGPROMOTE_SUCCESS:

---
base-commit: b024a51b0184b1efb6f55b11aaf7b15a490a6307

--  
Best regards,
Xueyuan

