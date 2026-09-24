Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0FD83D8918
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 04:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790224054; cv=none; b=Y37lCXjzjaKEG/DgLR2yHodMe4vjx245ilX9Ejc6iEDrwYcxE+8PwbPXK9YOuQKHm8miJgcWYS4/szjXvoje2XNyZgK044ZBvGPZoZgwj4gaSZYZJ9MplVcyde67x0aVIrgdTKX29Qfd34ecfuO1ySAQHXS11A+jQ/7IkZUQ9Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790224054; c=relaxed/simple;
	bh=u+ZdoPgS2w70wn1h+xA3nUtkpIPy4KipWT98fYKgD8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F0wAysbiNw+QnPLkbPT4QxNP7ic8Zs9gHpqShiu7CkUttRdwmay2Hf2y0KKcpo+ZnrNPIn2gzFixg9zznk+S2L+BhdgRqS9F9YjsvYY42paIZDnJf4Fg+owZv0RcuQq91+tHC9oixk55wfpkSTPDrUkAaH7pfCquVwIBepj3/y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eE1zSZm0; arc=none smtp.client-ip=74.125.227.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eE1zSZm0"
Received: by mail-pj2-f43.google.com with SMTP id d9443c01a7336-2d747ed6d6eso10153075ad.2
        for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 21:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790224052; x=1790828852; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8Qbj8scDayv1KTbBmuI3ZgNqnI9QLykgXWbif/mQ/Os=;
        b=eE1zSZm095/N3AtbApl472pBykxsgEKQa6zYGoFM4WNwMqF3b6bo0BD+yFbANGS6z6
         g8vJKUwFDUDgUJGXTbWa/Sh1b9Yvmz647hPAR8OXedtg4KIVP6/ZVG+eM4V+ii60Yii9
         0cT4IIzxm7Owm8kTsuNs99XjaxZgaIt82zaaxvQlE7TfkhXONZ+vRlO5miQpetGI6LOm
         qJxZ2A/En/bhIFrjwdUy62dbrZOUtNxFtztbS3vhbsAjlXw1CJ0ET8fBx2BcxR/yPB4B
         t0yJqI/YZmvSCLMZXiNSKjNkvFD7p5ViqAwjrACtviq0R0jflpOwdW0DwSZh6ccKf1NT
         ZWIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790224052; x=1790828852;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8Qbj8scDayv1KTbBmuI3ZgNqnI9QLykgXWbif/mQ/Os=;
        b=kuUB6wMTuC6q9ougXVqwfFry/kU+HGsz3S3riRbpnFdxSKWY9C/qgfegdTlno41J9s
         0ldH1XVSlvLA/9JlPJ3prgMhdRawb9FJ8S604Bq6KICGRQHfn7cnL7ErlI+1bOQ/u+Ky
         vF6ch4Ot05MdIBNIRP72ChphRnsWS5mvvRN+6Eu3r759Bi5u6Gw0a0BcsFajPMm9Q371
         HIGHfGoaVlgEvK84+9oqgSmJ7g4PAG6Ymem++Jq+h4/29uj1DuyxLHdT5oAOVR8MB2iG
         RIROZxRJKe11x9Al0q5uRip6UiJadVNiO2AramZpi8BKFVJAgntv7fSyJh6Ljtggz+A0
         L9Zg==
X-Forwarded-Encrypted: i=1; AKwUvBzqbQIz29W67qgnf38Tur5oxNcXJLn+9v7M1wbaoHzBGuzAd7HL0KeZCavDIgj5XfrUe6BMyZSd@vger.kernel.org
X-Gm-Message-State: AFuF++kszvQmPuMdQ5L08fxppzofswFFHT5pv+dAbikN/t0FiuZmS4ht
	QYSQxFGQD2iTRqnAoHCwqYNpz01Y32HQv5VHEOv6qu34evMJRn2s/uXA
X-Gm-Gg: AYBFou0aF2qUqFh555m2omByoyGudwE2J2mKld6P8+tFDvwOhP2DgewOLZJLRp549Mu
	Tivarlory4GYCsXpAggR8dqsXRddhnynIB8n/1AVFPp40kmJ62bWMf1crP/fkwvxvcuZU33RMBK
	9zKfJxGmOx8I1J7DdLJ0ehNhJxCt/fervEKXRQgTOJV7BKXyuvX8UAwFkAXwiOCFlLm/RY+BYfB
	EuuA93NiwMsayhu2D5s4UFN9V3khgYwlfTR5bvdH24+pdK603/hDcw8gZR/18IES9DsjbrBG8Lv
	1Vqlpm0A6n+DZH8EE3kEVc8k2gnIFJdU0UhM92tyOccrTlrLCQtymuPh3Py/hgzIcPoCIhTRlQf
	Imi19n8CEE6PeGxjP+fXguUHXkGushiYrzJvAGpByIgbXpH7IwrQHcFB03LOu4Wd0h3KxjAKmH9
	1nC1n2CUZSztjyky3PMUCmKQ2X30PeMi8bshkwYpZN+oog093ILYBSvWcYj+8L7ZuCR2gzCLR/2
	drYPUh8brPNZoC1bPAyGFw5fdPzFsT1/th7zMIT71a2vXjSKUBpR9fUabztd/HSIa5ht21sJjrL
	W1p0xIz4lA==
X-Received: by 2002:a17:903:1103:b0:2dd:c100:4b77 with SMTP id d9443c01a7336-2df7dc5a6b3mr10889045ad.46.1790224052075;
        Wed, 23 Sep 2026 21:27:32 -0700 (PDT)
Received: from phui-2.c.googlers.com.com (67.51.127.34.bc.googleusercontent.com. [34.127.51.67])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df6a5a4997sm19710685ad.27.2026.09.23.21.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 21:27:31 -0700 (PDT)
From: Hui Peng <benquike@gmail.com>
To: Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Shuah Khan <shuah@kernel.org>,
	Chen Ridong <chenridong@huawei.com>,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hui Peng <benquike@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v4 1/3] cgroup/cpuset: return PERR_NOCPUS in remote_partition_enable() on subpartitions_cpus conflict
Date: Thu, 24 Sep 2026 04:27:27 +0000
Message-ID: <20260924042729.1908863-2-benquike@gmail.com>
X-Mailer: git-send-email 2.56.0.rc1.310.g51773c2048-goog
In-Reply-To: <20260924042729.1908863-1-benquike@gmail.com>
References: <20260924042729.1908863-1-benquike@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a remote partition is created underneath an existing local partition
via a non-partition (PRS_MEMBER) intermediate cgroup, update_prstate() sees
parent->partition_root_state == PRS_MEMBER and calls
remote_partition_enable().

Commit 86888c7bd117 ("cgroup/cpuset: Add warnings to catch inconsistency
in exclusive CPUs") replaced the cpumask_intersects(tmp->new_cpus,
subpartitions_cpus) error check in remote_partition_enable() with
WARN_ON_ONCE(). As a result, remote_partition_enable() emits a warning
and proceeds to enable the remote partition on CPUs that are already
owned by the ancestor local partition in subpartitions_cpus.

This can be reproduced on Linux 7.3.0-rc3 with:

  mkdir -p /tmp/cg1
  mount -t cgroup2 none /tmp/cg1
  echo "+cpuset" > /tmp/cg1/cgroup.subtree_control

  mkdir /tmp/cg1/A
  echo 1 > /tmp/cg1/A/cpuset.cpus
  echo 1 > /tmp/cg1/A/cpuset.cpus.exclusive
  echo root > /tmp/cg1/A/cpuset.cpus.partition
  echo "+cpuset" > /tmp/cg1/A/cgroup.subtree_control

  mkdir /tmp/cg1/A/B
  echo 1 > /tmp/cg1/A/B/cpuset.cpus
  echo 1 > /tmp/cg1/A/B/cpuset.cpus.exclusive
  echo "+cpuset" > /tmp/cg1/A/B/cgroup.subtree_control

  mkdir /tmp/cg1/A/B/D
  echo 1 > /tmp/cg1/A/B/D/cpuset.cpus
  echo 1 > /tmp/cg1/A/B/D/cpuset.cpus.exclusive
  echo root > /tmp/cg1/A/B/D/cpuset.cpus.partition

which triggers:

  WARNING: kernel/cgroup/cpuset.c:1594 at remote_partition_enable+0x1c1/0x300

and leaves both /tmp/cg1/A and /tmp/cg1/A/B/D as active root partitions
claiming exclusive CPU 1.

Fix this by returning PERR_NOCPUS when tmp->new_cpus intersects
subpartitions_cpus in remote_partition_enable(), matching the error code
used by remote_cpus_update() for the same subpartitions_cpus conflict, and
add a regression test case to
tools/testing/selftests/cgroup/test_cpuset_prs.sh.

Tested in QEMU on Linux 7.3.0-rc3 using the reproducer above and
tools/testing/selftests/cgroup/test_cpuset_prs.sh.

Fixes: 86888c7bd117 ("cgroup/cpuset: Add warnings to catch inconsistency in exclusive CPUs")
Suggested-by: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Hui Peng <benquike@gmail.com>
---
 kernel/cgroup/cpuset.c                            | 3 ++-
 tools/testing/selftests/cgroup/test_cpuset_prs.sh | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 2538faac9aba..7381fa8502e7 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1591,10 +1591,11 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
 	 * above it or remote partition root underneath it is not allowed.
 	 */
 	compute_excpus(cs, tmp->new_cpus);
-	WARN_ON_ONCE(cpumask_intersects(tmp->new_cpus, subpartitions_cpus));
 	if (!cpumask_intersects(tmp->new_cpus, cpu_active_mask) ||
 	    cpumask_subset(top_cpuset.effective_cpus, tmp->new_cpus))
 		return PERR_INVCPUS;
+	if (cpumask_intersects(tmp->new_cpus, subpartitions_cpus))
+		return PERR_NOCPUS;
 	if (((new_prs == PRS_ISOLATED) &&
 	     !isolated_cpus_can_update(tmp->new_cpus, NULL)) ||
 	    prstate_housekeeping_conflict(new_prs, tmp->new_cpus))
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 3f7e81709365..b732078bf319 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -298,6 +298,8 @@ TEST_MATRIX=(
 	" C0-4:X2-4 C1-4:X2-4:P2 C2-4:X4:P1 \
 				   .      .      .      X1      .    0 A1:0-1|A2:2-4|A3:2-4 \
 								       A1:P0|A2:P2|A3:P-1 2-4"
+	" CX1-3:P1 CX1-3  CX1-3    .      .      .      P1      .    0 A1:1-3|A2:1-3|A3:1-3 \
+								       A1:P1|A2:P0|A3:P-1"
 
 	# Remote partition offline tests
 	"   C0-3    C1-3  C2-3     .    X2-3   X2-3 X2-3:P2:O2=0 .   0 A1:0-1|A2:1|A3:3 A1:P0|A3:P2 2-3"
-- 
2.49.0
