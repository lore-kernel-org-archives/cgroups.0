Received: from sg-3-111.ptr.tlmpb.com (sg-3-111.ptr.tlmpb.com [101.45.255.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F67837A49D
	for <cgroups@vger.kernel.org>; Sun,  9 Aug 2026 08:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786263742; cv=none; b=gZ9uPy1DD5jUcwHxgPG2ZcFDat+j1JjJg9Ci884jyh6EPB+1HSpcvCgjCjObkmdvhirRyGqBoNXBw7N/z3OT7gu2Yi1JC7CPIvDK8soM9r+FMqM8nWP1Mptam26ah8+NgtWcIGacov9pSMpFmRXjDrHNzxTPpHdxXECdSSt6mrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786263742; c=relaxed/simple;
	bh=pt81hSYU0uNijNHu5ZELRxHBAX8+VKfxS0ahcYAgjgE=;
	h=Message-Id:Mime-Version:Date:Subject:Content-Type:To:Cc:From; b=ThzskrEwK7BBsDdbJ3Bc7MRhSJ5zwV/BUmWU1LD1RZg4JICQvIT2Tbe3p4KQ78mCbIT0UzhZoSzRvPAStE0OaGiOIkT0CxrlykBVKfO8ZjxWqnE+ApuCS0Jr/dQ4RtZTtHGYy3lS4clkGyy74nUOmlR9Qly9Y+1eNGhn3FKhT+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=G5tSWqxz; arc=none smtp.client-ip=101.45.255.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="G5tSWqxz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1786263687; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=LZZiQX0XmIhwEqqHMCjXxFT3Oz1zfPeaBqcjQXnh1qE=;
 b=G5tSWqxzA+wKxmDxRtb3Mwc4oIVIQeQc/da/30YgcWrpXdHeT0JWBZaWEgNY/YP6LfBRoZ
 TKQqDZcYBb543NHXjVfOzxH47ICCH6X6e7trSBC3JFLor728d1ygp+r0eUlxhP7XajzSq8
 EuS0BIzrh4BfHYZ2JVWeQz6Sq7vRrgQgtl3NoZMJfgjMWwm+SBIEwUwNN0kYUFMGythKXj
 MxbylVPesKcjixV+MrnS3k9zfbFA2IJEpgOcI+vmkJGXK2Q5WXJhUMTRMMZoZ1Dk3b6Gru
 oLJD8flkqg2bB6geyLYeT2DUo0jCQa8F/0HeHvPMSqHuWykRG0HkAZ1RaUfsjw==
Message-Id: <20260809082111.3827531-1-qirui.001@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Rui Qi <qirui.001@bytedance.com>
Date: Sun,  9 Aug 2026 16:21:09 +0800
X-Lms-Return-Path: <lba+26a783885+fd4497+vger.kernel.org+qirui.001@bytedance.com>
Content-Transfer-Encoding: 7bit
Subject: [PATCH 0/2] selftests/cgroup: Fix cpuset test portability and hotplug error handling
X-Mailer: git-send-email 2.20.1
Content-Type: text/plain; charset=UTF-8
To: "Tejun Heo" <tj@kernel.org>
Cc: "Waiman Long" <longman@redhat.com>, 
	"Ridong Chen" <ridong.chen@linux.dev>, 
	"Johannes Weiner" <hannes@cmpxchg.org>, 
	=?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	"Shuah Khan" <shuah@kernel.org>, <cgroups@vger.kernel.org>, 
	<linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	"Rui Qi" <qirui.001@bytedance.com>
From: "Rui Qi" <qirui.001@bytedance.com>

Hi,

This series fixes two cpuset selftest issues.

Patch 1 removes awk -e from cpuset selftests. The option is accepted by
gawk, but rejected by mawk, causing mount point detection to fail on
systems where awk is provided by mawk.

Patch 2 preserves CPU hotplug write failures in test_cpuset_prs.sh. The
helper currently returns the status of pause after the write, hiding the
write failure from callers. Moving the write before the bookkeeping also
keeps OFFLINE_CPUS aligned with hotplug operations that actually
succeeded.

Testing:
- git apply --check the two patches in this series
- scripts/checkpatch.pl --strict on each patch
- bash -n tools/testing/selftests/cgroup/test_cpuset_prs.sh
- bash -n tools/testing/selftests/cgroup/test_cpuset_v1_hp.sh
- mawk 'BEGIN {print 1}'

The full cpuset hotplug selftests were not run because they offline and
online CPUs.

Rui Qi (2):
  selftests/cgroup: Avoid awk -e in cpuset tests
  selftests/cgroup: Preserve CPU hotplug write errors

 tools/testing/selftests/cgroup/test_cpuset_prs.sh   | 5 +++--
 tools/testing/selftests/cgroup/test_cpuset_v1_hp.sh | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

-- 
2.20.1
