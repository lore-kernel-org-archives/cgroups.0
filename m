Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793962563;
	b=RMSlRBBbi+HriWKchChrTAfNTqoSxe2SpEX6X2ZIY1F0aubY2gRRh2V2+YX7s53D+wQ9
	 P1fRNRGrWfo96QPC50fsNbYbt88RBusd2MytprFiU8BxWT8pV1rArxg7GT6ZfQPYgpjeQ
	 gfGPt7DCkTAXGBs7SLDkYlg7yxGti+JzHl38Nsl2R77Cu3y/hViuWNcNmkIcQVf5KOXZd
	 ZhSCwKC5L9q5Ur47jFyJT8SvUcsmAaT8cbmMjxCxJrYkpE8j8IDnAtBdfiewLrNvywxLQ
	 i2DINfg3XhgqfvU3+0BXCZsQx7SkSqg7oHZi9rySRfL2iHz8fY9REEzgGPyNdwPaAAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793962563;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=9rHwkPMwxdMgha3QVXCkmngbsNTxtZexOOuCRv+XpNE=;
	b=0Bk7S1kNJXE1/xpYQnUkBcDNVxAaW+cVMR++KANZEZwgeJJ4WlrnVZMdX7AFGoeJnlFB
	 qzo5jDRwZYCSJiqVr9S5BhGreOWdBOWH8l28SM3lOGw/+4HeEklYMCbw9efyFKjfGa6oo
	 TbtZPKs/lq8xNv39m8AQkSKFz2U2Wg9d66UdfX7Qp9XREJOx+PzFU91m7IxZeQkdgKByK
	 dap5s00XKW5dTwaHVEPM2rF4Td+J9biWQLScVt2oRsz5Sko+pinjiXBBzMRHRhDuGRiLa
	 hCFN9pnHTwVusJ7dMAog8IiM/AUqk33TAh7aco6gkioQpq4BVtxdxrKw0kLfJp9kkcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	arc=none smtp.remote-ip=91.218.175.18
Received: from mta0.migadu.com (out-18.mta0.migadu.com [91.218.175.18])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C162A606A32C
	for <cgroups@vger.kernel.org>; Fri,  6 Nov 2026 10:56:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C162A606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=PP1vC/2Py1tmxSvMadYBueWiOL9MqDxc72g6D5btaPo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793962558; v=1; x=1794567358;
 b=Bcoy02Y/s24WwhNg4as3UCM+R6eoOYRjrJztOhDkgiUVp2EB2L+X5GLizj6M/kqBRuO4gacD
 pko8ZQSsnvqHG21Lu5xgJjZVAteOSVijhyvU0BbZ6IfmG9014AXqsPZTNYk5FPrrLfwdBi+86qJ
 sMs/76KfTt67j2bGFtr7MAWI=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id da0bf48ede6c7b6a;
	Fri, 06 Nov 2026 10:55:58 +0000
X-Mizu-Trace-ID: da0bf48ede6c7b6a
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: Ridong Chen <ridong.chen@linux.dev>,
	Chen Ridong <chenridong@huawei.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Sashiko <sashiko-bot@kernel.org>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v2 0/4] cpuset: preparatory fixes and cleanups for partition rework
Date: Fri,  6 Nov 2026 18:55:34 +0800
Message-Id: <20261106105538.2915492-1-ridong.chen@linux.dev>
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

This is the first part of the cpuset local partition rework posted as
RFC v4 [1]. The rework is split into three parts to make it easier to
review and merge:

  1) fixes and preparatory cleanups (this series);
  2) introduce partition_enable/disable/update() and rework the local
     partition code on top of them;
  3) clean up the remaining partition state handling outside these
     helpers.

Patch 1 is a fix for an existing bug, found while looking into a review
comment on RFC v4: when cpuset.cpus.exclusive of an already invalid
partition root is cleared, its effective_xcpus is not reset, so its
former exclusive CPUs can't be claimed by a sibling. A test case is
added for it.

Patches 2-4 are the first three patches of RFC v4, rebased onto
next-20261104:

  2) add an early empty cpumask check in partition_xcpus_add/del(), so
     callers don't need to check it;
  3) settle the isolation state of CPUs given back to the parent in
     partition_xcpus_del(), so isolated_cpus_release() can be removed;
  4) generalize validate_partition() so it can be used for both local
     and remote partitions.

All patches build on their own, and test_cpuset_prs.sh passes with
this series applied.

[1] https://lore.kernel.org/all/20261101114206.2434398-1-ridong.chen@linux.dev/

Changes in v2:
  - Patch 1: force update_cpumasks_hier() after reset_partition_data(),
    so that the descendants don't keep the released exclusive CPUs, and
    add a test case for it (Sashiko).
  - Patch 1: fix the Fixes tags (Sashiko).
  - Link to v1: https://lore.kernel.org/all/20261105125215.2205892-1-ridong.chen@linux.dev/

Changes since RFC v4:
  - New patch 1 to fix the invalid partition effective_xcpus reset.
  - Patch 3: only settle the isolation state of the CPUs still owned by
    the parent when invalidating a child partition in
    compute_partition_effective_cpumask(), as the parent may be shrunk
    and not updated yet. This code is removed later in the rework.
  - Rebase onto next-20261104, which includes commit 362212853cd0
    ("cgroup/cpuset: Fix incorrect CPU accounting with parent's effective_xcpus expansion").



Chen Ridong (2):
  cpuset: add early empty cpumask check in partition_xcpus_add/del
  cpuset: generalize the validate_partition() interface

Ridong Chen (2):
  cgroup/cpuset: Reset partition data when an invalid partition stays
    invalid
  cpuset: settle isolation state when CPUs are given back to parent

 kernel/cgroup/cpuset.c                        | 217 ++++++++----------
 .../selftests/cgroup/test_cpuset_prs.sh       |   6 +
 2 files changed, 97 insertions(+), 126 deletions(-)


base-commit: 8b7179210b22f8e48a82c5ceacb9d56a9c4cfec4
-- 
2.34.1

