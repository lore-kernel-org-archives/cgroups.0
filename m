Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A863E0097
	for <cgroups@vger.kernel.org>; Fri, 21 Aug 2026 18:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787338683; cv=none; b=TBE6SWZ+Qcgpr74mgkTUGHfrrALWb6Vu1AA52Kmv9zP5VieNMrSST+kEvLywWXggY1WA3fDpKH/F2T7v7ZYvfkOLjGzNYKgbAGgetBsrbsztQsssXX43PHhdSn/pJnzvsO7sOhB1Aly7E9LuLSGfOsdYYM6QM6jXK2nLOhxW++k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787338683; c=relaxed/simple;
	bh=p4E4Ct3IlFbTeWS21yt/A9ZhhZobTV3W1Jsfzz388+Y=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nrhPcRd2NeHUbekMFQvw2OuwvBS+9ZLkMV646XsHrlgoQ2Gc4ZLf/LiUo2CUcKSBipRcSzzi1KfYLUInqL7he+WQXMjSpFB6e8jtUnu2u9wrQe0Yll0XcyFqr81TgTO87b8C9+tGm/pNsAeyAVtocN/jXtSXq23MqPf/tB75nz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bA2DGEKB; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Trc6mrBD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bA2DGEKB";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Trc6mrBD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787338678;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e2V2mpWvyYuIz7GKVVHxUcELAybMhQQsAX/9av2OZxM=;
	b=bA2DGEKB8b34WuDI1LSSAxtAxbWOnOFVVykKlynNz/Hohm6b46uWhCmSkrU60sOjYC+n5j
	ucm49vOUsN/RN+PUjwkPhpp8ipB8OPEalZc6ifMxRDQGXviD3J2lMFDUbLikmnsy13DFYI
	kGk3pfRQCCnU7kX5OhqeJf6W/It/Ej4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-28-Q3Mth6ClM1yYjluNJ78gHg-1; Fri, 21 Aug 2026 14:57:56 -0400
X-MC-Unique: Q3Mth6ClM1yYjluNJ78gHg-1
X-Mimecast-MFC-AGG-ID: Q3Mth6ClM1yYjluNJ78gHg_1787338676
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-92e5e38fbc5so154225785a.2
        for <cgroups@vger.kernel.org>; Fri, 21 Aug 2026 11:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787338676; x=1787943476; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e2V2mpWvyYuIz7GKVVHxUcELAybMhQQsAX/9av2OZxM=;
        b=Trc6mrBDX+zo4KJit944vd4EryF8ogDzd0zttSoaT5gO3/kZsiVh55oFO+OCMFOXdZ
         sbn61iyY+B1KSMphNhazGcTIp/5DaN3LGV0wey10B13v0tbWDJXG0pPmjmNKH4bGkQh4
         qaMivl+tt/YgzdNCjFtePnO/n5uZenMAU8jvBqXAeAY1UqvxDsWiNEwc71LyWt531AxH
         +LRSTiMR0PQIIEAG654GF52CIOnj64u/FilaR1QMMaBRNxQZDcIuwyTZqJBKMyL5t4rM
         w7schtzJ/CaA5StrI4I9zTMJL9LPfZ06J2XdPrwpEf5+PZE5FE3TAEJJ8X6NN/AQFUyS
         uOnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787338676; x=1787943476;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e2V2mpWvyYuIz7GKVVHxUcELAybMhQQsAX/9av2OZxM=;
        b=qaDkAGlH71mDjaY5lZmpY9wkQ5r/77/dV9lWTmuOMBeJB5nzUiCOHwx33QYgUcPDjv
         OaVRzZDhnpF/wKbxJ/imZTL4eBKtFJPQNhMWHQuol94FYvSOjehH7H26hiah5OfAKo4H
         z04XVIAJoq1sylJ7RM33q+xsMKnCClyWBVCErfw2N/UzoVNuy7JcBWIbtYqO7eFd0efT
         kP8ZI/j90uFFSCGLMUO8EOOSFNmmXciJmSbKcZ06i2bci3vaG7A4Umt3OiY/e0zrE7qx
         tfyZVQhI6V2kTnN7Rzc+p56uYuUE7P2tze1q409VWoQ37M5WY+Rx/Y1b/L8rYVxALkos
         m8gw==
X-Forwarded-Encrypted: i=1; AHgh+RqBKv1kZRpXwOHwROvfkELOwlXUbMWuMi/dmYCll0BmhkQ8RaiBzxQvI+Zaf5QT8VzD1rp3Zi9m@vger.kernel.org
X-Gm-Message-State: AFuF++l7WXeGOdn5WMi7qy2G7dBx0rYhZ0xuBYxaqZ6mTcI1f23It2ae
	lbQmfd5tJR2MngF1r/BvPorS9rQNU5HLYcXv2dZ0z6XCgXix1BeeGJQz3KbRPJD28yjdLHtcvjA
	snSnrk1eq1Pk3qcGjn4IArS9RdZ8Iw96uMTQ0PMPvf7X6S5HIB9J7QX1+xp8=
X-Gm-Gg: AR+sD12C/7/WiaQ0ovsohoNkUAK2eHkd7fLRUj1gZ3O4TQenlue+anv9kC1VksnrAwY
	RMK4D3arqtkPn6lIXpp6jpA+jBxklrnc31VlgXYbiUgDrn+apbrosNUEJSPynj9GmvP9GrQjyEr
	0qMjQLiJ63SfSlQPEqb7f80+LvS++y6wLjCIWTGlx0Ll24CnQ3W64VWePJP16FBxa+PrTwY7yjo
	AQN3Z2HTcKZ6If6hyvJRath7jcY7z0z7zX9Fzg3LwTVWLiXmr6fwtA+9LoxWFKheXXmWpSnHYbh
	EW2XaD9zO7498qaWwY/j8uzrb9a+RuSAtXqpQ4Fd2QK8sdM0T3KI2poLwgAcn7fNi54WB0hqAiG
	Q9z09blfqyfP7zFJ26S/471TNfLine2Vhf7Kaf7R2Wo4Y
X-Received: by 2002:a05:620a:29d6:b0:914:bd3f:b6db with SMTP id af79cd13be357-937394278e8mr807010285a.10.1787338675674;
        Fri, 21 Aug 2026 11:57:55 -0700 (PDT)
X-Received: by 2002:a05:620a:29d6:b0:914:bd3f:b6db with SMTP id af79cd13be357-937394278e8mr807005485a.10.1787338675183;
        Fri, 21 Aug 2026 11:57:55 -0700 (PDT)
Received: from localhost (pool-100-17-17-231.bstnma.fios.verizon.net. [100.17.17.231])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93720586ea5sm655734185a.38.2026.08.21.11.57.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 11:57:52 -0700 (PDT)
From: Eric Chanudet <echanude@redhat.com>
Date: Fri, 21 Aug 2026 14:56:54 -0400
Subject: [PATCH 02/11] mm/cma: include linux/cma.h in cma.h
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-cma-memcg-regions-v1-2-d21b165b8440@redhat.com>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
In-Reply-To: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Maxime Ripard <mripard@redhat.com>, 
 Albert Esteve <aesteve@redhat.com>, Eric Chanudet <echanude@redhat.com>
X-Mailer: b4 0.14.3

cma.h needs definitions from linux/cma.h (e.g, MAX_CMA_AREAS,
CMA_MAX_NAME), so including mm/cma.h requires including linux/cma.h.
Make the dependency explicit by including the header directly.

Signed-off-by: Eric Chanudet <echanude@redhat.com>
---
 mm/cma.c       | 1 -
 mm/cma.h       | 1 +
 mm/cma_debug.c | 1 -
 mm/cma_sysfs.c | 1 -
 4 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index e1820fb451e4..03f98f6d45a5 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -25,7 +25,6 @@
 #include <linux/string.h>
 #include <linux/string_choices.h>
 #include <linux/log2.h>
-#include <linux/cma.h>
 #include <linux/highmem.h>
 #include <linux/io.h>
 #include <linux/kmemleak.h>
diff --git a/mm/cma.h b/mm/cma.h
index c70180c36559..0c9de38d6bff 100644
--- a/mm/cma.h
+++ b/mm/cma.h
@@ -4,6 +4,7 @@
 
 #include <linux/debugfs.h>
 #include <linux/kobject.h>
+#include <linux/cma.h>
 
 struct cma_kobject {
 	struct kobject kobj;
diff --git a/mm/cma_debug.c b/mm/cma_debug.c
index 523ba4a0f9f7..70bfc6fbeeca 100644
--- a/mm/cma_debug.c
+++ b/mm/cma_debug.c
@@ -7,7 +7,6 @@
 
 
 #include <linux/debugfs.h>
-#include <linux/cma.h>
 #include <linux/list.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
diff --git a/mm/cma_sysfs.c b/mm/cma_sysfs.c
index d5bf792c6245..e4ee35bc682b 100644
--- a/mm/cma_sysfs.c
+++ b/mm/cma_sysfs.c
@@ -5,7 +5,6 @@
  * Copyright (c) 2021 Minchan Kim <minchan@kernel.org>
  */
 
-#include <linux/cma.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 

-- 
2.53.0

