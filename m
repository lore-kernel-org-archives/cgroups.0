Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B21713777E
	for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 03:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787542544; cv=none; b=Z6jjqvjEECyJjqB3giDqyBNGG6Fg15FBUUKzFRiEQzKS9uVCTYAHYif/nNzRf5Nhx+5hEo6xssH89UKvEA70SZM5damFdDNPvA2a8d44w6BW5AXLjB11JUby7us004wBT+h7694jmCGPR4V/CdTg9/+4KGrXbkPpFWthrRzJVhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787542544; c=relaxed/simple;
	bh=kbgCodxyQTaxxkxIo0FUrwNH41ZTUr4K/1wkJGxMPuo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=aMTZdLj7hKPo9925J1VJKNIok6Ry1NTtLAVIrzzEgai/jsGP8gonThNIM7R1t8c+RI4Wau02EwqwgzvzfhiQ35hYssVQYX/3tq6NRjvYyXC5GY9fQ3tblS63xfvWTDGgCF+smYBBcLZ9BZv0u9iBxuIC30W1Gq1sbojREaaFQkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--wfelipe.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CQ69D3AW; arc=none smtp.client-ip=209.85.214.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--wfelipe.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CQ69D3AW"
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d6c166bafcso4511085ad.2
        for <cgroups@vger.kernel.org>; Sun, 23 Aug 2026 20:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787542542; x=1788147342; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xxIn6wRkBnBvygNlVhjjksdALrlKyZQyyugm0lI7tMA=;
        b=CQ69D3AWW6HqoCoWr3QXKYEYidW/JhwFcL7aijHB6MaYJBvM4ydWchC5XvVTtvLJtk
         ydbgSD7iiuuJH0/8Jx6RPdFv5E2PPc0/yYRyIO2vYDLIkcfKjj/eQJIiYoBMV+wE/0tc
         6qrkqLOOE4TkTa4pk4+pPtN1Z+FpUkMiCjrNugQeVUA6d/Ka3/EJlAE9pUZGG0JlrM0n
         y6QedXrP/dsLG13EqnrBHTud82jhfECtQL4ImklBsU+HwKD968Pl2Oaf1EAPqm7pnkNX
         8iM34ixZ7f9o5y2UXjRDCAUMB4UPxKSt8+LsbVNwuCgJY9ZJw1/gIQbePQKn4uBjy0nD
         95EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787542542; x=1788147342;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xxIn6wRkBnBvygNlVhjjksdALrlKyZQyyugm0lI7tMA=;
        b=NPnewnp+cGyIZT9N4MHfxTd2L3mzIdgcZnxoV/PY6JbvT91dlPUQgG9prxn/Nz2UId
         SOfUopdX4LzkGzKdgPOUpiszlEho/YtrOinxi58pLrvJKA0Z2Ex0Xg0ti4aJw+QR2ik0
         mUs02t61ZGBMiko8GfVJ8e9Lw0JzM2H62EqyQeaDUNu/Q1fPle/OiOZ4rD3G7mvWUCPR
         LHZS4vuzG1bqSsi5VhhWAON2JezMqxWhrRO7T+LiLX7OUnuNFmc/l1aB73eQTqhv2nZ6
         rRX/CTJKn+0z9D/R5yYzUuMmViT4T0sYtwuDLNJlW6jPzo03G9jbwBK04h+EOXbQQepL
         xgYw==
X-Forwarded-Encrypted: i=1; AHgh+Rqq2Zy4L6iP+dqhWHqXQaTECf2znHa8xjuHaISpaQh7VoWXCdpvlBPvQXDyyObG/6NtviR0zQvf@vger.kernel.org
X-Gm-Message-State: AFuF++l5aYiRrPeHpsGH4CgDmTd6nKhVvJNZsd2bnrqRqsiugy9crRYD
	Yq10wX4jdrEWYIVaL7tX4Sr25sz78pdxj4obduQfbUEsU/HUlbQkueljN5uj3y/MfZPnK9rPPai
	wGGreVHY1ig==
X-Received: from pldc11.prod.google.com ([2002:a17:902:d98b:b0:2ca:c3ac:bb34])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f686:b0:2d0:cc92:f7af
 with SMTP id d9443c01a7336-2d670c96265mr233860275ad.9.1787542542407; Sun, 23
 Aug 2026 20:35:42 -0700 (PDT)
Date: Mon, 24 Aug 2026 03:33:56 +0000
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.766.g2966f0265a-goog
Message-ID: <20260824033533.2147900-1-wfelipe@google.com>
Subject: [PATCH v2 0/2] selftests/cgroup: fixes for test_zswap on single core VM
From: Wilson Felipe Pereira <wfelipe@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Wilson Felipe Pereira <wfelipe@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This series fixes two test failures in test_zswap observed when running on
a single-core VM (-smp 1) with 4GB of RAM.

Patch 1 addresses a race condition in test_zswap_writeback() where
waitpid() returns before the exiting child process is switched away by the
kernel, causing an immediate write of "+memory" to cgroup.subtree_control
to fail with -EBUSY. We fix this by waiting for cgroup.events to report
"populated 0".

Patch 2 fixes an implicit unsigned conversion bug in test_no_kmem_bypass()
where small negative timing differences between debugfs stored_pages and
cgroup zswapped bytes caused the comparison to falsely fail due to
unsigned promotion.

v1 -> v2:
- Patch 1: Replace EBUSY retry loop with cg_read_strcmp_wait() waiting for
  cgroup.events "populated 0" (Michal Koutn=C3=BD).
- Patch 1: Clarify task lifecycle in commit description (Yosry Ahmed).
- Patch 2: Remove abs() and declare delta/zswapped as signed longs with a
  signed threshold comparison (Michal Koutn=C3=BD).
- Patch 2: Add Fixes tag (Michal Koutn=C3=BD).

v1: https://lore.kernel.org/all/20260804042053.56940-1-wfelipe@google.com/

Wilson Felipe Pereira (2):
  selftests/cgroup: test_zswap: wait for cgroup to unpopulate in
    test_zswap_writeback
  selftests/cgroup: test_zswap: fix implicit unsigned promotion bug in
    test_no_kmem_bypass

 tools/testing/selftests/cgroup/test_zswap.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--=20
2.55.0.766.g2966f0265a-goog

