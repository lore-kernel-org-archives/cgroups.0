Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794240580;
	b=W9tWChE/cgxLgB3MM8wN2CCqkX7DWGdasTz1fdYEii86y+Km7Z4R/foDBgmtm85dpqqk
	 TCRMC+6zjtf2QadwnE47KAJjzvLrWaj6zhZ0CHbD9jlaumjV8knbyl1YifBzWv5GtzVgy
	 Hv0h2D42zIrdMu0Z1qjhxgnaAckAwjRXLrk+8Dk9pTjsjHQCCu0wosRkS7AHgK+RsZscm
	 uL5Wsmif+fzELPaKk2S14ibKC9B5NBTHfDmzlF0onXy/28Tt2GjIzY6nIfSyBaI5yrTP3
	 4l8ZkyM3+FJXLpuQPMasW1w3xbruu7TK6DKxmvR+5ODmxa3bXODBV5mXC4JV1jLfN6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794240580;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=tvD4TMtCJkUt7Zh1imSbDDpg26XkeYYGU9jaHZWXuvw=;
	b=4EeXW5+CB4el04IPuZEcG91fjOoMowqGITmhsyfCkz12M8kKaZsUh9GzRDNOGgN9YPfD
	 SN4zx/H9FwJ/T8svyjvna9UVmniRtEfLMtxxGE94AlkWLwBiLOUO9MmVlQIIZrEFlvGDP
	 XzqAFDw1fKrUAhUlxo6Iys9VHKr6akKbwokmGBbs4j5M5QvC8ZlxDEK8lV5DzJ2q/yEfR
	 NjyKYqHMT3hAlbJa/1A+ENC8rK0FhjV/kDV0EleHmtyXGfeLjDpraVP6PLy6Y9NjrGDPI
	 QaNd2WwgVqfz/LgEAHEXGmIMxBsnrn2Cmcyczm4dBFBvmEVBfrk+ndbOtXlYCzMNSAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MaXXfYTH;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FC5606EE81
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 16:09:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98FC5606EE81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MaXXfYTH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794240578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tvD4TMtCJkUt7Zh1imSbDDpg26XkeYYGU9jaHZWXuvw=;
	b=MaXXfYTHnISsCZtYOF3dS5nNMWckrUMv74vXTEkDg6GIVO6+o1f0i6RVB9HN2uySlmBTGa
	zmbLqzG6F4CC8ysW4Y2E0y5uEIastO/HBz2/EUs+qGYt/Ul6akk6M0OHVNSJxt+kZdkr8i
	/vgEOR7ZaI95x/c6gPKWoWWatoZeDNY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-630-6vCoMHaPNiqaccLSxybm8A-1; Mon,
 09 Nov 2026 11:09:35 -0500
X-MC-Unique: 6vCoMHaPNiqaccLSxybm8A-1
X-Mimecast-MFC-AGG-ID: 6vCoMHaPNiqaccLSxybm8A_1794240573
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4D83D1955D42;
	Mon,  9 Nov 2026 16:09:33 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id ACABE7E2;
	Mon,  9 Nov 2026 16:09:31 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Waiman Long <longman@redhat.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH 3/5] cgroup/cpuset: Protect current->mems_allowed read in cpuset_fork()
Date: Mon,  9 Nov 2026 11:09:10 -0500
Message-ID: <20261109160912.1369897-4-longman@redhat.com>
In-Reply-To: <20261109160912.1369897-1-longman@redhat.com>
References: <20261109160912.1369897-1-longman@redhat.com>
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

Reading mems_allowed of the current task outside of cpuset_mutex critical
section should be protected by using mems_allowed_seq seqlock as the
nodemask can be updated concurrently leading to a torn read. Such
protection is currently not implemented in cpuset_fork() for the
!CLONE_INTO_CGROUP case. As a result, the child task may inherit an empty
or corrupted mems_allowed nodemask. This violates NUMA memory policy
constraints and causes subsequent page allocations to unconditionally
fail, potentially leading to crashes or spurious OOM killer invocations
for the child task.

Fix that by using a read_mems_allowed_begin/read_mems_allowed_retry()
loop to protect the mems_allowed read.

Fixes: 06f4e9489891 ("cpuset: make sure new tasks conform to the current config of the cpuset")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/bug/linux-601100b4-fa77-45fd-99f9-bfbd4385201f
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index e8169b739454..1f25f27e0e9b 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3864,11 +3864,20 @@ static void cpuset_fork(struct task_struct *task)
 	rcu_read_unlock();
 
 	if (cs == oldcs) {
+		unsigned int seq;
+
 		if (cs == &top_cpuset)
 			return;
 
 		set_cpus_allowed_ptr(task, current->cpus_ptr);
-		task->mems_allowed = current->mems_allowed;
+		/*
+		 * A cpuset.mems update can update current->mems_allowed
+		 * concurrently, so retry it again if it really happens.
+		 */
+		do {
+			seq = read_mems_allowed_begin();
+			task->mems_allowed = current->mems_allowed;
+		} while (read_mems_allowed_retry(seq));
 		return;
 	}
 
-- 
2.56.0

