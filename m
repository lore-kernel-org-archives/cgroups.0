Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792785659;
	b=yL7UzYgP+hg0El6IjY2MbiokIRwJ9tgJq/7DRSXDgOHi9E6Fhm7W8Q/W0NHs/r2/Kz04
	 Y93kDnlah0Q/1ZIuwQeUpj07sVEFLTZh3+Sy2ofyIWyP8puGDpR7QkW7TMzCtlSMdWfyh
	 i+4F6gEEEvmksqNc/RZEiZXsf2wniyWv2y1pmOujs24bhNsivmAT2SRDGSTyNL/AX+Z5P
	 lI6qYeNFYmMcQNqIBIVQUPfx+ZH2HENC4wh0DVVeL12u+ucEJRwm4tKcOJQaR57T7MWj6
	 5ouF66RIAfK7pI7WP/L3p1Nc7r6BbE6vojr6+3cArzDzDPYZCBaVepcC+kEUKpjnOjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792785659;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=W2zdrfASIgne8nhIAu/3iGRmmi2su/VRFMJWYm0YZkA=;
	b=kn3YfDa8JQpiCf8QveScbK7CS2F0XJwu+OMUI0P1KEFHGGpmwcimHzvGGlwPm94aqFcX
	 HN2YRsWgnykeav/LhD8arfHijfmmN82ZVBwMKcte6uUB6Ftj6tikMMV0O0SozGDQGUl0+
	 dVm9ADhDoOyC6UXu+eZlUOYF6zoHppzi597zS+5OspcrgoJJuPQ5Gx4iDlEtR1VTh/KgQ
	 2MXcr0oMIIkQ1J/Sr9UP2Dd4zViU85ANP7W+6OskIbIYcEHBZ7bFFuVv5YeAOePqsOOtO
	 IssianfWnVyMeHj1H6ZA+5ASnlpAz8R5PGugcGMYlkjPh6Bz46hecXoQRYj/mHPHaZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=cTesWCTV;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2584C606A337
	for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 20:00:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2584C606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=cTesWCTV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792785658;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W2zdrfASIgne8nhIAu/3iGRmmi2su/VRFMJWYm0YZkA=;
	b=cTesWCTV5hk8ajOcehHNO0mzEraK4puLnb22vEfYSujQCT2qOFLMRZI68oA+bRZX9UfAgt
	HRU4qVy0GPKXETcgXyJm6n3V6EGymUdYUcUu5hw9q2X7pxfY/qj9U/eSqVA2XcD0yuHZwd
	sqS8C03oft9vAgjdaYAratpRa7l+abc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-610-u0XX_IM4OGSrcEcGpijfmQ-1; Fri,
 23 Oct 2026 16:00:54 -0400
X-MC-Unique: u0XX_IM4OGSrcEcGpijfmQ-1
X-Mimecast-MFC-AGG-ID: u0XX_IM4OGSrcEcGpijfmQ_1792785653
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 161CD1801360;
	Fri, 23 Oct 2026 20:00:53 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 770CC1956089;
	Fri, 23 Oct 2026 20:00:51 +0000 (UTC)
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
Subject: [PATCH-next v2 03/10] cgroup/cpuset: Fix incorrect effective_cpus bug in update_cpumasks_hier()
Date: Fri, 23 Oct 2026 16:00:29 -0400
Message-ID: <20261023200036.60560-4-longman@redhat.com>
In-Reply-To: <20261023200036.60560-1-longman@redhat.com>
References: <20261023200036.60560-1-longman@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

With the introduction of cpuset.cpus.exclusive, the computation of
effective_cpus differs depending on if a cpuset is a valid partition
root or not.

In update_cpumasks_hier(), effective_cpus is computed early
to check if the current subtree can be skipped. Later on
update_parent_effective_cpumask() may be called which can change the
partition state from valid to invalid or vice versa. If the partition
state changes, the previously computed effective_cpus may no longer be
valid. Fix that by recomputing effective_cpus again when that happens.

Also add a new test case into test_cpuset_prs.sh to verify this change.

Fixes: e2ffe502ba45 ("cgroup/cpuset: Add cpuset.cpus.exclusive for v2")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c                            | 10 ++++++++--
 tools/testing/selftests/cgroup/test_cpuset_prs.sh |  3 +++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 06b8a67cbd3d..69fc02cd7469 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2315,10 +2315,16 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 		if (update_parent) {
 			update_parent_effective_cpumask(cp, partcmd_update, NULL, tmp);
 			/*
-			 * The cpuset partition_root_state may become
-			 * invalid. Capture it.
+			 * Capture current partition_root_state as it may have
+			 * changed. Recompute effective cpumask if changed.
 			 */
 			new_prs = cp->partition_root_state;
+			if (new_prs != old_prs) {
+				if (new_prs > 0)
+					compute_partition_effective_cpumask(cp, tmp->new_cpus);
+				else
+					compute_effective_cpumask(tmp->new_cpus, cp, parent);
+			}
 		}
 
 		spin_lock_irq(&callback_lock);
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 8bdda955b4a7..f4eb984752a0 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -364,6 +364,9 @@ TEST_MATRIX=(
 	" C1-4:X2-4 C2-4:X3-4:P1 C3-4:X4:P2 \
 				   .      .      X5      .      .    0 A1:1-4|A2:2-4|A3:3-4 \
 								       A1:P0|A2:P-1|A3:P-2 ."
+	" C1-5:X3-5:P2 C3-5:X4-5:P2 C4-5:X5:P2 \
+				   .    X1-4     .       .      .    0 A1:1-3|A2:4|A3:4 \
+								       A1:P2|A2:P2|A3:P-2 1-4"
 	" C1-4:X2-4 C1-4:X3-4:P1 C3-4:X4:P2 \
 				   .      .      .      X1      .    0 A1:1-2|A2:3-4|A3:3-4 \
 								       A1:P0|A2:P1|A3:P-2 ."
-- 
2.56.0

