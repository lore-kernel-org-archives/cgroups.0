Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794792248;
	b=QVtqcJtgNByX+jjxPHRW4ssya+IqTAlujd7LVlXendym8Ju9LeDiTQ506LjQ8saAtKNa
	 yjpOWpcIQ93OreboWE06gepnRa7AgErOktfOgRUPYuy+2sW9KVUprN1H40BOL3sVSHUqi
	 yxedCSJ6SYkbLIiPGNk+OHDlAHAdHhodW2puAZlrQETFgQh27gj5dq7sO/UuYWEu1XbRC
	 Zs1vvDazl9b1t9H0vLKblevlnSp1gNvCnyBtRbZ4Ji9v2j6Jv2P4/+67JgAXUthi82463
	 jBW84jABcXAy6/XJhFm8FmflK9JqaqcFhshHxNs1LHwCstlrcu8/uNz2hToz+BS/83w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794792248;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=9PtDkN8OBZIBR2ON97agOAnd1lKKVP99DWVdfNySUX4=;
	b=X3phMVlZvIA6/xoVKdde35v6ihyUYblGivoUWT5KNh+lWWcJQQSO05I4o65id329XPl7
	 pTinbDWbkos4ry2ffm14G2d2ri8CgAdwwcVdl4CGUg/8XPqqcoK3Bbq9aa+4vPqXX3yjL
	 EKhrsUmFLDe3NyoeP9uAqD3wYwa865e6EPQkepmhSLF+VizUyniA6EENbsgPBuSUZ28tK
	 LTIkb+h1H0f4J4spnhZYjDwVA4NW5PC6ra4+HdPg2jDkUsQPGGhl2wzMUP9Xj2NBSK/gb
	 TDgCg6aveHWUaYxX+cG9RtZTHYGof+3BPD/IPZSta5eTooMI2zO6PHIGfh1uiUGkHOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=QRAh2sPL;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F254606A33B
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 01:24:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F254606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=QRAh2sPL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794792246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9PtDkN8OBZIBR2ON97agOAnd1lKKVP99DWVdfNySUX4=;
	b=QRAh2sPL5aA5qHsNnk2nBqf0/JqfOq+ivicsNRWhgRdJlwJs8zXg6f/iwja/NpvMElVFoL
	bCOAw5wNmKS44JOaaNRhmTzdM3twWh443M2THw03k9SS0Qe9T3F3vmq9q+nV4a8Gi95thH
	ZZ+D+zqlFhzF/nKZyoqQzHrD2DIxA50=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-533-coFtIg9XMF2VJJTHw8GsuA-1; Sun,
 15 Nov 2026 20:24:03 -0500
X-MC-Unique: coFtIg9XMF2VJJTHw8GsuA-1
X-Mimecast-MFC-AGG-ID: coFtIg9XMF2VJJTHw8GsuA_1794792242
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0896B1800546;
	Mon, 16 Nov 2026 01:24:02 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 25C0E589;
	Mon, 16 Nov 2026 01:24:00 +0000 (UTC)
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
Subject: [PATCH-next v4 6/6] cgroup/cpuset: Fix lockdep_is_cpuset_held()
Date: Sun, 15 Nov 2026 20:23:09 -0500
Message-ID: <20261116012330.2271010-7-longman@redhat.com>
In-Reply-To: <20261116012330.2271010-1-longman@redhat.com>
References: <20261116012330.2271010-1-longman@redhat.com>
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

Commit a84097e625f2 ("cgroup/cpuset: Call housekeeping_update()
without holding cpus_read_lock") changes lockdep_is_cpuset_held()
to return true if either cpuset_mutex or cpuset_top_mutex is held.
lockdep_is_cpuset_held() is used by housekeeping_dereference_check()
as one of the conditions that rcu_read_lock() is not needed to
access HK_TYPE_DOMAIN cpumask that can be changed at run time.
In reality, it should return true only if cpuset_top_mutex is held as
housekeeping_update() is called with only cpuset_top_mutex held.

If only cpuset_mutex is held, it is possible that there can be a parallel
housekeeping_update() call leading to a potential use-after-free situation
when HK_TYPE_DOMAIN housekeeping cpumask is being accessed. It also
means that rcu_read_lock will be required if only cpuset_mutex is being
held like when calling from hotplug, scheduler or cgroup.

Fixes: a84097e625f2 ("cgroup/cpuset: Call housekeeping_update() without holding cpus_read_lock")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset-v1.c | 16 ++++++++++------
 kernel/cgroup/cpuset.c    |  9 +++++++--
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup/cpuset-v1.c b/kernel/cgroup/cpuset-v1.c
index 7c7f2887dfaf..6bf6da639fec 100644
--- a/kernel/cgroup/cpuset-v1.c
+++ b/kernel/cgroup/cpuset-v1.c
@@ -686,6 +686,7 @@ int cpuset1_generate_sched_domains(cpumask_var_t **domains,
 	int csn;		/* how many cpuset ptrs in csa so far */
 	int i, j;		/* indices for partition finding loops */
 	cpumask_var_t *doms;	/* resulting partition; i.e. sched domains */
+	cpumask_var_t hk_cpus;	/* HK_TYPE_DOMAIN housekeeping CPUs */
 	struct sched_domain_attr *dattr;  /* attributes for custom domains */
 	int ndoms = 0;		/* number of sched domains in result */
 	int nslot;		/* next empty doms[] struct cpumask slot */
@@ -698,6 +699,11 @@ int cpuset1_generate_sched_domains(cpumask_var_t **domains,
 	dattr = NULL;
 	csa = NULL;
 
+	alloc_cpumask_var(&hk_cpus, GFP_KERNEL);
+	scoped_guard(rcu) {
+		cpumask_copy(hk_cpus, housekeeping_cpumask(HK_TYPE_DOMAIN));
+	}
+
 	/* Special case for the 99% of systems with one, full, sched domain */
 	if (is_sched_load_balance(&top_cpuset)) {
 		ndoms = 1;
@@ -710,9 +716,7 @@ int cpuset1_generate_sched_domains(cpumask_var_t **domains,
 			*dattr = SD_ATTR_INIT;
 			update_domain_attr_tree(dattr, &top_cpuset);
 		}
-		cpumask_and(doms[0], top_cpuset.effective_cpus,
-			    housekeeping_cpumask(HK_TYPE_DOMAIN));
-
+		cpumask_and(doms[0], top_cpuset.effective_cpus, hk_cpus);
 		goto done;
 	}
 
@@ -736,8 +740,7 @@ int cpuset1_generate_sched_domains(cpumask_var_t **domains,
 		 */
 		if (!cpumask_empty(cp->cpus_allowed) &&
 		    !(is_sched_load_balance(cp) &&
-		      cpumask_intersects(cp->cpus_allowed,
-					 housekeeping_cpumask(HK_TYPE_DOMAIN))))
+		      cpumask_intersects(cp->cpus_allowed, hk_cpus)))
 			continue;
 
 		if (is_sched_load_balance(cp) &&
@@ -794,7 +797,7 @@ int cpuset1_generate_sched_domains(cpumask_var_t **domains,
 						*(dattr + nslot) = SD_ATTR_INIT;
 				}
 				cpumask_or(dp, dp, csa[j]->effective_cpus);
-				cpumask_and(dp, dp, housekeeping_cpumask(HK_TYPE_DOMAIN));
+				cpumask_and(dp, dp, hk_cpus);
 				if (dattr)
 					update_domain_attr_tree(dattr + nslot, csa[j]);
 			}
@@ -806,6 +809,7 @@ int cpuset1_generate_sched_domains(cpumask_var_t **domains,
 
 done:
 	kfree(csa);
+	free_cpumask_var(hk_cpus);
 
 	/*
 	 * Fallback to the default domain if kmalloc() failed.
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 64cbcbdbf6da..d18439e13bce 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -343,10 +343,13 @@ void cpuset_full_unlock(void)
 }
 
 #ifdef CONFIG_LOCKDEP
+/*
+ * Holding cpuset_top_mutex will guarantee that a parallel
+ * housekeeping_update() call modifying housekeeping cpumasks is not possible.
+ */
 bool lockdep_is_cpuset_held(void)
 {
-	return lockdep_is_held(&cpuset_mutex) ||
-	       lockdep_is_held(&cpuset_top_mutex);
+	return lockdep_is_held(&cpuset_top_mutex);
 }
 #endif
 
@@ -1416,8 +1419,10 @@ static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
 		}
 	}
 
+	rcu_read_lock();
 	cpumask_and(full_hk_cpus, housekeeping_cpumask(HK_TYPE_KERNEL_NOISE),
 		    housekeeping_cpumask(HK_TYPE_DOMAIN));
+	rcu_read_unlock();
 	cpumask_andnot(full_hk_cpus, full_hk_cpus, isolated_cpus);
 	cpumask_and(full_hk_cpus, full_hk_cpus, cpu_active_mask);
 	res = !cpumask_weight_andnot(full_hk_cpus, new_cpus);
-- 
2.56.0

