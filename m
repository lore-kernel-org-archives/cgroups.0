Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861E937E5C2
	for <cgroups@vger.kernel.org>; Tue,  1 Sep 2026 05:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788240175; cv=none; b=eokrEmNDw8Udf0MJw9Ya2yJYCkZolX2AZerxfumrGu2tumtj0pG56PagdfG5ygjTXsDpNxSqWPwxgARpa50uh5ig1yLW4lt+iqtAFJUbKPd+3Bca8tfPwbIDDXZQl2OoQlRQSWVrmjo6GScRee/Mf0xWk+XLCahxOpkDJrK0OJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788240175; c=relaxed/simple;
	bh=Fks4pHYSzdgBN83mz688FTg4kFjTXCMANoaD+RC87Cg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gHIqQA21N4nNnKOTT+MHa4UFwfwdRyqQU4AhtLXbrY1Ia8zMsS9homOR5PoV6WaciLC3vYUimRhvxzZrp2HD3hP5+mwBYUpHrkoN7JtDhqFxlOfIHozVhMr9xEQzMCdRLNxAcfRCzlHgIqtQi8YLcdBHBquyhbD1cZUfC2ofKNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--wfelipe.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CQEaJ7f5; arc=none smtp.client-ip=209.85.216.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--wfelipe.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CQEaJ7f5"
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3968bb86fb7so807621a91.2
        for <cgroups@vger.kernel.org>; Mon, 31 Aug 2026 22:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788240174; x=1788844974; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1jqsz8r0tg3s4C+AAt1rnTrXqOx6Ok5MB9VnHnrHji0=;
        b=CQEaJ7f58ahxJGORCtH7ohvxIcjMoQslW20aYJEU3xgG7sI/0SPx9RXs269HM1btEg
         TLaGaQyILillh2X2IWex8vAWbYT3+szX++oHAicO9jI2jOXI+X6WuDtfSQdu3LJwPee7
         MbxEm7euhgJfvA0++qg8oes0GVzQebwkNbOv3CPCNWOMPsgc4JFr6Jj93K431WRkK1lG
         4y0UE6bLPjZ2zUcaFsi066om5dyGyIMOp+8jywL1M2orhlNKJZu5VMAY3q41uFEEWR4L
         SKbNvzA4VmuFwuR6y8ZWbC3Kf2DeYJA81WqqIxBPij02VPJ9Khw3HaOs8MWvOAyQO0Tn
         5awQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788240174; x=1788844974;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1jqsz8r0tg3s4C+AAt1rnTrXqOx6Ok5MB9VnHnrHji0=;
        b=i+QU7XJR3dnHqRGFe0bUMfyvop5rRbxlroA5WjqOUmVrbrUO0LoIDTrZUfVIQuCeKu
         UtO4+s2ub6zrH+rMq5q9+FlGaUQXqsJ4xF6UeMK4KingwVtRJdTozNqi6ZZbYtzFAYgh
         9rHqKdckJtm3XSEyjxyUdSsx1O5LAPaHwJlP/AiAodX6lH01cJi7MW8FP8nyxVZ0O4WY
         0fkNvjTAoCQg6t7NzJz86dheevDE1nvLDCz+UBdWd/RcPrKN5trYLV+VxmTucpmuiI1q
         EP/2Ez2xDuwhk6oj2VGva30vnbgd6IeFREGWNNhWIhaxoCAg3DBwMB/Rvn1hfSbEEnaV
         +oOg==
X-Forwarded-Encrypted: i=1; AKwUvBzfDrJvTwiWrKUmwggthUUwzGVvx8d538a+oBDfhD+BlPJikfVkhJmiKq20SW0y4Bil/t9vYMog@vger.kernel.org
X-Gm-Message-State: AFuF++nis0voJ2mSG6mLIicpIt0OORwfTX7v9426IVmLpLlSx1QiIG7A
	ywfScx39EY7zDDPodmsDncwrPp3FJqRVDQ4N412peLqgvYoI4ZFly5y97ORdRPT9mb1f2K4wJR4
	6UtBKh9jXSg==
X-Received: from pjpu5.prod.google.com ([2002:a17:90a:a205:b0:396:4de4:b1a3])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1811:b0:398:e86b:ce14
 with SMTP id 98e67ed59e1d1-398e86bcf08mr14606352a91.20.1788240173753; Mon, 31
 Aug 2026 22:22:53 -0700 (PDT)
Date: Tue,  1 Sep 2026 05:22:27 +0000
In-Reply-To: <20260901052250.154532-1-wfelipe@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260901052250.154532-1-wfelipe@google.com>
X-Mailer: git-send-email 2.55.0.970.g62bdec98f9-goog
Message-ID: <20260901052250.154532-2-wfelipe@google.com>
Subject: [PATCH v5 1/2] selftests/cgroup: test_zswap: wait for cgroup to
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
2.55.0.970.g62bdec98f9-goog

