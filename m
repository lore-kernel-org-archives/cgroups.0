Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC16542810
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 14:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791986806; cv=none; b=iNRjZIkBTbmAf/8FzF7cMoarXSWi7t5cfLRdrdWV5OkWqmPulMKOLC4xbwV1rMrDYhXJROLNpfs2HhhJQsq/XRje/N9cmG9GNHjthxdKnssI/kiwhJ9y0OXmgjCWywgP2HaFbHr9LxcUePPSGqZSYPjgsJtg99Pqk1mG34abI7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791986806; c=relaxed/simple;
	bh=6SYz5Uc2wViAOPgGfOwl3BAaSMS7tgHVetq32KqXoiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9JOaBdN7NT3IhAJXvUMHNr3KjrWn4fo4VNyv47hZkoveZwlq7pPwhjbqoxyuMynHbyThbIJ5hRkWU90p5WWir/j8EH3+98kd696/F3Bx3YvgpSbNowMUubhocwAKtCUaHA7ltHroINm2pQPPqhbvOZhVtuQtHQicwLh4/X4Te8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GqZ/kdNO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GqZ/kdNO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791986795;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0s+tG5dNwPT4lFxjIYixkIYbDTXJP5q7QQHRZdBmfSo=;
	b=GqZ/kdNOf/uR+n2np1bd4QmUVbzZaBRM62PqP+1x+flYFyvEzedfTPlWtxBOwAyUH+K6PH
	2jPrL0NUycMVemqbO85FAgvebOcxAyIiQwabq+xIUDa811pRnCvoGpek0aVsvAX/XydfHd
	wbYBiUGuJLu0N9F2mBa0YgICdtE1fKM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-94-KdOVWCr9P6eSMzoWeDKomQ-1; Wed,
 14 Oct 2026 14:06:29 +0000
X-MC-Unique: KdOVWCr9P6eSMzoWeDKomQ-1
X-Mimecast-MFC-AGG-ID: KdOVWCr9P6eSMzoWeDKomQ_1791986787
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C8D8B1955F00;
	Wed, 14 Oct 2026 14:06:27 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.rmtusnh.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CFD5F418;
	Wed, 14 Oct 2026 14:06:25 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>
Cc: cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Hui Peng <benquike@gmail.com>,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH-next v3 9/9] selftests/cgroup: Skip test_cpuset_prs.sh test if some required CPUs are offline
Date: Wed, 14 Oct 2026 10:05:48 -0400
Message-ID: <20261014140548.575122-10-longman@redhat.com>
In-Reply-To: <20261014140548.575122-1-longman@redhat.com>
References: <20261014140548.575122-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

The test_cpuset_prs.sh test assumes that all the relevant CPUs being
tested are online. If some of them are offline, some of the test cases
may fail. So skip the test if the required CPUs are either offline or
not present.

While at it, the cleanup() and online_cpus() functions as well as the
trap statement to run cleanup() on exit are moved earlier to make sure
the cleanup function will be run if the test is somehow aborted early.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 .../selftests/cgroup/test_cpuset_prs.sh       | 64 +++++++++++++------
 1 file changed, 43 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index ea0ebbdf4bb3..078475c9387a 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -67,6 +67,30 @@ then
 	echo Y > /sys/kernel/debug/sched/verbose
 fi
 
+cleanup()
+{
+	online_cpus
+	cd $CGROUP2
+	rmdir A1/A2/A3 A1/A2 A1 B1 test/A1 test/B1 test > /dev/null 2>&1
+	rmdir rtest/p1/c11 rtest/p1/c12 rtest/p2/c21 \
+	      rtest/p2/c22 rtest/p1 rtest/p2 rtest > /dev/null 2>&1
+	[[ -n "$SCHED_DEBUG" ]] &&
+		echo "$SCHED_DEBUG" > /sys/kernel/debug/sched/verbose
+}
+
+online_cpus()
+{
+	[[ -n "$OFFLINE_CPUS" ]] && {
+		for C in $OFFLINE_CPUS
+		do
+			write_cpu_online ${C}=1
+		done
+	}
+}
+
+# Clean up the cgroupfs directory if the test is aborted.
+trap cleanup 0 2 3 6
+
 cd $CGROUP2
 echo +cpuset > cgroup.subtree_control
 
@@ -141,16 +165,25 @@ TEST_ISOLCPUS=
 		skip_test "Current isolated CPUs ($CURRENT_ISOLCPUS) don't match boot isolated CPUs!"
 }
 
-cleanup()
-{
-	online_cpus
-	cd $CGROUP2
-	rmdir A1/A2/A3 A1/A2 A1 B1 test/A1 test/B1 test > /dev/null 2>&1
-	rmdir rtest/p1/c11 rtest/p1/c12 rtest/p2/c21 \
-	      rtest/p2/c22 rtest/p1 rtest/p2 rtest > /dev/null 2>&1
-	[[ -n "$SCHED_DEBUG" ]] &&
-		echo "$SCHED_DEBUG" > /sys/kernel/debug/sched/verbose
-}
+#
+# This test assumes that all the relevant CPUs being tested are online.
+# If some of them are offline, some of the tests may fail. So we are going to
+# skip running this test script if some of the required CPUs may be offline.
+# The required CPUs include CPUs 0-7 and the first boot time isolated CPU if
+# present. However the check below is not exhaustive and can be a false
+# positive, but users should not run this test if some CPUs are offline.
+#
+ONLINE_CPUS=$(cat /sys/devices/system/cpu/online | sed -e "s/,.*//")
+ONLINE_FIRST=$(echo $ONLINE_CPUS | sed -e "s/-.*//")
+ONLINE_LAST=$(echo $ONLINE_CPUS | sed -e "s/.*-//")
+if [[ -n "$FIRST_ISOLCPUS" ]]
+then
+	LAST_REQUIRED_CPU=$FIRST_ISOLCPUS
+else
+	LAST_REQUIRED_CPU=7
+fi
+[[ $ONLINE_FIRST != 0 || $ONLINE_LAST -lt $LAST_REQUIRED_CPU ]] &&
+	skip_test "Some of the required CPUs are offline or not present!"
 
 # Pause in ms
 pause()
@@ -748,16 +781,6 @@ set_ctrl_state_noerr()
 	}
 }
 
-online_cpus()
-{
-	[[ -n "$OFFLINE_CPUS" ]] && {
-		for C in $OFFLINE_CPUS
-		do
-			write_cpu_online ${C}=1
-		done
-	}
-}
-
 #
 # Remove all the test cgroup directories
 #
@@ -1391,7 +1414,6 @@ test_inotify()
 	echo "" > cpuset.cpus
 }
 
-trap cleanup 0 2 3 6
 run_state_test TEST_MATRIX
 run_remote_state_test REMOTE_TEST_MATRIX
 TEST_ISOLCPUS=1 run_state_test ISOLCPUS_TEST_MATRIX
-- 
2.55.0

