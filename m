Received: from mail-pj2-f41.google.com (mail-pj2-f41.google.com [74.125.227.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF56390229
	for <cgroups@vger.kernel.org>; Sat, 26 Sep 2026 06:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790404418; cv=none; b=Zjn2WU7m2hDLUnnKuvTpIiLZfpDq1dk62xHwbUraWnPSoqxIxe1LXQU2Qsv7IbzUzh2xBWrHxT6DWt05WiyKoR8bK6k7C3p3lmn6H3UwSWAa/GHBX3WnL/ZsRE+1yph7Frb31jenGqXruLr8i5muK5ZqXZOLJmYthrFiYdx+Foc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790404418; c=relaxed/simple;
	bh=YxGLNcL2oyZ/eOIGOXq1FuCmtSNOFrXPFNrPJzVU6Ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=klRILqJYEMkutyiaQ0AAqsHFi6id3GOqQCcHV819moc5aUfc/aeGyWZiAZDggsFMFpKm63nMdcrBPWbddaIMEqm+w6QMXHJLF8/eKz07eC0mUEi93vAyowqJHNIVia03ow6UHsYejTJTBtOCXCS9fN0G2PcaXCFE96+Bg/MLC+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vswkmy1o; arc=none smtp.client-ip=74.125.227.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vswkmy1o"
Received: by mail-pj2-f41.google.com with SMTP id d9443c01a7336-2df8bb777e4so5722505ad.3
        for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 23:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790404416; x=1791009216; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9Qh3I8a6NY8irFKYYs5frRNlHo7TF6xowJJxcHvbgDM=;
        b=Vswkmy1oTXqVAmwMWGka3qNgyrKnbi/7HFheY3GcpUk8WVWocfCdoRMrATZJtfIdXo
         p8KjlKjToaVwtPQe1KBq0jOvCpCrVd1PR5TN8tMIh4gCMONKk01Hnb+mlRWc1T7GGeq5
         EYfi7BSjhx66FVLhy6TmclshEd4vzIeSrbjGsO6SDVKPinr21eUUg4TSAN0DMf/YzSMO
         tZ2lGrQNOFRTtWdAKJrfCLsX1McOs/5Ox/SMA1dxpkuYJcK0ARX8YBUDxul8WuQvPP7k
         TvvT53KXlYPl7va2EsC+PFeX2a1pygCb9GpSsRo7g68QDydeXdlxFT9bxljdpGnW3Yk/
         uTEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790404416; x=1791009216;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9Qh3I8a6NY8irFKYYs5frRNlHo7TF6xowJJxcHvbgDM=;
        b=R+rlF/3wwFpiqhOG5vAqds7Za4dUs8J9DhD3ca+DESjmd9gGUcWbz1TJzhNt+3G/xd
         iJ97CuOu5J/f0tHAmxXTqxF3WQKbL9pj2uuaSH+X0fLDz8MF6svEEIE7ycRUZADdTw39
         jnl3cXBJyxoRkzA896DRRXyfFiSFdckPCE/4fPW/RRFrcGEMeCmQCtXjVSPLRwY2rmjy
         hu+ll3yQWwD8DPVm51biBS1oVBezN8aw44XiAo3zMW49Lf1rcId9UkGfIhlqFA6Plpgg
         aw/qKLe7PU4tf/ePj/BF0eRMoBHYqYIcVeD272zOyAJ/mq8nRxqfl3Fit4Nprd8Vu9DH
         uKOQ==
X-Forwarded-Encrypted: i=1; AKwUvBzWy8j3kfmvmCqGw+wnGB0rlLWEZmHJEGdav3JDu39b38RuoXHHOisFtJAZ3Li1UZZlFIZU296u@vger.kernel.org
X-Gm-Message-State: AFq9FYJzMrDI3kiFRmVFYpFjoZQ+cQbjfFBX45u0Z2fUXJPGB5Q8D+wv
	5ZR3Tn/plcLKU3MnY9xnOyrxB2hGCj95cq0eONUfrMQTpcAyXZBOlQTO
X-Gm-Gg: AYBFou3U1Pdyt/wHmAiGAMII5eFCOzQO09hEJp9pgSNfmQImxYKMo0QxxZpSlKCqKEb
	N8YODgFb7BBV9Qz5diIUeSDdT5kFJvK8rMjva0z16FO9F05sEJ0ammo2SB8toHfkF4FsuMSzOWi
	SbMx1BNI6nm73VLAenbXkceYLqGIXS42rAK0mqCpqiD3YCz2oYejx60wtZDG/pqM6Efy8Lsv42o
	PkfUjzaQEYs5v5TvedUsPnY3gkjKRYASFJNDVEVbAk40wNqVdXI3hqQv95B95UJ5Khs9oHGtg0M
	KqtP4Ig051U42aMWV249jqs6cIbGVS9YTHi6WA55Pxxf5GMDAUSIvCm6wuXcf0TJ73ANlqMauRo
	OM1MsRH8ehhuXnt81QHgtAZNyDZcwt1sSY/OZhuRsklNONmBAVgGEDvJVr5/2fr/aaEjQ/qebAd
	bH5j9olEBOf3nVAoKe0xpOfbOvplcgbQNWUYotTiIHg0nRw9QzSvjQ7SowpSDymxC3zvkwjfVm/
	HT6+s+Y8COY6cZdpBegOs+I906OoXJnYHwKFa0wjIZ4UQfXXGiU13lGoG1/7VPl2k5UF7V+T2sA
	5FQ=
X-Received: by 2002:a17:902:f64c:b0:2df:9eb0:760d with SMTP id d9443c01a7336-2df9eb07af8mr20882645ad.61.1790404416418;
        Fri, 25 Sep 2026 23:33:36 -0700 (PDT)
Received: from yupeng-XPS-15-9520.. (c-73-169-192-12.hsd1.wa.comcast.net. [73.169.192.12])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df91460aaasm19196895ad.73.2026.09.25.23.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 23:33:35 -0700 (PDT)
From: Peng Yu <yupeng0921@gmail.com>
To: Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>
Cc: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Maurizio Lombardi <mlombard@arkamax.eu>,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Peng Yu <yupeng0921@gmail.com>
Subject: [PATCH v5 1/2] cgroup: export cgroup_e_css()
Date: Fri, 25 Sep 2026 23:33:27 -0700
Message-ID: <20260926063328.257023-2-yupeng0921@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260926063328.257023-1-yupeng0921@gmail.com>
References: <20260926063328.257023-1-yupeng0921@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The nvmet invokes the cgroup_e_css for each bio and under
the rcu protection.

Signed-off-by: Peng Yu <yupeng0921@gmail.com>
---
 kernel/cgroup/cgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 2d532bf2c0c7..2cb0f1355c05 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -563,6 +563,7 @@ struct cgroup_subsys_state *cgroup_e_css(struct cgroup *cgrp,
 
 	return init_css_set.subsys[ss->id];
 }
+EXPORT_SYMBOL_GPL(cgroup_e_css);
 
 /**
  * cgroup_get_e_css - get a cgroup's effective css for the specified subsystem
-- 
2.53.0

