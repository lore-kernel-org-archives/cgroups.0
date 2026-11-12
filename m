Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.144
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794453587;
	b=P8BPi3mWbf92Mo5ZcAEnCN8T1CiowUJ/3eCWB+kC2pCW+b7K9rOI/490am4v2bJCOMn2
	 C9AwtktcG34jBE+LHWGxH8zVWT7jRYi9GirT2H/rbddsVynq9Gef4dcKZaOek+ao7disy
	 phWz6BDucK7feiqHrvVExbA1FHjflg3S0puDnkYpGwAvyVGbAzb6FHdh0NiAkGckVwWWl
	 FSUyi2+heSY1HOrVawQYQnCOpm4QRmTsobNUzu5EUle7vdlxgTkfFQI8uDC0anFaFr9U7
	 AKafNJf13za11T3Qd46T+1gQSCQL9aPk+ef9j64F23byKhJ9h+8NjyW5onefwy0CG+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794453587;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=o5LE6Zx1zeEr/AzMTsVKB6zW5N3GqNQCHSyV4DrbDv8=;
	b=taYuTItCAgOVjbIQCWwUu2Qh7RIbNC8yOaKJnYqcQrlz+PLXCDsDXAqKbWxvvbfCDUUD
	 oOuK8u71CcQ2azOKbB1PP4+LeT7EE0vEj3Hiv8uXS+8IhlWui+gZa8TppmyBAKzoXgDMb
	 ONY83eHh6o1kgGygTMB4tj7G9+6WdlNSc7xpCKwZvG0ejKxlIo6OiTuFJvhKISStjrud4
	 zuQtNg0zBzcyWAla+aLEyKSvVX0LPSf71iL+I9GZHgOPNY1aIXufANDRSTLGHxXnmsNc+
	 vpqbFqEnmu2BF0iepVvS3HUA+x8FM9WOdp79Bz+UJMkGhRUu7DeBLxlW3Y8XMMj7wgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=OiJospQR;
	arc=none smtp.remote-ip=91.218.175.144
Received: from mta0.migadu.com (out-144.mta0.migadu.com [91.218.175.144])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3F4606A323
	for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 03:19:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5F3F4606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=OiJospQR
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=rbSXXlWPEtbddhR5IFof2OtrVDKZHXiFi0qBQm26MgU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794453584; v=1; x=1795058384;
 b=OiJospQRPN8nI99yuB4I6PZMVM4IANVO/tH6J3ulzSwahGeMtV6c7I/LHbdZK+qhv54xfw+1
 xWg2Mq6gKQasI+g6ZPobRIJS0I+hECzGtJS0UgOHuJ5iWU6JU1NeOb3LFbQSyQitUzA6hAR2NUH
 SChZb/rMW/oJi00Ixpcz36eM=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 4231d3eaa989e534;
	Thu, 12 Nov 2026 03:19:44 +0000
X-Mizu-Trace-ID: 4231d3eaa989e534
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: Ridong Chen <ridong.chen@linux.dev>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH for-7.4-fixes v4 0/2] cpuset: preparatory fixes and cleanups for partition rework
Date: Thu, 12 Nov 2026 11:19:29 +0800
Message-Id: <20261112031931.2815548-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
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

From: Ridong Chen <chenridong@xiaomi.com>

This series is part of the cpuset local partition rework [1], which I
started while at Huawei and am now continuing at Xiaomi.

Patches 1 and 2 of v3 have been merged into cgroup/for-7.4-fixes. This
version only has the remaining patches 3 and 4 of v3, rebased onto
cgroup/for-7.4-fixes.

Both patches include a bug fix besides the restructuring (Waiman):

  1) settle the isolation state of CPUs given back to the parent in
     partition_xcpus_del(). This fixes the isolated CPU leak reported by
     Guopeng [2], where an isolated partition is invalidated after its
     parent root partition has become invalid and its CPUs are left in
     isolated_cpus.
  2) generalize validate_partition() so it can be used for both local
     and remote partitions. This fixes a false PERR_NOCPUS error when
     expanding a remote partition, where the no CPU left for tasks check
     is done against the cgroup parent instead of top_cpuset.

Patch 2 adds a test case to test_cpuset_prs.sh for the bug it fixes.
test_cpuset_prs.sh passes with this series applied.

[1] https://lore.kernel.org/all/20261101114206.2434398-1-ridong.chen@linux.dev/
[2] https://lore.kernel.org/all/20261105130344.664336-4-guopeng.zhang@linux.dev/

Changes in v4:
  - Drop patches 1 and 2, which have been merged.
  - Rebase onto cgroup/for-7.4-fixes, which includes commit 56681bc448a8
    ("cgroup/cpuset: Correctly set isolated_cpus when switching partition state").
  - Patch 1: describe the isolated CPU leak in the commit message, add
    Fixes, Reported-by and Closes tags (Waiman, Guopeng).
  - Patch 2: describe the remote partition expansion fix in the commit
    message, add a Fixes tag and a test case for it (Waiman).
  - Link to v3: https://lore.kernel.org/all/20261107120100.3587595-1-ridong.chen@linux.dev/

Ridong Chen (2):
  cpuset: settle isolation state when CPUs are given back to parent
  cpuset: generalize the validate_partition() interface

 kernel/cgroup/cpuset.c                        | 217 +++++++-----------
 .../selftests/cgroup/test_cpuset_prs.sh       |   5 +
 2 files changed, 83 insertions(+), 139 deletions(-)


base-commit: 56681bc448a80bb2473026b41c44c133766bc38d
-- 
2.34.1

