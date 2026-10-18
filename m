Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DDE3DB64D
	for <cgroups@vger.kernel.org>; Sun, 18 Oct 2026 22:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792361101; cv=none; b=kehTg6pKv6WY6UTmR8/5FtEnEZthQ32WtDv15Za2KGlZfPSGs2GQ3SFVdh5irrfKygjZuyz/fFp9PMwEZASMbQgZH/yg8weJ5qK1B+MYgITp2CR8mXVK+VJA0ylimpfJ9VIR3U096KEPawB2gtJJWoqov3X4XFkynXFcAK7QfxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792361101; c=relaxed/simple;
	bh=HMm8MU0ai0yuTQwxN6AZ7cjuZpabyMi4cgQPa/Jbj9E=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=UB9fIcIVTiXGROt8z10ri73Q0imiODcarqEn9NJ8urVCIB2ntHsYmgErMMxrS3XuhF3hKk4WEN22Ii5zti7oOhreF0hv7pqIxC0Q09/OU7I1fk1fgOdFJNbI76PYehmUAIdFSDM09d8QoZrB0dEqXuqT1q169fA3QGLmW9AqAYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jWGnEfjJ; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jWGnEfjJ"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3856d6fbcb3so934785a91.2
        for <cgroups@vger.kernel.org>; Sun, 18 Oct 2026 15:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792361099; x=1792965899; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=FXXu6sXqJk8SsG+U0f2HwCixxxfND+avQe3AD+r/VSs=;
        b=jWGnEfjJPniSeVcbPWrgIpVJxSHni9qn5y5aId108nT9OEkVkw/sP2up90WI1DEudt
         JiePtdWJpkYxSEo7YwLTkdKamKahooJbe6HhiJfjB6aeixqV/ThT56WmSBgyut41O4Ru
         Cj4zolTkA9EkjTspPSySt+OMUC0DDy+W0FlUX3XZSj9BofSn8yX2bD/x85Ux4vFrMLfF
         1HuwsAJqhMuZjzsyOJgXCa3xvTc43GBtNxWYbjMtiE0y+62z+4Lbiuc7GWWEFdYATRIE
         vrHqpmtcFjFbs9+yzySQpW7q4jshQguU5zn1o3l+Kh2++hIZF9PMiDr1lbLEy0Ca7Hyt
         LP4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792361099; x=1792965899;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=FXXu6sXqJk8SsG+U0f2HwCixxxfND+avQe3AD+r/VSs=;
        b=hDRtRtbgsTSzZ6CkExkdN3RsjGOmwfF0/ZarbvwKX2xtqWvfVZHKsM3P8nbY19csyv
         Feqfjb/fiQ/3r9fpp9pdi9j+O/VsajetkkF8vo9+pThsmSRuzicYZ7q2IhGXVluupI/i
         OU8s0W8pdr3P+q1BG+x+C3cOXrARVeiSvLLgPg6yh5/pyRII0TgSXtzDfvvkIB1LW+QD
         /F76IVtsZq45zZOTelTqwsN/qtdLQvRe+viy5pVn6nyINsF6SRCcePyDCzztkzLtqWEv
         TpeQs6lCBMVUqRSVOg0kEJ1/VsP5MPpnMMyTx/+NhlVcNolErZlBa4/RiEI0v3N9W1Tg
         ax7Q==
X-Forwarded-Encrypted: i=1; AKwUvBwn0H3QkUTXkxIWdsULXJaQDkUGIFCTzxZm9g96dsIW85A7iOBgrKF/+jjuKD4CoLRKFBKkEBDF@vger.kernel.org
X-Gm-Message-State: AFq9FYI3CuACI3eZ0rUgfDNAe8FJzTFG3GDHx9QO4vr22VrI+k3YDqKW
	n0drpvlRVknNoPs1oa/Ik45wKZRt1RkDLm8TmgqA9RL/urb0q5dQvyTG
X-Gm-Gg: AYBFou1yYLoEkuMEJzoorwpWWr+73p11Lf++emSxpy75t2YfmoYkSp50VTshjvn64lQ
	v/2evFBFxVIaCwbxYOeRxbJPs+m7g4D8EBgnJx2Sysv+490q1s0Y46bF5Wi5AjXQimuhoH8nIqj
	MVdCslpolwUe8W1Gx2oygzof6IcqwJN8zwpEusgH5vC/9PNEElpyCJfBsoIqVqbOaSuzt1k0Orp
	+eAIFEncw6YNuD/9+NGj4GCeD/y1P8dUzt60ZU+gS6EBchu3PywBhzXVpA876AiM3MYADWw2M7Q
	E2Ulz+lSMClRthHBtGCg4lL2UTlFKpt7DUP0F7GokUwIZvM9MwGdwwgrtUGDZSsG7ZR8A5wOkYK
	ul6qwN1rgPDQiA9k8yv4gSn0ebbm5j4LHgsnh8VNNU2Zzr+b1n8aMhfr82vVlYDKIdTHqYnOBvL
	P6przzXh3Mw26cd+PUFzrGajTVTbJDvzrcXa/+eiD+GscG8SBW5Cmr/vZMPnx652RVlUsZog==
X-Received: by 2002:a17:90b:580d:b0:396:41d1:cbc7 with SMTP id 98e67ed59e1d1-3acee2939c2mr4818318a91.3.1792361099415;
        Sun, 18 Oct 2026 15:04:59 -0700 (PDT)
Received: from [10.1.2.130] ([67.185.120.12])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac945e72c6sm17718271a91.5.2026.10.18.15.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 15:04:58 -0700 (PDT)
From: Kir Kolyshkin <kolyshkin@gmail.com>
Subject: [PATCH 0/2] cgroup: fix cgroup.kill for exited thread group leader
Date: Sun, 18 Oct 2026 15:04:38 -0700
Message-Id: <20261018-cgroup-kill-exited-leader-v1-0-c71ad94c20cc@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MQQqDMBBG4avIrDuQSbHYXkW6CMlfHQwqEy2Ce
 PeGLr/FeycVmKLQqznJ8NWiy1wht4biGOYBrKmavPMPcdJxHGzZV540Z8ahGxJnhATjIK20T3T
 R3x3VfjV89Pi/+/d1/QDnsFMnawAAAA==
X-Change-ID: 20261018-cgroup-kill-exited-leader-a15159e8c230
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Serge Hallyn <serge@hallyn.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Christian Brauner <brauner@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, 
 Oleg Nesterov <oleg@redhat.com>, cgroups@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Kir Kolyshkin <kolyshkin@gmail.com>
X-Mailer: b4 0.14.3

cgroup.kill fails to kill a process whose thread group leader has
exited while other threads are still running, leaving the cgroup
populated. This can be used by a process in a container to survive
the container being killed, including the case of a container with a
private PID namespace, where such a process is the container's init.

Patch 1 fixes __cgroup_kill() to walk all threads and to send a
thread-group-directed SIGKILL. Patch 2 adds selftests for both
scenarios described in patch 1; they fail without the fix.

Tested on v7.3-rc7 (x86_64 VM): test_kill passes (30 runs), other
cgroup selftests show no changes compared to the unpatched kernel.

The issue was found in crun, see patch 1 for details.

Signed-off-by: Kir Kolyshkin <kolyshkin@gmail.com>
---
Kir Kolyshkin (2):
      cgroup: fix cgroup.kill for exited thread group leader
      selftests/cgroup: test cgroup.kill with an exited thread group leader

 kernel/cgroup/cgroup.c                     |   4 +-
 tools/testing/selftests/cgroup/test_kill.c | 158 +++++++++++++++++++++++++++++
 2 files changed, 160 insertions(+), 2 deletions(-)
---
base-commit: f909e534f5e34feb2ea2701d54df63e21aa506fc
change-id: 20261018-cgroup-kill-exited-leader-a15159e8c230

Best regards,
-- 
Kir Kolyshkin <kolyshkin@gmail.com>

