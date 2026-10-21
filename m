Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792605050;
	b=Ij/0zj5YJlDrCtKog8gFprDxDBsjc3P8PCKgaN9YbOrNtTi2XN7TAOuZ8GfeUTU/r40/
	 XBz0BOjYCHnRSLDU8CHmihA3tmMY8xGEmUBw859h8P1wiVU0QlJJL7+8NCG66/Bmt4Xv/
	 a5GfWtOCBZfab8Nb8coEb4xqeEFsVyczgadxT5UXSXizytxG0MhP/Vda6TzxsDhRZj1Yw
	 TtMANoWyVXTEPn+/tjs7pozX7p88kA4qefpU1o4FHve3bQ5maQSoWATjO4SfA7LMwymgD
	 JL67HJOPO4zi8lFKrF7i/1N4fGaYV57Yc3kGC74o1D1Npj6oRqez0gph660M4EZHloA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792605050;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=mE9Ag/gCpQwpic9Sbpc9hGK5nNJZ45oi/KyynO+C5Ws=;
	b=wMWkKfwUIJzLfzOV2OaIlfvzI/tsUj8LKG4NByCq9JfdtHTtoGvM4Rz5u/7D2NzrYxo6
	 jzb8EKUICvukgZu2p7fjB8Wc8daEYBAitFQLsgRyxtSZT9si/KCyKJj3mmoCVVJdCttp4
	 246GlK5HEw2zqvrikKIqVK6YFF7XiNV1G6qtDiaUlYozEc6y5ppbjL7K9f349m67fcvKW
	 lgH8jTQKFaIUox8kUOmxHmSCfRXp+/o3+1cIFzPshysQmwHIxnOX7FuWSno4DOoCQkKec
	 UDXVAfWjMX6ilJusthwWBoy4XVLnbftYFAnY5q1rhxUobVb0IX2UdLmrFsY+sOnb2wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=trailofbits.com;
	spf=pass smtp.mailfrom=trailofbits.com;
	dkim=pass header.d=trailofbits.com header.i=@trailofbits.com header.a=rsa-sha256 header.s=google header.b=AcdzYn+x;
	arc=none smtp.remote-ip=74.125.82.43
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5624B606A31B
	for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 17:50:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5624B606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=trailofbits.com header.i=@trailofbits.com header.a=rsa-sha256 header.s=google header.b=AcdzYn+x
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-192faaff686so17865c88.1
        for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 10:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1792605049; x=1793209849; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mE9Ag/gCpQwpic9Sbpc9hGK5nNJZ45oi/KyynO+C5Ws=;
        b=AcdzYn+xJgZ24qhdgNzJ+znHcPBAcXz72e9f4fQNiIdR9DHJ88983AMvTE3ngzyFC7
         SDCp43YiGEg2N4XU5y9IxSku8AVhcBQifpG6b+xFWQnuaUlWF9eKV6mIv1RvQan4ZlRi
         A9tHlhTbISYlznruJmqYxa1i5DlWZ1i41oAkZUkiMLDZRtM51ZkD4+XEWQBcQnhAHTow
         3uG185oH+MfhXlZiE12QtsqR6cagzCQoEmcGwZ9t3m3bGudFO8B9vNQh02gnj6beJXsG
         HBNvvitmYn6+WQzRXLedcKF7QS4HnyyjH8bwxj1aB5uT88pEdpQBBl5Ih/61fj7fuIIF
         Trxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792605049; x=1793209849;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mE9Ag/gCpQwpic9Sbpc9hGK5nNJZ45oi/KyynO+C5Ws=;
        b=AXL6lOmByYL9v+C8lUshDb/IzCWW+7vuAGueX3XPfxHgOyrkjjHqSe0O6FBmOq6G+t
         1TVpgUHvdQO/L1n7b+yQaGx+3PEvlCvYo27LkU5tx8QHwyF+GyEpi9ICxWuhx4xuEUOx
         ppNG1WS08RIVweIi5SiEATl+xtzO9/Ep40xfQh2Nf5Uf1XDgh+h/dqH1WM1MNAyx0v/D
         EZXjY2Lr4vUch8g/d+owTBZseK6Yf42g5CKgPTqpNf7k3ladRe0gw1u9L1Z3XwCEg5/9
         9/hrLzghpvB9smILVNQLBVM2Ic67uFp+Sa9MJyboYqmTs4WtZBlCRl7+I6cB9THbhu7k
         bXxw==
X-Gm-Message-State: AFq9FYLm3whU50vWbl3JOTyNhilWXuzPWBNOiuGAjrHjWqstSh5DRmW/
	luL2bhSEIaJYQyhSu7n+G1HtgYmVXcRgbwm/tTEVMpev8buc150m/W3cUrLJ5WeQ2jx+e5Cv7Fl
	6T+5eXGTkhg==
X-Gm-Gg: AYBFou2Ct1BRz0V5wcWs5y8xsGacZc8j4B9cX+qLoIpd0t1+chi9lS8m6kPkCfMhf/G
	sUywP1dBhq6usNlmLP00gvzEG7+NX5B8FpGNHJqJjexg2MWmFxaBaCVkwRSVeC+PxteUoIkxhnU
	nOkg7o4zWlDHgkk+kYNj+DqpzFS9pMI+FKoro2+r3R11aaroGcpY+R+QyxYG/ML5UlADLE+96dm
	hArGXvyVdZcK/Me3uLctHw0qT3M9YKcjTzXFMABEvawZI4LRJAs2jxRskDST47nq1RaCgu39EmL
	3yrm2XmNT9CMuVkR2cj/Zjuonh832JnywwTEuvFmFUSDfUHjMuA4Ib7jh+UtIBbTjI6FsH80CiV
	611VXKfihzl01MwiX74OU+zh4XlSBGqoOXuH5gg6dzoMqUXj7kbo7yllQCBmXWTQp8iZ8yoi2RT
	dXGFq71wu3lFH0u1qNkwH3GGNH4gGZwhriNDZWlpqeyI5u+QjdtZrqcAIv7iPy9Sw4PukEfeWop
	rAT5cmxKOoFlnfmMvvPDOdK3wEMujHWlQZ8cpgBFwBq9xsGAXwPXEF9H63EPqtL5XrRe1pvW+CO
	Y6TRSvvKEVCOoaeeITeljpUuIq4QuSq6eefXNSy9A57qv2W3rB3v
X-Received: by 2002:a05:701b:424e:20b0:143:298f:33b8 with SMTP id a92af1059eb24-190a7756cafmr3521892c88.44.1792605049249;
        Wed, 21 Oct 2026 10:50:49 -0700 (PDT)
Received: from localhost.localdomain ([2603:8001:5f01:8bab:d059:e601:becb:a5ad])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1903ca044d4sm8229754c88.17.2026.10.21.10.50.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 21 Oct 2026 10:50:48 -0700 (PDT)
From: Artem Dinaburg <artem@trailofbits.com>
To: stable@vger.kernel.org
Cc: cgroups@vger.kernel.org,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	longman@redhat.com,
	mkoutny@suse.com,
	ridong.chen@linux.dev,
	tj@kernel.org
Subject: [PATCH 6.6.y] cgroup/cpuset: Make nr_deadline_tasks an atomic_t
Date: Wed, 21 Oct 2026 13:50:45 -0400
Message-ID: <20261021175045.1443-1-artem@trailofbits.com>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Waiman Long <longman@redhat.com>

[ Upstream commit 95220e1f18f6321008f021abc7d6f581f64bcb82 ]

The nr_deadline_tasks variable in the cpuset structure was introduced by
commit 6c24849f5515 ("sched/cpuset: Keep track of SCHED_DEADLINE task
in cpusets"). It is reported by sashiko [1] that nr_deadline_tasks
can currently be modified by inc_dl_tasks_cs() under rq->lock and
by cpuset_attach() under cpuset_mutex. So if both updates happen
simultaneously, the nr_deadline_tasks variable can be corrupted leading
to incorrect operations down the road.

Fix that by changing its type to atomic_t so that nr_deadline_tasks
are always atomically updated. This fix patch is a low hanging fruit.
It can handle some of the races between a concurrent sched_setscheduler()
and cpuset_can_attach()/cpuset_attach() calls, but not all of them like
the other issue raised by sashiko [2]. This will be handled hopefully
in a future follow up patch.

[1] https://sashiko.dev/#/patchset/20260626181923.133658-1-longman%40redhat.com
[2] https://sashiko.dev/#/patchset/20260630033344.352702-1-longman%40redhat.com

Fixes: 6c24849f5515 ("sched/cpuset: Keep track of SCHED_DEADLINE task in cpusets")
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Assisted-by: LLM
[ Backport to 6.6.y: Apply the declaration change in
  kernel/cgroup/cpuset.c; struct cpuset has not moved to
  cpuset-internal.h. ]
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
---
Hi,

Please consider this backport of the fix for CVE-2026-93150 to 6.6.y.

The code changes are identical to upstream, with the field declaration
applied in cpuset.c. See the bracketed backport note above.

The complete fix is already present in 6.12.y, 6.18.y and 7.2.y.

Build-tested only as part of a cumulative 6.6.y series on x86_64
(allmodconfig, CONFIG_WERROR=y); no runtime testing.

Thanks,
Artem Dinaburg

 kernel/cgroup/cpuset.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index bb413045d174469d9f5f8187af2de50d3c4076fd..4dc4b326781a8ffb93f503255eb5a026180adb23 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -175,7 +175,7 @@ struct cpuset {
 	 * number of SCHED_DEADLINE tasks attached to this cpuset, so that we
 	 * know when to rebuild associated root domain bandwidth information.
 	 */
-	int nr_deadline_tasks;
+	atomic_t nr_deadline_tasks;
 	int nr_migrate_dl_tasks;
 	u64 sum_migrate_dl_bw;
 
@@ -235,14 +235,14 @@ void inc_dl_tasks_cs(struct task_struct *p)
 {
 	struct cpuset *cs = task_cs(p);
 
-	cs->nr_deadline_tasks++;
+	atomic_inc(&cs->nr_deadline_tasks);
 }
 
 void dec_dl_tasks_cs(struct task_struct *p)
 {
 	struct cpuset *cs = task_cs(p);
 
-	cs->nr_deadline_tasks--;
+	atomic_dec(&cs->nr_deadline_tasks);
 }
 
 /* bits in struct cpuset flags field */
@@ -1091,7 +1091,7 @@ static void dl_update_tasks_root_domain(struct cpuset *cs)
 	struct css_task_iter it;
 	struct task_struct *task;
 
-	if (cs->nr_deadline_tasks == 0)
+	if (atomic_read(&cs->nr_deadline_tasks) == 0)
 		return;
 
 	css_task_iter_start(&cs->css, 0, &it);
@@ -2757,8 +2757,8 @@ out:
 	cs->old_mems_allowed = cpuset_attach_nodemask_to;
 
 	if (cs->nr_migrate_dl_tasks) {
-		cs->nr_deadline_tasks += cs->nr_migrate_dl_tasks;
-		oldcs->nr_deadline_tasks -= cs->nr_migrate_dl_tasks;
+		atomic_add(cs->nr_migrate_dl_tasks, &cs->nr_deadline_tasks);
+		atomic_sub(cs->nr_migrate_dl_tasks, &oldcs->nr_deadline_tasks);
 		reset_migrate_dl_data(cs);
 	}
 
