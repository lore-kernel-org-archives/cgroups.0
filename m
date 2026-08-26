Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12535361961;
	Wed, 26 Aug 2026 06:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787725829; cv=none; b=AUKuqmj2YDWzV5qV7RQqqo+ZOnjLWc3CC/JZCQfJ9b1RGGyEYlUkf6pkCXF1bleG289th4DiPWvGkh3V7I7dk8A4AA4zOty/2OjM4P8bKcqOYMYsFsak4cUlSDxVrwDkb0Y/lON435TQwayCYpgnuGemKkOQKfHqzCM2NOR+9+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787725829; c=relaxed/simple;
	bh=rDKvz/peGRfXq5YQmSPRC3KJaw3+ZougxMrFg0o5odI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=QWOqoYpjq2Rou/M9EhcsSkRHkxeFaFd+FzcbJJ6eztPdMlyZXah7g+YhObN3nenLxwrxChNqS6+X3En4G9y9VfL3OITKR+prp7bKGTulENVG3b4YnmSNPvLOIUmG4THB2HfJtzlhZol4sJz4U+SCiSFOcij7K67Y3QGZMycE22g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FUTiIvSl; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FUTiIvSl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787725825; x=1819261825;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=rDKvz/peGRfXq5YQmSPRC3KJaw3+ZougxMrFg0o5odI=;
  b=FUTiIvSlr+GzMmuGHF84g1oizqGFavAM7u55cuXsuq4eFenhOcappaH6
   u1I6pHE2kFt0us70rDHtQX46pDJJL/lLyk2qXrdvr37yC0fTqb+7RT2ue
   umBPw5eJ4LTLhFn5lHylqs4lImto2mKgKFFsi7+xSMd3N3aSlvNMBd+jY
   xcS/vrbav4y/R4pLhCZFB+1ubm4xjB3mc7djoQhFeP30uayd7emyVVXI1
   +RRY7zSW0CNT3ZmMT0ggMJTwANcqAt+uUn1dF40u4tPJ5Yen5z1vbuY/a
   Nb6jTqOgJUR2RfPyTx9WIUBwhTCGgrEXn/M9lgC2aAS1LyhPqxoUD/upz
   Q==;
X-CSE-ConnectionGUID: ygv4qhVVSjietBPVRP9A6g==
X-CSE-MsgGUID: tc+dz11HSz6FPlQ5F25JGg==
X-IronPort-AV: E=McAfee;i="6800,10657,11886"; a="113737053"
X-IronPort-AV: E=Sophos;i="6.25,244,1779174000"; 
   d="scan'208";a="113737053"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 23:30:16 -0700
X-CSE-ConnectionGUID: ZfRpfErhTaqv3OW7pFIz3Q==
X-CSE-MsgGUID: PADR+xa1RxuJ/tY1ZWnwdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,244,1779174000"; 
   d="scan'208";a="268067141"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 23:30:12 -0700
Date: Wed, 26 Aug 2026 14:30:05 +0800
From: kernel test robot <yi1.lai@intel.com>
To: Prakash Gupta <prakash.gupta@oss.qualcomm.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, cgroups@vger.kernel.org,
	linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Prakash Gupta <prakash.gupta@oss.qualcomm.com>, yi1.lai@intel.com
Subject: Re: [PATCH] mm/memcg: fix NULL nodeinfo[] dereference on
 late-onlined nodes
Message-ID: <202608261313.1d95c34d-lkp@intel.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810-memcg-nodeinfo-null-guard-v1-1-77a73204d63a@oss.qualcomm.com>


Hello,

kernel test robot noticed "Oops:general_protection_fault,probably_for_non-canonical_address#:#[##]SMP_KASAN" on:

commit: d793df2588b727e161c6586cafda1b3146216b36 ("[PATCH] mm/memcg: fix NULL nodeinfo[] dereference on late-onlined nodes")
url: https://github.com/intel-lab-lkp/linux/commits/Prakash-Gupta/mm-memcg-fix-NULL-nodeinfo-dereference-on-late-onlined-nodes/20260810-111630
patch link: https://lore.kernel.org/all/20260810-memcg-nodeinfo-null-guard-v1-1-77a73204d63a@oss.qualcomm.com/
patch subject: [PATCH] mm/memcg: fix NULL nodeinfo[] dereference on late-onlined nodes

in testcase: boot

config: x86_64-randconfig-r132-20260821
compiler: clang-22
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 32G

(please refer to attached dmesg/kmsg for entire log/backtrace)


If you fix the issue in a separate patch/commit (i.e. not just a new version of the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <yi1.lai@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202608261313.1d95c34d-lkp@intel.com


[    4.964339][   T26] KASAN: probably user-memory-access in range [0x0000000000002040-0x0000000000002047]
[    4.964822][    T1] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x1e3306b9ada, max_idle_ns: 440795224413 ns
[    4.964364][   T26] CPU: 1 UID: 0 PID: 26 Comm: kworker/u10:0 Tainted: G                T   7.2.0-rc6-00001-gd793df2588b7 #1 PREEMPTLAZY  7c3d8f436a783d0b482149cc8be5fdb0e2064a33
[    4.967167][   T26] Tainted: [T]=RANDSTRUCT
[    4.967167][   T26] Workqueue: async async_run_entry_fn
[    4.967167][   T26] RIP: 0010:mod_node_state+0x2d/0x180
[    4.967167][   T26] Code: 41 56 41 55 41 54 53 89 cd 41 89 d4 41 89 f7 49 89 fe 48 8d 9f 40 20 00 00 48 89 d8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 48 89 df e8 85 18 13 00 4c 8b 2b 44 89 fb 41 83
[    4.967167][   T26] RSP: 0000:ffffc900001c7610 EFLAGS: 00010002
[    4.967167][   T26] RAX: 0000000000000408 RBX: 0000000000002040 RCX: dffffc0000000000
[    4.967167][   T26] RDX: 0000000000000001 RSI: 0000000000000013 RDI: 0000000000000000
[    4.967167][   T26] RBP: 0000000000000000 R08: ffffffffffe8ac20 R09: 0000000000000001
[    4.967167][   T26] R10: 0000000000000000 R11: fffff52000038ecc R12: 0000000000000001
[    4.967167][   T26] R13: dffffc0000000000 R14: 0000000000000000 R15: 0000000000000013
[    4.967167][   T26] FS:  0000000000000000(0000) GS:ffff888799a99000(0000) knlGS:0000000000000000
[    4.967167][   T26] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    4.967167][   T26] CR2: 0000000000000000 CR3: 00000000040c5000 CR4: 00000000000406b0
[    4.967167][   T26] Call Trace:
[    4.967167][   T26]  <TASK>
[    4.967167][   T26]  mod_lruvec_state+0x47/0xc0
[    4.967167][   T26]  ? lruvec_stat_mod_folio+0x22/0x300
[    4.967167][   T26]  lruvec_stat_mod_folio+0x181/0x300
[    4.967167][   T26]  __filemap_add_folio+0x758/0xb00
[    4.967167][   T26]  ? workingset_activation+0x500/0x500
[    4.967167][   T26]  filemap_add_folio+0x1ce/0x380
[    4.967167][   T26]  __filemap_get_folio_mpol+0x3b5/0x940
[    4.967167][   T26]  simple_write_begin+0x61/0x2c0
[    4.967167][   T26]  page_symlink+0x1a8/0x300
[    4.967167][   T26]  ramfs_symlink+0x8c/0x140
[    4.967167][   T26]  vfs_symlink+0x12f/0x2c0
[    4.967167][   T26]  filename_symlinkat+0xf4/0x280
[    4.967167][   T26]  ? __asan_memcpy+0x40/0x80
[    4.967167][   T26]  init_symlink+0x2e/0x80
[    4.967167][   T26]  do_symlink+0xa5/0x180
[    4.967167][   T26]  flush_buffer+0x6b/0x100
[    4.967167][   T26]  ? unpack_to_rootfs+0x380/0x380
[    4.967167][   T26]  __gunzip+0x8bd/0xdc0
[    4.967167][   T26]  ? __gunzip+0xdc0/0xdc0
[    4.967167][   T26]  ? decompress_method+0x1c0/0x1c0
[    4.967167][   T26]  unpack_to_rootfs+0x21e/0x380
[    4.967167][   T26]  ? flush_buffer+0x100/0x100
[    4.967167][   T26]  ? xwrite+0x100/0x100
[    4.967167][   T26]  do_populate_rootfs+0x21c/0x300
[    4.967167][   T26]  async_run_entry_fn+0x95/0x3c0
[    4.967167][   T26]  ? process_scheduled_works+0x7a6/0x1240
[    4.967167][   T26]  process_scheduled_works+0x86b/0x1240
[    4.967167][   T26]  worker_thread+0x749/0xbc0
[    4.967167][   T26]  kthread+0x338/0x440
[    4.967167][   T26]  ? alloc_worker+0x2c0/0x2c0
[    4.967167][   T26]  ? __do_trace_sched_kthread_stop_ret+0x140/0x140
[    4.967167][   T26]  ret_from_fork+0x291/0x5c0
[    4.967167][   T26]  ? __do_trace_sched_kthread_stop_ret+0x140/0x140
[    4.967167][   T26]  ret_from_fork_asm+0x11/0x20
[    4.967167][   T26]  </TASK>
[    4.967167][   T26] Modules linked in:
[    4.967167][   T26] ---[ end trace 0000000000000000 ]---
[    4.967167][   T26] RIP: 0010:mod_node_state+0x2d/0x180
[    4.967167][   T26] Code: 41 56 41 55 41 54 53 89 cd 41 89 d4 41 89 f7 49 89 fe 48 8d 9f 40 20 00 00 48 89 d8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 48 89 df e8 85 18 13 00 4c 8b 2b 44 89 fb 41 83
[    4.967167][   T26] RSP: 0000:ffffc900001c7610 EFLAGS: 00010002
[    4.967167][   T26] RAX: 0000000000000408 RBX: 0000000000002040 RCX: dffffc0000000000
[    4.967167][   T26] RDX: 0000000000000001 RSI: 0000000000000013 RDI: 0000000000000000
[    4.967167][   T26] RBP: 0000000000000000 R08: ffffffffffe8ac20 R09: 0000000000000001
[    4.967167][   T26] R10: 0000000000000000 R11: fffff52000038ecc R12: 0000000000000001
[    4.967167][   T26] R13: dffffc0000000000 R14: 0000000000000000 R15: 0000000000000013
[    4.967167][   T26] FS:  0000000000000000(0000) GS:ffff888799a99000(0000) knlGS:0000000000000000
[    4.967167][   T26] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    4.967167][   T26] CR2: 0000000000000000 CR3: 00000000040c5000 CR4: 00000000000406b0
[    4.967167][   T26] Kernel panic - not syncing: Fatal exception


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260826/202608261313.1d95c34d-lkp@intel.com


--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


