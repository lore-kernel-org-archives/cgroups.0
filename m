Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0046A33372A
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 17:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791997718; cv=none; b=ToHu0xaRTFX8tr8b7c/Gm9SI4GUadetDI7gKCanY4krVW5OxOqi1tCjkpcP/mFbviPVI1sJtnqEv0yOUv4gHwCkP1AwfktFNxnQ6Z2oVe4FyRD24nR10Fi2Oc+Paj6RgLcf9XAEz9Cy08kHkg3AIsqNVxKWvVmwvC3tVB8W4FWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791997718; c=relaxed/simple;
	bh=hwfXrW/EvomtAm4NrtmoVlI/5Xl6aGcl4UefFobW4W0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Oxqx+7xk1YEKLXCXuV4yfexuTFIyizCdBOAEpCq+7mw8tcQlFSW5PQYMj3SQfKTBjHickFR2TioavRMJlXptXUCVuVCgg+LI9cOeAa+f2FLAPxNGzFdXNndphFlXVkhDzzX/2rJiOm43CIKUeqFRatMapZHi+A/4OeePgcNXpqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=LsXzq1cv; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=1SJjmi1g; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="LsXzq1cv";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="1SJjmi1g"
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69EGYI8U3257615
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 13:08:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=wvjq
	WmYMUiWctt9uBifSZeGbTvHPcL4+6cXa4k8By7g=; b=LsXzq1cvAORo8xB3WYL/
	M79uZ9MXS+5I2WdaA6VMhwqPsLyjj/cwfATCQIqVbZoSasTKw7AdYnwUsaWdGC6A
	hcMfTZBz7X0XuOmSvcLmG5/RwI3YpcZb3cLTc8MOkhHJTwYkfz1cA/AvCX6VlAwm
	vCtoQufw9pAfJ/Q8mfiynMRT8ZtUJ2JVrtIysCWCLbQetZgDQt6yxj6vuhyq8dhs
	0tWgnJ6NU3AXFiDN6+XyZc7tSoXQWIYoVnzXn3OP8Z8WSCTxmy75aCbKuKFtYYxq
	CoJd20bZvdrFHlgCYpXG4qE8AGjMAjl2o3N2+CcPpQemJnH5mfS3PDrvueNREq5g
	fA==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4ha024cy38-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 13:08:29 -0400 (EDT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-9197553d398so12816236d6.1
        for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 10:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1791997709; x=1792602509; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wvjqWmYMUiWctt9uBifSZeGbTvHPcL4+6cXa4k8By7g=;
        b=1SJjmi1gA4WWGufr4YDhfTqAV6EAcbnUtTZbQSsP3pIKv1A77p7fBWbMoa9O5TrHRB
         WkbUE0xCw3MEm8SfxjjVY73LMouFWrSbWTNgTL1GCtYj9jEJERJHBn93shyXmphsCVJh
         4rkhdvAXJEbeS0bwxIqoK7dUaoKhHAUldXWTnhWx0GbWGCNQ6nTalQY0nVPaQqGxqz30
         qHJxD7smJbi8ukVeZ6woatzrzm0+/QjnKRMW9vZCvKNX+ZNyZpE6sHKkk6AMfk+hKLGP
         rldnSzm/0OQc1EFJZ5q42UIWZWySjoCSrbSF5bxOu7qj4jX1PSmyokwQPKx7wfMNn4UT
         Lpqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791997709; x=1792602509;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wvjqWmYMUiWctt9uBifSZeGbTvHPcL4+6cXa4k8By7g=;
        b=jKUGhEd7M9aa9F4v0a7Dcyzz/TdqhrVNVFOzpkX1E6SUPYxKhBXmBliy6YvQvyfyUg
         Rb9GHyZzEEc/kt0tFhaO+dQRr7k2U+1VxqmIubR02QAATJpsM9BLNE7zH12z5zq7i/MX
         HMmzSFL0nLZ9kl8ZqtJ9LYhXy/Wi9DTrIfFN57xtCnC7NgZEcS46wbQsYgrNp7PJ5MFj
         GYRLBN1F2TohfTAI8dP6lIyv7x15e5lXuJ4/p/zkfGpo5OxJqJDd44bO76sZP3i1k6dM
         bL+cTXAIiNckIfIAFNbqrVxiN3DZpKRE9w3kpt4hY57EHCEY6rv1s0tNVyerVi+wPI9q
         Ckfw==
X-Gm-Message-State: AFq9FYJrkucNGVUm2t0LEsBzVxKsNhQcGdmz/80aLFhUPqi2EdlQqYXb
	iw0xTNoRbN5UcRLRhqMtO3MMhM/vbzmN9Rd6GwZ0NkDnG2nBGf0WtkhWnA2dFJrrTKAng1kL4t/
	vUFSlYvHL1Dpuava1RzTxLJu+F97B97fF3nvI20Nu7WehsPLF7bw4sFs=
X-Gm-Gg: AYBFou2BevbilrPRoC0ZPiWNJzhZLrocdvKNeUr2hmJHq48PBITSSwM0y4/dVijt0/4
	Y9+M4Kacr+HTj2mpM9VDzUWZtfWLIxTYUJI8qBmKCm3V7DhQFU2rhtVpwdrwXFJyl6zHz9TN5lg
	GtFTMt/WC715cdI0fTLtaK+VtdPnC8iLdOX5ueMrRhnUDVGX9FVAE2DeKQ2b3GuxuiIntWdsoLh
	uY0WcZNQ10YYoDYf+EiGwMVW0at0WP1xGkzp4g6NfrRCttyZBnJUM4QARdtJqhz/K5lHF0mioqm
	ef8rD/ygw1B8H1382LLIZ/9FetcNzrR73wX5W3eur10KkdjnLWbDoJ1hPDNOD5xGwOG9KHd5kcz
	QZsmC2XTpnpaa0Dcno1IvelpUg0dyxAlGueD8Jni8JPfWsIk=
X-Received: by 2002:a05:6214:2524:b0:917:aeec:a168 with SMTP id 6a1803df08f44-91b5532c8e9mr267544026d6.2.1791997708759;
        Wed, 14 Oct 2026 10:08:28 -0700 (PDT)
X-Received: by 2002:a05:6214:2524:b0:917:aeec:a168 with SMTP id 6a1803df08f44-91b5532c8e9mr267543326d6.2.1791997708075;
        Wed, 14 Oct 2026 10:08:28 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-148.net.columbia.edu. [128.59.176.148])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b9bda8643sm49190116d6.25.2026.10.14.10.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 10:08:27 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 14 Oct 2026 13:08:21 -0400
Subject: [PATCH 2/2] mm: memcontrol: remove page_memcg_check()
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-memcg-unused-page-helpers-v1-2-240b37c53831@columbia.edu>
References: <20261014-memcg-unused-page-helpers-v1-0-240b37c53831@columbia.edu>
In-Reply-To: <20261014-memcg-unused-page-helpers-v1-0-240b37c53831@columbia.edu>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Muchun Song <muchun.song@linux.dev>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791997705; l=1282;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=hwfXrW/EvomtAm4NrtmoVlI/5Xl6aGcl4UefFobW4W0=;
 b=TZ1ZoYpyxWx8/N/dvvOcZk3ivGbLWSEy1vFeU3AtXGJupMue7wcYcSNO3eJG9IivQ0ZJ2RAhb
 y1B7LNZP21rDHAEmJ+aoDG9vlhr0/yR4e7puZzOKm1fw5Xpuis+XXPB
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=J4E/fwnS c=1 sm=1 tr=0 ts=6acfb70d cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=dxtdfZqDOO0kCslK4e47hQ==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=ji2j2xl9BP2pTznAyDMA:9 a=QEXdDO2ut3YA:10 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA2OCBTYWx0ZWRfXyTn8XzPgNAc2
 575JnAV5OnomLXmtbGcxoXOytu8vg1T1o55PhCQug8gESsFMTOSAoOtLh0zkcNOBYdgboZ5/4jb
 93wILOt+YsNAajcrjzjuIXNnZeJzfrMFMjbGv3vF9bLLriMM9pBj
X-Proofpoint-ORIG-GUID: LOQuGw4KuRCMf4rshYndAevabbMtaPkP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA2OCBTYWx0ZWRfX9Id9S+F/or9N
 8zGGtdh1lYNG9zRzNI/tPFaM+paTkow/DYuU4ksXm/ewXDPV99YqB/HITCQl2qAXl/ulz47kHRr
 UKsSUWLjl+i6o2vfdSfpASKGBeTmDIQKdX8fH9tf2k3fZRkYk0LdpKamPEKHdIWogHwP/F+FNzS
 Lfqm7zsPtZFLS921Q5xJSImEXNTmr8mZzLG5QvQL+J/B+5DMuMa42Vx3AxCu1LbhAVILqub0Ced
 6eUx2Ssm81Milb7wNKauYlcd2kLS1t+F48Ofrd0EZyFvDQFvckqMTKcDhHJ+pcLbwgRmYpqBVJg
 xnSPEiIeeoVnR82GjDVLKSciBXVZhm1usw0QA5lsmHFU4DIy0IO5uswoFz0McQgNl14mQCaYPAY
 oHkBq8n8KhG4cf3uondvpNGg/1JmWdtXOaQVoKyC09ki7tP/nuGSlvZTxtU9iYELZc/mSwtZeU6
 pG5wcEmnJ+3+5H13UJg==
X-Proofpoint-GUID: LOQuGw4KuRCMf4rshYndAevabbMtaPkP
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11935
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=10 suspectscore=0 priorityscore=1501
 malwarescore=0 adultscore=0 bulkscore=10 spamscore=0 phishscore=0
 lowpriorityscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610140068

The last caller was removed in commit 90f095b816e2 ("mm/page_owner: use
memcg_data snapshot to avoid TOCTOU in print_page_owner_memcg()").
Remove it.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index b65a2d0fca3a..33439e285d94 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -499,13 +499,6 @@ static inline struct mem_cgroup *folio_memcg_check(const struct folio *folio)
 	return obj_cgroup_memcg(objcg);
 }
 
-static inline struct mem_cgroup *page_memcg_check(const struct page *page)
-{
-	if (PageTail(page))
-		return NULL;
-	return folio_memcg_check((const struct folio *)page);
-}
-
 static inline struct mem_cgroup *get_mem_cgroup_from_objcg(const struct obj_cgroup *objcg)
 {
 	struct mem_cgroup *memcg;
@@ -1089,11 +1082,6 @@ static inline struct mem_cgroup *folio_memcg_check(const struct folio *folio)
 	return NULL;
 }
 
-static inline struct mem_cgroup *page_memcg_check(const struct page *page)
-{
-	return NULL;
-}
-
 static inline struct mem_cgroup *get_mem_cgroup_from_objcg(const struct obj_cgroup *objcg)
 {
 	return NULL;

-- 
2.39.5

