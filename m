Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B60198845;
	Mon, 26 Aug 2024 22:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724713108; cv=none; b=MQXJeWgZIxKp3IrMElnIQ5whqgAHSX+J/5nMppI1brvoKWllaQJP4G1EbholvSABhp/clAcWEYBXzcKDodRSTAnCnEUKaTftloMfFcAC2RoqjBuoJwMEcfFiT4jIRP8UbfUDoQnrXbzO54raKZfZuEK2vQFQ7jfydZiC36t+ouI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724713108; c=relaxed/simple;
	bh=e6lLBcx4ERTTLg8tRujSMSZE/P5cT3AkTyBpKv97ESU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a89MgEJD3r/0SfDEQe9vpzHhUp0GdgAXhxn9Q9yhbsNl8L5mb02/HH2GLMw6sfeH8CtmuiOiZpGDqIyRuQzPjAAAHo8sqJiGBNtZ0cqGEEVLp//UrsC4TFMNdkstNjTCUetRjg4OxXn48hbvn5e885kdmkmwaqa2ogCtBb2PCGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FTFbxB8S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FTFbxB8S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F48FC8B7A1;
	Mon, 26 Aug 2024 22:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724713107;
	bh=e6lLBcx4ERTTLg8tRujSMSZE/P5cT3AkTyBpKv97ESU=;
	h=From:To:Cc:Subject:Date:From;
	b=FTFbxB8STnSYaaw04zm/Ayp3R2ovXuQCGJCe3vU5hfYRb6S9b6PLTJo0M4lLSVfCv
	 W4rKGmb1xJjum0w06xylUoRlZjF2Fr7s9OUFGqvCHoq7dY4xSp6gmEsOZjXUPQvJJM
	 CW91ItY+M/vmmEucyGIRUfVzVaQzrB4V3w+N39PNd9MwH1XMca04zfEoaXeaxCfPNA
	 bRBxa4apHRS6dx/Zi20ZSbcSUW1e1MPw0w47rgGuHlxi3wysOwlhNbKsX8aUBOC22s
	 J0yIIRexDd8w2gR6iWWbVAZv8HMG2JLfHl5kM/HZ6BJ4O56mQAWKXntfEUBaFGPQu4
	 6iayWTYkWgmBQ==
From: Tejun Heo <tj@kernel.org>
To: void@manifault.com,
	peterz@infradead.org,
	mingo@redhat.com
Cc: cgroups@vger.kernel.org,
	lizefan.x@bytedance.com,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org
Subject: [PATCHSET v2 sched_ext/for-6.12] sched_ext: Add cgroup support
Date: Mon, 26 Aug 2024 12:57:38 -1000
Message-ID: <20240826225822.791578-1-tj@kernel.org>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is v2 of sched_ext cgroup support patchset. Changes from v1
(http://lkml.kernel.org/r/20240808002550.731248-1-tj@kernel.org) are:

- cgroup interface file visiblity toggling based on SCX_OPS flags is dropped
  as it caused more confusion than helping anything. sched_ext now just
  warns when unimplemented features are used.

This was originally taken from the cgroup integration part of the sched_ext
v6 patchset:

  http://lkml.kernel.org/r/20240501151312.635565-1-tj@kernel.org

This patchset is on top of sched_ext/for-6.12 (9ad2861b773d ("sched_ext:
Allow dequeue_task_scx to fail")) and contains the following patches:

 0001-sched-Expose-css_tg.patch
 0002-sched-Make-cpu_shares_read_u64-use-tg_weight.patch
 0003-sched-Introduce-CONFIG_GROUP_SCHED_WEIGHT.patch
 0004-sched_ext-Add-cgroup-support.patch
 0005-sched_ext-Add-a-cgroup-scheduler-which-uses-flattene.patch

 0001-0003 are sched core preparations. Straightforward. No functional
 changes.

 0004 adds cgroup support to sched_ext.

 0005 implements an example scheduler which uses the cgroup support.

The patchset is also available in the following git branch:

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/sched_ext.git scx-cgroup-v2

diffstat follows. Thanks.

 include/linux/sched/ext.h                       |    3
 init/Kconfig                                    |   10
 kernel/sched/core.c                             |   98 +++-
 kernel/sched/ext.c                              |  519 ++++++++++++++++++++++++-
 kernel/sched/ext.h                              |   22 +
 kernel/sched/sched.h                            |   14
 tools/sched_ext/Makefile                        |    2
 tools/sched_ext/README.md                       |   12
 tools/sched_ext/include/scx/common.bpf.h        |    1
 tools/sched_ext/scx_flatcg.bpf.c                |  949 ++++++++++++++++++++++++++++++++++++++++++++++
 tools/sched_ext/scx_flatcg.c                    |  233 +++++++++++
 tools/sched_ext/scx_flatcg.h                    |   51 ++
 tools/testing/selftests/sched_ext/maximal.bpf.c |   32 +
 13 files changed, 1906 insertions(+), 40 deletions(-)

--
tejun
