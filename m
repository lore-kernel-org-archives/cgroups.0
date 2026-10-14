Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEE34ADD95
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 22:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792016707; cv=none; b=dxlb+ls58N7GAfVkjdO5v/hTuLwRnX6u+0B6EXVw2JKoqhofdJlCyZ2Zr61oXX3gErGJ5N1P/PDwtSijk12MkCZI+elOm5Vb4XdwJhFOjHsccRcDiZzpfZHEBZNxGFKMbZMGXpmoYC7OzslRk8ThbR8TWmvfSKWwer4SkCEtk/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792016707; c=relaxed/simple;
	bh=hfvB5WHRTQozrNyoakBODE3S1Lb68W/sTFfmK2qbwAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DD0pyxBpyklbx0tN/ZeCvJb0w9BLXWPRiYGmZCzxxj4taXvrOn2fdcTMwH1FFN1XU3eMIkGHPr/0fcVnYvM7QRBtfEYrvDm4t8r135crHbeWL6NIknKBzHb/vJxyjlZ3cU0OLH1puBiOa+kVVIaxDyOvRhtweJexY2jY2qt7ROk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=OVuqGwNi; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="OVuqGwNi"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-5352a876d5aso59306671cf.1
        for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 15:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792016705; x=1792621505; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pX7eJVw8NKbWVjClJVlyeDcXYqLdmF7XB6xKTvch9pw=;
        b=OVuqGwNi4olBPQQ7eVfJm/3nIHV83c2rvUSx4MtDBlFar9mCtEx+XaDLxE/J90jjLC
         gBzi+GoN8QStnsG0H0V51vL77no2K/Ogw5SfkVYbPQAS0ghOL7vWyLpfPY03HvofowQr
         th1ngCnOazhTMNgMeT6v1iDa7+OFZDZCAaNbKVcfJ5bZrdGYzJyK2V6sDJNz1Kmyc6Hf
         /xrHw2Qkr5cdipNimW9BEG8xIBfgL78ZgUcQLmtlEgFSf1CnWaHu8OSBjN/3HhIMni7u
         zmUyUvSSwBl+g2NgUyiuq3arMKREaYE0py4C2ri/hlJ8I0llFYqna6ifW2b5f8qeA5Rf
         qijQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792016705; x=1792621505;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pX7eJVw8NKbWVjClJVlyeDcXYqLdmF7XB6xKTvch9pw=;
        b=Adc2UAUL7MldedPjoFEruJkJ+rJ1LbPRHttWlkM50NL2xu1obFU2MjWh4kULaik3Zn
         CZH2kvzkkHUFavlTBHByQm4wRIuy6WjyNS1KmFBozZo5PCm4SIkX+meChb5la1M3Ddid
         //d0duLDcIeBODzFzIl9dCvqGZc1CHVJi+5XfzS9oad9Sb1jKR3+0UkGcKAqPUUojANk
         pXyJZCdkicJSVroI6vr5nqJYwyj9tA8Fmf6TMSe5CFtPNweWqtTnSGFRTzBFkx9BXi2v
         lRAvumS6AWOlQuE8QtB72z74NMl00FxZW2MxiB2m7rS9fafTLD8Lm9j+RtY0SCvCMFWt
         cBYg==
X-Forwarded-Encrypted: i=1; AKwUvBzY9G76HNDBMOmxWSxxihxyv9YVp8rhvcaYPWw/Rl2mZ2Oo7hlPOVaBTOxEQ2vpnVghnZy2vPBh@vger.kernel.org
X-Gm-Message-State: AFq9FYLaSQjJQsfUkWxMnupzx5+LaO60Ky4PZ8tPmrxQ+uXXuJvMpmaP
	P/MW3mSAyDVcE5DEnxDLlF/mMAGKFPTugKlWJ8NYKWuDj11OahqYMlQXvRc8fm8VP9s=
X-Gm-Gg: AYBFou2cGlbSiSoH0vnv7Tl6QfGFp7kusheTjeIFUhmEnVNFyySAex6yf4ZLGCWTuG7
	DIxhjR5oGa/yVzDaGLjDF5h4/mgM0Q7fHbwiIQdN6ixBI+mVA+5RyAdAbeLNLCQteLPSB91ynKC
	Dw+l+ylFtkuYNP1dgnBr5eoKrSRr/nEmWl5GcLQguosNaOSDy6UueUADvZL80iIttZdBQ5nXzFK
	XT1HRTPOLZG9xexe0o7ecZzPR2cYfTRkVFYW3P7IIFH8BM9Zf4PdKx+JT5B/W8p1ahuYNkibGz6
	8HMzA6VlbnFDRlYfgLcsrAIj4OYiVR0xDuiRGS0bVZlj3MPApzVSXpJTlk/7IEBOAhEceRCSJK4
	GcP6drRJxiRA2uLEgv67xx0Oeyx5IDU2hKZaf57+0jB+WdZlw52h18xYovxnj0kzHWOUZHxEllq
	/12bRyqOpMFSNYsAg9C2j4FRuT6fB9UxbMCtYP/LC+4PIOPC27SOZqj+AtYWn9d8oKH7WiBx/6t
	mqF5hduWh1JyBPs1eipiKEnYRCKn6G3Loslop9YS7xL1H417Gww0FX/+w1S
X-Received: by 2002:a05:622a:13ca:b0:535:25db:17ae with SMTP id d75a77b69052e-5359f48cabdmr289086201cf.11.1792016705227;
        Wed, 14 Oct 2026 15:25:05 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-536128418b2sm8652601cf.30.2026.10.14.15.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 15:25:04 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org,
	cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	ziy@nvidia.com,
	david@kernel.org,
	mgorman@techsingularity.net
Subject: [PATCH 2/2] cgroup/cpuset: use mems_allowed_seq when checking a policy nodemask
Date: Wed, 14 Oct 2026 18:24:56 -0400
Message-ID: <20261014222456.2318284-3-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014222456.2318284-1-gourry@gourry.net>
References: <20261014222456.2318284-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A cpuset update changes the task's mems_allowed and rebinds its
mempolicy in separate steps under mems_allowed_seq, but the check
reads both without it.  This can cause a spurious numa placement
miss under some cpuset/mempolicy combinations.

A reader that loads one mask before the update and the other after
it can see a spurious empty intersection and drop the nodemask.

For example, a task with cpuset.mems={0} and MPOL_BIND={0}.  If the 
cpuset moves to mems={1,2}, the policy is rebound to {1}.

The allocator can race and compare the old mems_allowed {0} against
the new policy {1} - which will result in a dropped nodemask and a
misplaced allocation on node 2.

Simply retry the intersection until mems_allowed_seq is stable.

This covers the task policy, which is rebound under mems_allowed_seq.
VMA policies are rebound afterwards by mpol_rebind_mm(), outside
mems_allowed_seq, and are not covered by this change.

Fixes: cc9a6c877661 ("cpuset: mm: reduce large amounts of memory barrier related damage v3")
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 kernel/cgroup/cpuset.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 3f52717c19654..8ee239d5c6b48 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -4354,10 +4354,21 @@ nodemask_t cpuset_mems_allowed(struct task_struct *tsk)
  * @nodemask: the nodemask to be checked
  *
  * Are any of the nodes in the nodemask allowed in current->mems_allowed?
+ *
+ * A cpuset update rebinds the task's mempolicy and changes mems_allowed in
+ * separate steps, so retry if an update raced with the check.
  */
 int cpuset_nodemask_valid_mems_allowed(const nodemask_t *nodemask)
 {
-	return nodes_intersects(*nodemask, current->mems_allowed);
+	unsigned int seq;
+	int ret;
+
+	do {
+		seq = read_mems_allowed_begin();
+		ret = nodes_intersects(*nodemask, current->mems_allowed);
+	} while (read_mems_allowed_retry(seq));
+
+	return ret;
 }
 
 /*
-- 
2.53.0-Meta

