Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA0A3090C4
	for <cgroups@vger.kernel.org>; Sat, 21 Feb 2026 18:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771700094; cv=none; b=tTtjzO6PR6qdru54iYVglOMJVogl/EJF7LCJ2epPBuvQHCeCUOKLlAVdsoKYwKKZ3/gpzEK28ARQ5WHDMZeOs9vMBBqVy8y1mubd1aL8oOxNduce4+CP31T607pguXjhY+w/etMjOe/ctLbAEV2dBNOdz4zflsWFM086M73ppAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771700094; c=relaxed/simple;
	bh=SccU/7lNAwptDz6quN2kuH9L4uDtYo/Jxa+nW4laf1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtHpW9zX0ZN5hOpohfGuR/HzqpiSYArYLSxqPJcM9kzYR/CuXqideYYbRt8/oMfYFL3eRwKhvvQEkW0tMsXl+EWt3tr34vorCUMCitL5PaKz16jbK3N/qQk0KD9afYw/5xXH8dQhOcVz90axj9S+6LYYptt2oRbZN5iX7V9wqaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SNT2+nat; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SNT2+nat"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771700092;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/mUVi/Bf+nz7Vl/nMR86R4IIl2B+eNG5a+UoMwKwkVE=;
	b=SNT2+natmMNw4/rERUd7zb5gD9m4zlpX41w2lMcQ6e0D8AFc1DZCDB8sWjJZgId3UZ0K4x
	uQpMBMuTbOV4WSx65hLdbj8fAE13YQYokkmmeGlDAGzJBitRJdGTNqAFhvFbKUMlx1xoV0
	LJEEeKmcFYs9X0u8976/Qo3Ff42E+Kw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-197-ND3nx1n6OWu4WFyGsnoGHw-1; Sat,
 21 Feb 2026 13:54:48 -0500
X-MC-Unique: ND3nx1n6OWu4WFyGsnoGHw-1
X-Mimecast-MFC-AGG-ID: ND3nx1n6OWu4WFyGsnoGHw_1771700086
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6CFE518003F6;
	Sat, 21 Feb 2026 18:54:45 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.2.16.15])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7B0201955D85;
	Sat, 21 Feb 2026 18:54:40 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Chen Ridong <chenridong@huaweicloud.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Waiman Long <longman@redhat.com>
Subject: [PATCH v6 1/8] cgroup/cpuset: Fix incorrect change to effective_xcpus in partition_xcpus_del()
Date: Sat, 21 Feb 2026 13:54:11 -0500
Message-ID: <20260221185418.29319-2-longman@redhat.com>
In-Reply-To: <20260221185418.29319-1-longman@redhat.com>
References: <20260221185418.29319-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

The effective_xcpus of a cpuset can contain offline CPUs. In
partition_xcpus_del(), the xcpus parameter is incorrectly used as
a temporary cpumask to mask out offline CPUs. As xcpus can be the
effective_xcpus of a cpuset, this can result in unexpected changes
in that cpumask. Fix this problem by not making any changes to the
xcpus parameter.

Fixes: 11e5f407b64a ("cgroup/cpuset: Keep track of CPUs in isolated partitions")
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 7607dfe516e6..4d10e320b144 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1220,8 +1220,8 @@ static void partition_xcpus_del(int old_prs, struct cpuset *parent,
 		isolated_cpus_update(old_prs, parent->partition_root_state,
 				     xcpus);
 
-	cpumask_and(xcpus, xcpus, cpu_active_mask);
 	cpumask_or(parent->effective_cpus, parent->effective_cpus, xcpus);
+	cpumask_and(parent->effective_cpus, parent->effective_cpus, cpu_active_mask);
 }
 
 /*
-- 
2.53.0

