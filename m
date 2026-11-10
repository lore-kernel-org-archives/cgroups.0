Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.159
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794287021;
	b=zcDZg2zwFg+Dr1BaFSYjgP4YgiRY7pqePys7PppV111sZOlzEiU6GuaAsrjjXiijWIio
	 TBFY5zkHMXhAmkz7D50prZQ7ZZsp/agEOpUppSTs/Cnhx8F9nYZHTG4NQ4wDlGu1eBF/Q
	 Krlz0KfXOnEI9E1oPC852pQIpGMZp14tR8HXSkchaJ29mxdQrygSMfJEb9Qobt++yhcXE
	 M+n2SvX2HtsTBc9gZnBZrrrJGzPsNKJHdMxp0qZpV/wn/oYHPR7buzrMH5dt2I93EReq0
	 AJw/e4xp9n96Spvup0XgcPglZ7F+isfl8jZDi73GfSlIyZ8pebayRLPZSsMn6dfcuag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794287021;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=W1sxioC7CMROvx/r1UAJHDcZA5UE9rSvFPDNj6JhOK4=;
	b=3TCjLrrCjOeV7jTn/k0Xjs7tfo8EF1OjRBVFbA2Yp37X7MPYNINYgRcUytsDXpFw63jX
	 moyQWVzFocZcXxGvVs7HEH6ghV75NmFCMb8Ph6QeNfxhiahvb32wDGeYK0KtRjoIevrRB
	 oQ2k+M/xzMIoMEVQyH4/4YtRV2MnOHjayxFRAMZYBY535Md90TM2INM3dBBusWX99uhks
	 XfTOw40lG0PBSzFyhf6Am+7niceSmyrmjZoHPOpUi2cvgwCgHM/6H2CqEiniHuOc7FbWL
	 bYGjGcATMeODm8dBKtQ3rOlOjDYkHmKzSh9pVFpMd7FnD5osJoQ247LZrV7vPFr85CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Xd0EjLAQ;
	arc=none smtp.remote-ip=95.215.58.159
Received: from mta1.migadu.com (out-159.mta1.migadu.com [95.215.58.159])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10C7606B08D
	for <cgroups@vger.kernel.org>; Tue, 10 Nov 2026 05:03:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B10C7606B08D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Xd0EjLAQ
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Qr6efF4jJpI/9qmyxgdFUkjEvcMPZqgHpk0hHki1Z4s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794287017; v=1; x=1794891817;
 b=Xd0EjLAQInbtqgBG2V1h/z14CjaVAf7gULqoklf9JVH48Jr+t9XUp7Y2fHU+2y0YOagLbcGA
 BlZUKjqsrlRpQWCqfynz2P9Br5u+10MTsYUM/4Q7rCuOHzOlv6XxK7zDlWZUS6MV/HINxnqJoUD
 eioefPzq0vKMzGvxpk0PE59U=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 2b2d84358f04e1ee;
	Tue, 10 Nov 2026 05:03:37 +0000
X-Mizu-Trace-ID: 2b2d84358f04e1ee
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>
Cc: Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH v3 0/3] cgroup/cpuset: Keep the top scheduling domain populated
Date: Tue, 10 Nov 2026 13:03:21 +0800
Message-ID: <20261110050324.173461-1-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
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

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

Boot-isolated CPUs stay in top_cpuset.effective_cpus, but are excluded
from its scheduling domain. Allocating all boot domain housekeeping CPUs
to partitions can therefore leave the top scheduling domain empty even
though effective_cpus is nonempty, leading to warnings and an OOPS in
build_perf_domains(). CPU hotplug can reach the same state.

The patches are ordered as follows:

  1. Check local and remote partition creation and CPU mask updates.
  2. Allow top-level partition CPU replacements that return CPUs to the
     parent in the same update.
  3. Handle CPU hotplug and preserve partitions that cannot return an
     active boot domain housekeeping CPU.

Changes since v2:
  Keep patch 1's kernel changes unchanged. Update its selftests following
  Longman's and Sashiko's comments and cover recovery with a single
  top-level HK CPU. Add patch 2 to fix the CPU replacement rejection
  reported by Sashiko, with its own regression test. Update the hotplug
  fix, now patch 3, to avoid invalidating unrelated partitions, including
  partitions whose boot housekeeping CPUs are all offline. Drop v2's
  isolated CPU cleanup patch in favor of Ridong's fix:
  https://lore.kernel.org/all/20261107120100.3587595-4-ridong.chen@linux.dev/

  v2: https://lore.kernel.org/all/20261105130344.664336-1-guopeng.zhang@linux.dev/

Changes since v1:
  Rework the fix following Ridong's suggestion and add test cases.
  Add patch 2 for CPU hotplug and patch 3 for isolated CPU cleanup
  when the parent partition becomes invalid.

  v1: https://lore.kernel.org/all/20261104071600.474587-1-guopeng.zhang@linux.dev/

Guopeng Zhang (3):
  cgroup/cpuset: Reject updates that empty the top sched domain
  cgroup/cpuset: Allow top-level partition CPU replacement
  cgroup/cpuset: Keep the top sched domain non-empty on CPU hotplug

 kernel/cgroup/cpuset.c                        | 75 +++++++++++++++++--
 .../selftests/cgroup/test_cpuset_prs.sh       | 68 +++++++++++++++++
 2 files changed, 137 insertions(+), 6 deletions(-)

-- 
2.43.0

