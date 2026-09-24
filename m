Received: from mta1.migadu.com (out-43.mta1.migadu.com [95.215.58.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA4A43F8AC
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 09:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790241365; cv=none; b=fW0kkCUxRUjvAwFDFE6smfgRsfc5y6WSH3t6ujni5cBhMHLQG5ddkYE+RiFhBiBpUQa+g8KT5yxXmngVHK7tURcE8smuYhOpnsbaBB1ycwcXf8/36wJco17tVIeYENRPagmRHD3fXa9TNmv1OixVPnoxuBdD5BBxXPxJBrKyMds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790241365; c=relaxed/simple;
	bh=j4fPj55lYae/y5tdy10+TEYjmKUlPO6ycJwyC1KIIrk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FNziec9P/K9lPtOfuMQ1aaz3hIwO1FiwCikf8OdziCu1SaFXoOnjmvjzi/FZ+iRkB2np1SzOnt34IL9rr1eSi+AaUc5cG5oNa9plOmq5wyzdBEHRWcDHJOGXKKJtXQJS/8uLQOQIPH8b/ghmo6jXZmlILI22Q3UwcOBo2gyb3H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CYg4F3NV; arc=none smtp.client-ip=95.215.58.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CYg4F3NV"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=j4fPj55lYae/y5tdy10+TEYjmKUlPO6ycJwyC1KIIrk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790241358; v=1; x=1790846158;
 b=CYg4F3NVjRUy+Uarg7Z3sd/kZP/B1vMlwY7W2HiSAebBQaJyDSF/yv8LTgvWuySZFAIJkZ2M
 /5zaJjkc0LoGES7o224ea6ZGYbi9pUwDu7kbD5Iwg5bRqrUnbcWYkmazmEdby4uRylDUaO+/S8L
 YydK10YoBooNN86ZUPNvNdbA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 26b6c31f36dc8543;
	Thu, 24 Sep 2026 09:15:57 +0000
X-Mizu-Trace-ID: 26b6c31f36dc8543
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH] cgroup/pids: Restore pids.events notifications in local mode
Date: Thu, 24 Sep 2026 17:15:36 +0800
Message-ID: <20260924091536.63572-1-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

A fork rejected by the pids controller increments the counter reported by
pids.events. When local event accounting is selected, however, pids_event()
returns after notifying only events_local_file, leaving pids.events pollers
asleep.

On legacy hierarchies, pids.events.local does not exist. With
pids_localevents, pids.events reports the same local counter. In both
cases, pids.events changes without generating a notification.

This can be reproduced with a pids_localevents mount:

    mkdir /tmp/test
    mount -t cgroup2 -o pids_localevents none /tmp/test
    mkdir /tmp/test/t
    echo 1 > /tmp/test/t/pids.max
    cat /tmp/test/t/pids.events                 # max 0
    timeout 3 inotifywait -e modify /tmp/test/t/pids.events &
    sh -c 'echo $$ > /tmp/test/t/cgroup.procs; (true &)' 2>/dev/null
    wait
    cat /tmp/test/t/pids.events                 # max 1

Without this patch, inotifywait times out without reporting an event.
Notify pids.events before returning from the local event path.

Fixes: 3f26a885a068 ("cgroup/pids: Add pids.events.local")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 kernel/cgroup/pids.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/cgroup/pids.c b/kernel/cgroup/pids.c
index ecbb839d2acb..8444e270554a 100644
--- a/kernel/cgroup/pids.c
+++ b/kernel/cgroup/pids.c
@@ -253,6 +253,11 @@ static void pids_event(struct pids_cgroup *pids_forking,
 	}
 	if (!cgroup_subsys_on_dfl(pids_cgrp_subsys) ||
 	    cgrp_dfl_root.flags & CGRP_ROOT_PIDS_LOCAL_EVENTS) {
+		/*
+		 * pids.events reports the local counter on legacy hierarchies and
+		 * when pids_localevents is enabled.
+		 */
+		cgroup_file_notify(&p->events_file);
 		cgroup_file_notify(&p->events_local_file);
 		return;
 	}
-- 
2.43.0

