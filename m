Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651162ECD35
	for <cgroups@vger.kernel.org>; Fri, 28 Aug 2026 05:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787895784; cv=pass; b=a57L+D6Cob0Pc3oRtPwoaYBdlsFpLIQFZbp+y0V8uUQ0zg2xcIpJFkYG4unjNlMYKmq00jl9/zLM+BvwEkz2+TxG1pAmX/lWkh3jsMRFP2Ihn/b2G3O6iKl5yrb37kpzwwOFlFfP2Q5w/gvPP9ntX4TWPC/su9JYaO+ovl79UcE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787895784; c=relaxed/simple;
	bh=wBxP4YbhlKCZA5smzchOnIzBLXWhALGSS58Lbit0obQ=;
	h=From:MIME-Version:Date:Message-ID:Subject:To:Cc:Content-Type; b=s4btl6b62Yb3v+XsPPagAtExZcfiB1wdeouDuqasPdZWWdM4lKF3CCvFkq4yOlzT1oqHn3kUmmi23QosKbXfrmrqw3qJK08c4iv6I7nYNZV/Ji8VHALjRHlBHMPfcB2TypueOIaC2NpHo/MgDwEBWTfnis6mn8r1w/9h0OlqzlM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu; spf=pass smtp.mailfrom=berkeley.edu; dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b=DbGunFKk; arc=pass smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b="DbGunFKk"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-39682983a0fso628676a91.3
        for <cgroups@vger.kernel.org>; Thu, 27 Aug 2026 22:43:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787895783; cv=none;
        d=google.com; s=arc-20260327;
        b=YidGJnInP1GBw8cgFcwguqXjtkz57EnIiMp6sR8xuOXWSNpMtrKorK6ScGXTZImLAb
         HL0EDEb3xPF8UTPxhPlWb+oJtvClPTC8n0/jxlYVpFHapQhvL3ijaPPX7ta396/w2dI6
         vrvHwPFEtL+0c70GYwqdEciuWkcRxxuerPHLBCcjadPyDda23Kb1/HwPK6OKbWA5HvGo
         gH5cbsKIApwZY3cOUHkDqhd9545clqL800ezfeyFCo+t9rkqP+sk4W69TgfA7x0qF90J
         aa9Uvzmfw7oI+7OT95fgMSYudDX/CKTT6sS30rc/ISbGgs0GYtnmseNf4dntDNEWTq3A
         dwwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=ymcSwDmaIrMigTTRllqGG5n7lpgRFCcfMNtdeB++vus=;
        fh=JzzAQT7lbP7g7Op/NwxggUxfxXvEpFnFxSUQuYuSomc=;
        b=WZ6pqdArBL00oLe9rNNe+j4KiJSgjaoPbRumCCa6kmzCnS59OqqtghG6y2p5edcYPa
         8MHDQoPYtkHpmGAowMYIrmi5VdVFsMMxIPeyZBMDundQ51tp1MMtjdME6Rwfn/b+Vn1e
         u73McIH+R/Mi8i5hePH5/IENKpiRtnslsakjiHCR902bGHAxUf/hLq5GrmKjM71s4Bwm
         Qj2SidEOY05g1eK0HlKM1qZPngscHfbF3Fo+1muyY8l7itvueiwxzG1k84wedmUjhTbj
         BJ/hMlmQ2IW8GW5rHAPAtMO0HZ95esA4nsJ3nL6PUSbVWfJbkPJcwo/siliiWrscyMXp
         onNg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1787895783; x=1788500583; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ymcSwDmaIrMigTTRllqGG5n7lpgRFCcfMNtdeB++vus=;
        b=DbGunFKkbLMAP17Y7TdVSRMr8mnu9MPZKVSt922mkdNBXR/RRGCUS7VkD34L8HuVMk
         MNA0LcDOVo0krgDQBk5ecXyDr/AgE/MVTf3O13vHMWyiD8DTLAcbZS+Nnw7OnGlOm2wL
         w9rcHUq2X4SV2UxlwZNx1SieR1zbUdBiEvXUA08rsC9NCKbH+t4qUYy/sf2xoTQ+SWN2
         E2rQOOtk4zVJswtbhBE1owblP9iNh3Z0KumjFrLCLO+BzArw2nLz+1T0kWrRpyC41Fv6
         iqmyLEVPK8XiT1wibG0qHSVcFDH3dFYOOMtbeXk9L7Fo81J4mTitFSKVNN59VJm6waNQ
         /qAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787895783; x=1788500583;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ymcSwDmaIrMigTTRllqGG5n7lpgRFCcfMNtdeB++vus=;
        b=IbI65aB4oSdTR2ws+3D8+S5UmyGexiTp3bYB5uYNcqJ7/H5ehfJKlQPRkzJRNGYV6g
         dX7pwHCCmGpqfxXj3KJzcnu//ZuPcc8Zz+6wJAcBZZRbirFDwsqkjiVVwlG93sNvsRz6
         K4jM7Le+W/XUvwaJvHsvlHIVSGFmmx8OwKVMlQssBGyLxIhLkf/ZSzNYGBvIhG3jMxLL
         qt/QrKExi7jTvYEuBzgx2eLoZ2bqcmnePRJBw+nXmDShCZljlQ5/SR0Y6ZFsAMUNmgCZ
         jQYRPa6E4YOOG1lU5F6YvAimHapUcUiloY/cq964sIAi/EyUX08dhOu2shlcL/cDOaiB
         hxNw==
X-Forwarded-Encrypted: i=1; AHgh+Rpd3YPFHhI0elPzzy1XY/Zoff30XfX8BDI7G2YlqP68njQIKXvkAfVxlMgXAHc5RYk6dIjrevf9@vger.kernel.org
X-Gm-Message-State: AFuF++lzzA0jDqyKjgJOglVyUVPPqYHbQRIKcyRLrMvMBCea6S7Glaaf
	Fzlpt3zxQR8Hw1y/XAjZoZhK2wJsEK0voaXpgzTsQZTH4g7i7CeKvpYxqZUmghskGu2d/IdYXW6
	s5hpeMYdoSxMIgEgMSJfl0oKmA3i/2JcntKR3DKs3pVfUQqEVZWYUQg==
X-Gm-Gg: AR+sD121I77RyHzbOv+MWMJ4WC5iqJlQGDkomfEqAL2+/KAU+9FxjNtH/PRfoVO9RJw
	mi0RIp9KK6z2/AobLWgSyZh6nQRG34pOPno3aQSmkv44P+S0W2YURzexpMVeQm3PsDiZVLWgfcf
	EmorUO0QlxRcTgqh0UDV4PylzSDTZxfQmw7Rw6Z38wR2e5kAb7Wm1MsYv8MZ5omc0G3QT/76+vQ
	avV2EY79L6G6diHJFL+ex2+8LMXrjVOCGOSdgPS5KDwiQwi9EDGfX4yFJrFLN7S4oaYiNG7534Y
	FxHsWdAi2ItCXbgMliFAxpBl93oYtBzZGgbSOQ0TVMeiB2Egk4eryH7JYnuBex7tOmO1HhEAoM3
	7ggvk/o7I5Z+nU27Ynks4JEYrarxCwl+1
X-Received: by 2002:a17:90b:530c:b0:381:1c96:829b with SMTP id
 98e67ed59e1d1-396d0d4c43amr9634249a91.3.1787895781568; Thu, 27 Aug 2026
 22:43:01 -0700 (PDT)
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 27 Aug 2026 22:43:01 -0700
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 27 Aug 2026 22:43:01 -0700
From: Farhad Alemi <farhad.alemi@berkeley.edu>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 27 Aug 2026 22:43:01 -0700
X-Gm-Features: AcwNN1Wp7GsXp8ne0pKDNCHjGi3GIZAVKBDWrEj4p0lfI9KYWd84e7KzkWViHJo
Message-ID: <CA+0ovChh3VjsKN1g+ZGjwwY2fGTpP7uD+aCCByLj5Qbymw=bfQ@mail.gmail.com>
Subject: [BUG] general protection fault in cpuset_cpus_allowed
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: falemi@asu.edu, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

As part of the kernel research at ASU's SEFCOM
lab, we hit the crash below. Crash reports can be found here:

  https://github.com/farhad-alemi/public_bug_reports/tree/main/166-general-protection-fault-in-cpuset-cpus-allowed/

  Oops: general protection fault, probably for non-canonical address
0xdffffc000000001d: 0000 [#1] SMP KASAN NOPTI
  KASAN: null-ptr-deref in range [0x00000000000000e8-0x00000000000000ef]
  RIP: 0010:bitmap_intersects include/linux/bitmap.h:440 [inline]
  RIP: 0010:cpumask_intersects include/linux/cpumask.h:822 [inline]
  RIP: 0010:guarantee_active_cpus kernel/cgroup/cpuset.c:481 [inline]
  RIP: 0010:__cpuset_cpus_allowed_locked kernel/cgroup/cpuset.c:4022 [inline]
  RIP: 0010:cpuset_cpus_allowed+0x14a/0x2f0 kernel/cgroup/cpuset.c:4071
  Call Trace:
   cpuset_cpus_allowed+0x14a/0x2f0 kernel/cgroup/cpuset.c:4071
   __sched_setaffinity+0x98/0x3c0 kernel/sched/syscalls.c:1149
   sched_setaffinity+0x341/0x4a0 kernel/sched/syscalls.c:1237
   __x64_sys_sched_setaffinity+0x106/0x170 kernel/sched/syscalls.c:1262

A second capture reaches the identical fault -- same address, same KASAN range,
same RIP -- through cpuset_fork <- cgroup_post_fork <- copy_process <-
kernel_clone <- clone3, with the crashing task being systemd at PID 1.

Our reproducer.c is available upon request.

Happy to test a patch if that would help.

Regards,
