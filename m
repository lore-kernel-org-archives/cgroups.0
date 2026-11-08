Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794149875;
	b=jlpYy9rQ9XxDr32DwFCI7jurC9GEg0dfzOH1xi0KmyQRnYLlmauv0ATh5DuFFfS7dYL2
	 qEmE1FfhDJq9OiLM6lmIgKGw+beeaa3GvkL0EjKA0pMKwfHxXFKYIuWr2uqZM0AKUZQDb
	 iv6vNocKJ2Dv8hTDSauRUL6NaCeT9UUUqgcG4NSLhNAtIOlrsgG12S1QrJvBY0QAL0Z6J
	 QH+lyXg++inWB6kh13rUL4FewuJZkeTqBX84WNdhyKt8yQSF1dN7YN0VPmouh2I/GPEKY
	 0qz3Rb8Uzm9aUxD2LhqKR5ywY6xL3NMdNEFuw2Aq2YMBKRy1DK35lnxgKz9bhFsn/+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794149875;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=eBvV1HvSLM1f5WpxBj3YNWfu0VcDksHS62CpaFr2AYA=;
	b=FD5331gA7WVplxqDgII/RbhIjzTu7AkWJ2wdNvRzcatlJbGmW32irU7mLqy+7gDgFBTM
	 cuQWQ13Eqt3otxnD0zjQc535PjUKWmE5bCCbfpak8Z/th1KRYZIuMGncWStZNMcY9d1pp
	 n7EFFj1wi2AsrtXFd9bns1VZEuZxv/CccWKCYnzwit5JXZiE2FIp3DjADdtyvDJx7xB3f
	 lYgqCVWocuv/MmzXo2D7gtGB2J2z3QmEaCBzRCyyLpxsbHG8Lsc7ODsKQihGh4g8gwlAn
	 VVaWm2h7Schi5BNhI4JyWHSMqgwJeFzaWjVOTW51V1MpIBOpw+fH7avFziY82zRZ8aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=O9me9xdu;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7A2606A320;
	Sun,  8 Nov 2026 14:57:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5F7A2606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=O9me9xdu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794149874;
	bh=eBvV1HvSLM1f5WpxBj3YNWfu0VcDksHS62CpaFr2AYA=;
	h=From:To:Cc:Subject:Date:From;
	b=O9me9xduiw6h5DSWsa0C1WGznGmvte/eyyXiuWISOdMc37XxfWqRFgw4Y9Sewwz1M
	 +KaAmihychkpM6Ug7YI2wadBDo+epg1I6gKxdxRAFGVADnc7gMtdz5j46eBsRRG/Or
	 wHLM2SjrLL1eA62SffHBN/g+zDZOgnpLwYSZoj3Te1iELhm/Sjdpfl2goAbcS0+FD4
	 2yJ1WS1VKlT+FaweqWUtYdoD38vGCzqV9Z2EI/nYAD/r1o2rgvW0tri0iviKXU3DhM
	 jKr3978wZ0iha1yp0FzWi0DirToQwruWT3iBcTcSah4AwR+1SWIXRh0izNSJQ3r0aC
	 B1zS1EAnk9LNg==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jMwyB3d8PzMyT;
	Sun, 08 Nov 2026 09:57:54 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Waiman Long <longman@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [BUG] cpuset: WARNING in cpuset_update_sd_hk_unlock() when isolated partitions take every housekeeping CPU
Date: Sun,  8 Nov 2026 09:57:54 -0500
Message-Id: <20261108145754.1532162-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
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

Hi,

With isolcpus=domain, cpuset accepts isolated partitions that leave no
housekeeping CPU. housekeeping_update() then refuses the new mask, and
cpuset_update_sd_hk_unlock() warns.

I found this while testing a fix for another cpuset problem [1]. Its
sequence goes through that problem first, so I ran it only on a kernel
with that fix.

Trigger
=======

Boot 5 CPUs with isolcpus=domain,0,1. CPUs 2 to 4 are then the
housekeeping CPUs. With cgroup v2:

  cd /sys/fs/cgroup
  echo +cpuset > cgroup.subtree_control
  mkdir P Q
  echo 4 > P/cpuset.cpus
  echo isolated > P/cpuset.cpus.partition
  echo 2-3 > Q/cpuset.cpus
  echo root > Q/cpuset.cpus.partition
  echo isolated > Q/cpuset.cpus.partition    # WARNING

The last write is accepted. Q reads back as isolated.

  WARNING: kernel/cgroup/cpuset.c:1481 at cpuset_update_sd_hk_unlock+0x79/0x80, CPU#1: k2/93
  CPU: 1 UID: 0 PID: 93 Comm: k2 Not tainted 7.4.0-rc1-00268-ge99d0e004b05 #108 PREEMPT(lazy)
  RAX: 00000000ffffffea
  Call Trace:
   cpuset_partition_write+0x9e/0xe0
   kernfs_fop_write_iter+0x14d/0x210
   vfs_write+0x252/0x550
   ksys_write+0x6c/0xe0
   do_syscall_64+0x109/0x5d0

RAX is -EINVAL, the return of housekeeping_update().

Analysis
========

From reading tip sched/urgent (006991aa8997):
- Making Q isolated would remove CPUs 2 and 3 from HK_TYPE_DOMAIN.
  CPUs 0 and 1 are isolated at boot, and P holds CPU 4. So no
  housekeeping CPU would remain.
- housekeeping_update() refuses that mask with -EINVAL. Commit
  03ff73510169 ("cpuset: Update HK_TYPE_DOMAIN cpumask from cpuset")
  calls it under WARN_ON_ONCE() in cpuset_update_sd_hk_unlock().
- prstate_housekeeping_conflict() refuses such a partition only with
  nohz_full, since commit 103b08709e8a ("cgroup/cpuset: Fail if
  isolated and nohz_full don't leave any housekeeping").

So cpuset and the housekeeping code disagree on what is valid. The
write returns 0, and the isolated CPUs of the top cpuset read 0-4. But
by reading, HK_TYPE_DOMAIN keeps its old mask.

Should cpuset refuse an isolated partition that leaves no
HK_TYPE_DOMAIN housekeeping CPU, as it does for nohz_full? I did not
write a patch, since you may prefer another place for the check.

The analysis was written by an LLM coding assistant under my direction
and review.

Thanks,

Mathieu

[1] The empty sched domain report, sent along with this one.
