Received: from mail-pz2-f17.google.com (mail-pz2-f17.google.com [74.125.228.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535C13655C2
	for <cgroups@vger.kernel.org>; Sun, 20 Sep 2026 03:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789873502; cv=none; b=CwxZW9mD9RohXhWW0PQ3n1ojzhgftEoRcwKMgaspU93uxT1I2rDW31M+5ZuGhBbm/W+UU9FR8PynwWN2J02O9gBtOT81DqI5af72BXav9S+SlxuKL+415hrelX+do+UKg5Yj+zLTUllUzlB7Jn+CD66PuSpwiKhBcGADM6Vrdqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789873502; c=relaxed/simple;
	bh=PQKfce6qNobeV66Tulqhji9RvgMUcyKHoQd16SQ70f8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jDTWWyDc+p4Ht5asZUNBImrvHd1rptosmZ34OLmeySyk0i+0ZlOSJMayHQ0kOs7GhK/kvkU/HeCYH7WGIsFBliW317JpcfaVjonasz4eg84dfJnqX0dP5gNEuMheDI/wyZYbEDo/w5GxeIFH69yXstbA3pmdvceWTllTbSnOpps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FT9lR/Yr; arc=none smtp.client-ip=74.125.228.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FT9lR/Yr"
Received: by mail-pz2-f17.google.com with SMTP id 41be03b00d2f7-cc4c3304784so1710961a12.3
        for <cgroups@vger.kernel.org>; Sat, 19 Sep 2026 20:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789873501; x=1790478301; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/N3tbEyac1V2m5E+SXDSzpZs6SujX/8UcS11enQcxbI=;
        b=FT9lR/YrXgjHodppbmUx+IjoZFdxcoqQdw8rEYzrb+Mo/ippLk88HRCR4vC48SzhMv
         YcPWdlCsTyb0uFE9YS+xEaIWQATivJhSvUiEoP3alwYwtfdD4xxfFWF4ADNsR7Y/yTiB
         TFQ/zOi0jxJbwed5s/AP6qFku3eHuwYS4pfGfBRtCcQV2jdarrB21Oe2fxhDfko/ri31
         HbcSOSlfQLfCnPUMnI7GALbyXYPFHGpaZ9tBS98730NtvLUuP7U8Zub/tj26ufUzE8CY
         ohPTvKQnX05HFG+Cy5pDN2vx/SRktAK9y20m0i1/rJ4W958C1Hk5F+b4hg7q3/RVA9FA
         yzAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789873501; x=1790478301;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/N3tbEyac1V2m5E+SXDSzpZs6SujX/8UcS11enQcxbI=;
        b=HO5ETWS79ehqnZWATAWsEmrykxWcPDl7J0B7ZFP4ryasqn/Y4WP4TYMUx9AuOxbYXE
         EWUKGg6f6gaL107vxJ4bW78B33JNNAauIfXo/EJt2DgojV0d2oElDEngVH54eV/H5MGj
         8sI0izbfVDvlDCnpjo6iFy5bXC4BYw5K2keEmNEooJ+ghIWNzDQB7QxmkWuAVGEE3qEo
         ZWkh8/EWHcRTivI4SxDhGHwA/IdcfYmW22S5J5Oqcuc/IJbhdAKfRYUsZsZ3OEhECnmW
         WityXIHHGReqYw96oi2GqztR317vfJvpDnOaQ7EawatY6iXITlD+9lZoZ5MtnO2X8XFH
         stkg==
X-Forwarded-Encrypted: i=1; AKwUvBwoh0r5/l8RdO3yNTX7psyAZzFhJW6ZxvPu9tLTIR1ZBiP/UykFeNGLvBDJafutgIlY4TgCOERD@vger.kernel.org
X-Gm-Message-State: AFuF++nzzDMQBZw+LLfji01upfgwzj/MzSH7FzEzVPkb5KphNm+6sl40
	o91Qq83rdiNPeZKGMx6BagnLRVjpsuu+GJqvV4DxzB2E1t02ZVXINFXC4LFXpZ4R
X-Gm-Gg: AYBFou1SjvxH7PLRWzUqqm9csAHWItge0e7c4QxLYfUvD7PXbf2CFiizIWAeqxlBq+h
	YTLcbwIXYt2C0O9Z8AAQOk8lCPZnnnEWdEHoNXnVighDaCixExKS5CSTmaXhAaMKdaQhve3Lmpk
	eb1xkavE2kd35XW25sGLPbM8Z8eiwLBpJzEtRaMBmTS0D7AEvn+UXZpgD/pG4quFHwe+ToDexIT
	NWh9pPYw8Xn4uLh18K7eWa1wYcPqqejVPPtQjQSaj1ZYfnBIRApOZTxODJaXU/HAtAUPW4vmrg9
	Xk7ExML88z2cz0WejI1nJfbVi1eqDb7BptEwRjf3fY7dSrSqPaj2M2Wi6JgSajyStAiIXmFNGCH
	oYv/54MViovcs78AD2i0uPDvsyzAXPYfpWaqu/hHodvpO8SmJ+XLyd/4tTDPnJmy3kdFe+kW24Y
	GYwgm3RTYDFXfhgIKDW0qB2XLxhrFVw6S1/62lklyyAr50qREcnMehRVN+ELeBYxyLlzLolx1ol
	9kEfOSpG787LFODd1VRl2CcTi+zGmRfjJOA3GzRxFXgZNWFZbq+X48ZDb5x35/fpj/rOYoIbzH8
	mIwjDqxdpjE=
X-Received: by 2002:a17:90b:1647:b0:39e:4498:4863 with SMTP id 98e67ed59e1d1-39e54f4187emr15946001a91.10.1789873500462;
        Sat, 19 Sep 2026 20:05:00 -0700 (PDT)
Received: from phui-2.c.googlers.com.com (78.123.83.34.bc.googleusercontent.com. [34.83.123.78])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a026898b76sm4760914a91.16.2026.09.19.20.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 20:05:00 -0700 (PDT)
From: Hui Peng <benquike@gmail.com>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: longman@redhat.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hui Peng <benquike@gmail.com>
Subject: Re: [PATCH] cgroup/cpuset: prevent overlapping local and remote partition creation
Date: Sun, 20 Sep 2026 03:04:58 +0000
Message-ID: <20260920030458.1800040-1-benquike@gmail.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <139d9231-4723-4365-9af7-8142e6581ede@linux.dev>
References: <20260919221727.3706964-1-benquike@gmail.com> <139d9231-4723-4365-9af7-8142e6581ede@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, Sep 20, 2026 at 09:22:09AM +0800, Ridong Chen wrote:
> Could you please first describe what the issue is and how it can be triggered?
> Or is there any reproducer?

Hi Ridong,

Thanks for taking a look. Below is a detailed description of both
scenarios, how each is triggered in the current code, the dmesg
WARNINGs produced on 7.3.0-rc3, and the minimized shell reproducers.

------------------------------------------------------------------------
Scenario 1: Enabling a remote partition underneath an ancestor local
            partition root (remote_partition_enable)
------------------------------------------------------------------------

How it happens:
1. Suppose top-level cgroup "A" is a valid local partition root owning
   CPU 1 (cpuset.cpus = 1, cpuset.cpus.exclusive = 1,
   cpuset.cpus.partition = root). Enabling "A" calls
   partition_xcpus_add(..., &top_cpuset, {1}), which adds CPU 1 to
   subpartitions_cpus.
2. Child "A/B" is a normal non-partition member (cpuset.cpus.partition =
   member) with cpuset.cpus = 1 and cpuset.cpus.exclusive = 1.
3. Grandchild "A/B/D" has cpuset.cpus = 1, cpuset.cpus.exclusive = 1.
   When "root" is written to "A/B/D/cpuset.cpus.partition",
   update_prstate() checks is_partition_valid(parent) on A/B (which is
   false because A/B is PRS_MEMBER) and therefore calls
   remote_partition_enable(D, PRS_ROOT, &tmpmask).
4. In remote_partition_enable(), compute_excpus(D, tmp->new_cpus) walks
   up D -> B -> A and computes tmp->new_cpus = {1}. Because ancestor "A"
   is already a valid local partition root, CPU 1 is already present in
   subpartitions_cpus.
5. remote_partition_enable() hits:
     WARN_ON_ONCE(cpumask_intersects(tmp->new_cpus, subpartitions_cpus));
   at kernel/cgroup/cpuset.c:1594 and continues without returning an
   error, enabling "A/B/D" as a valid remote partition on CPU 1 while
   ancestor "A" is simultaneously a valid local partition on CPU 1,
   which then also triggers a second WARNING in
   rebuild_sched_domains_locked() (kernel/cgroup/cpuset.c:906).

Minimized reproducer (Scenario 1):
  #!/bin/sh
  mkdir -p /tmp/cg1
  mount -t cgroup2 none /tmp/cg1
  echo "+cpuset" > /tmp/cg1/cgroup.subtree_control

  mkdir /tmp/cg1/A
  echo 1 > /tmp/cg1/A/cpuset.cpus
  echo 1 > /tmp/cg1/A/cpuset.cpus.exclusive
  echo root > /tmp/cg1/A/cpuset.cpus.partition
  echo "+cpuset" > /tmp/cg1/A/cgroup.subtree_control

  mkdir /tmp/cg1/A/B
  echo 1 > /tmp/cg1/A/B/cpuset.cpus
  echo 1 > /tmp/cg1/A/B/cpuset.cpus.exclusive
  echo "+cpuset" > /tmp/cg1/A/B/cgroup.subtree_control

  mkdir /tmp/cg1/A/B/D
  echo 1 > /tmp/cg1/A/B/D/cpuset.cpus
  echo 1 > /tmp/cg1/A/B/D/cpuset.cpus.exclusive
  echo root > /tmp/cg1/A/B/D/cpuset.cpus.partition

dmesg output on 7.3.0-rc3:
  WARNING: kernel/cgroup/cpuset.c:1594 at update_prstate+0xbef/0xd70, CPU#2
  Call Trace:
   cpuset_partition_write+0x112/0x140
  WARNING: kernel/cgroup/cpuset.c:906 at rebuild_sched_domains_locked+0x4f2/0x710, CPU#2
  Call Trace:
   cpuset_partition_write+0x112/0x140

------------------------------------------------------------------------
Scenario 2: Invalid top-level local partition transitioning to valid
            over an active remote child partition (validate_partition)
------------------------------------------------------------------------

How it happens:
1. Suppose top-level cgroup "A" is configured as a partition root
   (echo root > A/cpuset.cpus.partition) and given all online CPUs
   (e.g., echo 0-3 > A/cpuset.cpus.exclusive on a 4-CPU system), which
   transitions "A" to PRS_INVALID_ROOT ("root invalid (Parent unable to
   distribute cpu downstream)").
2. Because "A" is invalid (!is_partition_valid(A)), creating child "A/R"
   with cpuset.cpus = 1, cpuset.cpus.exclusive = 1, and
   cpuset.cpus.partition = root succeeds via remote_partition_enable(),
   making "A/R" a valid remote partition on CPU 1 (adding CPU 1 to
   subpartitions_cpus and removing CPU 1 from top_cpuset.effective_cpus).
3. Next, shrinking "A/cpuset.cpus.exclusive" from "0-3" to "1" calls
   update_exclusive_cpumask() -> partition_cpus_change(A, trialcs, &tmp)
   -> validate_partition(A, trialcs).
4. Unlike update_prstate() (which checks (parent == &top_cpuset) &&
   cpumask_intersects(..., subpartitions_cpus) and returns PERR_REMOTE),
   validate_partition() omits the subpartitions_cpus check and returns
   PERR_NONE (0).
5. partition_cpus_change() then calls update_parent_effective_cpumask(A,
   partcmd_update, trialcs->effective_xcpus, &tmp) to activate "A" on
   CPU 1, which is already removed from top_cpuset.effective_cpus by
   "A/R", triggering WARN_ON_ONCE(!cpumask_subset(tmp->new_cpus,
   parent->effective_cpus)) at kernel/cgroup/cpuset.c:1943 and
   WARN_ON_ONCE(old_prs < 0) in partition_xcpus_del() at
   kernel/cgroup/cpuset.c:1342.

Minimized reproducer (Scenario 2, on a 4-CPU VM):
  #!/bin/sh
  mkdir -p /tmp/cg2
  mount -t cgroup2 none /tmp/cg2
  echo "+cpuset" > /tmp/cg2/cgroup.subtree_control

  mkdir /tmp/cg2/A
  echo root > /tmp/cg2/A/cpuset.cpus.partition
  echo 0-3 > /tmp/cg2/A/cpuset.cpus.exclusive
  echo "+cpuset" > /tmp/cg2/A/cgroup.subtree_control

  mkdir /tmp/cg2/A/R
  echo 1 > /tmp/cg2/A/R/cpuset.cpus
  echo 1 > /tmp/cg2/A/R/cpuset.cpus.exclusive
  echo root > /tmp/cg2/A/R/cpuset.cpus.partition

  # Shrink A's exclusive_cpus to 1
  echo 1 > /tmp/cg2/A/cpuset.cpus.exclusive

dmesg output on 7.3.0-rc3:
  WARNING: kernel/cgroup/cpuset.c:1943 at update_parent_effective_cpumask+0x189b/0x1fd0
  Call Trace:
   cpuset_write_resmask+0xcf2/0x1690
  WARNING: kernel/cgroup/cpuset.c:1342 at partition_xcpus_del+0x15b/0x1b0
  Call Trace:
   update_parent_effective_cpumask+0x118c/0x1fd0
   cpuset_write_resmask+0xcf2/0x1690

Also, in v2 of the patch, I will refine the check in validate_partition()
to exclude cs's own existing effective_xcpus when cs is already a valid
local partition (!is_partition_valid(cs)), and split the two scenarios
into separate patches with these reproducers in the commit messages if
you prefer.

Best regards,
Hui Peng
