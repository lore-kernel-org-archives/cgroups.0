Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63FA33F59C
	for <cgroups@vger.kernel.org>; Mon, 12 Oct 2026 05:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791783749; cv=none; b=shEVsb+PIokLYoYgTTSYPOHdwNgmIXkZIQSVZvGPM2sNdyS191k+Nhpf+p0hve8t31DxdhhX8LQW1NTLc/IL73MoI2kTXZJnmyhbAPBHHD/MDR/1Pnguh55QGz0ZwYZKsqIihNCsJQh5nVC2LRG6lvCiwQsgIsYlBCKGV4boj68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791783749; c=relaxed/simple;
	bh=p+9HQ/2qU6hqqbNv9Hj0rg3//zMxgJo30lA7NXPrBp0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Fa0Ea7HlNUP/qn01kcW9LTn+jklOpJzmixy17rdQNHhfp0rEBse0NfNC3Oel6S9RQQnYRVQufYBRndIJh5KfjOma+DDjiIDhHPUdAAaJydr1EmK+VKKpA4RHCTqJauyITGrE51PvyI5avmpD3ttj1+qehH8zsG8VKa3i0ESslig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nGRnOnwz; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nGRnOnwz"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48dd33a7bd4so107770f8f.3
        for <cgroups@vger.kernel.org>; Sun, 11 Oct 2026 22:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791783746; x=1792388546; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Oj5XhgSe0FpI9L7joKTl2xjZXYCjBG3XVmlBR03TmF0=;
        b=nGRnOnwz1VXC3wSgdHIAa4X7KSrT4RUbyNxx3OTmzOu7Td0FqvwmqHvVZhxO5ojUql
         rRkGbTt+0iyoYns8AK6eb1Ts1VZ7eKQUV+MEkIWh9WO22RjzROLGmjHEgk8wCX2DIS7a
         BOu6po5dG8iqS4XAg6CwU1I+ecNrBUutEuvwjAzLkUt/kzrpq6vEi04RVtImW9SBU7NM
         +zJhsuOqOFdAgxLdlUziMm/Bdq//gTQ8RNBPoM64X+UHr190eRDqATDo9V5oka8uvHBh
         b0lKSNfqYml8ItWXtktkin/Hy1mxhQvJZ3JLZDkjHubk9GpYf15trpRXHZSml3tL/cjU
         fQlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791783746; x=1792388546;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Oj5XhgSe0FpI9L7joKTl2xjZXYCjBG3XVmlBR03TmF0=;
        b=w185PZXywj9BKFWHeDPDwp7WUHSPnF2xwZk124wfKbL6THrSFurBDYhtmRsh2S3Dlp
         kalmKYJanVHYdiZILTHkmiE1ItuYJisYALQzUyqZsb8Ei6w6Q00ODKl8uaCutsLvpQNx
         gxWjmXayVOSPR/XDkLc+9EI1EOwR3+YWxi1khORiqziWM51kUfqqYy8OWahqx/0IRRoo
         oaVLwdOpmgBfxeoVYbMY84YdylhelYuGQKwam5tmoMsQTog1kkjBW27TCJSqWJwTQGpt
         w7Ad+oyGmLbC7OCOYCgjXI2vYpEr9vWaE3QJI5EfjWpZoXIJRui7TrAjDn420JAt5nMI
         fjqw==
X-Forwarded-Encrypted: i=1; AKwUvBy/V7F3tk5NbOJpGhWYuT1rs4Mr50ENLDwyxM5yH0DPXyb6pC2Jeqz5SGWVBnxIOQAvdMEjZfYu@vger.kernel.org
X-Gm-Message-State: AFq9FYIK4VM1pQBR3O+xHTJmui7oV+EsbbGrME9Goh4h/Hmu4frja2mY
	dOXSB89fGq0m1m9613jDr3nMFqIQbZlGCvJnihzuSn8vtGrBe7YC5dcB19BVAUny
X-Gm-Gg: AYBFou1ChkhFKChOAlKidpmwHMZE+4T1c7fGLf96QeZCZZtrm8Ubb4B4hGr8ebHRdVW
	arOltWtyYnEKxd+hVoSSM1TppA0f8c0SaFAdEWNkIyCuoDg7uGE3kirLTow3KnW6CthPQD3Av/1
	X1ll1+2Gv00eVkcetbO4vR2zLIPb7jZG6ms7jdCya9FEdF57iNAzIOG0IbScr/N7DxRCROhzHl5
	u/8sYFdPMkYxxxtd/l7bAD6ca4MymUZ5IUNOUxcY0yGK60z4S2RBzPNgUguLKbWIAoduQE4f68W
	rzzRRoydiEmejecuQMXyBeQiB4q1A7prx/B+WBI1ylJrJHHFllOPJ+t21NUPnhQK7BZzCJNGQ0+
	1FAvGRVH2uT+5ooNklRhqXgIS2AcYPm4FnWz/yKuODy4v7kp7FEIsCwSlCjNl68UO/RbjOcYFlI
	wKq5T7RPLDXoC3NA2dorsSXUteyKK63WyNkqhjDYUAKk+vzhxzVk8cC+OtT27mPqt/E+/tqUubk
	N45HkGHG/P+dwT6Db1zoy59Hq/HJHb5fhcFgqEsnZ2TInc8nOLw7bfbCngCAQSjVRk13Ah1srpH
	p7kPTBiEC732ihXCm2ZqtpHmwEmTWmkj83Ag+YdFXJ7z4iFL/Ke0U8o6nKADuBBwbD71I3ijdCo
	=
X-Received: by 2002:a5d:6312:0:b0:48d:ba1b:e151 with SMTP id ffacd0b85a97d-48dbaaeb490mr11563603f8f.38.1791783745844;
        Sun, 11 Oct 2026 22:42:25 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a8ab-0f01-016a-c770-797f-eaee.310.pool.telefonica.de. [2a02:3100:a8ab:f01:16a:c770:797f:eaee])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48ddbbd745dsm1013851f8f.15.2026.10.11.22.42.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 11 Oct 2026 22:42:25 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Li Zefan <lizefan@huawei.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] cgroup: Avoid warning when procfs is disabled
Date: Mon, 12 Oct 2026 07:42:19 +0200
Message-Id: <20261012054219.13365-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With CGROUPS=y and PROC_FS=n, proc_create_single() returns NULL and
cgroup initialization warns during every boot.

Only check creation of /proc/cgroups when procfs is enabled.

Fixes: 035f4f510583 ("cgroup: replace error handling in cgroup_init() with WARN_ON()s")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 kernel/cgroup/cgroup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 227d09704ca5..567afb75a4ec 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6612,7 +6612,9 @@ int __init cgroup_init(void)
 	WARN_ON(sysfs_create_mount_point(fs_kobj, "cgroup"));
 	WARN_ON(register_filesystem(&cgroup_fs_type));
 	WARN_ON(register_filesystem(&cgroup2_fs_type));
-	WARN_ON(!proc_create_single("cgroups", 0, NULL, proc_cgroupstats_show));
+	if (IS_ENABLED(CONFIG_PROC_FS))
+		WARN_ON(!proc_create_single("cgroups", 0, NULL,
+					    proc_cgroupstats_show));
 #ifdef CONFIG_CPUSETS_V1
 	WARN_ON(register_filesystem(&cpuset_fs_type));
 #endif
-- 
2.53.0

