Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF04B29A9E9
	for <cgroups@vger.kernel.org>; Fri,  1 May 2026 02:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777602088; cv=none; b=tbzj9r/NeRDbzw+z0pXrkPCqFtfW8zv1nVpDvGi92LqU7DKA7WQdh+uqDLhFYIu1w8WPCsVSP6mwrpkruiHf6+NmeeKm/czWrfifKRXX5ZWX49I8b7QFJ4+UJijA0tbyOrEG4ckU8UpJn2K0kv+Yxa4nOpxIFEbNt38kwCn8bro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777602088; c=relaxed/simple;
	bh=Nfpug8EBqILfEEBWnFAmLFa+NOlWS63AoatPY2hJOI8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h5d0UrtBir/8rLTlCfTUnVmzLV/N71e/JkIk7R5EHH1tY7McljhzfWJ5f966ynZBJIsKgIfYFBGs72+qROSnTwEX4kQ4dpRSk3MVjKEOXZn8RQ10NYkgf1Jx0wabviuA8BFGk8zXo1EHtiysujpgg7uVoKXB62K5Vtv0Ie8FLvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UZn6lwAU; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UZn6lwAU"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777602075;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3twploam4MV/bq5u/Ty0iH6HK100PxWqx9qv6h7XzQg=;
	b=UZn6lwAUya5Xqtq40t+UrkKEXXFY9Z2IHb6Rwly1pbpj3+VOZ9/R474cwB5eDgVQvM3oFz
	tq4oR7/tjB2jcS5ypfFobRHj/IGmLL5MTnbWaRkWgjFUw47NQ/iWJQPXkmJDYH0Wbgi8lE
	soqpuUXGjwL2TyvDxA3aI1aUZnDg530=
From: Li Wang <li.wang@linux.dev>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	shuah@kernel.org
Cc: cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] selftests/cgroup: Fix false positive failures in test_percpu_basic
Date: Fri,  1 May 2026 10:20:56 +0800
Message-ID: <20260501022058.18024-1-li.wang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This patch series addresses two separate issues that cause false
positive failures in the test_percpu_basic test within the cgroup
kmem selftests.

The first issue stems from a hardcoded assumption about the system
page size, which breaks the test on architectures with larger page
sizes.

The second issue is an overly strict memory check that fails to
account for the slab metadata allocated during cgroup creation.

v2:
  * Replace my email with li.wang@linux.dev
  * Adding Waiman's Reviewed-by tag

Li Wang (2):
  selftests/cgroup: Fix hardcoded page size in test_percpu_basic
  selftests/cgroup: include slab in test_percpu_basic memory check

 tools/testing/selftests/cgroup/test_kmem.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

-- 
2.54.0

