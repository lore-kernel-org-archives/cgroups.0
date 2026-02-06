Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E16930B51D
	for <cgroups@vger.kernel.org>; Fri,  6 Feb 2026 07:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770362564; cv=none; b=Odu2O1JOk4et/xVSNwaRn500Dy9X1KkLv7bJyIVti27EfUiAFd+I4BCQAIL1Ocq/a6ZKs5jVQpQZ36QOQPmS+7UJ58a0ups2xGmqFhVVbl/hj3EWkwt/mu6nplqVLAc91c1LzKJl6KegHS9AxPiOt0R38iarIZtjYyxC3rYhaqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770362564; c=relaxed/simple;
	bh=Onzvce5Nzkj3pJmnRVm5lfenrB7dgKRCKFm1hNfC8eQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kkmO9XqMrfq7X2zCjXePW16a1UySFX/ppKcdh7GuDyYMlFXzwYXGuan9PPvZMUk6JLz4Vo0LgUmGm6RTTFXUtEbTIuKHxQHIn/RZtEus2ozW4bLO2zWkZSIVzv9QqAs3mho9RXyWDqzqdWP0UdekpAxFuncHk5CGpZCmB6MquPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZthEn73D; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZthEn73D"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770362552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XrFsXOEXMwmpE+X7noVwyIey4LQ89wmI4Q6a+MI4j84=;
	b=ZthEn73DhQMpdw0mejJoSncG/7xCwqooUAFD5+w2kfvO+ILzsyQhn4EWIpHRg550dU2drV
	HMdw15SxF0yj/wsHKFu+8sovUsh3uMIk3MVfJeydVqkX5C+ibmTZlN/mCxD9U8BmDw9Dmu
	c5ReqVc4wiHyTXNbPw8eQoNDoezjqXo=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Shuah Khan <shuah@kernel.org>,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v2 0/2] mm: zswap: add per-memcg stat for incompressible pages
Date: Fri,  6 Feb 2026 15:22:14 +0800
Message-ID: <20260206072220.144008-1-jiayuan.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

In containerized environments, knowing which cgroup is contributing
incompressible pages to zswap is essential for effective resource
management. This series adds a new per-memcg stat 'zswap_incomp' to
track incompressible pages, along with a selftest.

Patch 1: Add the per-memcg zswap_incomp stat and documentation
Patch 2: Add selftest for the new stat

Changes v1 -> v2:
https://lore.kernel.org/linux-mm/20260205053013.25134-1-jiayuan.chen@linux.dev/

- Rename zswpraw/MEMCG_ZSWAP_RAW to zswap_incomp/MEMCG_ZSWAP_INCOMP
  (Shakeel Butt, Yosry Ahmed)
- Drop zswap_is_incomp() helper, keep opencode (size == PAGE_SIZE) with
  comments explaining the incompressibility check (Yosry Ahmed)
- Add documentation in cgroup-v2.rst (Nhat Pham, SeongJae Park)
- Add selftest as a separate patch (Nhat Pham)
- Add reference link to Chris Li's discussion on the need for per-memcg
  incompressible page tracking (Nhat Pham)

Jiayuan Chen (2):
  mm: zswap: add per-memcg stat for incompressible pages
  selftests/cgroup: add test for zswap incompressible pages

 Documentation/admin-guide/cgroup-v2.rst     |  5 ++
 include/linux/memcontrol.h                  |  1 +
 mm/memcontrol.c                             |  8 ++
 tools/testing/selftests/cgroup/test_zswap.c | 96 +++++++++++++++++++++
 4 files changed, 110 insertions(+)

-- 
2.43.0

