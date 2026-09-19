Received: from mail-pz2-f40.google.com (mail-pz2-f40.google.com [74.125.228.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F76A339394
	for <cgroups@vger.kernel.org>; Sat, 19 Sep 2026 22:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789856250; cv=none; b=or5YTZaNcCjLhjr9KcOs79x1htfcISTFPMvaZyUxmHcdQiiFs/AEo45hkJnTFfoMaE3Jr45l5qjBbPO038ot2pxdIrKwwlNFPVlqRc66HdBUa3nEpupQ3THXdbD5xfksMbllCQelIDp83vQn+3cgN5zceJ1OWTfvWn39eh0pxds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789856250; c=relaxed/simple;
	bh=PBlYrbUMa8c9n2w8jCK5pWTavFbfpz7iWRc+vhU8O+k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U65Vx7P5tEBlslXOaSyih7cPWWJHHRMj93LH68Nswm2nyaVysbUlaYgzN1G0ZHb0Qi82GvXOVDGJTX0Q4zQ94pY2oxMigpUsYOMvSzftMIqziMGlMdXYZ70lKniHcIn6NWMs7khBE02j3czODDjXqVaXTW5o/SgB7tlBtn98zxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JlUv+6LJ; arc=none smtp.client-ip=74.125.228.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JlUv+6LJ"
Received: by mail-pz2-f40.google.com with SMTP id 41be03b00d2f7-cc515bef69dso1207048a12.2
        for <cgroups@vger.kernel.org>; Sat, 19 Sep 2026 15:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789856249; x=1790461049; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nHjDEI31PmhjL+jQcpe7FJPCDJTSJKQhfDFskj8mPNE=;
        b=JlUv+6LJhRQOcs562CtY6Wdl47GuDZqmxZRMRuVwmW885sl3UvQBN9cRsEtlVns/53
         1TWgeH9j5m9S7HvCI7u6Mj2SUq6pbL4iFmCA0lpidEz80K1bWF3vPED9zGB6lw/24yBj
         Hpfx2Hqy4qLlyOJLfBe8y/pussFBYo0GRsjTLs9Fhprhbciu5TASAH7TdCQaIHjJRF1f
         kxwgGWK15+Z9AUHbwyh5hT+waW7j2sCMH3rU5FbXxx3fphAd+GwuIThnIZ6UWJPrDka/
         j1xuesKjLYVEIJLvhcu5/EWeAyepBRDQSf5B1/a3OmzfYQRUQBRIw7G+ReZZrFlFR4Pt
         qdSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789856249; x=1790461049;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nHjDEI31PmhjL+jQcpe7FJPCDJTSJKQhfDFskj8mPNE=;
        b=m504fZwzvMMRSVasmyS4p0f8/iD4sgvzidh74C0f65da2mxqC+jNhiP+SXRXdV5I5r
         tngJ1YiqrQEXC7YFWdeMJNvlhsk4D/xecWumZSdowL67aEJvwCyOkWGND5Mk579wBp0j
         FWlARF+b0iBn1Jzh1pDhLJb5+UBGsEtDi6awqJBlZiK5JdYt3okU2W2OfeAr1atqTDxL
         v459E9CX8YXrl1GvcXq4bRiv2i12b1csHktzMy0lUdzFHE+jQBOo/xgZxw1iooeGnJ4i
         eaLMufY12gNLMFFmpRHOFz9torfZvDOoOSk87fUeOoEgVwzlBul2DcZYRTptbeud8GEm
         KXxQ==
X-Gm-Message-State: AFuF++lpkrRk4P2ppHDGc9NIgSf0u/cuntFlPV3LCPCk4h0K29dBZvBX
	5NjtKf3oWupS+PvWKSjYdpO1QUmE7GWiXR4ngLuJ3DO4VnO+unh2eKEw
X-Gm-Gg: AYBFou083LI62pdFq1fzPMkBPiR+cRQYIk5QqgJzN7hwtb5rkOEJNsmv7QRP7FyEUck
	z6DAHIuwt2Mmvc/o+WNCEBEc32SerTSMvymVWgyVYbufL5lek6f8BSE4CTkZWMRo8DE+VMuACHa
	B4b4Hq1qSm1+s+Zu4EAduLB3TLFC0rMD+L0Wccqta8pZXdgJs6imZ2viV3CHEpkSXePFrqf0md9
	k7sQNM0WrqfkgvxMxzoBUYNDw9MRV42gyTtPk/EBRAAFso1K7w97uAMuuttrY1TzL4OgvdGNaV5
	vhmpcS5NIMcmiL0WnCO1KxlqQ+HpTam6estskrrBjfVhAHOcVsv1unJLo9Wf7EQcHoB7gGuY7P1
	FO3Om5uLQWsmj95ua0uW7Yk+2oR/ZB+RAtJyprRg8FjJNV76ehtZcypE/pOgv+uz3IKEeQ+fgwR
	j0B75WRvDwcW8fEdEl78lsqbd9PCySc60Nh9pUAb8CyYaeq2JF4qUaZEqRT9ChxLMh7Z3uLaJrE
	sGwt22FMdkNjCYr2WLYey2kVnLdRrQQ0Ke2jbGFnHzfocPTgYJDfmOPkB+VtIDfV1dE3f52A4p7
	WAyGwZPv08Bsap/8Vp/P
X-Received: by 2002:a17:90b:5281:b0:3a0:3673:dbbf with SMTP id 98e67ed59e1d1-3a03673dd7bmr458144a91.59.1789856248664;
        Sat, 19 Sep 2026 15:17:28 -0700 (PDT)
Received: from phui-2.c.googlers.com.com (78.123.83.34.bc.googleusercontent.com. [34.83.123.78])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6c37a88csm6240077a91.8.2026.09.19.15.17.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 15:17:28 -0700 (PDT)
From: Hui Peng <benquike@gmail.com>
To: longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] cgroup/cpuset: prevent overlapping local and remote partition creation
Date: Sat, 19 Sep 2026 22:17:27 +0000
Message-ID: <20260919221727.3706964-1-benquike@gmail.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix two partition validation bugs in kernel/cgroup/cpuset.c:

1. In remote_partition_enable(), check whether the requested effective
   xcpus intersect parent->subpartitions_cpus so a remote partition
   cannot claim CPUs already delegated to a local child partition.
2. In validate_partition(), verify that enabling a local partition does
   not overlap CPUs already allocated to an active remote partition.

Fixes: aa7d3a56a20f ("cpuset: fix warning when disabling remote partition")
Assisted-by: LLM
Signed-off-by: Hui Peng <benquike@gmail.com>
---
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 2538faac9aba..13fad096c494 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -713,7 +713,10 @@ static inline bool cpus_excl_conflict(struct cpuset *trial, struct cpuset *sibli
 		return true;
 
 	/* Exclusive_cpus cannot intersect */
-	return cpumask_intersects(trial->exclusive_cpus, sibling->exclusive_cpus);
+	return cpumask_intersects(trial->exclusive_cpus,
+				  cpumask_empty(sibling->exclusive_cpus)
+				  ? sibling->effective_xcpus
+				  : sibling->exclusive_cpus);
 }
 
 static inline bool mems_excl_conflict(struct cpuset *cs1, struct cpuset *cs2)
@@ -1591,8 +1594,8 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
 	 * above it or remote partition root underneath it is not allowed.
 	 */
 	compute_excpus(cs, tmp->new_cpus);
-	WARN_ON_ONCE(cpumask_intersects(tmp->new_cpus, subpartitions_cpus));
 	if (!cpumask_intersects(tmp->new_cpus, cpu_active_mask) ||
+	    cpumask_intersects(tmp->new_cpus, subpartitions_cpus) ||
 	    cpumask_subset(top_cpuset.effective_cpus, tmp->new_cpus))
 		return PERR_INVCPUS;
 	if (((new_prs == PRS_ISOLATED) &&
@@ -2411,6 +2414,10 @@ static enum prs_errcode validate_partition(struct cpuset *cs, struct cpuset *tri
 	if (cpumask_empty(trialcs->effective_xcpus))
 		return PERR_INVCPUS;
 
+	if ((parent == &top_cpuset) &&
+	    cpumask_intersects(trialcs->effective_xcpus, subpartitions_cpus))
+		return PERR_REMOTE;
+
 	if (prstate_housekeeping_conflict(trialcs->partition_root_state,
 					  trialcs->effective_xcpus))
 		return PERR_HKEEPING;
@@ -2970,7 +2977,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 		 * local or remote partition.
 		 */
 		if ((parent == &top_cpuset) &&
-		    cpumask_intersects(cs->exclusive_cpus, subpartitions_cpus)) {
+		    cpumask_intersects(user_xcpus(cs), subpartitions_cpus)) {
 			err = PERR_REMOTE;
 			goto out;
 		}
