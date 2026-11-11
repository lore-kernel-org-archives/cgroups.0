Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794381459;
	b=M86m2fK5n8LpnqVhcJUlepkdDJmKfMeqAR8Br0VmqNj9yUcC+7jeKvsX0au+sep3iPm1
	 0BYXiPqpTDZRvHX5q9nZB9fS88o8/S+619N3GEyHCq27FGrTmJA+21s6InhKIfgentC+N
	 BTYT5FiUZrGAZWhYiuSKETL9eas17mWr0rKUPf+z+srHbvGs55ZJ16paz0n73lZehXFB8
	 NL4xK5R83EKo0sq1A+uCoKHKlXARWiY6nkBZnjD+99ClrJf1pRS9ZZABp28DzlvFMGb1P
	 dlOn/AQbQualmilVnWpIPs3Svh+H6gFJEZjXXqu3aeA0/Mpfmdni3ibMHms59BRiTng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794381459;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7JuUV+9RepX3x2BjxY1OAwwH8ZUYdafN/RIIq5XC+Dg=;
	b=v/KoLUzDR/qibdHGO2MxJTNm/GgTdcQwydMHgsE5m2u573CBafmcAzlvLq9QLnNvzJtF
	 LNd3Z7ruDU6cHYGa4f6e7Tn6L7nHZwwgkXv4DZ5yqDsie4de/DzXTR/htvHRMVnoyJl9q
	 NUj7NqsaKnVBJGCK4x8TZhbkzHcnzid4Qt6dTggks3O6re/wAgV7asOzZPdcORQxt1i/Q
	 1JCGgusMMU8g5ZWoa8SmN+asIp1kghekPcGWaTpC5fw6FrSe7MWIw5pC5bdC2/KObmedZ
	 1k77wxbVw7PsL88yUd96sP1GFTLGAC46bFj8Qj2TYoZyQiqEd2V3V+yQmj8JVKtycIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=shopee.com;
	spf=pass smtp.mailfrom=shopee.com;
	dkim=pass header.d=shopee.com header.i=@shopee.com header.a=rsa-sha256 header.s=shopee.com header.b=NtO6LCzw;
	arc=none smtp.remote-ip=209.85.215.179
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC2D606A324
	for <cgroups@vger.kernel.org>; Wed, 11 Nov 2026 07:17:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8FC2D606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shopee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=shopee.com header.i=@shopee.com header.a=rsa-sha256 header.s=shopee.com header.b=NtO6LCzw
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cd8ba7c2694so1151795a12.1
        for <cgroups@vger.kernel.org>; Tue, 10 Nov 2026 23:17:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1794381458; x=1794986258; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7JuUV+9RepX3x2BjxY1OAwwH8ZUYdafN/RIIq5XC+Dg=;
        b=NtO6LCzwI02Orj/2Yvb9GDZhhVin0DcWcYMk0C31Tghbkl/z57abysVA1EQlx+rmSz
         H17+kKRE7+J/IJdTM0c85KE3IlObb+sCRYf7U0pBDWvWMVE3YOgheQcr9qg1zdfc3ANm
         tEyCl5FbMtCqCRnglULlPeYRNlRU4cQ1QEoA+W4xq7iatAchM4ElvsJ3U8dOmKf8x8Qt
         aDtj3oUiepWhJvE2voP7c5AcrmwKwyPazxV3to6IufSuKTMFtqT1YfRAg7KOlb7+8/rx
         bhOWk32MFUSI8OGvL3sVPP0rxUjyBF20puWf91y3nVRUlZgSjaZa+/r7+an8V6jFaiD4
         WHyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794381458; x=1794986258;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7JuUV+9RepX3x2BjxY1OAwwH8ZUYdafN/RIIq5XC+Dg=;
        b=GjSYK0RTXNbUShQas0e/yO6GmMU2+ppfqfBVvKpvsl9Hh1TdZQsAE12DiK0NAnHZ44
         KHs0gyG+sz1Hk0XJua1T1CmlJ3L+R0vOPwKcbb4I/QDAtaFdgDfFoucVYRtnsRO5kFWk
         xCf/GMv1iNlG3FnPj3PEt8pUAoKQlHa55f/dSOD7XJzDeCcjGTfUZqDJUdDLrK2fxIp6
         tZiZ0K8K5+jwePOxCZmkMpdftvGj3uL0YagbGdFSifuWGLUNof/jAeIiVH102lrpamv6
         v+NLZV8yOkJIpT/TVhRASvVG8A6GHHupett1ZYqzSnl5AKIIbkz8RBZfBpKzx6YvqL9Z
         QwFQ==
X-Forwarded-Encrypted: i=1; AL+hErGWFWrccGp1BnLlSHgKPHVnEEwgw6hSTEzGpxt6syz7Qtc+7UF0ixk0wrst5OxTcVgg1OY9BNFx@vger.kernel.org
X-Gm-Message-State: APuU4Z/wdoI3eebeegePk7BPdUcHORzMwZm7UqeEqjTLoKUCGmK8mnY7
	6zlNUD7givPAyYbwNtj1OenkgmeUyDJfXvJLfS3dWH1oAdlwzT802bUYFgrd/xm3jw4=
X-Gm-Gg: AYBFou347EmZDOzYJvH4vV+e2w87YERX+Af2eEEcHBVX32nyhXUiP9MtVAKujiil3bM
	dKuQwf68qmlFaLeo65ym1dO7TKNFOK+5rH9gEWDhGHU3glSDAOpWZW1VmBctLc9GUWBwze5UPWP
	2xydm5lT1N4f+ahxSj7N2HKDySmxd14aou+4GVOrX4XqOtlRhfvyuowzuu0H3i0X585niWuNHhc
	JjPhbmMk0QjcpVOEZjTNF3Z+eFry7T/2cpGvs4CP9Nl9K75IV26mIfu4A1Rv7q+uI6b1g38x1/7
	8iGqB4C8bBw1d+BN3vegK/CfAhkvriKSQsW3FN8VZydjeveduaugbIvqO1XF70Y0JNvWX1QLAy1
	lFLu2LV6rME/8uDZoKdT/P41LaVe2sX7HDAuHNgHXOY04Nf5vVuTQGACZhPX7hWTqPbm9Dx5UYb
	oQfgeZybQDjKsonGH0jdjaSz+86JQh2WBSDCxTFOPgZ+gcTJNJnB9fKoJaFX1ALqLpNQTqTAE4i
	zqE5kH1de/YXUxERHK+9gQc4YyD/JKjj6ie1Eb7g+IkcjBkQUa+orMF4HMCdRtlClwUZzODhjOQ
	yg0fHYI26p/RIyyHUTGGDsKP8RsIhnOS8SpqQCCSqUO3AaBQDKEAG8+yeAEAg8XrPSD0j9v6O3M
	edU+/GWws//Dn5Js=
X-Received: by 2002:a17:90b:2552:b0:3b0:9deb:d994 with SMTP id 98e67ed59e1d1-3b182f85315mr1524391a91.64.1794381457818;
        Tue, 10 Nov 2026 23:17:37 -0800 (PST)
Received: from LPMV6FJ9FM.cn.corp.seagroup.com ([143.92.118.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b17db5cc73sm3189218a91.10.2026.11.10.23.17.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 10 Nov 2026 23:17:36 -0800 (PST)
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
Subject: [PATCH v2] mm/bpf: Always flush memcg stats when explicitly requested
Date: Wed, 11 Nov 2026 15:14:34 +0800
Message-Id: <20261111071434.34547-1-mingyu.he@shopee.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
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

Make bpf_mem_cgroup_flush_stats() bypass the update threshold so BPF
callers can explicitly flush stale statistics without waiting for the
periodic flush.

Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Link: https://lore.kernel.org/all/avKy9oMwDRjKjfzm@linux.dev/
Signed-off-by: Runli <mingyu.he@shopee.com>
---
Changes since v1:
- Make the BPF kfunc flush unconditionally, as suggested by Shakeel.
- Leave memcg_rstat_updated() unchanged.

v1: https://lore.kernel.org/all/20260911032905.63683-1-mingyu.he@shopee.com/

 mm/bpf_memcontrol.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index d8f579c28560..f8552651b6d6 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -7,6 +7,7 @@
 
 #include <linux/memcontrol.h>
 #include <linux/bpf.h>
+#include <linux/cgroup.h>
 
 #include "internal.h"
 
@@ -154,11 +155,12 @@ __bpf_kfunc unsigned long bpf_mem_cgroup_page_state(struct mem_cgroup *memcg, in
  * bpf_mem_cgroup_flush_stats - Flush memory cgroup's statistics
  * @memcg: memory cgroup
  *
- * Propagate memory cgroup's statistics up the cgroup tree.
+ * Flush the memory cgroup subtree and propagate its statistics up the cgroup
+ * tree, regardless of the number of pending updates.
  */
 __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 {
-	mem_cgroup_flush_stats(memcg);
+	css_rstat_flush(&memcg->css);
 }
 
 /**
-- 
2.39.2 (Apple Git-143)

