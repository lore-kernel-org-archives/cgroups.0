Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0CE514777
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 16:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789750578; cv=none; b=UUpYfp+JyKLI7Pd4ofesfUcxXUicOqbgD6biW/KYCJKI1iyUnWTObJZOwug4rZg3mfYUgA33iEUM4pVUaS15LfOi8mCjqTZa88SpEp9LE0zC2xkE2GwzAhIN9FIjUXxNP97QUOyTO+bZET5LTJHbZbMThKo3LQioD1UNwlcXj4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789750578; c=relaxed/simple;
	bh=U/LYoO7oBxOuvMc09F7HnYsAy38akskdSWtc0NSRjB0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KWIK+99oW/xL/be7xMDZbsWFG29/oA4Jkq+n7ANHfpS52ayO19zZu4J3pf/5VjTBapFokrmGB4/AP5Q1ue+8kfJrEVKB7pHQBOPHIJDVWqfHV2+kWJo7m9R+ET+X+11x8rS1xzck2R5A6k3tyXGxlZhULC2v4a0fTipbir2s518=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ifApiZS1; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ifApiZS1"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2dd88a115ebso8863325ad.2
        for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 09:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789750575; x=1790355375; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vlZnDcCseMui9jUINJQcjoCRqZxi7W4Ng1w2zFUjkmM=;
        b=ifApiZS1NdInPxdYtZTVQ46Q7vyyWRDRKf3XbM3ScVLxSkaPKnTrgu3KFdj/QbUJtc
         sx0FEfV9daGJ57/TyLzwhAwTNx5yK2bBreomDJ6wZWhHQbjXfkyplF7Gnv9QpoGPNI5g
         C3I7QzyWmHAjEGP2OncxnA9v7x1jbKmp49aeEpItknar1vWCaIJbdUiqofaliXACz951
         b97eumQSsKmcj2a84MiLfFeeDAoJkpuSra/Uw6eddZfd05Ehp+X+iGJpgp9LOGkOsDHo
         4s0F9HdIhPJjgQcFoYM+Sv7AePTB5rnpeG5b2drEShol9ZkcB9szeCZwWg4gLUraQ1Ey
         rqwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789750575; x=1790355375;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vlZnDcCseMui9jUINJQcjoCRqZxi7W4Ng1w2zFUjkmM=;
        b=wRSrsAf+oHo2Fe52i3x8N/k+jro+tP3hIJYM72uT+oTeZNoPx+AmjJF56koZjLX71Z
         +1CH2S1Thig/HVw/7hGObgSqdt6BbLgotkqd2nTFEbBgKpoF799Rtl7y9LVjV7gA45Da
         jr8588Ljzr8vuGWiXtfyWr/Sf/9OQqet7CDDD9Ye+plEnqz95Qz9i07P6g0ROUCGovMM
         n7JSplxaAw4Bp/YPumfTrjH2qEucnhVSjihmVOn9IhhSyBUzY6+6eQRUi+Mu7247LvWg
         ACkfHOQhoYwyGPFlM+yeFDsl5ehc2yXAp/hAawBD3H2Kdac6Rejuqy+Tl/7vUUtnWg2M
         rVgA==
X-Gm-Message-State: AFuF++lOvm2WpFHAugDIhOkDmmEeJTyUsJFNg6VEOY6MGMfeT3qOIaVe
	DYT0P8u9acZefnLK9iYyuBxqUezEBa7LIS6wtPF1iy4/2h6hR3zOzBRC
X-Gm-Gg: AYBFou2FnAa4iWUTtI6qh6ntgwWwxA4rQKdIFSIk9GjAZkh6DcB31L75dsJdA+bc5Ax
	IskqXlfiVsBvK6SKjckH+zF78YgYYR45WceM5K/xwyASarzyyEKgsYfAPugBPDB6lINy5peV1sq
	DKfObhmuUbuNVpqFCMPmRuKVQS/PHg6BERyWJETrqHBtRA9sj21q1sW7ukhxI9/7NflhzUrQ19h
	t2CL0K02unwslBl5P3rdwNooqbykHufKLBureCnRWl+OrPzOw9ktGv4grruLHhoX2jmeHLdkmtw
	5rh/OpvZHOBgLGnCCQP1wUcAPkqsXF3KN6SkbRCnO4Dh8wkp7Fe5k3ac1Q2dPXy9o5LMeRT2Lec
	bxXBMNCtLwmfxDxloRB15hyyhQS5XZFoCm4tEBvrVhNoQUmD/deFVFyp0zNW1S5YwQW05B8VUjC
	K57DO3pfOjtv3VSecAU97rlS9yJjnG1KJ9P3DQ4lY9rVHwEfMsrdpDaPf6iRq07J9unA==
X-Received: by 2002:a17:903:3205:b0:2d8:f965:7e48 with SMTP id d9443c01a7336-2ddb1ab3990mr72792395ad.1.1789750575418;
        Fri, 18 Sep 2026 09:56:15 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ddb75bfe10sm11409685ad.64.2026.09.18.09.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 09:56:15 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH 0/2] memcg: remove unused page-based helpers
Date: Sat, 19 Sep 2026 01:55:56 +0900
Message-ID: <20260918165601.1014666-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

While reading memcontrol.h, I found two page-based helpers that have
no callers.

No functional change.

Sang-Heon Jeon (2):
  memcg: remove unused page_memcg_check()
  memcg: remove unused mod_memcg_page_state()

 include/linux/memcontrol.h | 32 --------------------------------
 1 file changed, 32 deletions(-)

-- 
2.43.0

