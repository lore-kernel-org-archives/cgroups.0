Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C4D376BD0
	for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 03:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787542546; cv=none; b=Vta2ip+7MW9xQvXc0Xs94o7eLD9nm8UAz62CWuQYDK9YTOJsLUq5NPcb/1ZLcDozzlCLIUa6iKLXPK2rBGDcWX5kkJolMV+s+voUisbPZKV0N4wgRMU5lmUmmrv6ZHT8la+GdVlbskFZb8/6kO4wr3Bbpar5588BdM48t6NGIhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787542546; c=relaxed/simple;
	bh=RX9tbEJGh8uuIbWQO+YgeJhWqknJ4mX0lzATa1cSsnw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JmIt6I9vztY4sD1l5VniLpYREVsxpiV0VJdrSC5hCJe1ORP0JJ0bIv7gHqydf9oyCQfWoTvZtg9PkZC4FtdMKQzTuUUfVgW637mB1g1EknAiehaIzuwSVlR03BNQAnX29VGY1cRit8w3zW/moYWE/6OqA7bJXtZKMtR0bvTUNnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--wfelipe.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VNB/g7sy; arc=none smtp.client-ip=209.85.214.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--wfelipe.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VNB/g7sy"
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2ce7dff6253so39089255ad.1
        for <cgroups@vger.kernel.org>; Sun, 23 Aug 2026 20:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787542545; x=1788147345; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uLeWQI8viIKf2ncJdeLCdpToNayUvXof6lXIwZBpCjQ=;
        b=VNB/g7syu5iKfwGAIFnAWhzrE/lyAEE3JUdz4SeHPDtFS2nJlSOCa1GN+RoKZ8TlK8
         gLS7fNA1ME6YVq5vjSEP+e9V4AF3PP2/oQE0q8IF617bzq2JwdRbnfx/bnOpHPCNcEYq
         iF2tdmpVKF5t3Vve/EYh2VdlEjMGSfSD5xdMVJVerFzW19qA+V+WEe9D6X6EVDi2yRJM
         049TiffLfRq6IbLHG6cfNipB1IJqS4gWHm3nqXvvSaqe29LNoVxFDXf/V2QEky/BAXc9
         EsDCnTTpg0+TvzJiQSpaeiOio0IxhY+PpAsdRUnBUoOUSY5mgITaVgg4M/Yjk+O/fYtU
         NVdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787542545; x=1788147345;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uLeWQI8viIKf2ncJdeLCdpToNayUvXof6lXIwZBpCjQ=;
        b=T4/a0G7ZWxlIqqODW1YTFOAyVvgFxjFtNil8kyXGaKcwC8lfzsUhRB6xMyMssSoCkA
         JuclOf4ijJX79l1y+JxwKiDj4JzXnCcq8Pjn8Y/C7pF7IixaPJ2MjbjC2Q1tOshszGku
         u0rlPA0U41RDbRlK2AJ4B7xuy7jjWIhsruKz6inRt2wtfo9bvy3skl/boQxVn6ywiAlA
         p84uBEESrjx6fBvt9WgXoOai+qBim4vruBIRW4xiIjV606hgIbPwZLSKgxF3J69xDvT6
         kMAn9yMZUkAetrfqCtyCTbejJYzIjSoRgWhCcELcdKsSa/+qud3eGlsQNaYaS9H9J2pC
         NVLA==
X-Forwarded-Encrypted: i=1; AHgh+Ron8g67OAYEv9NGE+tBFan7N84pN5YdRiyHsA4VjP31Xkd9YH8m5B8zOFVLYYS68rC8XEO0S/jE@vger.kernel.org
X-Gm-Message-State: AFuF++md1t0gd82VCXAtuF8XhBT0pfcx4CIoMaehZ4Z+A6WChNzgvnda
	GhjxsIEUGUuLfq31gwgByX6Vlm32+XtNu7Z3j3pQwLuRPybRC68cw+XBktdmFgfbO7A+sBHDqzA
	JfGL2I608iQ==
X-Received: from plgk2.prod.google.com ([2002:a17:902:ce02:b0:2d5:6077:5a69])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3b85:b0:2cc:ac15:ff4c
 with SMTP id d9443c01a7336-2d61a0da51fmr357601025ad.8.1787542544728; Sun, 23
 Aug 2026 20:35:44 -0700 (PDT)
Date: Mon, 24 Aug 2026 03:33:57 +0000
In-Reply-To: <20260824033533.2147900-1-wfelipe@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260824033533.2147900-1-wfelipe@google.com>
X-Mailer: git-send-email 2.55.0.766.g2966f0265a-goog
Message-ID: <20260824033533.2147900-2-wfelipe@google.com>
Subject: [PATCH v2 1/2] selftests/cgroup: test_zswap: wait for cgroup to
 unpopulate in test_zswap_writeback
From: Wilson Felipe Pereira <wfelipe@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Wilson Felipe Pereira <wfelipe@google.com>
Content-Type: text/plain; charset="UTF-8"

When running test_zswap on a single-core VM (-smp 1) with 4GB of RAM,
test_zswap_writeback intermittently fails on the initial run after boot.

In test_zswap_writeback(), after waitpid() reaps the child process created
by test_zswap_writeback_one(), writing "+memory" to cgroup.subtree_control
can fail with -EBUSY. Under cgroup v2, enabling domain subtree controllers
is forbidden while any tasks remain in cgroup.procs.

When a child process exits, exit_notify() wakes the parent process,
allowing waitpid() to return immediately. However, the cgroup populated
task count (nr_populated_csets) is only decremented when the exiting
task is switched away via finish_task_switch() -> cgroup_task_dead(). On
single-core systems, the parent runs before the dead child has been
switched out, causing "+memory" to fail with -EBUSY if written immediately
after waitpid() returns.

Fix this by waiting for cgroup.events to report "populated 0\n" via
cg_read_strcmp_wait() before enabling subtree control.

Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
---
 tools/testing/selftests/cgroup/test_zswap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 49b36ee79160..a7ff525c1267 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -407,6 +407,8 @@ static int test_zswap_writeback(const char *root, bool wb)
 	 * Thus, the parent's setting shall be what's in effect. */
 	if (cg_write(test_group, "memory.zswap.max", "max"))
 		goto out;
+	if (cg_read_strcmp_wait(test_group, "cgroup.events", "populated 0\n"))
+		goto out;
 	if (cg_write(test_group, "cgroup.subtree_control", "+memory"))
 		goto out;
 
-- 
2.55.0.766.g2966f0265a-goog

