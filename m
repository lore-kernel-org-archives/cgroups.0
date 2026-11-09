Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794251426;
	b=QR2kx6TClbWV0tzJ8b0ZpjwmWDcYHwmXIkc+tEVYoVHv4so4sDrQe/XohUCcHJ/J1dZ/
	 481JaJNE4dkv1/AaQJpjOjF9ZaFoAgDe++dPu7LEyyHNttWxyCuAji6KMwwCOP9xotz8r
	 p0qPDmIUdSHRjhXqp5NMSZIAG0wje3LYH9OBYAfdNiHlhlEmvAgdMzybOf4qxmrmJ0Usg
	 ffyLPmKxuafSUYDJQZHsYmNUDXfDimKRVOVPp+0Z643zz72D7LxgA7dE3H+jwBbWQxvFY
	 s9psEgaME3paZiYVHAk4F4O3Xr+GyYF3bT61VCJly4A+SAa52A5uhW7wZ9hLnAOsxaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794251426;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=BR2H0P0oVpV7sSUQ86LkRigPdcwLV9GujxCpcT1ujvM=;
	b=AW6NoP4Wr3msXFE1ObURXiDLINkX5LJ6TOgoQt64lZbhV6LPqFMhV4he/Rdka3cS1uc+
	 UdvPF/o75E2P0K/s/M72zkgKfVGuI4qXuXmFYI8k7GbrKP/sb41JruGyxcjim/fiqlE2z
	 hUGX7ryYb4XDjkP7kzmX6K2i/GxweHaYGRMX/4Bg3WB2TT/AZdAY59LTpF25sCteAHmZe
	 FfYhcfllFfpX8AY6IGk/l9WX1KmsmlvYu3VnAclZM00skhln7fBE9GeAoekvSBgIGgZo7
	 n+zP7I9OR9NbkQoDmnjoTuuNis+d57aN+0BxtTUUlt6FGxYtjr1B7laFy/nUyf7J6Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=bDd6rkG2;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D9260A262A
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 19:10:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 06D9260A262A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=bDd6rkG2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794251425;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BR2H0P0oVpV7sSUQ86LkRigPdcwLV9GujxCpcT1ujvM=;
	b=bDd6rkG2KWikNaQ6t4MS/77Y6BgmXFV3Xhd3XKL6SuThgjFS6esmy/3o8+m7XLQURWlocE
	9YxHgSmyXg+4EqPOO/LxpZghLW1vSk2lZ812oIRrO0cEW9fcpj2u+gXSALp2b//r21+YWh
	JN4r5nKZa8wgu2NPVnQO3Uqx0UDrMOA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-3-kCYuJ8PaMlCLS02q9swIQw-1; Mon,
 09 Nov 2026 14:10:21 -0500
X-MC-Unique: kCYuJ8PaMlCLS02q9swIQw-1
X-Mimecast-MFC-AGG-ID: kCYuJ8PaMlCLS02q9swIQw_1794251420
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 371D319560AE;
	Mon,  9 Nov 2026 19:10:20 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AF71F195608C;
	Mon,  9 Nov 2026 19:10:18 +0000 (UTC)
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
Subject: [PATCH-next v2 5/5] cgroup/cpuset: Correctly set isolated_cpus when switching partition state
Date: Mon,  9 Nov 2026 14:09:55 -0500
Message-ID: <20261109190955.1398611-6-longman@redhat.com>
In-Reply-To: <20261109190955.1398611-1-longman@redhat.com>
References: <20261109190955.1398611-1-longman@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

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
index 2d4744f2d6ac..741a13bbeda7 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -556,6 +556,13 @@ TEST_MATRIX=(
 	" C2-6:X2-5:P1 CX3-6:P2 \
 	                    .      .   T:X4-6    .      .      .     0 A1:4-6|A2:4-6 A1:P1|A2:P-2 ."
 
+	# Switch PRS state (root <=> isolated) will properly update cpuset.cpus.isolated
+	# even if child partitions are present.
+	" C1-6:P1 C3-6:P1 C5-6:P2  .       .    P2      .      .     0 A1:1-2:A2:3-4:A3:5-6
+								       A1:P1|A2:P2:A3:P2 3-6"
+	" C1-6:P1 C3-6:P2 C5-6:P2  .       .    P1      .      .     0 A1:1-2:A2:3-4:A3:5-6
+								       A1:P1|A2:P1:A3:P2 5-6"
+
 	#
 	#  old-A1 old-A2 old-A3 old-B1 new-A1 new-A2 new-A3 new-B1 fail ECPUs Pstate ISOLCPUS
 	#  ------ ------ ------ ------ ------ ------ ------ ------ ---- ----- ------ --------
-- 
2.56.0

