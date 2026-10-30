Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793366090;
	b=wVlD71ZSCsvi4prtpCcIXvFpnctBwRT2wiEOGwGvy011vASlylZSkdJty5SXNzI9fn05
	 wGorAVcaMVpzpWGywSbyJZehny2aSrK3OYsKE63Jig83mefHt7dekKCWimViiOMkDX+C7
	 RnT1cNXeCLL8cz8cf0BjijW6yX9MMA3f49XwS/5fX/cV0X9G5/cVOUQIoHOkKYtdxH1T5
	 gZVC8+BiK5TWzNpxPwct+1V8l61MLMASDMsO93Ff739ZzB2UW1qmKifU2Rm+9FVywVUrz
	 Y4MiyG5c8/9vyYdhOMmfiNCenAKje03+ICanC1AzqARcHoBzovONIUBgA5oAV3VH9+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793366090;
	h=DMARC-Filter:X-UUID:X-CTIC-Tags:X-CID-P-RULE:X-CID-O-INFO:X-CID-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6VORSQYAD9hkgCjYkMujVkvIAUlg8MP5kdg3x4OHjys=;
	b=AKCxtfkmCOK00yjujSDf1sUvrmqvJ/KmgwubeohOc32x88w1o50VE2Z73bTpPC5Hl5aH
	 +7iGuaurVkijLkFbwlZ6s0b21Gb8pyYkSAQV1Ce0olgOtzumt/NCGmeFz4Qj2ltqz7w3C
	 2WWGn4SN7tJaKFnJZ971KppYPvVXhxsS7VLuIwMESDEE5Qt3wsGCHWuIYyRpJM/fHi4Ol
	 q3OEHRpo8U132SrSjlEaSxckSzX3TLsyVtGd8ObnQEafZVtW+dWdg9uqJFM3Luw0OSnln
	 t2rez+32Hko7A0SjehjT1u+C7ONYnTSxQTLqdMBf5Ww1R74IUZoP7X+b6KUxW3D4xcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A505606A31A;
	Fri, 30 Oct 2026 13:14:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8A505606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: d76768b4d46311f19a56ed5b684f684d-20261030
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CHARSET
	HR_CHARSET_NUM, HR_CTE_8B, HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD
	HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER
	HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_CHARSET
	HR_TO_CHARSET_NUM, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NAME, IP_UNTRUSTED
	SRC_UNTRUSTED, IP_LOWREP, SRC_LOWREP, SA_TRUSTED, SA_EXISTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:69b5ee93-52ae-4c4a-9985-d8c17c632739,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:69b5ee93-52ae-4c4a-9985-d8c17c632739,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:34c42cb444fc9590b091253d6743d438,BulkI
	D:261030211439NJ1LLJM9,BulkQuantity:0,SF:10|38|66|78|102|127|136|865|898,T
	C:nil,Content:0|15|50|99,EDM:-3|-100,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,
	QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
	,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d76768b4d46311f19a56ed5b684f684d-20261030
X-User: sunshaojie@kylinos.cn
Received: from sunshaojie-pc [(114.244.3.119)] by mailgw.kylinos.cn
	(envelope-from <sunshaojie@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1702212056; Fri, 30 Oct 2026 21:14:30 +0800
From: Shaojie Sun <sunshaojie@kylinos.cn>
To: Tejun Heo <tj@kernel.org>,
	Waiman Long <longman@redhat.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shaojie Sun <sunshaojie@kylinos.cn>
Subject: [PATCH] cgroup/cpuset: Drop redundant no-cpu check in partcmd_update with newmask
Date: Fri, 30 Oct 2026 21:14:08 +0800
Message-ID: <20261030131408.1054507-1-sunshaojie@kylinos.cn>
X-Mailer: git-send-email 2.50.1
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

update_parent_effective_cpumask() with a non-NULL newmask is only ever
reached from partition_cpus_change(), and only after validate_partition()
has checked the very same condition with the very same arguments:

  tasks_nocpu_error(parent_cs(cs), cs, trialcs->effective_xcpus)

since newmask is exactly trialcs->effective_xcpus and both functions use
parent_cs(cs) as the parent. cs, parent and cpu_active_mask cannot change
in between either, as cpuset_mutex and cpu_read_lock are held for the
whole operation. Hence

  nocpu = tasks_nocpu_error(parent, cs, newmask);

is always false here and the block that turns a "nocpu" condition into
PERR_NOCPUS is dead code. A new CPU list that would drain the parent is
fully handled by validate_partition(), which routes the write to
partcmd_invalidate and hands the partition's CPUs back to the parent.

The "!adding || !cpumask_intersects(addmask, cpu_active_mask)" test that
guards the block does not change this: the block can only be entered when
nocpu is true, and that never happens here.

Drop the redundant check and the dead PERR_NOCPUS block, and leave a
comment pointing at where the "parent could be drained" case is handled.
The empty-newmask check in the same branch is left alone: it validates
the newmask argument of this function, while what is removed here is a
decision that belongs to validate_partition().

No functional change.

Signed-off-by: Shaojie Sun <sunshaojie@kylinos.cn>
---
 kernel/cgroup/cpuset.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 3219f927c35e..c7b3a734cda8 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2016,9 +2016,6 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 			goto write_error;
 		}
 
-		/* Check newmask whether cpus are available for parent/cs */
-		nocpu = tasks_nocpu_error(parent, cs, newmask);
-
 		/*
 		 * partcmd_update with newmask:
 		 *
@@ -2033,6 +2030,11 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 		 * For invalid partition:
 		 *   delmask = newmask & parent->effective_xcpus
 		 *   The partition may become valid soon.
+		 *
+		 * Note that the no-cpu check is not repeated here:
+		 * validate_partition() has already evaluated
+		 * tasks_nocpu_error() with this very mask, and a failing
+		 * write is routed to partcmd_invalidate instead.
 		 */
 		if (is_partition_invalid(cs)) {
 			adding = false;
@@ -2056,18 +2058,6 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 			cpumask_and(tmp->new_cpus, tmp->delmask, cpu_active_mask);
 			WARN_ON_ONCE(!cpumask_subset(tmp->new_cpus, parent->effective_cpus));
 		}
-
-		/*
-		 * Make partition invalid if parent's effective_cpus could
-		 * become empty and there are tasks in the parent.
-		 */
-		if (nocpu && (!adding ||
-		    !cpumask_intersects(tmp->addmask, cpu_active_mask))) {
-			part_error = PERR_NOCPUS;
-			deleting = false;
-			adding = cpumask_and(tmp->addmask,
-					     cs->effective_xcpus, parent->effective_xcpus);
-		}
 	} else {
 		/*
 		 * partcmd_update w/o newmask
-- 
2.50.1

