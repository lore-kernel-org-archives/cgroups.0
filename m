Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794277482;
	b=tBGk8zhk8zR+JuWuadMj6YTHBBf6BEZo4KKDbU5FNWR+C3j+WheAEsj/WI0m4RgcZkrN
	 xBE66XXRmo6X+0hI4lN84CkBhStBsiEL/dYAzNMa32IIZbkN17u4PSrs7Xb1IrHVZfX/p
	 upYroQVPeUkZMwze9lxRDCh7APkbK7c4zZp1ntqucmc6muvJliVnH+i6UqmMKeDY+SIMl
	 +lofWrOJR9aGIJwgALTqXT/HIH4kUw/YIHjsXfcfq3xNB/f+HJy8SEwKAVCqwvf/HTKSj
	 Fp2GToE1l+wB/onD2kEDRnBtvV2FIv+SSomcUhjoFVpU3UvVFQ6mj+kQjo3/s+54Pmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794277482;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=27Ci1Zm96fbspIIVyB98OB/5lJZMQqsULnEUarjSfnw=;
	b=5Q4OH3zy+39eVcRfJAY6gxCQa1MDuliAb7Xqwdg9BiGVHZFGsZ5XKcEi9pzJrARjh7vI
	 jM7kcznJycV/9F+PiMq0dxD2LYIf3jfPDfcmMm3phs2CqYdFkVWbjEItn7vCWlakBD5Ho
	 Hn9MSbItOQEubVgzUlC1B5AjGJ4hcP4eyiQBAoAl85CR+KBzhjJRXzsYKzaJlOO9X2TZ/
	 1VZpbiOYsfVkAaoNUckgM6S/CFI0Oy31gegJZF5h9BEQhCIyPKKrUwGTNUenJ0gGu0Cw8
	 HMC6/PVebSLrDUV3bQiGoz0si451Nl1tx0eYLWryqNcXh1sX3dBRf/k0ImZdFj/KrVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=CuSqWjWM;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96839606A31C
	for <cgroups@vger.kernel.org>; Tue, 10 Nov 2026 02:24:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 96839606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=CuSqWjWM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794277480;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=27Ci1Zm96fbspIIVyB98OB/5lJZMQqsULnEUarjSfnw=;
	b=CuSqWjWMlDq7vYRsWZ+VoS7EXP9UHrX1OKC36w9tmG0R2B7JGe6l3lxC6Wl+IkH/vulmdE
	404t73RUUMF0lyA9z4GgZEzY1Obm2IcRFeQBfIC1PJ5QFOxjRFuYzaXvVwEiJhMN7i20mT
	r1lfJxJhBOwx5tv8/EZvRiyHnWYVano=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-658-wVwLMOsWPiyekHJO59cnVw-1; Mon,
 09 Nov 2026 21:24:39 -0500
X-MC-Unique: wVwLMOsWPiyekHJO59cnVw-1
X-Mimecast-MFC-AGG-ID: wVwLMOsWPiyekHJO59cnVw_1794277477
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 510CF19560B4;
	Tue, 10 Nov 2026 02:24:37 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 127DC1684;
	Tue, 10 Nov 2026 02:24:34 +0000 (UTC)
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
	Waiman Long <longman@redhat.com>
Subject: [PATCH-next v2.1 5/5] cgroup/cpuset: Correctly set isolated_cpus when switching partition state
Date: Mon,  9 Nov 2026 21:24:00 -0500
Message-ID: <20261110022400.1450404-1-longman@redhat.com>
In-Reply-To: <20261109190955.1398611-6-longman@redhat.com>
References: <20261109190955.1398611-6-longman@redhat.com>
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

When update_prstate() is called to switch the partition state from
root to isolated or vice versa, the whole effective_xcpus is passed to
isolated_cpus_update(). However, if there are child partitions present,
some of the effective_xcpus are dedicated to those child partitions
and their partition states will remain the same or get invalidated in
the case of child root partition with isolated parent in the latter
update_cpumasks_heir() call. In the latter case, their exclusive CPUs
will be returned to their parent.

Therefore isolated_cpus may be set incorrectly with child partitions
underneath. Fix that by excluding their exclusive CPUs in computing
the correct cpumask of exclusive CPUs used by that partition alone.

Add new test cases into test_cpuset_prs.sh to test for such cases.

Fixes: 11e5f407b64a ("cgroup/cpuset: Keep track of CPUs in isolated partitions")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c                        | 30 +++++++++++++++----
 .../selftests/cgroup/test_cpuset_prs.sh       |  7 +++++
 2 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 7aa614c6ac4d..41048997a955 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3054,12 +3054,32 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 						  cs->effective_xcpus, NULL))
 			err = PERR_HKEEPING;
 		else if (parent_prs == PRS_ISOLATED)
-			err = PERR_ISOPARENT;
+			err = PERR_ISOPARENT;	/* old_prs should be isolated */
 
-		if (!err)
-			isolcpus_updated = true;
-		else
+		if (err) {
 			disable_partition = true;
+		} else {
+			struct cgroup_subsys_state *css;
+			struct cpuset *child;
+
+			/*
+			 * Need to scan child partitions, if present, and
+			 * exclude their effective_xcpus from cs. In the case
+			 * of switching to isolated partition with child root
+			 * partitions, those child partitions will be
+			 * invalidated in update_cpumasks_hier().
+			 */
+			isolcpus_updated = true;
+			cpumask_copy(tmpmask.new_cpus, cs->effective_xcpus);
+			rcu_read_lock();
+			cpuset_for_each_child(child, css, cs) {
+				if (!is_partition_valid(child))
+					continue;
+				cpumask_andnot(tmpmask.new_cpus, tmpmask.new_cpus,
+					       child->effective_xcpus);
+			}
+			rcu_read_unlock();
+		}
 	} else {
 		/*
 		 * Switching back to member is always allowed even if it
@@ -3093,7 +3113,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 	if (!is_partition_valid(cs))
 		reset_partition_data(cs);
 	else if (isolcpus_updated)
-		isolated_cpus_update(old_prs, new_prs, cs->effective_xcpus);
+		isolated_cpus_update(old_prs, new_prs, tmpmask.new_cpus);
 	spin_unlock_irq(&callback_lock);
 
 	/* Force update if partition is disabled & update effective_xcpus */
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 2d4744f2d6ac..351c8e8e89fa 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -556,6 +556,13 @@ TEST_MATRIX=(
 	" C2-6:X2-5:P1 CX3-6:P2 \
 	                    .      .   T:X4-6    .      .      .     0 A1:4-6|A2:4-6 A1:P1|A2:P-2 ."
 
+	# Switch PRS state (root <=> isolated) will properly update cpuset.cpus.isolated
+	# even if child partitions are present.
+	" C1-6:P1 C3-6:P1 C5-6:P2  .       .    P2      .      .     0 A1:1-2|A2:3-4|A3:5-6
+								       A1:P1|A2:P2|A3:P2 3-6"
+	" C1-6:P1 C3-6:P2 C5-6:P2  .       .    P1      .      .     0 A1:1-2|A2:3-4|A3:5-6
+								       A1:P1|A2:P1|A3:P2 5-6"
+
 	#
 	#  old-A1 old-A2 old-A3 old-B1 new-A1 new-A2 new-A3 new-B1 fail ECPUs Pstate ISOLCPUS
 	#  ------ ------ ------ ------ ------ ------ ------ ------ ---- ----- ------ --------
-- 
2.56.0

