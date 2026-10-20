Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792515389;
	b=JB6xoi2BpJxL/PzB8wg3gnZ6U0VMKmnyP6tkj+BiBCqOSlim3GrxGl8q7D3TsOmMmZyP
	 13V9Dle03gFB4KCJwHMTf9y4ferODuIqBHRBMRdPGRyztYJ8g8Fu9h/YbmKgPg45kCqWP
	 EpBYX4SMtlyyl2eWEjzDum+G+CiS1UwLlCwdqoZF1gYO5YHuB9dpyMH+KF6LQfMwFV6V8
	 LM/K9ihzx2nXZpJa2y0pS+ovOMygGHl2SyKc3ERUgWMMQcNSblUH5PK8yvrJwu+2OKyuj
	 HOIawbeRUdyz3QorzPGyS6bYHlR3q6ix9eOXKwYg3UibPOKvCfMtBHcqio9Fm8zGvRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792515389;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=lJA6tKVLSd/rks8VATU4AwzUzgulNjgUJQKYEzoQbI0=;
	b=wuja9w9fLvaz9CX9wykvAzONb8pKWQrHIgT0lwWcP6ijj7sSyT3x5kQC5EoM7bPPeyfy
	 M5nOvt4peFjoQ6SRhumVptdbaqEhovonLu/XgAr+eFGhMKqiux75e9fbrlXG1OrUZFilb
	 6DCrc3QmRMdgLwxt1OwB43sa8UAvV6ojZXE6TJLAHMZBUfn3f5AkuQx9C+k8Vv5/vl4HA
	 upkldcYQDG+S9FA1R32iWnMy47Ca4QhOWawcgxBi6tL9OD2IpQs3S5n7nO4A301qhHwbg
	 QEHKn0Jj4qvC5HBzKfk7UvA5l22S7O0+2MpqxtMRusSPxQ2yqQo7DMjzPAqJm+JHwKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=rPcumr3h;
	arc=none smtp.remote-ip=209.85.128.177
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C21606A31D
	for <cgroups@vger.kernel.org>; Tue, 20 Oct 2026 16:56:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83C21606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=rPcumr3h
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-8b05bf699easo30738747b3.2
        for <cgroups@vger.kernel.org>; Tue, 20 Oct 2026 09:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792515388; x=1793120188; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lJA6tKVLSd/rks8VATU4AwzUzgulNjgUJQKYEzoQbI0=;
        b=rPcumr3hk92ul3zXknSP9ezvJXtbsOjBFUcexwd+d06SRbxRqchUGHCasG/ZKBsC8r
         P+2in+A40BsBSmqyMsQKCF6Bg+UMhT1YHmuHxJ0ddDno/m4YI/1irGtzS5vbhx8R8BH8
         j53tCE5oLzFxDGzTMIa58F/nuA/rP/QVeEua2FoCQrRTbwUgNKzyLLWncQtP6my2gAaw
         D5uLE4WBc4k0qv9zL5RG2PC4zlFRWmUD7Ter0xbpFYV67h+g0scghhUVrHo1Y6Syl6fA
         XLYiYPxE3TKTjcSdX42jVrkALtgMtAirKZHLx7YgKJYCHN81dZDenyXt+tXOq9K20SDG
         BrJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792515388; x=1793120188;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lJA6tKVLSd/rks8VATU4AwzUzgulNjgUJQKYEzoQbI0=;
        b=rt+MzPRpmaJs0Ce5ylY6MbfpuMvJUonkSrnr/BkSfT22HQ+rVE3nxq+NZ2gZchFF89
         H8D3Z0AqUzizn06nso2uXp3nP2+YZkNpseGEqzxtd9NnaX9BTSp5k9hGzpLrWeNM14xx
         rP4b7b+3O5KqppMbIOYX2Tn4GdO6CIIHuJMNVOfJWEbA1YOTYLlJoW/chiPnzjFTssBJ
         YaRs9OcDaFI9Lepfd4SiChpLE92FtJ5ADsit9V3V6trWohxYP9QEkVtC1qSXeG4Xb2HC
         WHVw2ampLfvmRj9m+hrECMbEhVbIheBLGi+6q6EWKu7+Q0I38okMyEFVWdVU7Bbueat8
         8W5g==
X-Forwarded-Encrypted: i=1; AKwUvBxamDWd1uXCTSZssMOQR/c3onwaUSosYRoou6UzXYxKjpK6HzmRsRgnQVSiMHy6yhcz27LzY93B@vger.kernel.org
X-Gm-Message-State: AFq9FYJfPad0F7r5MXKesqP1lyPlE0G8EqTCCng2jrNQ0tR43FzDReqW
	P+GtRaQPWWay4zd/CCm9q3vCFxAev77SqSoxUiZlS00WUbDF4/J25DiD
X-Gm-Gg: AYBFou0r/ROr3re4LWbTqYKtZaWtjvT9EUb3iHqSq/Nc33hok79TJimt01sJD4tzSd+
	A36M6vYaoFhGyu3KHYcn0lkqxlEVW+3Q9mXg7raXIZ7zNlCpHJDPnar9xJa+K2Q7Nv33oLzBLw7
	yzSjGKWKz5ZipzOySTsjLA3b0gYNpraGSjL4io3B/JxCBSULBrZcZzZMmrlORB0p3eMwvknRMC+
	Dw9EU16AoLrZ7vedvd19XI1RU3RVnUAeIcJhS4NGKJIVLD8Xoqf5JU850jJ70itlKGJQPoNyqFn
	39ejqIaRlnHCPoV0PhcPCxiD2wSauuwHGOkx8ttZJsbXH9m0eGM0QAgPaSzT0tQr0VkcXZ9+vkX
	aZU84m/5I8T0H6INA5RUDXRem4M+C0JDB07NMlwtLw+O8VtriRNPxR+hVKWRMWXdsuP9GM/gbqa
	GO44Gj3wqhRruzLib7ryfHfbaws+7vuQA6rTvfoannFqyCgqxbDwvVUR4Ue4vg9oJtDUACCRGYk
	blpy/KF9msDcXaBIkAhRkfEvhQ3
X-Received: by 2002:a05:690c:888:b0:873:17c9:b054 with SMTP id 00721157ae682-8b0f21690aemr36925147b3.21.1792515388537;
        Tue, 20 Oct 2026 09:56:28 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:8::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b1300715cfsm549777b3.14.2026.10.20.09.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 09:56:28 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH] mm/memcontrol: publish null pointer before dropping css reference
Date: Tue, 20 Oct 2026 09:56:26 -0700
Message-ID: <20261020165627.1599959-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
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

struct memcg_stock_pcp hold references to cgroups that it tracks to make
sure that the memcg never gets freed with unaccounted charges still
living in the stock. The cached stock can be cleared either via
drain_stock() or consume_stock(), which drop the reference if the
stock goes to 0, and then clears the pointer from the stock.

If that was the last reference, the memcg is freed after an RCU grace
period, but this can happen while the pointer still points to the
to-be-freed memcg. Then a reader that enters its read-side critical
section after the grace period has started is not waited for, and then
can dereference it after the memcg gets freed.

In practice, this is very rare and I have not been able to reproduce
the issue in my own testing.

Switch the order of the reference drop and the publishing so that
we first publish the NULL pointer, then drop the reference.

This is based on a report from Sashiko, who found this pre-existing
issue in my page_counter_stock series [1].

[1] https://sashiko.dev/#/patchset/20260928192349.3432886-1-joshua.hahnjy%40gmail.com

Fixes: e1a366be5cb4 ("mm: memcontrol: switch to rcu protection in drain_all_stock()")
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e7d7db5718f9a..a05d9a8baa1b6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2172,8 +2172,8 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 			stock_pages -= nr_pages;
 			WRITE_ONCE(stock->nr_pages[i], stock_pages);
 			if (!stock_pages) {
-				css_put(&memcg->css);
 				WRITE_ONCE(stock->cached[i], NULL);
+				css_put(&memcg->css);
 			}
 			ret = true;
 		}
@@ -2209,8 +2209,8 @@ static void drain_stock(struct memcg_stock_pcp *stock, int i)
 		WRITE_ONCE(stock->nr_pages[i], 0);
 	}
 
-	css_put(&old->css);
 	WRITE_ONCE(stock->cached[i], NULL);
+	css_put(&old->css);
 }
 
 static void drain_stock_fully(struct memcg_stock_pcp *stock)
-- 
2.53.0-Meta

