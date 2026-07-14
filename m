Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A032441031
	for <cgroups@vger.kernel.org>; Tue, 14 Jul 2026 18:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784054094; cv=none; b=Xl6FMJBXL8/2TMWjQpJu+qgsfdJUA9R6D4br+uvxGjeInro4ZjO7G3EqAM4FwQ+H6iTdLwHB1+mDu5nNDyRJkd2S/8091axlthdRKHRjaQTt5SjpdpKcPUE9hpjUbx5VT2iccZJyeADtdeQx99Z7Q5o0ko9MR673DegYNc+SyNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784054094; c=relaxed/simple;
	bh=n7tA+JtthjCpt5jYdK/6ZMA5a1orybyfZ9MbxgkmU5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OIzDOinfhHQ5SEIH+PtFKUlEKaXsJzyFnaQyWBGxcjON3Lg7/gJh6E3pljZLdYb+oO6e85Qz/RpEke9BEhWbwfwBECqKx49LQRBkUD80fzcsdhKVNctIMWsnJ1sEeAd2mADpW2MVcPeqQaY8WDuwdq0iAxt8OUNsH+14LDlVTgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eQ5Jvz3c; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eQ5Jvz3c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784054091;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=t120cvhZNXeUe/p+SXy1bzc4SzG5CODrSc2c+k96MwQ=;
	b=eQ5Jvz3cbdQngaJIcBJSbag+0OkZMqw6CLWv5vnpIfSQrvzKYrJglDVptcyve4MrPcXt/6
	T3L42GmunDha/nHYX727u1oxg/Febd2lJIj7aMgLFLMXQjNxeiL2kgS40KKGV5IPl4sbMq
	HCiFtfpGHCwnOhE2s/hf1AxayxaXQSk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-686-v2QOTTi3PbmBzNphDqPq8A-1; Tue,
 14 Jul 2026 14:34:46 -0400
X-MC-Unique: v2QOTTi3PbmBzNphDqPq8A-1
X-Mimecast-MFC-AGG-ID: v2QOTTi3PbmBzNphDqPq8A_1784054084
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 71020180061E;
	Tue, 14 Jul 2026 18:34:44 +0000 (UTC)
Received: from llong-thinkpadp1gen5.rmtusnh.csb (unknown [10.22.65.193])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C7B5319560A3;
	Tue, 14 Jul 2026 18:34:42 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Waiman Long <longman@redhat.com>
Subject: [PATCH] selftests/cgroup: Fix intermittent test_cgfreezer_ptrace test failures
Date: Tue, 14 Jul 2026 14:31:25 -0400
Message-ID: <20260714183125.521650-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

It is found that the test_cgfreezer_ptrace test of test_freezer can
intermittently fail on some architectures like arm64 and ppc64.

After further tracing of the mechanics of the test_cgfreezer_ptrace test,
it is found that the ptrace(PTRACE_DETACH) call temporaily unfreezes the
cgroup and then freezes it again afterward in the detaching process. The
reading of the frozen flag from cgroup.events is done from a different
process running maybe on a different CPU. As a result, racing is possible
and the intermediate unfrozen state can be read leading to occasional test
failures especially on architectures with a weak memory model like arm64.

Fix that by adding a short 1 ms delay before reading the frozen state
to ensure that the final frozen value will be read.

By running test_freezer 100 times in a loop, there were 28
test_cgfreezer_ptrace failures out of 100 on an arm64 test system before
the patch. After applying the patch, there was no test failure at all
in 100 runs of test_freezer.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 tools/testing/selftests/cgroup/test_freezer.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_freezer.c b/tools/testing/selftests/cgroup/test_freezer.c
index 0569e93fa6b0..8e2cca74d212 100644
--- a/tools/testing/selftests/cgroup/test_freezer.c
+++ b/tools/testing/selftests/cgroup/test_freezer.c
@@ -625,6 +625,18 @@ static int test_cgfreezer_ptrace(const char *root)
 	if (ptrace(PTRACE_DETACH, pid, NULL, NULL))
 		goto cleanup;
 
+	/*
+	 * The ptrace(PTRACE_DETACH) call will temporaily unfreeze the cgroup
+	 * and then freeze it again afterward in the detaching process. The
+	 * reading of the frozen flag from cgroup.events is done from a
+	 * different process running maybe on a different CPU. As a result,
+	 * racing is possible and the intermediate unfrozen state can be read
+	 * leading to occasional test failure especially on architectures with
+	 * a weak memory model like arm64. This intermittent test failure can
+	 * be avoided by adding a 1ms short delay before reading the frozen
+	 * state.
+	 */
+	usleep(1000);
 	if (cg_check_frozen(cgroup, true))
 		goto cleanup;
 
-- 
2.55.0

