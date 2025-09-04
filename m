Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0AF267733;
	Thu,  4 Sep 2025 21:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757021204; cv=none; b=uI0RUjnSUL1+TNfMKFvEZGY43DkfO80YwOqvQE4yvK1cAqITLqOVpjWf8gLh5q0+FX88/bhB2Qxo3n/obu4GPLrKUkYoukhZBPlg/kIzVhY3COa/3upQhMHWDMkm6xK55yeFFzD2R+lJaFyQR+9qmbIZvaChkO0AdiLVKtWk5mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757021204; c=relaxed/simple;
	bh=6X3563M2mbjaMI94C/dDyk0VB96o3B0QsmVXKrJa0/E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gryD7vEtD5HfMZTLUFk58QdfApp4kHa+UjKhRa4mPByzAMQxZpm4jub4ocTsQv4fqkrvC8D1g125A8Fp/Pys+LVH3q5nwE8IEkTMQ1ab7/WZ/yOWfEqCgFj7+nPsoebxr5dELbvXGxH3FjNPeB3aDj6sfyY7SpER+SqhklhdOZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JIMEy3jU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JIMEy3jU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480B3C4CEF0;
	Thu,  4 Sep 2025 21:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757021204;
	bh=6X3563M2mbjaMI94C/dDyk0VB96o3B0QsmVXKrJa0/E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JIMEy3jUAnC/0h8n0rjJJ3r/hf3bTfvXMeVj8JAGEzqnaKlM/TIryv1PmAelQ+Fry
	 GeJ04ryKPZlnxa9+sdmtAQiZY5twb4opjax1VOofqkjP++LzO3O+JT56N3IkgbjwSe
	 SEXFyo2PVzL4tWQ7VXdUQFk1QyykR1MO0STy/aJl1dm0WsgTUkxpUuaGBbdwx0Hsj7
	 txKrS62NQgMPC2Wh4+hISlIfjU/5IKd2nHwGJKFWCtof+XYyUdGhqj/8dL2DcS0oSk
	 68i3Xvy6c922EAtStak2vPEQFmlxlZXcVhKqDTc2Z8oS6CsFNYZBwNPnvoSkUOqC5+
	 o3gb+r6dMDYHQ==
Date: Thu, 4 Sep 2025 11:26:43 -1000
From: Tejun Heo <tj@kernel.org>
To: kernel test robot <lkp@intel.com>
Cc: Chuyi Zhou <zhouchuyi@bytedance.com>, llvm@lists.linux.dev,
	oe-kbuild-all@lists.linux.dev, cgroups@vger.kernel.org
Subject: [PATCH cgroup/for-6.18] cgroup: Remove unused local variables from
 cgroup_procs_write_finish()
Message-ID: <aLoEE9o-DKeVo1id@slm.duckdns.org>
References: <202509050527.YEPZiaXZ-lkp@intel.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202509050527.YEPZiaXZ-lkp@intel.com>

From 222f83d5ab86344010f9e121799202b9ab25375b Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Thu, 4 Sep 2025 11:23:43 -1000

d8b269e009bb ("cgroup: Remove unused cgroup_subsys::post_attach") made $ss
and $ssid unused but didn't drop them leading to compilation warnings. Drop
them.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Chuyi Zhou <zhouchuyi@bytedance.com>
---
Applied to cgroup/for-6.18.

Thanks.

 kernel/cgroup/cgroup.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 0dc6ad71f175..e7acfaa49517 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3026,9 +3026,6 @@ struct task_struct *cgroup_procs_write_start(char *buf, bool threadgroup,
 
 void cgroup_procs_write_finish(struct task_struct *task, bool threadgroup_locked)
 {
-	struct cgroup_subsys *ss;
-	int ssid;
-
 	/* release reference from cgroup_procs_write_start() */
 	put_task_struct(task);
 
-- 
2.51.0

