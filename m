Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792785284;
	b=HbPWSuoU0f+5BAmH0niqpUv4Ni7lVTk4Ai/XyLruWC7S5/QtAMjfTu1ERN6YUnGvtENi
	 kUoW15GYiuatMROW2EbQkdBj/N7kcSj/AyTZ8MVst67mL5P6Mml/LQd+bZzaQ3WEeqfi9
	 su054WpDrJezEsTBZhUb+Um4RQswmJruj1dFd6VKHSYSPTwiMYX5Hd9xT/4R3pnQ6KgD4
	 afRUMQfVQ8COfc7lqq097/ABumMD5lwrH8sjzfHU08z0m3D6kO+XBLeil9icJ/5JEfK8v
	 nzJRuKj4n0ef9O6J8SVU2qP/S6apeytKQOLTXBhXodM1j2Ud+3mAJRVUcq8h5tg7s9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792785284;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=cpi2EB3quHQgRCV81Rzv4dQD8elBWDJHR5WGv5PMzrE=;
	b=p2Aw2uMj9PDRzdHvbF6HvTtBzWeLpntww9TQvXyavSmTiAdF+NCNG3MqtYDWLkDqAdD1
	 TMeViZEfhrHaCBnuDuiyQAK067QXFyZcuOQDaCilwQK2O3Oo62VOLS45OrsjxEYMJtNRd
	 aKMV5jK6xtARTy6NMpcB+JHs8fKxslWnsiDdmQoxxfP43IfQ0eajKnIvprfn5oIxxlaZs
	 n4NOg8Tqzp8NQJ3Gz9KQijjXvwoQDr1m2kLAd5F07UtcSNrs4W4pU9PH169GOfXwDPCnJ
	 8dDJxo80oMLOZeIdoje6uVnE6O3Hhv2EeeKUdtExFOBhBXlci7c+RZttwhDyQdwy6Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=F2OjsTuS;
	arc=none smtp.remote-ip=209.85.128.177
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9E4606A32E
	for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 19:54:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AA9E4606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=F2OjsTuS
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-8b05bf699easo12867897b3.2
        for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 12:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792785282; x=1793390082; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cpi2EB3quHQgRCV81Rzv4dQD8elBWDJHR5WGv5PMzrE=;
        b=F2OjsTuSL6PVNs63tm+ricYJIzLRzmZ9xGkIgr9wBvR3jhtI8aL398rTIG8prwON3v
         gEOFJd1he522xh0JHGFz0FInas1OSTqgmJlMr4CkT9DacALmFwLr+kwBee58tgKXwhEV
         yTjKR7FY8QZJCu3q2YNAk2DocC33QLMkp+KlkKPbZBXv1q2K+Sz0AR6vQAH+35yZDH0K
         ioD1GQn6M+kwuXHZTB2YLwIXhwSW5ZOsnGeWVoUfBbwVEAv13GNHzn5Wbp9acMeuCzaz
         78sZTmKtnglSmLyVSpejj7COwdrz5PkIao+L2SIL+PyH+pjtVXzjsJ/bAYGnE0AUQrwF
         czpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792785282; x=1793390082;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cpi2EB3quHQgRCV81Rzv4dQD8elBWDJHR5WGv5PMzrE=;
        b=ED2Svrv/uFqOGaCxOpEhMNODHSgbVd0pEiI7BTj1XGZToka/PhMh97aSGKqpoxrHHR
         73ogRykMdh2sDB7j0s1E9xB7EBi2Mf1tDkEFfpLba1bI3R0/PzgUhHCeuBJKKz1t8AoT
         aFE1nA1PSIkqyiDqVmXd4QRMMSn/X31iatgclatBut7Fzg2r5n6z4LNICPPF8FH0ymuB
         kVjiDNCqlsJNDAd/hCgGfI1CPx91BTOH0g3f+w3DYmkT7c8jJKGbrPTr3PhS4+2mSUPw
         fQxhK/e96v9rDN0IRgUhGZnHY5CGryWWnPsgA6afLy7D+UEEShtKcntRFLSY9diBfkFR
         m+jA==
X-Forwarded-Encrypted: i=1; AKwUvBxa4TlYBKYuRn9NRa0qoJY5T77U/nAEb6dy8f74EYpgw4ZHoCQTQaGM//0ZL0raEqEvD3dTrI88@vger.kernel.org
X-Gm-Message-State: AFq9FYJJLQsNFRIppU1DKYht7HfJ4GLN4L75F4oL2b6X5dCPZvahuS6r
	eAtAi3YKqPPL9TT62PzqTei5A1Ut6BcGbdC5gdHSxEaF6bxdAw5UaEmE6ESfDQ==
X-Gm-Gg: AYBFou0uZyzCSwszvRjnHjMkBzUu203mnaJFHKwYAmZ7ow3XDqOK0HEFj0iT/Rko3Ee
	0lAJ0K0TP29XPDi3AesB4nkog/SrwNjpNEDzZxoWv0tuG5FyePOiu9yBsek02aCkRhr4WzWr/Hq
	K1uYuHLVkRGrL8+IZkaqOxRvqLXro3ERfIHx80sBQwloP0zVBkrUa0cOzCoxP+GMB7+Dl3tsI2/
	hwH1QoirqAZNPdgcjMnQ2vLxcP4na7GEGORs9IIdaWP/0hBOI5ElDP/Hd3uhSdllpyKywhT4m2J
	jQFtFsLjOwIzlLyB710SttzL++k+rNI06QI7Aw+v3FJXc19P/98BOqX6YIA6Zua2qgoYP7vJ3FN
	9d3gPdqBMj8b8r7FmjvHzHo7XlGexFFPDtxtPm6oCpivZ51VpLIf3K2ymKoKyglu458uQw+MD/9
	yd0X/enpHcy3NOP0N1f5HMKJ9LSd2Z59qR6PIF0+DllrfBv72dWfOIg26ADvmexIMxRFG0k42nH
	Pm3SeK0/AXYYd1Ri/SRbAJ955YKwZlKXHGWafkCBIaC7llrFk0Utkz6UY8hl+7wq814fy8Tvs+G
	zWgaW4u0vMNx+BSAEO7P5/aXMbUZ9rhr
X-Received: by 2002:a05:690c:c117:b0:8ac:805b:3a7d with SMTP id 00721157ae682-8b166c2de63mr1462627b3.47.1792785282377;
        Fri, 23 Oct 2026 12:54:42 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:40::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b166dd01c0sm961667b3.7.2026.10.23.12.54.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 12:54:41 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 0/2] memcg: reduce cacheline contention from lruvec stat
Date: Fri, 23 Oct 2026 12:54:15 -0700
Message-ID: <20261023195417.1391216-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
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

Memcg lruvec stat updates read fields of struct mem_cgroup_per_node and struct
lruvec that can share a 128-byte cacheline pair with lines the lru_lock holder
writes constantly (the LRU list heads, lru_lock or lru_zone_size[]), depending
on where struct mem_cgroup_per_node lands in its slab. On CPUs that do spatial
prefetching (eg Intel CPUs), this makes the stat updates contend with the
lru_lock holder.

Patch 1 rearranges struct mem_cgroup_per_node so that its read-mostly line is
paired with a cold line, and patch 2 makes the folio and kmem stat updates use
the memcg and node they already know instead of going through the lruvec,
whose pgdat field shares a cacheline pair with lru_lock or lru_zone_size[].

Results on a 2-socket Skylake (80 CPUs), average pages per second for
threads faulting in and freeing memory in a single memcg:

	   base     patch 1   patch 1+2 
shmem, 20 threads  4.74M    5.59M     5.77M
shmem, 80 threads  7.94M    8.66M     8.82M
anon,  20 threads  3.04M    3.08M     3.10M

Changelog
---------
v2: https://lore.kernel.org/linux-mm/20261022223930.138779-1-joannelkoong@gmail.com/
Changes from v2 -> v3:
- Add in a comment about memcg_pn_cold placement after memcg_pn_read_mostly
  (Shakeel)
- Add Shakeel's Acked-bys

v1: https://lore.kernel.org/linux-mm/20261020200730.250189-1-joannelkoong@gmail.com/
Changes from v1 -> v2:
- Replace the lruvec_stats_percpu pointers in struct mem_cgroup with a
  rearranged struct mem_cgroup_per_node layout (Shakeel)
- Move lruvec_stat_mod_folio()/mod_lruvec_kmem_state() change into its own
  patch (Shakeel)

Joanne Koong (2):
  memcg: reduce cacheline contention between lruvec stat updates and LRU
    lists
  memcg: don't go through the lruvec for folio and kmem lruvec stat
    updates

 include/linux/memcontrol.h | 29 ++++++++++------
 mm/memcontrol.c            | 71 ++++++++++++++++----------------------
 2 files changed, 47 insertions(+), 53 deletions(-)


base-commit: fcec4f4bcc1101dbd7e3aff267856b3bbfe128c6
-- 
2.52.0

