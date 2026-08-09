Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE03D394EB0
	for <cgroups@vger.kernel.org>; Sun,  9 Aug 2026 08:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786263717; cv=none; b=lBAsCN36u0c675xgxgf5GfEBFA+Fl9Gi44Dv+j4h9Tejs6ArH1eOEfU1tdiXY++fJ016VIeBtVWh5jcY2aTq0NkTsyzVjHh3GsBJ2BdUEUKLJltAseHaXJ7FEgUUGt+rmT9fV9vnrldVv5X1tPTyzi93MmyXRjfy4h/U27AwAfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786263717; c=relaxed/simple;
	bh=FrECniDkg8YKqMi0Smbs3zq22i2qjrcQ6gW/2ZUChZQ=;
	h=Content-Type:Subject:References:To:From:Mime-Version:In-Reply-To:
	 Cc:Date:Message-Id; b=eEc0dSMxRbSo27SQ5DIRcU/dYZP6BH5d57b9HPFSAxaSeaOU9Mvopxdggz2S5GY7s1TAI1/AlEVkQBYVlqviH0iVnY6T6Rq/DI0uwGLkQcYSbcK5y7Q3RGEQRX/KlmHu5nqpfaOvxK8tv8tXoJVrgCkpt+FokXuUVXazpH0AU9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=nJzrUsVF; arc=none smtp.client-ip=209.127.230.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="nJzrUsVF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1786263708; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=muA4oqikWdywQP1E8XrJ2gVJyxiRqn34qvWdx3tjp1c=;
 b=nJzrUsVFgU0cEeQtsIYydE67fJJbjAoEUT4oV16FlL5Om2lSayfUb3hyQIMamhUB0XZ0f2
 9KaWZPG0/LJg0kbCbwJjMPDPBwKaMErPtPA6vOjhRThVV2BNdo5PJNkYV1q3e5yor9aztC
 dfSV9zch7Lr5rKkcYKdZXZR8OtKS1pOtZLNH122XohSy2NjNX3t0WDo3PhicLLqK/blWbb
 TY8JKY/gSGshUyFAAlL9vaIeH3DW9ypvr5AAisZMY2CO9sj911jG8FNv6VVi30Q5EsihsI
 cfI/Bnbce5GvHckSt+S3uXYA+4HL22i5ZMG2qvikry7FUsnipNhv1R7By8BbOg==
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH 2/2] selftests/cgroup: Preserve CPU hotplug write errors
X-Lms-Return-Path: <lba+26a78389a+470e91+vger.kernel.org+qirui.001@bytedance.com>
References: <20260809082111.3827531-1-qirui.001@bytedance.com>
X-Mailer: git-send-email 2.20.1
X-Original-From: Rui Qi <qirui.001@bytedance.com>
To: "Tejun Heo" <tj@kernel.org>
From: "Rui Qi" <qirui.001@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <20260809082111.3827531-1-qirui.001@bytedance.com>
Cc: "Waiman Long" <longman@redhat.com>, 
	"Ridong Chen" <ridong.chen@linux.dev>, 
	"Johannes Weiner" <hannes@cmpxchg.org>, 
	=?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	"Shuah Khan" <shuah@kernel.org>, <cgroups@vger.kernel.org>, 
	<linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	"Rui Qi" <qirui.001@bytedance.com>
Date: Sun,  9 Aug 2026 16:21:11 +0800
Message-Id: <20260809082111.3827531-3-qirui.001@bytedance.com>
Content-Transfer-Encoding: 7bit

The cpuset partition root state selftest checks several CPU hotplug
transitions. If writing to a CPU online file fails, the helper still
runs pause afterwards and returns the status of pause instead of the
failed write.

This hides the real hotplug failure and can make later checks run
against expectations for a transition that never happened. Move the
write before the bookkeeping and return when it fails, so callers can
observe the hotplug error and the test does not record a CPU as offline
unless the offline operation actually succeeded.

Fixes: a8c52eba880a ("kselftest/cgroup: Add cpuset v2 partition root state test")
Signed-off-by: Rui Qi <qirui.001@bytedance.com>
---
 tools/testing/selftests/cgroup/test_cpuset_prs.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 16c38eb11e63..a2f7208633bc 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -412,6 +412,7 @@ write_cpu_online()
 	CPU=${1%=*}
 	VAL=${1#*=}
 	CPUFILE=//sys/devices/system/cpu/cpu${CPU}/online
+	echo $VAL > $CPUFILE || return 1
 	if [[ $VAL -eq 0 ]]
 	then
 		OFFLINE_CPUS="$OFFLINE_CPUS $CPU"
@@ -421,7 +422,6 @@ write_cpu_online()
 					sort | uniq -u)
 		}
 	fi
-	echo $VAL > $CPUFILE
 	pause 0.05
 }
 
@@ -493,6 +493,7 @@ set_ctrl_state()
 			eval $COMM $REDIRECT
 			;;
 		    O*) VAL=${CMD#?}
+			COMM="write_cpu_online $VAL"
 			write_cpu_online $VAL
 			;;
 		    T*) COMM="echo 0 > $TFILE"
-- 
2.20.1
