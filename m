Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410983DDB09
	for <cgroups@vger.kernel.org>; Fri, 21 Aug 2026 18:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787338723; cv=none; b=K32BfheE2ELIrkQrcftfe+2+3WTgqkrMcZCn8hsbp+btnmz48vzVKRuNLCVntGWlZC2owr2hucEM0aXXhIew77IMtyi72zasZzpOTG3Ff370nPDi5pVXu1ltovGI8iPEUX9Z4xLwVMNvQGXu+ZMF7oKFOzydViJKFYTJotfq558=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787338723; c=relaxed/simple;
	bh=bE3pWVKKdTpuMaQ8HVFIYEoYxc3fMC8VaZaqYRmtIio=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ikfc4BmyrsSBv5Q5SN+viSzmRJGc6FnLYwps1Jbm5NW26PNVpQEZ1f65MDi1JNym63aM3NiQruEuQUWhse7B/FDP4qvInGFBeRwmKqwW0Zysk1fXQ4x3bnrLihkQIrjyWheR4u5kzO5yU29rdpcu/3s9JnPjG1CbexpVU9hulCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=chrAZVi/; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ADzPuKSH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="chrAZVi/";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ADzPuKSH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787338721;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W7KnOp/dzi6YYMtNTCErSrAxbzUuBVlszjrt1QEKyR0=;
	b=chrAZVi/mG4uby1Kr0EayXEJv8+xLi2YNsCf8fupW86BUFz69zATT95YQ9WLhz/6gKkgkc
	kkdZJZiIGltkwNVYaSOr8wZG2te5fL1gfEmcMQctF05IVMYOQ+zyRgQo25+4lFbyKRLNfv
	FAXscm4Ez3BG20GuT9WEykKeQT22zVU=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-92-yzzbNQXqPlO1czVGC_OUjQ-1; Fri, 21 Aug 2026 14:58:05 -0400
X-MC-Unique: yzzbNQXqPlO1czVGC_OUjQ-1
X-Mimecast-MFC-AGG-ID: yzzbNQXqPlO1czVGC_OUjQ_1787338685
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-92e8004d60eso230523385a.1
        for <cgroups@vger.kernel.org>; Fri, 21 Aug 2026 11:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787338685; x=1787943485; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W7KnOp/dzi6YYMtNTCErSrAxbzUuBVlszjrt1QEKyR0=;
        b=ADzPuKSHQH6pEXjFXHRaIBShK89x8kcJkNsdxqErDNLjymnJlwhaxZxXRuG/v0zsFZ
         m7Kr9QM2WmVdubt2ebx1S1gOfXAdyh6Rc+8R60MkKEh+TzBaTMvaXjBVoh9yp2rUAWaT
         3KYJMIBW+4+MCmEG70mWJxlXYo6pz5cuMcOnzbYtJaqBDD+sGhHiFZl03Tz2F1uyOG6v
         fdbgMyVFEUoSe+5DemlDeZh3l08Z3BlIX4hwAZ17F9FHoFrBr5pSL18YDYs5SvHD8aXN
         EyyiXfYsos2PzdbIVcPee/X4adSgDlKNQvUDxdwpSr1zGR5M5Abtph96+FUI4vp8h4f2
         9eFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787338685; x=1787943485;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W7KnOp/dzi6YYMtNTCErSrAxbzUuBVlszjrt1QEKyR0=;
        b=JnEJ6kIElmUmSb9jrheDPsd//eiA0wSUVfnFHk8gtS86lwmLJi7Jnr29ldq65Afjbm
         xY967GJCx3b0sKC0w49YPqczfflaTzcL7MhO6su92e/Iup3Z32NVwnmu/OxU6WYbi2gF
         zNk4CHUEZ4e+QVR71hJfMgSTryhlpQB443RqoRBGMHwnsD2Hesod8IN1w2ogvJyJwzHP
         0OQDGk1yG1t06XKQK3Gs7R+EKSD1JwKxK+Ll5yc2Db7LiiSFhSACqSiGYfp5vTLn51f1
         itBnZC+MX0nagW7GuSo7XyKQ52hQ9Y6BeVsLHI1UKMNAgOFnRkck5QU0ZGaACXEE8zQZ
         1OJA==
X-Forwarded-Encrypted: i=1; AHgh+RrgSCyGzaCT8oCBZX4C/WN7QoMDf2beEUDu2bMwUIvevL1e0BCLaEMn1rI9VLYhwFtHfdFEKu21@vger.kernel.org
X-Gm-Message-State: AFuF++nRk0Q0BHIKK4B0nPdfhZoihMDVgtlR9TD/iK1o+DxrXiA8+tGv
	5xL787CvW+j8ycHw9oQzInmBJZUouaSta34UFQmAGY5gvX3Iw8aqypYrA6pEN9HF+nVw4WcYNNW
	c8nZpyaLvj1uMU5dEKlaBgxG7uSv5G+bLkqSj/wHpGktKm3cN5z7HWEoXdCM=
X-Gm-Gg: AR+sD10/r1AzjxTTQ8YIapKGcNWzyvZolJuZcQambxAiMF4ei5C9mULkw8UXdwHT1Fz
	PNVwo8QIjOmRYWSsCwDKhTMQd3X5Te8ucRTqo5g2Nm5mpULxXkTgSEukJeW/I7VfVnS5XmJ7eRZ
	FDw7s1GGESGQI/zjVS+OTjL0N6JW3aRrf0mx+CMLEVO6F2se4InxfYKiYYiQyYgXeGIMHS3kiFC
	JLThHorEi1M1YStWRjMfNXDa9gIcWqCLufEkCjRcVM2osxmyazSAQGETWdYZ1iV/w+/roPRVHVN
	Dl3TOxB3Csgq7E+0iqbyOvOT/o6J53aF/GrFNbt+OO9BQluj28QAIO382uKOPl+iIJXFtOutMZF
	ZrDUyqGC0TtcXAKV0zT7cVgdSa4xRjLwX7a1Z+jEJf0uw
X-Received: by 2002:a05:620a:601b:b0:930:a26a:fb2a with SMTP id af79cd13be357-937394324demr865129685a.2.1787338684946;
        Fri, 21 Aug 2026 11:58:04 -0700 (PDT)
X-Received: by 2002:a05:620a:601b:b0:930:a26a:fb2a with SMTP id af79cd13be357-937394324demr865124585a.2.1787338684435;
        Fri, 21 Aug 2026 11:58:04 -0700 (PDT)
Received: from localhost (pool-100-17-17-231.bstnma.fios.verizon.net. [100.17.17.231])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9372fdf59f3sm385976385a.10.2026.08.21.11.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 11:58:03 -0700 (PDT)
From: Eric Chanudet <echanude@redhat.com>
Date: Fri, 21 Aug 2026 14:56:58 -0400
Subject: [PATCH 06/11] memcg: register per-area usage counters in cgroupfs
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-cma-memcg-regions-v1-6-d21b165b8440@redhat.com>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
In-Reply-To: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Maxime Ripard <mripard@redhat.com>, 
 Albert Esteve <aesteve@redhat.com>, Eric Chanudet <echanude@redhat.com>
X-Mailer: b4 0.14.3

Expose memory.cma.<area>.{current,max} files under each non-root cgroup
when cgroupfs memory_cma_accounting option is enabled.

memory.cma.<area>.current reports the cgroup's CMA usage for that area.
memory.cma.<area>.max is a read-write limit (default: max).

Each CMA area gets a cftype template with its name set from the CMA
area's name.

Signed-off-by: Eric Chanudet <echanude@redhat.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 15 ++++++
 mm/memcontrol.c                         | 89 +++++++++++++++++++++++++++++++++
 2 files changed, 104 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 3dfc13f31a0c..39871a7a08a8 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1928,6 +1928,21 @@ The following nested keys are defined.
 	This setting has no effect if zswap is disabled, and swapping
 	is allowed unless memory.swap.max is set to 0.
 
+  memory.cma.<area>.current
+        A read-only single value file which exists on non-root cgroups. <area>
+        is the CMA area name (e.g. "reserved" for the default DMA CMA area).
+
+        The total amount of CMA memory currently charged to the cgroup for the
+        given CMA area. Only accounted when memory_cma_accounting is enabled.
+
+  memory.cma.<area>.max
+        A read-write single value file which exists on non-root cgroups. The
+        default is "max".
+
+        CMA usage hard limit for the given area. If a cgroup's CMA usage for
+        this area exceeds this limit, the allocation will fail. Only enforced
+        when memory_cma_accounting is enabled.
+
   memory.pressure
 	A read-only nested-keyed file.
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8eca00d30fc5..f28d610a59ce 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6182,3 +6182,92 @@ void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
 		K(atomic_long_read(&memcg->memory.children_min_usage)),
 		K(atomic_long_read(&memcg->memory.children_low_usage)));
 }
+
+#ifdef CONFIG_CMA
+static int memory_cma_current_show(struct seq_file *m, void *v)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+	int idx = seq_cft(m)->private;
+	unsigned long cur = page_counter_read(&memcg->cma_counters[idx]);
+
+	seq_printf(m, "%lu\n", cur * PAGE_SIZE);
+
+	return 0;
+}
+
+static int memory_cma_max_show(struct seq_file *m, void *v)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+	int idx = seq_cft(m)->private;
+	unsigned long max = READ_ONCE(memcg->cma_counters[idx].max);
+
+	return seq_puts_memcg_tunable(m, max);
+}
+
+static ssize_t memory_cma_max_write(struct kernfs_open_file *of, char *buf,
+				    size_t nbytes, loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	int idx = of_cft(of)->private;
+	unsigned long max;
+	int rc;
+
+	buf = strstrip(buf);
+	rc = page_counter_memparse(buf, "max", &max);
+	if (rc)
+		return rc;
+
+	xchg(&memcg->cma_counters[idx].max, max);
+
+	return nbytes;
+}
+
+static struct cftype cma_dfl_tmpl[] = {
+	{
+		.name = "current",
+		.seq_show = memory_cma_current_show,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+	{
+		.name = "max",
+		.seq_show = memory_cma_max_show,
+		.write = memory_cma_max_write,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+	{ }
+};
+#define CMA_DFL_TMPL_SIZE	(ARRAY_SIZE(cma_dfl_tmpl) - 1)
+
+static struct cftype *cma_dfl_files;
+
+static int __init mem_cgroup_cma_init(void)
+{
+	struct cftype *cft;
+	unsigned int i, j;
+	int count;
+
+	if (mem_cgroup_disabled() || !cma_area_count)
+		return 0;
+
+	count = cma_area_count * CMA_DFL_TMPL_SIZE;
+	cma_dfl_files = kcalloc(count + 1, sizeof(*cma_dfl_tmpl), GFP_KERNEL);
+	if (!cma_dfl_files)
+		return -ENOMEM;
+
+	for (i = 0; i < cma_area_count; ++i)
+		for (j = 0; j < CMA_DFL_TMPL_SIZE; ++j) {
+			cft = &cma_dfl_files[i * CMA_DFL_TMPL_SIZE + j];
+			*cft = cma_dfl_tmpl[j];
+			snprintf(cft->name, MAX_CFTYPE_NAME, "cma.%s.%s",
+				 cma_get_name(&cma_areas[i]),
+				 cma_dfl_tmpl[j].name);
+			cft->private = i; /* cma area index for counters in callbacks. */
+			lockdep_register_key(&cft->lockdep_key);
+		}
+
+	WARN_ON(cgroup_add_dfl_cftypes(&memory_cgrp_subsys, cma_dfl_files));
+
+	return 0;
+}
+subsys_initcall(mem_cgroup_cma_init);
+#endif /* CONFIG_CMA */

-- 
2.53.0

