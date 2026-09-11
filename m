Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7425F4BEE41
	for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 22:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789164597; cv=none; b=NK82rwciF8+JXQVOgZLJ1Ac8Vlz3A7zD8MFaxaC6ybcZurWL7AslyqgoFOhU4IS5s5qGjQm0+ie71+MxG5GK8z61ndx0nnlxsvvWkFfKD3M31MVBTsi8+uhSUrhD6Vkv502Z7xydXJLeAWnQsHMobV12WU2sE69eKG2emqfJkIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789164597; c=relaxed/simple;
	bh=t+Do4nGFECT6+LKHRKvJVejkOKMJELdYcZO6ItT3PsI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lC1SQzwKNGGWYHnJyt1C0Uwg4Pzz9hsCihkdt+BlPqKELmNXJv+3vZSXUYhTu70e1P3/FhHnyXBeZYGMybXP8bmPCMIUbVRKaXolGVO+6oqvft6SlKvsBzRBtAuQWYJDowxPcX0UMEAJHo9VmKw6WZUBx0CEyl+ibApEAVEGgSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UXVKXqDY; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UXVKXqDY"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d822dso450145e9.2
        for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 15:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789164594; x=1789769394; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Dk8RJ/gWGUzJZL37Z13wVy/RHkm1H9VT60iwGnpNGc4=;
        b=UXVKXqDYkUXMqC1VF7c5oSmOINGOJjIRwB+zt63W1TugeVgGhA+4fA0uWFfdCxMnml
         JY8aOD6UENqwML/LorPb3nBylNitbNjBtkbAOWs3l9pNaLZZ1YeN3Vjkc/EovEZEI+4O
         bpRZFnENG8YuAf7qOlL/zoyFyyIK2Nemdl3BD6iS6HOBUewYeUSkiuaVxKeKt5rjloDk
         okfVGjgHoYrKlWgOoE5s2SczIkCuuahrw1Isgb/zKXwtuSGVEhA8YHDV3A0+QGeM8Eq/
         cuvoxPx6Rgj+7drav+4YNH6hUcoJ3itgi2nFP6n9IECVTDsrlhntZODs2ibr7+isStYY
         v9pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789164594; x=1789769394;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Dk8RJ/gWGUzJZL37Z13wVy/RHkm1H9VT60iwGnpNGc4=;
        b=c66l6XlgFkZ0EWfEf9FnW+cDR4UPAN7VxVSAINUzjlMNJ+Vqot93QggtRnyQTIMsTX
         mxSj76CnZUNk6dZ1ceJI1qgLqPh9OQMlZpS1YTeKFJ9aL1SkRK3S6kOaudxAf9mX2iRb
         2nQgDGgeImULenD22kp64ugrAho4lemufSw8mbUBe4qfaNMFMd5yk/6bqcWDZPejd3QW
         6XrO22Cu/HhIEFwsKMN0JnpaKJNQxhy0DdY84VrBQdnxrgNZi/NE56y9fg2ib/r8vqaB
         CADhw3nQ9ylaHAIRFE3YgBU4cNhBA2oII3q1pKQxYTBjrI4bcyA4gw9YQxaSSnuABadx
         IIQg==
X-Forwarded-Encrypted: i=1; AKwUvBxsp/yTUZFrFxQv+QJ3AZrnAKHAYvg+GSkTq8SioWVwsfpbyol43GngDC+hFRu9XX7EGKxfByfr@vger.kernel.org
X-Gm-Message-State: AFuF++kqTjAKr5OVHgdHOdS8RshMIy2BgcEKLWlYMOUjZtY/6M3JvOSr
	pwcHXRUonu3pc332J+tq21Wmw1XYg5VwWHTyJrBCOsZHDvqB3Jlvs9L1
X-Gm-Gg: AYBFou18Ul6/x/tm4Yo5AS/0fT5G/rn/atw6yFzlMrmuc0UwrZaFnHTt+DDYYPC/rGr
	TL9QMaiEckQbUCb4br4iZK+DilLfi+IEOoZyVJ97AE+06PcdfcmMdLBTo+xzen/E9T92F0EHnAO
	vooHk7cRe1RQivY+AyII1Zj0MUpZ0acZFGLwKGh4ycp14u8dOk2mkAvK+0VwtZlbDPPjSF3lhMy
	6bT/v6B9YtDTN3tjDLBJcNGdBm0j3HyYFPRKSD3krJKC0+K+R97lfN79rEFJ2hqjc4HR9DHQ9kk
	Aoh+uznGyEV4lgKcuxAo0/q+WoTUEw6nBy0D3H0Fxd6u5Ojp+d+KSg4wXxvUKaJ/AcZte+JJkaA
	RqB5/qif9ZPGLWF2w5XjcrhbfFUE54SPyueGpU6Y9H9w+y1Nxym9BoAcHZPaqRVGomyG57g2OEs
	s4VHoxrJl+z/FivmtbkN/muwq7bZ+j9jYEiDxYJ/au951/+INjbKL049kqFIgNevn2sL8BuM0Be
	k8/1X8egh2zwF305TQAZgquvYA43fxYL1BP3eWujfbeZYsiVUuCHiV2WYAwb/KjSoBUFwX1QWxI
	MBw2aOlniLko7LCB0b/+xNHEwaXpSqdfMcubSzP1OwLxjmk=
X-Received: by 2002:a05:600c:3f16:b0:49d:25b0:cc60 with SMTP id 5b1f17b1804b1-49e6cc13c99mr904955e9.29.1789164593578;
        Fri, 11 Sep 2026 15:09:53 -0700 (PDT)
Received: from localhost.localdomain (dynamic-095-114-033-154.95.114.pool.telefonica.de. [95.114.33.154])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e69f02c92sm33383385e9.2.2026.09.11.15.09.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 11 Sep 2026 15:09:53 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	cgroups@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] cgroup/dmem: Fix eviction helper reference in dmem_cgroup_try_charge()
Date: Sat, 12 Sep 2026 00:08:33 +0200
Message-Id: <20260911220833.6958-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel-doc comment of dmem_cgroup_try_charge() refers to
dmem_cgroup_evict_valuable, which does not exist. The name is
dmem_cgroup_state_evict_valuable. Say dmem_cgroup_state_evict_valuable.

Fixes: b168ed458dde ("kernel/cgroup: Add "dmem" memory accounting cgroup")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 kernel/cgroup/dmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/dmem.c b/kernel/cgroup/dmem.c
index 4683f3d6802268ddad40bd5d9e10305fc4dfddc5..13dbd083f6dedf83002ee7e7912e1f983e3594f0 100644
--- a/kernel/cgroup/dmem.c
+++ b/kernel/cgroup/dmem.c
@@ -706,7 +706,7 @@ EXPORT_SYMBOL_GPL(dmem_cgroup_uncharge);
  *
  * When this function fails with -EAGAIN and @ret_limit_pool is non-null, it
  * will be set to the pool for which the limit is hit. This can be used for
- * eviction as argument to dmem_cgroup_evict_valuable(). This reference must be freed
+ * eviction as argument to dmem_cgroup_state_evict_valuable(). This reference must be freed
  * with @dmem_cgroup_pool_state_put().
  *
  * Return: 0 on success, -EAGAIN on hitting a limit, or a negative errno on failure.
