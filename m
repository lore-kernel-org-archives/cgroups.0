Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794607545;
	b=Q4P6Nj03wFrdRdlZIpZEcCnFiGaG/Ku4x7sSmVPFnJMSFy+eIX8enh+UF5p1+TS9g0Y+
	 f1CSXqE8lqDLwd8qrczeckB0GiOR0dwguT2nHYCPEQTmkLslHYolmVfzkUjQdTG/xgDqE
	 u4EzQm8hAhWqrnr4otkgv8kEyCpNabLQaxdp7Qh3nXYsLva41SaIGwfqmdHy2sGtwsgNw
	 xMcRSql3MuD1doOM/qSuslOlOgyfayEWgXSQjQJdysVgvCmfLLgXpsiooEqQ7Ybslu72f
	 F0WBwsVSK8n9hUdlS7o1u06tFZMyGXrCfzfdTRVWIpHnyNdn5FPQLx3kTcdzGkUxnHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794607545;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YgttlTwq9TxT/yyyrQShMeW4eBGuS6HklOlBPU6eqn0=;
	b=Wgzhzc8XAws9OTawqRIARKq9bhpG9TUzqCky6PtTWbO4gtr2s10i/OgrWoiPbzjRwXLa
	 S1cGDQjQElCi1YSqQGvf8cVXXo1ViFZdi88A18LmgtmDxAZ+dw8+L6zeDLc5Y1ZxGrX/3
	 HxlwpYZCLT91cdDsuZK4wJwpEmEqJ0J7gZBZhc5XK8kCadg5IB9bIxtm1GyN+cDbRWOam
	 hi8WitkpBK2+47FL63wVxq4CZOL8YiqaxIJ0Y36NePiP+omUh7B8OsZMxpsAMma/UJat+
	 ACZ5RRwoijDhy7MWmm5u2ZpA8T/vRbBRROpoaBmujlBM4P9pXd/gQ/P+t1ZhTOtcFaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JRyxkfqQ;
	arc=none smtp.remote-ip=74.125.224.44
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228D8606A330
	for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 22:05:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 228D8606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JRyxkfqQ
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-679a2b5fe87so1742544d50.3
        for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 14:05:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794607543; x=1795212343; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YgttlTwq9TxT/yyyrQShMeW4eBGuS6HklOlBPU6eqn0=;
        b=JRyxkfqQGqh98A/nJKAcqD5QHgukBuKN7TyvozwqGRZh+QnYlJK78ArockRO3XsyvM
         Vm/Y4xdJ443xlAZOQnSS8uT7oofueC1kA2HeJQaf6nSQwIe57IsqM4Hbp/Pt+Slg8t7t
         Oa8Z6+a/rWczyCopRr38rNpIyh2D5u62JpfETeuZA/+p2EiHvurBi++ZuvzldItP9Nkq
         UP+7XhrL35i8lYC2J+acb0LxlqCm945CfacnB6X81KOWrb57HKQIPJiBwXAXJnO0fIbR
         kmvDtE0dkcYnVDgVOMX6SZpf6mU4y8cWXqJwOF5J1+Gn3wMOg3G1rnG2bnfhMM3goCSh
         lpYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794607543; x=1795212343;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YgttlTwq9TxT/yyyrQShMeW4eBGuS6HklOlBPU6eqn0=;
        b=kJXcZdUB3KFFGVYTb/WddqInP4RZVeJfK78K9xvHF9iaQPYLfTH5q2jWrEyOos1cMa
         93PVCtgoXa0jg70uys45pdiJtEt0lr2kg4pHffVz9kyVVvOLkcwDJ9boVGqsv3MckMIb
         VwVzDxNuPDs5q5sJ1cIcWcsMtFi3oNRyC7l3dfvD+AxijZw6S7kN6A8mez8FgG/hdEUq
         irlunEPc7fFf/KJkUzHuLSRXSNkXm36ysMwbjt0uLhEx43QghlfPZ1BioxNM/4zhFN0B
         bzieRVs7KiJeXnC9jfJTpCaKMGSZU2Pl7Kbg0VEuTT8mnNCNM2hW+QVZleTDYrCTNdxm
         X8nA==
X-Forwarded-Encrypted: i=1; AL+hErH7JPzNw/ZqoCHyJ30Ey4ShJKtjucSbG1QPjiyQhSIwXe4SgyanI+NrovL3tpsjVIfIDyevatwx@vger.kernel.org
X-Gm-Message-State: APuU4Z/Mb4x35/CH8apiGAd2SzxFIYyQ11rRIIFalV4xeV8vS48bIh7I
	jHutwkqeVDpkP2Vy1EDAQz6H95YAqdK8+Q4ctYkFZnxMSBtI2btSjIpD
X-Gm-Gg: AYBFou2HXWMuawITcagELBYHZZoXKvCK71y/h1WozM0DA679tBniAPueZIwK/ZJ3+FM
	OK7n4NMr1k3I/ywGl7Ax9zrMFVNtmsafo+ABb1PskuKpCLMTBsrYsCNvSNxZN2n/oS6dbMRejnd
	8CdJ37+EtwSTkY/K8QqoDXrsP0Utk064hxFR6nh+THLnd1NeaqTHiDr6exuLRqbGEA/qGprxyUl
	qZfexQZWXr1JhkRAMy65LIo7Z/LBL32wFJnc6YFaAamRuD/apUz2Rht2QIUsa/8dvqz9fRWPcGk
	RurQvDNEpK2nReeAHykpnK0kfWo8lZslKGcYsW9is3DF21NDNZA0qnzID8IOxq18CvfQjGcBA0j
	UINg7xJKFuestPRmrcH+j/12/W2bzfu0F6pkzCUHlnJtJG9O6BNEGN3B7U7cOjoNJfJSQw/9Zfg
	sLGVjB1Z9hone+WB2X8T7TfcyVOdig2oLwiYN16BwhiXKCtutChtscqjeXttcyf/qTvtQUdtbnK
	ldxfhminsSJ+61yvOSLhogfz92qMwOGtx8JfupYl8Dsp6Np5dsbLYV/+NCIRRFjE4IzxoHLQzZA
	/zQoIU00xMilrJox7e0sCwn2s8jmnOi7bVWKV7ezSUH6OZ6RSu3hmrucOa8suA==
X-Received: by 2002:a53:b84c:0:b0:67c:b95:6753 with SMTP id 956f58d0204a3-67d8976d393mr1422762d50.146.1794607542894;
        Fri, 13 Nov 2026 14:05:42 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:53::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67d8a433a15sm3200910d50.2.2026.11.13.14.05.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 14:05:42 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Michal Koutny <mkoutny@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Harry Yoo <harry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Balbir Singh <balbirs@nvidia.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v9 1/7] mm/memcontrol: flatten try_charge_memcg control flow
Date: Fri, 13 Nov 2026 14:05:28 -0800
Message-ID: <20261113220539.2275715-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261113220539.2275715-1-joshua.hahnjy@gmail.com>
References: <20261113220539.2275715-1-joshua.hahnjy@gmail.com>
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

Refactor try_charge_memcg by flattening the nested memsw/memory
page_counter operations to separate the logic between the two.

When page_counter_try_charge is made stock-aware, this flattening makes
the control flow easier to follow since each page counter now has its
own success/failure paths.

No functional changes intended.

Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 091401cecf397..aaeef20eec06a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2815,18 +2815,21 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		batch = nr_pages;
 
 	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
-	if (!do_memsw_account() ||
-	    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
-		if (page_counter_try_charge(&memcg->memory, batch, &counter))
-			goto done_restock;
-		if (do_memsw_account())
-			page_counter_uncharge(&memcg->memsw, batch);
-		mem_over_limit = mem_cgroup_from_counter(counter, memory);
-	} else {
+	if (do_memsw_account() &&
+	    !page_counter_try_charge(&memcg->memsw, batch, &counter)) {
 		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
 		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
+		goto reclaim;
 	}
 
+	if (page_counter_try_charge(&memcg->memory, batch, &counter))
+		goto done_restock;
+
+	if (do_memsw_account())
+		page_counter_uncharge(&memcg->memsw, batch);
+	mem_over_limit = mem_cgroup_from_counter(counter, memory);
+
+reclaim:
 	if (batch > nr_pages) {
 		batch = nr_pages;
 		goto retry;
-- 
2.53.1-Meta

