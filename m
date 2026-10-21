Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792544454;
	b=qrSaaf0xGq5JP1miNL/HryCP6/UTpHvzXErSOfpTX6dMlSjQarU5Ub9ujVYIWFVMNUU9
	 NXfFQ2v6/wafU0MAQx2BDlQT2SYggvhLwSvhWwGiXZeZNmGeZrc4z4id1jedGherxg8OQ
	 CZ83skTi3MEDo0qF0SKSJ6Dns10ubd/0M+KoN49xEl5YKaDYCrHID5hD71S6NsiO96lAj
	 ZCW67mxMd9qRerheEFrVyIK1gC+jiQUNwDS+uRRRtSIRlb91zi1NafG2aTA0NT4i651ij
	 yR0UVx4X0EtgrUfivAe0t0km8JV9YTukVj1QxFo7t/cz3zQqRKk89+t3SeL6XX+V8cA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792544454;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=brjSVHHjkTm3a15jKpejTsFNYVkjpbbbJOFcNDM0Mpk=;
	b=gNbGLPwwpyEHRzY3n7ooM7YdrhSLIrZdElUWn1xN+qdGbCdzL8xAAyx17KH35ykND422
	 PZMPrJUqXeNu1FeGyVnrxolFLaMYp++XT+GwsVE4MAOI4OWEzgrxRtSyOz917M0jlKdwz
	 KGHUCGwGFOOWn87ZFuGvqr3akn/irKVuYc9FIeI0NZNN4ug0qFaaKVaSl4C9muPHPKYnx
	 eGQdjUpgJSDH+mT/hHZKx0MXzw8fGpi4AxWEW4pzBX9TRswODPtdR0S8+4y/D/LSFlerf
	 mFzPLxZTG0ktcvgf5+Zhp/ln1SagE610uV6NR3LfL/5DocrDG4KBWthms4hlJX4lgaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=mcQrSgh0;
	arc=none smtp.remote-ip=209.85.128.182
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5B1606A31D
	for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 01:00:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D5B1606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=mcQrSgh0
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-8ab37e44643so1690307b3.0
        for <cgroups@vger.kernel.org>; Tue, 20 Oct 2026 18:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792544453; x=1793149253; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=brjSVHHjkTm3a15jKpejTsFNYVkjpbbbJOFcNDM0Mpk=;
        b=mcQrSgh0MujISwQ7p917m1RGlUW4KAsn8eqG7CBqhmdhd6P2/6AmdTdIJlCqffTrJ7
         eWkfBKs0ZxQcJ1y4EeBrHb1CO10CMBDvGVsiMw9WT1RPaRZK4dNZRsCyxr5ENbibWcYx
         PcFFm/t69wd8rJJS5MG9mI+zugx1ox9gHZ426zA8OawA3wkwOXyVnrZZduBCS7zG9S0s
         LJFWcMhPRgx1j/sjLInpTk6DJHBpRcFYtWIYJPCjNFEQ5Hy97uvkd/A/DPRAyteUtJOV
         EDqdNccTjfi3VLyJnQxtxIJWlmwxomYkXe1XPdEFjPrglJ2RDqXi98WfumCfMzHBP6Tv
         JKcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792544453; x=1793149253;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=brjSVHHjkTm3a15jKpejTsFNYVkjpbbbJOFcNDM0Mpk=;
        b=O07VsPuBmsoLhL11rxymJqWKftZmChokw1rTk9sOUjtHuAoAk3bYlEEQNevB8VRMRu
         UL+K2wrmoblWDa5xigoZHYO6WdMOhKAC83+82dR9x4RvjPcRnYsWLMO0ppQe068fgy46
         /niJ2LBy0syuU95pjP76YJSuWnY2LhXNiWDq3h2rsYhESY1teaU/i4n2DbRddIxBCBr5
         6dksQwc00HuhZ77ERaX3Rhwa8di3K4zGEujjzr3BCJQv8xb0ZiK9K3KaZ98RVeVNJXZe
         nlwycRGMsxjKP3mlq8W5clrvA28jW9RRp0u9kEeoZtcKPjPn2oHjZnXXkg8lR1KlURgD
         MeIQ==
X-Forwarded-Encrypted: i=1; AKwUvBzWZ+Ix3PjJWzEN/63QJeCUt9JXSQOUsVHzXNtLVor3uje3khdriGBOyWpMGQatQwQ01KwqSpJ3@vger.kernel.org
X-Gm-Message-State: AFq9FYKsepeb/xfsRfbRrVnwY49/aC8c8ZI4ttDEUEYYIlSvVvi/B/07
	N1EcmEKL8+w7BigavOxgrDVwZK/D+121wtK0c/KzLCxSKfZFRWiIv7SJ
X-Gm-Gg: AYBFou3wjwhz6p5kNq5x1Pn0wpDF16Al4m+ts4beA7DbI7CYONuQwHy7p9LDkVEwP2L
	7pc89HfuoPUgVznTcHdgpY13eLASH7oTDwiJvjFI5aq0iO+8EyigRZKB26SeXOffCu56gVGU96f
	nRb2oP0UFL9tSgk9AyEaaZLQvNbYQAy5ZCm40T+7/NyUxl9n8kemK8vNvlzSEr8f1fHjXlpBn+t
	szigd7k/OVQe8XMAT8t4hYTRB80zvysGy0rpJwvicJEGwy1p3GgMs8wOA5VgTRA+irSJXdtDy7g
	ea2AxtkB6wqumnyHkaEXTS0EamEzJ1yxSvWVfIpADq3eerlk+krndDkwky0HkgwA/aXADQXKdOT
	+M7og0JSEasKFD4rl+a+HZ8MaMh5aKsTeixxfv8XtQnNcAaX1FmpZ8+rnibsheFFcF/AShhdtzX
	CXh5lzM0StSaqLZz2qLtIiqfez9rwD5DS8PaMbFRWzqCTVPyJ6YVvczYwvEvi+vUn//T+JRwskW
	l1CZ1jMo9Ko1Ehei4hEvO2ecemLOvrKl2INiKGopmsHdppAQmf4mg8EHg2LKj4ix/XYrbMucr3t
	1ksS7OY0SQ==
X-Received: by 2002:a05:690c:e1c3:20b0:8b0:702f:3554 with SMTP id 00721157ae682-8b133d0edeamr2195557b3.8.1792544453129;
        Tue, 20 Oct 2026 18:00:53 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:3::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b1300ae0c2sm5192247b3.18.2026.10.20.18.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 18:00:52 -0700 (PDT)
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
Subject: [PATCH v2] mm/memcontrol: publish null pointer before dropping css reference
Date: Tue, 20 Oct 2026 18:00:50 -0700
Message-ID: <20261021010051.1529261-1-joshua.hahnjy@gmail.com>
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
living in the stock. When the cached stock goes to 0 for a memcg, its
reference is dropped and the cached memcg pointer is set to NULL.

If that was the last reference, the css_put would free the associated
cgroup before publishing the NULL pointer, which can be racy on 
PREEMPT_RT. To summarize Shakeel Butt's analysis in [2],

CPU 1					CPU 2
local_trylock() takes a per-CPU
spinlock, which is an rcu read
lock along with migrate_disable

drain_stock
css_put drops the last reference
release work is queued

kworker runs css_release_work_fn()
call_rcu() starts grace period G
which waits for the refill task.

<preempt>
					drain_all_stock
					is_memcg_drain_needed()
					enters rcu_read_lock(), but
					 grace period G does not wait
					since it started after G did

					<prempt>

stock->cached[i] is cleared and
unlocks. Grace period G ends,
old is freed

					mem_cgroup_is_descendant() reads
					old->css.cgroup which has just
					been freed.

To close this gap on PREEMPT_RT, switch the order of the referene drop
and the publishing so that we publish the NULL pointer before dropping
the reference. Note that this can only happen from drain_stock who can
hold the last reference, but not on consume_stock since another
reference will always be held. But fix this in both sites to maintain
consistency. 

This is based on a report from Sashiko, who found this pre-existing
issue in my page_counter_stock series [1].

[1] https://sashiko.dev/#/patchset/20260928192349.3432886-1-joshua.hahnjy%40gmail.com
[2] https://lore.kernel.org/all/atfMngq7nyZpt4u-@linux.dev/

Fixes: e1a366be5cb4 ("mm: memcontrol: switch to rcu protection in drain_all_stock()")
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
v1 --> v2
- Rewrote cover letter for clarity on what the actual condition to hit
  the race condition, which Shakeel Butt provided. 

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

