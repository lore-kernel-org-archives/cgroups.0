Received: from mta1.migadu.com (out-71.mta1.migadu.com [95.215.58.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558F135FF6C
	for <cgroups@vger.kernel.org>; Sat, 10 Oct 2026 08:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791619216; cv=none; b=K9fhkVcqgvZWbrro6fP9100ePmIh+qJBArpUCkbtNnrqj39aWXMLWDmWlikfNgS5YLsE36aHPabLS7hcjtaUdbwvEPOE47hcBxowN7MtufkhRIukZ5uA9j9ayNWjEyCaDm/lNoLlBuytggfiKC318Q9pDIzipeuRg4KXCvVk6lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791619216; c=relaxed/simple;
	bh=p0AI5n+riIxZ5JkCgM3O+7zB4u43RyxG0DXFWAAWyFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XhXdhJVZeTn92VSVuS1ljRABZDEaHXTdu8rHklNbSVDBn4lOOigdl+HXet+nJv6LItBrp3dTq/YVH5AlOn0TV1cerghy6WfjvjC8gv975hVbsYyVAuotWFaVZ1a7/ezMk93w2VPpeHOacpVy3CHGvIyhoc4U/geP6NruN9cc8fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Y2MbOI7T; arc=none smtp.client-ip=95.215.58.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Y2MbOI7T"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=p0AI5n+riIxZ5JkCgM3O+7zB4u43RyxG0DXFWAAWyFQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791619213; v=1; x=1792224013;
 b=Y2MbOI7TPuOFrELBaVc8NaX4278O19CQqIw7vjeMy41yHGZa0kDrh4+c/NTSLbFa03iTwTXC
 Gs+Cj3nrO6ReKbVqq9E05ymq4ezQamWYK9W7OEUd3/lDm45KOZUxBwbwssX7Z+7tld/Axym+DjT
 zCaTffz7yOhBfdxkqZfufNn0=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 986908dd76835a70;
	Sat, 10 Oct 2026 08:00:12 +0000
X-Mizu-Trace-ID: 986908dd76835a70
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Ridong Chen <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH 2/2] cgroup/cpuset: Fix invalid local partition recovery
Date: Sat, 10 Oct 2026 15:59:47 +0800
Message-ID: <20261010075947.333549-3-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261010075947.333549-1-guopeng.zhang@linux.dev>
References: <20261010075947.333549-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

An invalid local partition may fail to recover after its exclusive CPU
list is changed to a valid one.

This can be reproduced on a cgroup v2 system with CPUs 0-7 online:

    cd /sys/fs/cgroup
    echo +cpuset > cgroup.subtree_control
    mkdir A
    echo 0-7 > A/cpuset.cpus
    echo 0-7 > A/cpuset.cpus.exclusive
    echo root > A/cpuset.cpus.partition
    cat A/cpuset.cpus.partition
    echo 1 > A/cpuset.cpus.exclusive
    cat A/cpuset.cpus.partition

The first read reports root invalid because all CPUs were requested.
After the mask is changed to CPU 1, the partition should become valid,
but it remains invalid with PERR_NOCPUS.

update_exclusive_cpumask() calls partition_cpus_change() before updating
cs->exclusive_cpus. update_parent_effective_cpumask() then gets the
old 0-7 mask from user_xcpus() and sets PERR_NOCPUS even though the new
mask leaves CPUs for the parent.

Move the exclusive_cpus update before partition_cpus_change() so that
the partition update sees the new mask.

Fixes: 46c521bac592 ("cgroup/cpuset: Enable invalid to valid local partition transition")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 kernel/cgroup/cpuset.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index de7553459adc..e96bc66ffa07 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2546,10 +2546,14 @@ static int update_exclusive_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 		return -ENOMEM;
 
 	trialcs->prs_err = PERR_NONE;
-	partition_cpus_change(cs, trialcs, &tmp);
 
 	spin_lock_irq(&callback_lock);
 	cpumask_copy(cs->exclusive_cpus, trialcs->exclusive_cpus);
+	spin_unlock_irq(&callback_lock);
+
+	partition_cpus_change(cs, trialcs, &tmp);
+
+	spin_lock_irq(&callback_lock);
 	cpumask_copy(cs->effective_xcpus, trialcs->effective_xcpus);
 	if ((old_prs > 0) && !is_partition_valid(cs))
 		reset_partition_data(cs);
-- 
2.43.0

