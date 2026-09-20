Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279383E5A33
	for <cgroups@vger.kernel.org>; Sun, 20 Sep 2026 08:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789892619; cv=none; b=uj2tseNzm6Thy46HeWXNZofKlLLSoV2tVLy2+X0Kt/75v2HYAlbYejQ82LVWUOhrAswnQwa4g1sEaPsrPWBHODfO2p7xXwDDQk5jVDJqlp5jLQ1xhrWV0XUb/LsBzl5L3I98XYLwOErrO2gojx1pyp8CPRoU5RUrvwsyu9F8KBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789892619; c=relaxed/simple;
	bh=r3HmbfzGAcI0BvXl/lBXbJebAU3RMWd+rRpyxTb+XMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6XFy4wAoViOIW61q+njJ2pnzWt/uJV0K1aSkVgbNtLl8PbaRuSCInBSpbp4/C0qGljgZpBhDlT/EZvZx1QWoPitub/apfEvgM4Ni/gwhMGOrS3iXDl3ubjzfZTVw1xa9w3AF+H363JhmYg547Qk3Us7ue7NDOwhDqbRyOoNpZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PQ9FvjwM; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PQ9FvjwM"
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396cccbba92so1863823a91.0
        for <cgroups@vger.kernel.org>; Sun, 20 Sep 2026 01:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789892617; x=1790497417; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c2qdqETkDPJMb7+/awd6bnaN+kmDPzUlN+dwNBfLj/U=;
        b=PQ9FvjwMCcxsabKXGJQAAikVfTdhLyKpIQrNGI9Z/i1GunzFNn32hANQoQrs7LGvOt
         77R/wCroybJwAzTS3eXgYTHajtanX7TuC1v/hx4ybflaNN47eDtmwXUCmYO+0ZBgX3l9
         SwkaHnDZQfIQi7rX0FOEqH/tlLvEKWhLZm6jkkj1PxK/tTcgXdknG95coppyZNaqiX3K
         PdY5u2eGGYVqXX9Z059AdCh4aJDrCgShUSO5tNkRapCNk3pKbme56Vgxa+v81UPjsme6
         xwsE7fMK3F8WQYHLBeIGrc1islbGDIr+x4Hepj5VYl42RQOldx4ArBacPl+ZD5TZp4sB
         kIaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789892617; x=1790497417;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=c2qdqETkDPJMb7+/awd6bnaN+kmDPzUlN+dwNBfLj/U=;
        b=ttzTV+v9o8JpqRXQgpuZmD7bzN3GAkzLzSFxioC+Wnkpr6vGi8Y6GPZ+/qqdtgKfva
         H+0//u1Uw8Vx3coiIt8y4Tj8dJ0HtgVNScTCv60LFtI4EdRZmI978FRR+tZQmqjVaLtk
         m7Ed0bp0r5zZVE0XqVJyg99gOYwl5B0dDNbE5ppHkN81sUs99p5nDdwkR0QMD9oa1cll
         LM2ZTWPw4Nd/i+cSSOeABaJqiclYXyG29O4WmGQgLnviqS4/OPScH69bCRMgTfTo9exV
         zg37qa9JsS8M2Guv4Nl9dN/9TZe1XCHIG13XpJrisLqq0Fm8H5jlJWgtehxU0XI5JqWV
         wgoA==
X-Forwarded-Encrypted: i=1; AKwUvBzWk6KNRWGgkjROU7WTnKWFYdsxKLe8t7tY7sn4X2j3+Jdi4vDwr2ytAeGmzLifBInq2203SmqL@vger.kernel.org
X-Gm-Message-State: AFuF++nyEdJ56fToUCCqUMgW6SUgYxGjl+kwBwdYfabYZOsMxeto0rqC
	iaY4FW/BFQyGCg8IqMYid1f7E3DwmJpoin/M6i0lGQCJRzUCmPaSIVpz
X-Gm-Gg: AYBFou2UjJC3HPrfMLYkn91b0Zak89h/pwz3Af8ub72hlenHUCL7vk65W1gRI2Z22st
	Fv5195dtUZvR1G3kOTrSCz0PbQC14UR+FoBQdGuyRXTCZRkJE5A90Qq8lvHd5Jd1Pog3tkWPEDp
	6Ny/KunYUhT0WsYvWEuXSRNSxdMAFbTDFAzCPqAsj1I9b2TsNx8KWTDkC1jOrpUnTMMSnGskGMU
	dVG4PCtVCFfxvdoxEaQxqpKUVRJ4aGwGlDFVIs615PCiWctP3Uq/ixK6E0K/hclVKG3M+SrlIgB
	eRnGv28gi9VFBmhZw/I0v5HW6V3Rvs2O30hd57YucVrG1c/5J6pPaOCMtMxviTOxWRPTABRX7d4
	/QZ9cXeEvrVwi9LxNIfp0HSrgrVJd0wwCAHHIf3bIUJ5xEg3gZ+kxgaOIbJ3Vfsr1f2euPe/nKU
	sWZlxsytw3YV3Fs5rAMcN4d8wjx2YyrGNRnEpXCqYwnIL4KaqHWC/UVKDWWmsHeUTlT7gTCwasH
	18sjPx7iyhT/CJqas6UWlSbcy3jqF9eZZxinTezR24u+qUTkx1wU5MCdT91JUl2Mv1gPXIZp88H
	PoLJxCOq9g==
X-Received: by 2002:a17:90b:5305:b0:39e:4c81:6c63 with SMTP id 98e67ed59e1d1-39e54dbe3c1mr12675804a91.30.1789892617248;
        Sun, 20 Sep 2026 01:23:37 -0700 (PDT)
Received: from phui-2.c.googlers.com.com (67.51.127.34.bc.googleusercontent.com. [34.127.51.67])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e55b83602sm5635853a91.1.2026.09.20.01.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 01:23:36 -0700 (PDT)
From: Hui Peng <benquike@gmail.com>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Michal Koutny <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hui Peng <benquike@gmail.com>
Subject: [PATCH v2 1/2] cgroup/cpuset: return PERR_NOCPUS in remote_partition_enable() on subpartitions_cpus conflict
Date: Sun, 20 Sep 2026 08:23:34 +0000
Message-ID: <20260920082335.257680-1-benquike@gmail.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <139d9231-4723-4365-9af7-8142e6581ede@linux.dev>
References: <139d9231-4723-4365-9af7-8142e6581ede@linux.dev>
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
Cc: stable@vger.kernel.org
Signed-off-by: Hui Peng <benquike@gmail.com>
---
Changes in v2:
- Split into a 2-patch series (1/2 for remote_partition_enable(), 2/2 for
  validate_partition() and cpus_excl_conflict()).
- Return PERR_NOCPUS instead of PERR_INVCPUS when tmp->new_cpus intersects
  subpartitions_cpus to match remote_cpus_update(), as suggested by
  Guopeng Zhang.
- Add regression test to tools/testing/selftests/cgroup/test_cpuset_prs.sh
  and include the step-by-step reproducer in the commit description as
  requested by Ridong Chen.

 kernel/cgroup/cpuset.c                        | 3 ++-
 tools/testing/selftests/cgroup/test_cpuset_prs.sh | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 52eb66e3353e..7381fa8502e7 100644
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
+	" CX1-3:P1 CX1-3  CX1-3    .      .      .      P1     .     0 A1:1-3|A2:1-3|A3:1-3 \
+								       A1:P1|A2:P0|A3:P-1"
 
 	# Remote partition offline tests
 	"   C0-3    C1-3  C2-3     .    X2-3   X2-3 X2-3:P2:O2=0 .   0 A1:0-1|A2:1|A3:3 A1:P0|A3:P2 2-3"
-- 
2.49.0
