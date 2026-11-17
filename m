Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.248
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794902679;
	b=jDA31yaTxd+0YiSjw6K4rxl+2SaKYqVr7a4qzeb8vg67ko5VDWiRkAPlw+x8ZGqqL1kZ
	 n/ogEIWaV2darAvN0McsLzNFJ246eNpbwrV54RuWQMV88wS+tCr08P9wqLb+V0z68ifdd
	 VKCcqbk/in0VownAG7F2z/885CfKkanklMpCD4SdYGLfCO3Uc2xgwjdK5gqjc/iVdTHX2
	 F1RMribHWn3cxiVIu2vjmKy3vr955c2CfDpoJvt59HDuYrfzXD5d320c7gendQmKVLr+U
	 Q2axGRM99NlK3G/ZtLM4egE2aBWcp+TAfjHsYfJurVCB9R4POPP0yL8oEBMHOGJLa6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794902679;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vXF8oVQRnsv2ot54KZJo/sivs9IEK1CA2mVPqtmHEpE=;
	b=L6miGOOPhwj4cVED1y/w01MTc8KsToIR7Q1HgZHIt0s/jhjyj9ZmEeUMo59I4JGhtoI8
	 61IMrCcdWdPVrmYqZyxYJSN9btDHn5qaFFg0fS5FWKWjLY9jEamDHkI45BzFlClPakZEt
	 BsfkeA2QBxnQHn0DDpmkjoK3jMme+pkFTdkWIUXzwBE0TuL0er4aR45OmQgC8EuVVSKiq
	 YHF73I+I2fP4TiEH58SuM8JyIiX9O9hihC+G16DotIy5uELjycLXdNcqWwpjfNI2LjVIg
	 tJxJBhXajYUc/K6qWUh8ksMFtUHHgDq77Cal1AXeb5yR5uTAFzMYBFVdICa7E1in9kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lmfEcNYC;
	arc=none smtp.remote-ip=91.218.175.248
Received: from mta0.migadu.com (out-248.mta0.migadu.com [91.218.175.248])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BAA606A896
	for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 08:04:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C0BAA606A896
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lmfEcNYC
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=tUoF/AF9aJL8T6z27kbc5MffrFYSSF3reZSFJQMzMtw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794902676; v=1; x=1795507476;
 b=lmfEcNYCbZTd26bIDYO2TnJG/JHdK/UTeHJrWAv9/mpX1ujBe5n7AnpNLBSFWpfwlxbfNEEG
 7kDhevuwHoZoActQctm33DJVN2Mc6zlE5trLRzPWrxBI2lDcsYQBgCNxb+uTcsfj7uLTWLyPWh+
 qwfku+otFb//lzvlhCA9ua5U=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9847e282a775229b;
	Tue, 17 Nov 2026 08:04:36 +0000
X-Mizu-Trace-ID: 9847e282a775229b
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Down <chris@chrisdown.name>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH 2/2] mm: memcg: fix memory.high throttle lost to u64 overflow
Date: Tue, 17 Nov 2026 16:04:21 +0800
Message-ID: <f1cfcbc31ade9851c3c09db6bfd190682a130245.1794902513.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1794902513.git.zhuhui@kylinos.cn>
References: <cover.1794902513.git.zhuhui@kylinos.cn>
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

From: Hui Zhu <zhuhui@kylinos.cn>

calculate_high_delay() squares max_overage and scales it by HZ in u64.
max_overage is the ratio ((usage - high) << 20) / high, and memory.high has
no lower bound, so the product wraps once a cgroup is about 130x over its
limit (at HZ=1000). The wrapped value is arbitrary and can be exactly zero:
with memory.high set to one page and usage at 2049 pages, one page past the
8M mark, max_overage is 2^31, the product wraps to zero and the penalty
comes out 0 jiffies instead of the 2 seconds the formula calls for. The
caller then takes its "penalty_jiffies <= HZ / 100" exit, skipping both the
throttle and the reclaim retry loop.

Clamp the overage to MEMCG_MAX_DELAY_OVERAGE before squaring it. The bound
keeps the product within u64 for any supported HZ, and by then the delay
has long saturated at MEMCG_MAX_HIGH_DELAY_JIFFIES, so no penalty is
shortened.

Fixes: 0e4b01df8659 ("mm, memcg: throttle allocators when failing reclaim over memory.high")
Cc: stable@vger.kernel.org
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/memcontrol.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1ba42724ed1e..aeec1bbabb26 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2521,6 +2521,15 @@ static void high_irq_work_func(struct irq_work *work)
  #define MEMCG_DELAY_PRECISION_SHIFT 20
  #define MEMCG_DELAY_SCALING_SHIFT 14
 
+/*
+ * Cap for the overage passed to calculate_high_delay(). Squaring a larger
+ * overage and scaling it by HZ overflows u64, and the wrapped product may
+ * come out zero, skipping the throttle entirely. At the cap the square
+ * still fits in u64 for any HZ, and the delay has long saturated at
+ * MEMCG_MAX_HIGH_DELAY_JIFFIES, so clamping never shortens it.
+ */
+#define MEMCG_MAX_DELAY_OVERAGE (1ULL << 26)
+
 static u64 calculate_overage(unsigned long usage, unsigned long high)
 {
 	u64 overage;
@@ -2581,6 +2590,8 @@ static unsigned long calculate_high_delay(unsigned int nr_pages,
 	if (!max_overage)
 		return 0;
 
+	max_overage = min_t(u64, max_overage, MEMCG_MAX_DELAY_OVERAGE);
+
 	/*
 	 * We use overage compared to memory.high to calculate the number of
 	 * jiffies to sleep (penalty_jiffies). Ideally this value should be
-- 
2.53.0

