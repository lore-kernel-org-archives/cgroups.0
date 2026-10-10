Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE873655E7
	for <cgroups@vger.kernel.org>; Sat, 10 Oct 2026 22:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791670828; cv=none; b=kLEEHdiB4aT3YD6xThKV38YE/S4K+hTXnOtCbqglQX1rcUiNCHMJVksP3yaadmoLB/3baeCgbnlZpt/Lljz1thCWnzZiT2p+UixuJorkaNK1ZPWJUbFIywx56zFpXFkMHNbIBG3qGaqTiCYDlOLu2KOkVD0+3zNA/YLWt7vbT9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791670828; c=relaxed/simple;
	bh=VqhUmzwrgKPfE5pBHaM+esOvZJYDu+QRd/LkWy8dDj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBoIe557OkK1otQdAu7qm0qLcxym8lIbBqQIpogQemCb2cm0TzDa7ve2ZO86u7XdX1dQbwrZ/59Jd78YcVvc64xfmH5WSgenULvViOqtVFAhyBFilXyJlFD2GZJ9aI1ovqvqP0PUOXeO6ZFh2pjoY0Zl6yuNqEyWOIMJvZkUNlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CehY7GG2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CehY7GG2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791670824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XxpScX6DN1b+9VfzAdMJq36FU2Z4Pa62BOcKgqYMGUA=;
	b=CehY7GG25wFQ1BJMN500VM8nEg38fjO+Jy8a6uW8b0FzAIE4DQsjBI7qJ0Nj1X/ozNwIRf
	JjvueIdeqtVJ0CWXPWC51ctC/JbFfRka4tPQyg+OvUt6EA/5A6Pd9l5idQKqCXINxwZida
	pHP213bp2P46ZKVvZoDWq6+eC0RUJ/U=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-80-wT2EUwStNGeyhzbxRW2XrQ-1; Sat,
 10 Oct 2026 22:20:20 +0000
X-MC-Unique: wT2EUwStNGeyhzbxRW2XrQ-1
X-Mimecast-MFC-AGG-ID: wT2EUwStNGeyhzbxRW2XrQ_1791670818
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D0A4D18002E6;
	Sat, 10 Oct 2026 22:20:18 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 039DC18004D4;
	Sat, 10 Oct 2026 22:20:15 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Hui Peng <benquike@gmail.com>,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH-next v2 6/6] selftests/cgroup: Skip test_cpuset_prs.sh test if some required CPUs are offline
Date: Sat, 10 Oct 2026 18:19:38 -0400
Message-ID: <20261010221938.243859-7-longman@redhat.com>
In-Reply-To: <20261010221938.243859-1-longman@redhat.com>
References: <20261010221938.243859-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

The test_cpuset_prs.sh test assumes that all the relevant CPUs being
tested are online. If some of them are offline, some of the test cases
may fail. So skip the test if the required CPUs are either offline or
not present.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 .../selftests/cgroup/test_cpuset_prs.sh       | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 3d392e8c66aa..f57971ebb90e 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -118,6 +118,26 @@ TEST_ISOLCPUS=
 		skip_test "Current isolated CPUs ($CURRENT_ISOLCPUS) don't match boot isolated CPUs!"
 }
 
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
+
 cleanup()
 {
 	online_cpus
-- 
2.55.0

