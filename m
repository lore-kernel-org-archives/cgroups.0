Received: from mail-pj2-f42.google.com (mail-pj2-f42.google.com [74.125.227.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BE4472068
	for <cgroups@vger.kernel.org>; Sun, 20 Sep 2026 18:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789928095; cv=none; b=HW3ZnJ9aeI2tFhmDhPhNTXhdKpz5esbw2fBRiIOfATc5fNeM0ckfPMTAZpBUFpHBd9eB9LCRaLoHeHB4/onqHsH+WMA/5qnwcdL+FX8L84LjPEPSV/9MxbAQE2xnopE03I5+2nI5t9GZK69F3GUkthvaTd3culV9vPhTViKcijY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789928095; c=relaxed/simple;
	bh=ljrqpukr3NP5yrDjkb+Jpb6Ys4RNZtVj2TiTWC404Bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DRXeynKQ0COragSR1BriID8U3qxmpQHo/qhOPXUAWiN2BxVdaAmaReJRVnZ/lKWe90kxQK9Cnm/tKrVZ0gssQDhkLWZ0SHCIuJqlFTeWy+hNOTHnE4/YgwcNuIeoAitTv2eWqKTP+YF5RQ1CPagFxBOZPwxoME/xX+/vflESNg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=s0tG/0/1; arc=none smtp.client-ip=74.125.227.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s0tG/0/1"
Received: by mail-pj2-f42.google.com with SMTP id d9443c01a7336-2df4aa80a73so368515ad.3
        for <cgroups@vger.kernel.org>; Sun, 20 Sep 2026 11:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789928093; x=1790532893; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bIGxyqhgDCJxQrUSlOVUsvnBCPzikecf8ZgHQx68EUQ=;
        b=s0tG/0/10XJx/mcuXgliPlt13qzin7Ife58BuWPaA8GnB7oHnfF2uQ0khztArpRVGN
         m/pvCDSQs2O3UygsCyyPCucGMYS6o6laGb/UmOyfNiuTHaFkriExNuCYT3bIm0PUyrO5
         CANDNEAzWsUaXAlceZn31C/hnzvGUF5cdrImyQXU8bQN9LsdHQGNI8arPKnfuD6sLmZw
         cJyRg8eEoPICrdsD1d9/R0mX7PhaFDXqupWQ5lBHoorOvj0GOrdGebydMvmqJdrKOA50
         M+mealyN4BAZYqkv6vKMrsHZJk7Fn8U6bxF//Ai+goL8YVSCO+KhyJGw/dt3KwGZPc8w
         5iKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789928093; x=1790532893;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bIGxyqhgDCJxQrUSlOVUsvnBCPzikecf8ZgHQx68EUQ=;
        b=gNUBTaFASs2yEykimXrdPqFWv3xwOkAnqX9CIlBaNxqz1SxBPNNSLkGbTw2zosuiqh
         LNi78tvwfyWbLnSTpVhvf69lTXR04Xs9W9u3O6JOzt0/kHKbnFRRRvKoqVdt7o/gT8vI
         eYRsPfpV6m9GSu1URUS+XIVQmYJci5OT7YXMu7Jh9orbrSXDEapE0xHVbgJZ38Kym5E1
         tw+jwwVUGgP7nhgSHHV9rNmzdemEJp7Ly1qXvDrMOwl78Ltej54CBqFHVY5C0qrmWyZb
         onYzh7jrU8kjs4YFXnmTp2iKXbDbY8rRa+9ZP5Fm0X6MMwvlQD0sFygm0KKHhD558nrE
         jseQ==
X-Forwarded-Encrypted: i=1; AKwUvBxhnlJKdW/7S6UExKfIxGawP4i2Cyo/Hq9r4W7Vy3IluiK+hZ2rY3bzS6YJLYFsAjZyuE4M8wsh@vger.kernel.org
X-Gm-Message-State: AFuF++lWWBxYxZEscV9ZWsf6x3nl15VCk3jvgOGUWqONv/pvmOquA81Z
	STuXmOp5ggC/W8RU5LQko8ikv9Le4S1szY0XIWejFF1tYkrfYff3/fYt
X-Gm-Gg: AYBFou0Jwo/pEoey33bnwk6f8pKDfilbTkgnpPy7R6B5DE+9IdjhkMDSQUSyFU1rnay
	Dq5+tUSDP7jRMMjwbhLRpcJM7UeRgzI5YQxbf12v/btLz0bWaOte1mD/T/1YD8KPr+9vnB90cHp
	YNOAJQK1aa7NksLfAaTsk/jf5I5PlHO/DCbplpUR9O/PBMRfAgSuEpv3Ugs+gcz9G8MRyhVOrrd
	YL0S8c/0jVsa+430YDjCv3ssKQ8ghFeEVytzbNf8AOKuMbUbNIZtaD+LkJyy2LNJvLXrcGjISzA
	SliqVK5HqQJg3bdOrRZ8m9xpjIDp2KFnC4dAGorLcBa4r5jSrxNmluAULFa+rTUblFvzRQ4OyfK
	4E8bGae+Aew6rnb1v8pSCHlgSS8yQOxd/71s0LMXvuyE/W/6Uwb7/KrvWW3xaMl16fkkc7hmcSo
	ylCsEwSnbaG5/1/JcWgUIc8y6bSHXVRvcFAM9QWwbD01ms6SUgnVwfWqRi9SwJfbhc2+MvNsOUH
	Vz0kwMHoWs/GpcmItvPRj+ceLf1X34f4Fyd7t0mJVRRpBUKNFZkx1eg00aZ8DUSgXnfNwleeWDN
	Gnfl5TTkcg==
X-Received: by 2002:a17:903:1a26:b0:2dd:89b1:7fdb with SMTP id d9443c01a7336-2ddb1aeea09mr127586005ad.9.1789928092709;
        Sun, 20 Sep 2026 11:14:52 -0700 (PDT)
Received: from phui-2.c.googlers.com.com (78.123.83.34.bc.googleusercontent.com. [34.83.123.78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ddc179df35sm22087225ad.40.2026.09.20.11.14.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 11:14:52 -0700 (PDT)
From: Hui Peng <benquike@gmail.com>
To: Guopeng Zhang <guopeng.zhang@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>
Cc: Michal Koutny <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Hui Peng <benquike@gmail.com>
Subject: [PATCH v3 3/3] cgroup/cpuset: check sibling effective_xcpus in cpus_excl_conflict()
Date: Sun, 20 Sep 2026 18:14:49 +0000
Message-ID: <20260920181449.3122336-3-benquike@gmail.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920181449.3122336-1-benquike@gmail.com>
References: <aa90bb73-c2af-4d13-8f2a-0435aa528058@linux.dev>
 <20260920181449.3122336-1-benquike@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In cpus_excl_conflict(), when a valid local partition A1 uses implicit
exclusive CPUs (cpuset.cpus set without cpuset.cpus.exclusive, so
sibling->exclusive_cpus is empty while sibling->effective_xcpus is
populated), a sibling cgroup B1 can still set cpuset.cpus.exclusive on
the same CPUs because cpus_excl_conflict() only checks
sibling->exclusive_cpus.

Fall back to sibling->effective_xcpus in cpus_excl_conflict() when
sibling->exclusive_cpus is empty, and add a regression test case to
tools/testing/selftests/cgroup/test_cpuset_prs.sh.

Tested in QEMU on Linux 7.3.0-rc3 using
tools/testing/selftests/cgroup/test_cpuset_prs.sh.

Fixes: 2a3602030d80 ("cgroup/cpuset: Don't invalidate sibling partitions on cpuset.cpus conflict")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Hui Peng <benquike@gmail.com>
---
Changes in v3:
- Split out from the validate_partition() fix into patch 3/3 and add the
  Fixes tag for commit 2a3602030d80, as pointed out by Guopeng Zhang.

 kernel/cgroup/cpuset.c                        | 5 ++++-
 tools/testing/selftests/cgroup/test_cpuset_prs.sh | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 7c5b4a8f1f3a..f46a51f07938 100644
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
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index f4d1822d4e21..f62155cf6162 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -445,6 +445,7 @@ TEST_MATRIX=(
 
 	# Changes to cpuset.cpus.exclusive that violate exclusivity rule is rejected
 	"   C0-3     .      .    C4-5   X0-3     .      .     X3-5   1 A1:0-3|B1:4-5"
+	"  C0-3:P1   .      .    C4-5     .      .      .     X3-5   1 A1:0-3|B1:4-5 A1:P1|B1:P0"
 
 	# cpuset.cpus.exclusive cannot be set to a superset of sibling's cpuset.cpus
 	"   C0-3     .      .    C4-5   X3-5     .      .      .     1 A1:0-3|B1:4-5"
-- 
2.49.0
