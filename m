Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C2638CFED
	for <cgroups@vger.kernel.org>; Fri,  4 Sep 2026 22:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788562271; cv=none; b=iqCHD5+t+k1dwVfRCs1AaqNv9C3AfZnpOvglioik8DN1M+xD80s+BPARCFJmvg+BwQv6uRbPKi2QvWcg6PBMXfzTCzF1m5eQFvThmz3y1UaP/RZSEAA2eU1sogbqWiUDP/ToTnl/Q9Tiv/rCwkFh34bo/w4NthpBGvXu+HgJf6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788562271; c=relaxed/simple;
	bh=BH0sJiRzFlk64hqG4rCWsKMMTvzMukqzBxeOy8VRpSU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ltud7l7dgV11sUitgewh0Xmaxzm12glD3ojnb0VfJoHnEkJlKme4V8oVuEggnEHFXOrPmYW1OhTiWzdIz0ooO+P7OgiFohfJwe/b7dYwREA9jUWUoa3KMoJtNiZJjX7v04qQt73fFppjkM5xHisrf4aTFQ0B0EMYP//fM0x2PIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--wfelipe.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AwWmW932; arc=none smtp.client-ip=209.85.216.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--wfelipe.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AwWmW932"
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e8fee6af3so1948309a91.1
        for <cgroups@vger.kernel.org>; Fri, 04 Sep 2026 15:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788562269; x=1789167069; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=etVT3JR9OsRtloAyimt/t5S2ubPCA2IZVBKjgKO3AfA=;
        b=AwWmW932FkhjNUV6DIYweOvyEHcmC+At/HTdWgGsKzsaMLu41wtvvOQkahEZfEwFl1
         vHtrO4tB+YiweA/OBUXJE8DY5OUO4qTFZJhts0/onDK1jIAeoWNoQ7ztTz5nCvCIxLAF
         3dcn1FDWawsnRbGsDQEP1kH6n+hSAGVOw0Qce4aYhEJyJwzyWURAcxIe2EKGOOvkO5Px
         G3+a6VcvzPClmn0x5MuDwhgqtjb9TkVwWS4g4CmrR6cpvOKa7QRRkjKbaDrGS/6S7uiM
         gg02gYVjfYLqT7hi5nhnhrnNx1pFiRgHr0HzsCrLpYplizdHlij+FP6mb5lxMg9YNxLf
         vHNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788562269; x=1789167069;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=etVT3JR9OsRtloAyimt/t5S2ubPCA2IZVBKjgKO3AfA=;
        b=M+oBuDoLOU4r/KeUsxiAbYIBXeq9+i3x/LV/VZ63LHPJwugQELoQdncG99fcExhgVY
         Kkl+GH8MLin7G6PxA5yoLg2xUdY4x+HOMzOI0cwGC1PHhhr1qPRkS3P2yLC7rKdKRVkE
         wdDajdC+I8Pk1gKn4qATV1E/k3Au2JsHJS05bU/uPTMK58AtIDuyxj3YPpugt8Bzmw30
         sYA772gtQNSnHD888XW3oaDEHDZonoJv8rEjyOzH2teSdKSDnT39lq20f15cPS3AkjZl
         bdL3MQP2p93LKAsmEtFiJMXhjTkXYu6QNYT3nDEIGiAwjuJLd98PewZx1AOI+eATDIVL
         hW6Q==
X-Forwarded-Encrypted: i=1; AKwUvBwkB638Lllm+Sv8//XYfgN/T5MnOzUlsATHyrW3QV+jMSBoGmpyYfctUPwZJxovh34EKHtp+8rW@vger.kernel.org
X-Gm-Message-State: AFuF++kFGNuIIhcHjvH8JNGynpgx4HXDetdRvP5LMY3fE26FuGLUh2xz
	3ALZHKg1YZ9zrcJGVTqjdGYTkNqp17DoMF0CMnPaiCiLvKac8ZGAWMSf1aiSKR3Ug8fP6NSpGCw
	vM6HO02VUxQ==
X-Received: from pgu38.prod.google.com ([2002:a63:1466:0:b0:c9a:53ea:434a])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:4388:b0:3da:1e2f:3be9
 with SMTP id adf61e73a8af0-3da3a0b0070mr14239936637.22.1788562268577; Fri, 04
 Sep 2026 15:51:08 -0700 (PDT)
Date: Fri,  4 Sep 2026 22:45:13 +0000
In-Reply-To: <20260904225103.2955759-1-wfelipe@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260904225103.2955759-1-wfelipe@google.com>
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
Message-ID: <20260904225103.2955759-2-wfelipe@google.com>
Subject: [PATCH v6 1/3] selftests/cgroup: test_zswap: wait for cgroup to
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
Content-Transfer-Encoding: quoted-printable

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
Acked-by: Michal Koutn=C3=BD <mkoutny@suse.com>
---
 tools/testing/selftests/cgroup/test_zswap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/se=
lftests/cgroup/test_zswap.c
index 609c48f38524..8f2c9aa4776c 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -408,6 +408,8 @@ static int test_zswap_writeback(const char *root, bool =
wb)
 	 * Thus, the parent's setting shall be what's in effect. */
 	if (cg_write(test_group, "memory.zswap.max", "max"))
 		goto out;
+	if (cg_read_strcmp_wait(test_group, "cgroup.events", "populated 0\n"))
+		goto out;
 	if (cg_write(test_group, "cgroup.subtree_control", "+memory"))
 		goto out;
=20
--=20
2.55.0.979.g7e5102b832-goog

