Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEFF63A6B6D
	for <cgroups@vger.kernel.org>; Sun,  9 Aug 2026 08:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786263705; cv=none; b=H92ESyr4GZySS1NSFpO9b2Z5ZiC2GFeLbVxBgFSRDTgz05j4Y18ckkkYAs5r2/qyDL+TCh6Na3ZpsCKM1RXM8cB4IpI74FTaqPN/yyMsZs9yWIMyBwlZE2w8xTtj1mruUjAHrQNzgbHzdGu7klxoWeUVkFV6pEEIAYq3mkXDmzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786263705; c=relaxed/simple;
	bh=6xga2Rem33SBu03y3gctGh9ND9hhWHOzbjuyhtOHQzo=;
	h=Message-Id:In-Reply-To:References:Content-Type:To:Cc:Subject:
	 Mime-Version:Date:From; b=Xv3iR/Ca2lYorFCLGxGWyXvSjN7GNccN7NTgDA2jXs1kE034tyRTSxIkBPNK8+cEMfu/7hy+PfKlxjH0NDGzBdORyJFoMb4GdkyvhPeemFMd0HRTaKg1WFkUZzsIqOTHh848qNjO9nHEdXjnb2WVMGdBPY2KQjX+7nZXcVSSf9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=YCZc5CWD; arc=none smtp.client-ip=209.127.230.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="YCZc5CWD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1786263697; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=0Yk0lYL9aqPBymANq4am5jSB+FYd5S9sbi6/i8dc480=;
 b=YCZc5CWDxLfbLTzlyJ0VYTLolNveLYQYsBvLsJZx0IL1+1IOHu0F4E8XwKaqblJVpDIYPB
 aArDrZkWSFZCN6DarCHZ3U9THa/STwjW0qPvV/B7yc790Utygxz2r2oUYaLB/Gj4zZV6OC
 hpqGrs3due4wTvYwIyxTT2l3vdM9r7mRpGOb7zvmd8rF7jQVyZ+LsobnoTFnDBVavEuAMv
 sXO+jJdkxJFV4POvkEl+AcQYXSYAdf3AFblnNsi5xikifTxwYgbqyOCY17i+o/fJLrp+Ey
 cnNvOC0LD+fz1aS6o82OjqGuyjNpba1Gu5sqzK8ojitLLUdbMzjMDpX1tE4+jw==
Message-Id: <20260809082111.3827531-2-qirui.001@bytedance.com>
X-Original-From: Rui Qi <qirui.001@bytedance.com>
In-Reply-To: <20260809082111.3827531-1-qirui.001@bytedance.com>
References: <20260809082111.3827531-1-qirui.001@bytedance.com>
Content-Type: text/plain; charset=UTF-8
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 7bit
To: "Tejun Heo" <tj@kernel.org>
Cc: "Waiman Long" <longman@redhat.com>, 
	"Ridong Chen" <ridong.chen@linux.dev>, 
	"Johannes Weiner" <hannes@cmpxchg.org>, 
	=?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	"Shuah Khan" <shuah@kernel.org>, <cgroups@vger.kernel.org>, 
	<linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	"Rui Qi" <qirui.001@bytedance.com>
Subject: [PATCH 1/2] selftests/cgroup: Avoid awk -e in cpuset tests
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a78388f+989199+vger.kernel.org+qirui.001@bytedance.com>
Date: Sun,  9 Aug 2026 16:21:10 +0800
From: "Rui Qi" <qirui.001@bytedance.com>

The cpuset selftests use awk -e to parse cgroup mount points. This
works with gawk, but mawk rejects the option. In test_cpuset_prs.sh,
this leaves CGROUP2 empty and causes the test to skip as if cgroup v2
were not mounted. The same non-portable invocation exists in the cpuset
v1 hotplug test.

The scripts only need to pass a single awk program. Use the standard awk
invocation without -e so mount point detection works with awk
implementations that do not support the gawk extension.

Fixes: a8c52eba880a ("kselftest/cgroup: Add cpuset v2 partition root state test")
Fixes: 812c5945bdb8 ("cgroup/cpuset: Add test_cpuset_v1_hp.sh")
Signed-off-by: Rui Qi <qirui.001@bytedance.com>
---
 tools/testing/selftests/cgroup/test_cpuset_prs.sh   | 2 +-
 tools/testing/selftests/cgroup/test_cpuset_v1_hp.sh | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 400a696a0d21..16c38eb11e63 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -20,7 +20,7 @@ skip_test() {
 WAIT_INOTIFY=$(cd $(dirname $0); pwd)/wait_inotify
 
 # Find cgroup v2 mount point
-CGROUP2=$(mount -t cgroup2 | head -1 | awk -e '{print $3}')
+CGROUP2=$(mount -t cgroup2 | head -1 | awk '{print $3}')
 [[ -n "$CGROUP2" ]] || skip_test "Cgroup v2 mount point not found!"
 SUBPARTS_CPUS=$CGROUP2/.__DEBUG__.cpuset.cpus.subpartitions
 CPULIST=$(cat $CGROUP2/cpuset.cpus.effective)
diff --git a/tools/testing/selftests/cgroup/test_cpuset_v1_hp.sh b/tools/testing/selftests/cgroup/test_cpuset_v1_hp.sh
index 7406c24be1ac..da97f1643f9a 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_v1_hp.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_v1_hp.sh
@@ -14,7 +14,7 @@ skip_test() {
 [[ $(id -u) -eq 0 ]] || skip_test "Test must be run as root!"
 
 # Find cpuset v1 mount point
-CPUSET=$(mount -t cgroup | grep cpuset | head -1 | awk -e '{print $3}')
+CPUSET=$(mount -t cgroup | grep cpuset | head -1 | awk '{print $3}')
 [[ -n "$CPUSET" ]] || skip_test "cpuset v1 mount point not found!"
 
 #
-- 
2.20.1
