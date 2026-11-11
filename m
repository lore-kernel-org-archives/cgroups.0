Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794362551;
	b=hKYDQ0k95hVIsFJEiF9DnY92BXgNQisAetl1Ru5rSSxQWvrW7vHBeejxB34xuIk0KRke
	 p0hWT8GxrvfUb7W2LEHnvDiKH4maJzwI/v931xEwFnGFFZDPzBtAHI6QUDT0LhQloJEWx
	 Z3T2lD7JdV8VMYn0t3rMgyEJDPYzz/I+DN0lG71Xu+kZHAsbbGyjhLG/dIG61B3TXchJc
	 b/XNXOl1OsKOX4VP+jXZNS1AZlVF8+l/lEwqM95s++5IEUAMUPHPc2sesFzL+TpbZ1mXO
	 6rapQbwUj+Jh+IrvnbhY+Kj5ApjArnqxQsbNUEfnzw1LPyLsiHEfxLoWV7cLVk6u52A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794362551;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=JpHoJwtc8OMNwBDNPrWb6hXydtit460wCEFWU9Dm5s8=;
	b=GEaLwwYDWE54lAe/RSN4HgZBnJRVAfTbxb1+ODn9ZnNrJf2oanIMTUajoc0W6heCmawT
	 8ejSsy0g5i2goO+rcO84TJ7QgLrGX9RqzdPAdSKHoJab/ssnhq/m5dXtBb50gKm3y9w6p
	 7TNGY9TQT95vAX+4ISMtxq+XerYp/VqqGTYlMBYjcTekX780/Rur9ogBaga3EmHkvEEdi
	 1J3rraQZTQWPIQDsoVpWQWbPiXAlF8xUdwbCy8HCcBqlFNYL77+OSI7nWCJwr1KL5ccSD
	 B/h4hPfIXh6tMT8F6rXlxeStgrTzn6ejjdj2j/YFqhDG5yFIzkFeIFkkVV2Y1o/CodQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=U6dXBUVd;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDDC60A2613
	for <cgroups@vger.kernel.org>; Wed, 11 Nov 2026 02:02:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8EDDC60A2613
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=U6dXBUVd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794362549;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JpHoJwtc8OMNwBDNPrWb6hXydtit460wCEFWU9Dm5s8=;
	b=U6dXBUVd2veZfAIO2u55p9zPcOt1RjlqJ7RjQ8LuofRp9o68qYrJZK3ktCi+puuNCKnJZ4
	h4VmKIqjQE8BmszQ/2/ZUVHMPhXnrg0Xtj9GeJdz5MZNpwpkuBJvjh80sf9uyQ9iJtn2M2
	fbAItPQgI9UkoI+Qe2597TzKcaAZE4Y=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-556-RcGYwQhxNdyC48DWEme60g-1; Tue,
 10 Nov 2026 21:02:26 -0500
X-MC-Unique: RcGYwQhxNdyC48DWEme60g-1
X-Mimecast-MFC-AGG-ID: RcGYwQhxNdyC48DWEme60g_1794362544
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 921FC180214E;
	Wed, 11 Nov 2026 02:02:24 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8F1E41966664;
	Wed, 11 Nov 2026 02:02:22 +0000 (UTC)
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
Subject: [PATCH-next v3 3/3] cgroup/cpuset: Check remote partition underneath before making an invalid partition valid
Date: Tue, 10 Nov 2026 21:02:04 -0500
Message-ID: <20261111020204.1660055-4-longman@redhat.com>
In-Reply-To: <20261111020204.1660055-1-longman@redhat.com>
References: <20261111020204.1660055-1-longman@redhat.com>
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

When re-evaluating an invalid local partition via partcmd_update,
update_parent_effective_cpumask() does not check whether a descendant
remote partition is using its exclusive CPUs, promoting the cpuset to a
valid partition root over the remote partition. This condition should only
be possible if parent is the top_cpuset and exclusive_cpus isn't empty.

This leaves an active remote partition underneath a valid
local partition root with overlapping exclusive CPUs, breaking
scheduler domain partitioning and triggering warnings in
compute_partition_effective_cpumask() and generate_sched_domains().

Fix that by checking the effective_xcpus against subpartitions_cpus
when an underneath remote partition is possible to make sure that all
the exclusive CPUs are available before allowing the invalid partition
to be switched back to valid.

Also make sure that effective_xcpus is non-empty before swtiching an
invalid partition back to valid.

Add a test case in test_cpuset_prs.sh to verify that an invalid partition
with a remote partition underneath cannot be switched back to valid
with a hotplug event.

Fixes: 181c8e091aae ("cgroup/cpuset: Introduce remote partition")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/bug/linux-47715b89-d5fb-4731-b7c9-070773c6ff75
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c                        | 42 ++++++++++++-------
 .../selftests/cgroup/test_cpuset_prs.sh       |  4 ++
 2 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 8b684361c94e..af5fd543fe88 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2034,11 +2034,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 		 * tasks_nocpu_error() with this very mask, and a failing
 		 * write is routed to partcmd_invalidate instead.
 		 */
-		if (is_partition_invalid(cs)) {
-			adding = false;
-			deleting = cpumask_and(tmp->delmask,
-					newmask, parent->effective_xcpus);
-		} else {
+		if (is_partition_valid(cs)) {
 			cpumask_andnot(tmp->addmask, cs->effective_xcpus, newmask);
 			adding = cpumask_and(tmp->addmask, tmp->addmask,
 					     parent->effective_xcpus);
@@ -2046,6 +2042,17 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 			cpumask_andnot(tmp->delmask, newmask, cs->effective_xcpus);
 			deleting = cpumask_and(tmp->delmask, tmp->delmask,
 					       parent->effective_xcpus);
+		} else {
+			deleting = cpumask_and(tmp->delmask,
+					newmask, parent->effective_xcpus);
+
+			/* Check if a remote partition may be underneath */
+			if ((parent == &top_cpuset) &&
+			    !cpumask_empty(cs->exclusive_cpus) &&
+			    cpumask_intersects(tmp->delmask, subpartitions_cpus)) {
+				part_error = PERR_REMOTE;
+				deleting = false;
+			}
 		}
 
 		/*
@@ -2126,34 +2133,37 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 		} else if (is_partition_invalid(cs)) {
 			struct cgroup_subsys_state *css;
 			struct cpuset *child;
-			bool exclusive = true;
 
 			/*
 			 * Convert invalid partition to valid has to pass the
-			 * cpu exclusivity test when cpuset.cpus.exclusive is
-			 * empty as well as the housekeeping check.
+			 * following tests:
+			 * 1) housekeeping CPU conflict check
+			 * 2) cpu exclusivity test when cpuset.cpus.exclusive is
+			 *    empty.
+			 * 3) if parent is top_cpuset, none of the effective_xcpus
+			 *    (tmp->delmask) are in subpartitions_cpus, if not a
+			 *    remote partition may be underneath.
 			 */
 			if (prstate_housekeeping_conflict(cs->partition_root_state,
 							  parent_prs, tmp->delmask, NULL)) {
 				part_error = PERR_HKEEPING;
-				goto write_error;
-			}
-			if (cpumask_empty(cs->exclusive_cpus)) {
+			} else if (cpumask_empty(cs->exclusive_cpus)) {
 				rcu_read_lock();
 				cpuset_for_each_child(child, css, parent) {
 					if (child == cs)
 						continue;
 					if (!cpusets_are_exclusive(cs, child)) {
-						exclusive = false;
+						part_error = PERR_NOTEXCL;
 						break;
 					}
 				}
 				rcu_read_unlock();
+			} else if ((parent == &top_cpuset) &&
+				   cpumask_intersects(tmp->delmask, subpartitions_cpus)) {
+				part_error = PERR_REMOTE;
 			}
-			if (exclusive)
+			if (!part_error)
 				deleting = !cpumask_empty(tmp->delmask);
-			else
-				part_error = PERR_NOTEXCL;
 		}
 	}
 
@@ -2174,7 +2184,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 			break;
 		case PRS_INVALID_ROOT:
 		case PRS_INVALID_ISOLATED:
-			if (!part_error)
+			if (!part_error && deleting)
 				new_prs = -old_prs;
 			break;
 		}
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 1e9e6b4c6f7b..3d873804abc2 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -563,6 +563,10 @@ TEST_MATRIX=(
 	" C1-6:P1 C3-6:P2 C5-6:P2  .       .    P1      .      .     0 A1:1-2|A2:3-4|A3:5-6 \
 								       A1:P1|A2:P1|A3:P2 5-6"
 
+	# A hotplug event will not incorrectly activate an invalid partition with
+	# a remote partition underneath.
+	"  CX1-4  C3-4:P1   .      .      P1   O1=0     .      .     0 A1:2|A2:3-4 A1:P-1|A2:P1"
+
 	#
 	#  old-A1 old-A2 old-A3 old-B1 new-A1 new-A2 new-A3 new-B1 fail ECPUs Pstate ISOLCPUS
 	#  ------ ------ ------ ------ ------ ------ ------ ------ ---- ----- ------ --------
-- 
2.56.0

