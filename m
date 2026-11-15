Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794782084;
	b=uVHWLzGWJ0KBmacQ93DtJmRrCWaaIf86kfEdlDATdANx6QYJ9kQr2c4C0uCRt4ANMeB3
	 iQkrMnu6yUu71EYWmC3EDtWJhdKkWUkgQrCjiTXWwqhxBIL4Xu33qDFrmgoNGcpJrVpgG
	 2aWy6cf2I1gZR3xrSI3xPfLSrYgBJ/b72brMOgH6FXGynWUY7K0frKxfst/dOD11vzZxC
	 +Ha9lxt9kStABleja7XBYuX9NwOEBcUlXaZXOgEpY/OzoGlhZ8isZXbH2jt32E9Wzag8c
	 YogPM64kBhPlPnNJ/V6TDlatfQmFOmCQwFmz/SFz6//LnpLKfmb44sKUnz5cm02ajdw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794782084;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=vKFwJFQVkE1SOt4l66iLRKSuv0tZWR+rY8jCMRsdO8w=;
	b=NZ3L10stW1MyfqwzxhGvC1l+V2E92LwE4/Suqbo+mvnjYl5cZRfGySaChFbdn6MCNygA
	 9c1L3DNHIGWRrJji/e2pH4/32QcI7T4EOhgZ1BIJVGtliXh5GZEnKR1UZ9uQM0NGqiVLm
	 amB990Cusalx03b/RgTcfl1AGdn4XD63a2T+UkYkec9BHi4qiFgXdFFWs4rySwBFPdPXS
	 itDPo6C9zlXYUTtUaZhWWmXPMhmYfmHJvn9p5pCuKYicOmIRwL2R+JXcQibrrRSu2ttLf
	 lCvCgNXV+z1PXAnUSdmbakkfKCNqvIovwG17RmElBCkxRBw0aSgjrAN0RR/20AFKhXQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X7naLAEK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70233606A329;
	Sun, 15 Nov 2026 22:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X7naLAEK
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794782084;
	b=FenyRT3yhU6b1N2AfqKt5Vr6MpoL0rHA5R1RVo1Xu3ggW+QVtiCjdHjkAvaFPt3WdgNZ
	 n78mgfIRbH7vjg7oBeyN8QmSJGxA0tCGpNgTwvGcFDVpqG2eqCMtn0Pzj4tKZ/u+9+weS
	 1tKuhc9L2JED/eCG7m5O+iSMI8b7KzmXZ4hu1k7XnA6oas/7U467/Rbh49tza08DDwEb8
	 r4/n2wAQNGwVVanuQ/6ynmJRSLFmRv+p30pRvP+BR750vmx0eOyPPoTwRzP6WzXeI15Do
	 XX48JbRlSEdUMnKOCNS0HQotNtDu/LTqX0dwWEq+yrVSySAWLU0B3yMijhBYve1Z10Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794782084;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=vKFwJFQVkE1SOt4l66iLRKSuv0tZWR+rY8jCMRsdO8w=;
	b=l3pw+h0Uyi+bZVAPv8toyZcnHUeRKgmFVcL8xrI65/IHWEpp1eqTUaXnHcCdQWGFPtMs
	 tnU8fB9l3XuPE7BJ+x2G/ZP9+0fZzc1CogN4Y36XdaZi5ggcbJuD7f+Bi1R1wehOdMkKM
	 wP2ptfXcMhBqGBzQhyOuv//XVdAycX5R1cbkeYeuwZucCG/CfN5G9MnHm6nAIUsZYUDAn
	 O9Nd9ZkopxscM2mwm2cfoaHjehvFVW79g268o+mGU72v6VcvjjAtOEBgpThOTuGNPLhPS
	 43T6wdgnGj7z5KxkQ9w3gIvwLPdoChrDP0PnsJ3WyaGLOhOBk4CQaP/7Fl1kD6XOgFA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id BAEAF1F000C5;
	Sun, 15 Nov 2026 22:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794782084;
	bh=vKFwJFQVkE1SOt4l66iLRKSuv0tZWR+rY8jCMRsdO8w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=X7naLAEK6oirit7XszsuEpnhnwzUL+HlZXDoZ69WpabPeKtC+ge0LzI/oLPhciV7d
	 sjrCgAip+/R3jOWmfA8Tvp7WL35tswKNMSF82yH8FU2pRZQFGHzcl0ISwZ91bLzs45
	 a9KUFhpP2iIkyVY0HBKVEEppPmbXl+XytgE43KtboGz39SCw+nlprFAuL2N2Vu+LI5
	 ckb/mAB/T4w+XFzqbsM2cCJ5DlHJg1S+LFPVoUWqTCKoyBLJ19hK5/ebPBLzuQlLs2
	 U7NsE5x/Y10qD7OfY/hcGzZlRx2dALTroiE8S/Ik8R8rkJ6T03nX+EY/jiaB8XnXsd
	 9xZCpMUX1ZAOA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 4B4D54A244;
	Sun, 15 Nov 2026 22:34:43 +0000 (UTC)
From: Alireza Asgari via B4 Relay <devnull+alireza.asgari.net@kernel.org>
Date: Sun, 15 Nov 2026 22:34:41 +0000
Subject: [PATCH RFC nf-next 1/9] memcg: saturate deferred memory.high page
 debt
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
Message-Id: <20261115-b4-nfqueue-memory-accounting-v1-1-b9cc30819997@asgari.net>
References: <20261115-b4-nfqueue-memory-accounting-v1-0-b9cc30819997@asgari.net>
In-Reply-To: <20261115-b4-nfqueue-memory-accounting-v1-0-b9cc30819997@asgari.net>
To: netfilter-devel@vger.kernel.org, linux-mm@kvack.org
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, 
 Phil Sutter <phil@nwl.cc>, Shuah Khan <shuah@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, 
 Chris Down <chris@chrisdown.name>, 
 Zhang Jiao <zhangjiao2@cmss.chinamobile.com>, Song Hu <husong@kylinos.cn>, 
 cgroups@vger.kernel.org, netdev@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Alireza Asgari <alireza@asgari.net>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794782082; l=2138;
 i=alireza@asgari.net; s=alireza-kernel; h=from:subject:message-id;
 bh=MFLqtuTtN7u8/DPQa2KEvRoRy7eP6Qdkj4IqlD51WpM=;
 b=m98I55EK5DDGlH5OD7HSN8CrjP52A8a7eITltlcAQqwelzQ/Ji/0VnlVZwsHX3oQHyR75mAWM
 RPrXccDRgy0DuW481S+kjEPQp4IqBc8At79t2aeJgNQhfDBRfENeSrn
X-Developer-Key: i=alireza@asgari.net; a=ed25519;
 pk=wuQ0/M69FqoVnrCMUJ13EQCwrCwVjCrtz75k15vW8tw=
X-Endpoint-Received: by B4 Relay for alireza@asgari.net/alireza-kernel with
 auth_id=1055
X-Original-From: Alireza Asgari <alireza@asgari.net>
Reply-To: alireza@asgari.net
Content-Transfer-Encoding: 7bit

From: Alireza Asgari <alireza@asgari.net>

Repeated nonblocking charges can accumulate deferred memory.high work
before the charging task returns to userspace. The unsigned-int page
counter can wrap, including to zero, and erase that pending work. Large
virtual capacity reservations can reach this range without allocating
corresponding physical memory, including on 64-bit kernels.

Saturate the addition at UINT_MAX. Ordinary additions retain their value;
very large debt retains the pressure signal instead of wrapping. This does
not change memory.max checks or promise exact debt beyond the saturation
point.

Found during AI-assisted source review of virtual capacity accounting.
The accompanying KUnit patch calls the real GFP_NOWAIT charging path with
an isolated counter fixture and a 65-page charge. It seeds debt near
UINT_MAX to cover exact-boundary, crossing, and already-saturated cases;
it does not allocate the corresponding large amount of physical memory.

The debt case passed on both 64-bit and 32-bit x86 KUnit kernels built
from this series. The test exercises the production charging and debt
update path; it does not reproduce end-to-end throttling.

Fixes: b23afb93d317 ("memcg: punt high overage reclaim to return-to-userland path")
Signed-off-by: Alireza Asgari <alireza@asgari.net>
---
 mm/memcontrol.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 84f4a8fd4d16..1980fb7431a8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2894,8 +2894,12 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 			 * Target some best-effort fairness between the tasks,
 			 * and distribute reclaim work and delay penalties
 			 * based on how much each task is actually allocating.
+			 * Saturate so repeated nonblocking charges cannot erase
+			 * pending work by wrapping the counter back to zero.
 			 */
-			current->memcg_nr_pages_over_high += batch;
+			current->memcg_nr_pages_over_high += min(
+				batch,
+				UINT_MAX - current->memcg_nr_pages_over_high);
 			set_notify_resume(current);
 			break;
 		}

-- 
2.34.1


