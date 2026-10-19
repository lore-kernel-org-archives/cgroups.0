Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792433465;
	b=ozoXKpGhE/WEraZUpnAraHSTLCRlrzEXKeSbgBVBvimij8hqjH9A/PiYYfXTL2nxiw/c
	 2cCJlNhtj/vz1CfcdHRMtBauvicYRUgtB2xYi33xFkFokcybJwKKlowb9GR+susyzvoYH
	 3Ogr4sDSQ6Lonp+AhIwhtlNJDKk145784g7X729OGzWRHGWwPcdrtl0wJeDHOK1ZjnniV
	 4q9f1nmRyWtFpjfo8Ca4rEe/uWvyFECfBw3U5BynoRH4ox03fo/GPzO4ixuydfePC+i8y
	 /EWqtx1BcsgkNXlhyeZ0LU2Pewbqg3vTBWtcrawk6/Em/ibwFZx4risyVMtPaEXYG5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792433465;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=fRpRjOsNXnarjnEQWZ+ErDczW+pYEljbQ5Lk8t6C4EY=;
	b=qSnuKr6/lf/WPYsPvcnKEHh/YZsCkyXPY/mo8Wdy/I9CjH6jWToZQd16sa1Gb7bEMTvi
	 9QRI44COd75dtabpnngIrIvbpz4v5CRwlfuxASJRWGD7RI1MqJ6AD02ze1HsQ+s3h+TNS
	 dvr4145ST57YzcIkHTV8ekfbJyeH4hsINpLUt32WvgpyaQM+jHkXPyFuCq4fdUwBW3ULp
	 l4u46GE+B4iQjJF0pjb1eV6qhon6fp8zhesb38ri2yt4t6SGP3iAw22OwwQAkWZup+1A8
	 80xtlC8kGonbTYzrgiWAurgniAfdxV1WGRYimxjKmfzDjKfd5q2yhJJJuY6i8VNF9YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=iRMfKc6j;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4C360A3838
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 18:11:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE4C360A3838
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=iRMfKc6j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792433463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fRpRjOsNXnarjnEQWZ+ErDczW+pYEljbQ5Lk8t6C4EY=;
	b=iRMfKc6jImDA7O3yfohsWl5ti57h+3F70qMThmn0EwJeG0dV9JfGoVxF6rlSKJF4I4/6Na
	TcCd1aaWQccT9RFO5eTtYnB9Sa4OcpR9H0FtFlm/V3HX7pwHZ+jZMWoQVDVxg7rGaXRHG3
	Xj1859t1o/QqPa0PqO23UuCPEM26VTk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-497-109DXJwlOFq_-0n6tQukrA-1; Mon,
 19 Oct 2026 18:10:57 +0000
X-MC-Unique: 109DXJwlOFq_-0n6tQukrA-1
X-Mimecast-MFC-AGG-ID: 109DXJwlOFq_-0n6tQukrA_1792433455
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ABF18195609F;
	Mon, 19 Oct 2026 18:10:55 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.rmtusnh.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B4469418;
	Mon, 19 Oct 2026 18:10:53 +0000 (UTC)
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
Subject: [PATCH-next v4 9/9] selftests/cgroup: Skip test_cpuset_prs.sh test if some required CPUs are offline
Date: Mon, 19 Oct 2026 14:10:20 -0400
Message-ID: <20261019181020.1069325-10-longman@redhat.com>
In-Reply-To: <20261019181020.1069325-1-longman@redhat.com>
References: <20261019181020.1069325-1-longman@redhat.com>
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
index 7639e9f11cf9..d04aad697b96 100755
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
 
@@ -143,16 +167,25 @@ TEST_ISOLCPUS=
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
@@ -754,16 +787,6 @@ set_ctrl_state_noerr()
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
@@ -1397,7 +1420,6 @@ test_inotify()
 	echo "" > cpuset.cpus
 }
 
-trap cleanup 0 2 3 6
 run_state_test TEST_MATRIX
 run_remote_state_test REMOTE_TEST_MATRIX
 TEST_ISOLCPUS=1 run_state_test ISOLCPUS_TEST_MATRIX
-- 
2.55.0

