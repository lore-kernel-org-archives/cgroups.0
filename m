Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794127301;
	b=PiA53mDc29oVHgewxKheiEPTCH5JMbex7g/bDEFc5g7ZC2XbUfyVb6ZTwDJ1/xRajud1
	 XqG9msiJMjEjTiyd9r8XxyGIBDtHX9Ty/c+3SDDnXKviGGzgEA/bADQkn01otyCNGp291
	 zZ1j3GNu/655YGoUJglhC94wFlHOFlbPsH51RS6S4Y2BPyKVuQWql8vfJnr1K60FlZVR8
	 7OHCrC4k3tyWw+PCuyyjKMAkOWtQN3IAGNb+ZY1BCxeLMJ2PJZXbN5Zc6ESiNfFPBhBKt
	 x9uGg+75cB9uWdHPPQBqzakeZjgS6XhT8EF0podVCg1n5+RmzVWURM9/SNoc0ht//9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794127301;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:User-Agent;
	bh=04OWJWl0q4USzjLVzwemPm053ugbzZoSSOQ6EL5Fbvs=;
	b=pgaLlNDtP+YrMteJSwatw5JbcVqGvDTPGUfs9EU5cLjMbT+HOSmZs9BWyA0dkRrjreMS
	 fJOD56GZstnwIfPY9NDJMj3wf2Twy9OYptqc8cccxUL/lZkYL99RqDv/TfXSdXTcliBfU
	 VQNCIEWSSE1VNqoAwx2IG7r+oEUKnxdRNkMBZOu9cLIr1nMry5qevowK4tA9JCXReWX5e
	 msg2b1WgUaCtNtC9KQjIZTnYEA/fkveJfHCxm26VxLw1zBeKzX0G450nuXh/x0HA9x8t/
	 ijZSmD2ile5RVQpqugMeKHpvzElP2Ad9qcs3u5Dzr7E2C52wvCOQpw7wyEM/3/yBCPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=d4G+Qk7i;
	arc=none smtp.remote-ip=209.85.216.50
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB28606A31C
	for <cgroups@vger.kernel.org>; Sun,  8 Nov 2026 08:41:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AAB28606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=d4G+Qk7i
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3ada8bc2380so123317a91.3
        for <cgroups@vger.kernel.org>; Sun, 08 Nov 2026 00:41:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794127300; x=1794732100; darn=vger.kernel.org;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=04OWJWl0q4USzjLVzwemPm053ugbzZoSSOQ6EL5Fbvs=;
        b=d4G+Qk7i9L7YqnXb63Yt8hNFVlT9F14ZiFmxza3GzeCu8eU7/7uSBFQfb6vy08FOlW
         X/Po1s3J4ztNeKa6n71PqF1FHeBsFng7jQJxQfOQjplrHxf+TvCfin+simyiUHXuU2EC
         X8H+K6tMSmyw5qBXCO+tth7JyW4GlR3KP3g50=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794127300; x=1794732100;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=04OWJWl0q4USzjLVzwemPm053ugbzZoSSOQ6EL5Fbvs=;
        b=xSU2NQUAdOxWd0oIUwiQ6mC0W6XZOl5h7dSYTSdsKOg0ZE+O3/s1iDOksEG5PG5Z53
         MV57sdmVD7BCIHdUSRuk472IeES0zh4IPHq1rRIJpfqD4jte7TUyFXH/DvNbKG3DDTqW
         1gKpF0YRvgLVA+QeQAhJhm6s3c9Z5AOgLfd0hEEsI2hIokyeQrXmq2FbaGbdYMS2wIu5
         xgRtWyS8l1nfjRlDO9nKf6sqEgAk9/W3XfaoU3Cz1oGWiKZ1n0svacP3Pxsmh9NDe6Dy
         +Ywk7b6eQG5SYpREijkE1sHxwtph939GDeCQgLad0BNzDs/Lu+zK69Iaz9cITWSI8xsj
         MaGw==
X-Forwarded-Encrypted: i=1; AL+hErGhIUHOsQJfDMaTxnx4g+sWSXduMlDXb7R8VI2xJbkocJkILDa3LK5JnB6guJWSx8E/kuyIKKlp@vger.kernel.org
X-Gm-Message-State: APuU4Z+s4M+3XI/dCudC6Nn1r0gACFZ+iHJeXMM/+5BRxHcXwNxfm/qm
	ZQt+gmcbmOxf8naTUZ9h4Vawj5CXd+BgpeL1yJKAsHI7Xygn2jkikD1kC3Ufcf4MOMmL8IdgOAd
	VFtvlaEgwISBh
X-Gm-Gg: AYBFou32ruQL/tFEQZZAP9OVczcMFGlOyH1yeRmSgpf4mJrGitHWcv0Z7S3/VU7JikJ
	p99L1PzfTfN0+BNKPiyTerSrK7nFl7bFEfFI11VKj8/qdj4nBr3pyBrbb2dK5Jkph3z6wdqsNqM
	LVSsdtyubMufsb/PUTqb4usAcdIV/1sUO1r/bCiyrOxo+kTXq+ct9JPoJ77BPMUsc6lv4pR114z
	Nu/zY8TiUFAW8KzGzth0SAIzN7K48xHpAzRQ3qXH/hcAA8L6+iEtTFKvj1mUkNxcnWkykgKO+FT
	uDmS7q0LeUKUVc06qtThR1IwZU64mtQD47Iya/WsLg+2Py/yjSPnd69Ug/+ChW6fsxDdaxxZ/j+
	0y6bdWCzbDKH6JE8RjPVqHY3SKRk3/VVEOJrTlWQDcLYlmGdxrc0HohhOxaf2cZxdDMzQA/s84h
	yX+70oEsnfzy1f9JIy9k66K5JGNpGfasNNorbyTiUBP4P2McMnLgdR9UWDJvm0L56dqrTrqvthM
	T1KKHxWf2x48LoE7esTp51SPfAgoMsoSuPNPbavBuQ4q7KTn/6zMEm8w08TsfwKxjB8CWUOsVJS
	52EM7pe1+/3Ur+7FKZnUDmMOFSdfEWW1KmPM6XWo/1Xcp7YpIbKE8FORDrMhbHTAjLeBHN8Sp2a
	eg/eeB69PNo/6x988OT7c/LMm6bYvQk9oduSH4RXlH7+7c5iGJzECgtsYnrdIkmxG0Nj+kgz1Gi
	LOQvDB2wH9VAS+JyVy85RUIGYGcPF81m4mi946Hb2GOXE5hcUDkHob
X-Received: by 2002:a17:90b:4b83:b0:3b0:ac2c:1619 with SMTP id 98e67ed59e1d1-3b12d3e713amr651515a91.39.1794127299954;
        Sun, 08 Nov 2026 00:41:39 -0800 (PST)
Received: from localhost ([50.175.87.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b101bc4586sm3906321a91.2.2026.11.08.00.41.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 00:41:39 -0800 (PST)
Date: Sun, 8 Nov 2026 00:41:37 -0800
From: Chris Down <chris@chrisdown.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Zhan Xusheng <zhanxusheng1024@gmail.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v2] mm: memcontrol: Don't lose track of exiting OOM victims
Message-ID: <avA1wXhTMs9eY2NF@chrisdown.name>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)

When oom_evaluate_task() comes across a victim we've already killed, it
backs off until the victim's mm has MMF_OOM_SKIP. This gives the victim
a chance to free some memory before we kill anything else. However,
since commit a72f73c4dd9b ("cgroup: Don't expose dead tasks in cgroup"),
css_task_iter skips exiting tasks once signal->live reaches zero. That
happens before exit_mm(), so a single-threaded victim can disappear
from the memcg scan while it still has all its memory.

This can kill another process when the first kill would have been
enough to recover, and we've seen it happen in production. If the
second victim is in a cgroup with memory.oom.group enabled, the extra
kill can take down the whole workload.

In tests I used a 64 MiB memcg with swap disabled. I started a process
that faults in 44 MiB of anonymous memory, submits a 4 KiB direct AIO
read to null_blk, and goes to sleep. I set null_blk to take 10 seconds
to complete the read so the victim would have to wait for it in
exit_aio(). Two seconds after starting the first process, I started a
second one that tries to fault in 40 MiB.

The 40 MiB allocation hits memory.max partway through and triggers an
OOM kill. The OOM killer picks the first process, which has more
resident memory. With the read still pending, the victim blocks in
exit_aio() before it can tear down its address space.

memory.events showed oom_kill 2 in three runs. In one of them the first
process hadn't submitted the read yet when it was killed. The slow read
just makes the window easier to hit.

The cgroup iterator hides these tasks so that cgroup.procs doesn't
show processes that waitpid() may already have reaped. That's fine for
cgroup.procs, but the OOM scan needs to see a victim even after its last
thread has started exiting. We already have CSS_TASK_ITER_WITH_DEAD
for sched_ext, so use it for mem_cgroup_scan_tasks() as well.

With this applied, OOM selection backs off while the first victim still
has memory to free. The 40 MiB allocation completes and memory.events
shows oom_kill 1 in three test runs.

Fixes: a72f73c4dd9b ("cgroup: Don't expose dead tasks in cgroup")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chris Down <chris@chrisdown.name>
---
v2: Give more concrete details in changelog (akpm)

 mm/memcontrol.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 84f4a8fd4d16..cb7cfae9ce5a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1451,7 +1451,13 @@ void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 		struct css_task_iter it;
 		struct task_struct *task;
 
-		css_task_iter_start(&iter->css, CSS_TASK_ITER_PROCS, &it);
+		/*
+		 * An OOM victim can start exiting well before its mm is
+		 * torn down. Keep it visible so oom_evaluate_task() can
+		 * back off while there's still memory to free.
+		 */
+		css_task_iter_start(&iter->css, CSS_TASK_ITER_PROCS |
+				    CSS_TASK_ITER_WITH_DEAD, &it);
 		while (!ret && (task = css_task_iter_next(&it))) {
 			ret = fn(task, arg);
 			/* Avoid potential softlockup warning */

base-commit: fa4ad798f6f681031775266044ba1b0cf3c670bd
