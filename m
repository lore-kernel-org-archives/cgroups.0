Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795097483;
	b=aw5Fm3ej+tFpU8wCvSuV8gdvYmgg27CM4t9M8iDKcg8BpjJmyrzI3irqxXOiqaZopNt3
	 sjcVZD1WQbpVz4Wa4BdfLUmbKb3vP4INDUa6hEIhLrKoL1fGA4n/bFjZfboHiAYAPF88M
	 BXduIHI9B9JoxnRzw6fYpSMmW1KTHQWv1D/Ez+/0hvpdzrbeHSXjr/A3j3ySIWGj67gqh
	 /t5pkC6rnSqTQtF8U31OqOZjhWtHE/zhpmhNNMkP/NSuA28kZtO+9xObJSooHgMckqVYD
	 mF8+p2jY1R95ex3d1KZXzaj9J+MivGQOf5tjonzvDrW3W/cWk+bcX9pEcudJ6q3rvUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795097483;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Date:From:To:Cc:
	 Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=28OwL7LMN9BNWrZxvtunkM472yJRAdMErQfbeGnmfC8=;
	b=bVxakQrrj3OXTqngbq+M8AMjLeQyf2PHfT3YA9z73iPmubHOLf9xpO0SdIfDNfjnmRYT
	 DXnOZsYTNeokU3jivdXn2uzxprTM61Jck3mchTAspt5g49w9RE5aJieff44FTIA0A65Vg
	 VPXXJLMpgvQW60uGx6E3xfgYvlv7Q9VQfg/ojJNfljW+4eP38od23jX03DgTlYSelB3kX
	 TPJx9ohOGU+rFZIVznvxWdsl46RP4HaRq1QiI6o8rxslZmCvjQlfypu46MUrTiLx8Ec6w
	 owkdpldJLXDj4CJzs5cCCwsryjG0zhqKhM5mPhWwoAHTB8zoQvJg/g2/51KITqVFpBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Vjp9KtHD;
	arc=none smtp.remote-ip=192.198.163.15
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06C9606A320;
	Thu, 19 Nov 2026 14:11:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F06C9606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Vjp9KtHD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795097484; x=1826633484;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding:in-reply-to;
  bh=nw7rQPipSkhtV/UQgw2LJ0rMDn1dGG0TaB4g5lNPeio=;
  b=Vjp9KtHDrVhrYhO4VOxiY310vKfZD9wSWCSV/BWWmHQC97zeos0+qUHX
   vLKH7MOy3qIccIEGyh0lnbk7tHaXaTXosTmWsEgLzXIEg4yJ82qYzLiLt
   UCXL5+YCriXyKtXMHwrDoIw0X65B47VR/Hyl3pTgiQLireNng2coy8WPi
   MWginHp/5Ppty0fC4KlNnQMhmxNm13g/nOnxQG7iQGPNwZN3hbnP366e7
   mVSXal12vrkpELzueMTT9+wiXvIvzsyB8Bj9CWGhIUePFYn8koM3ZTaEE
   p8g7VJtxvMQYWaCY0FJT5r7/Ar5iQnKqdNrUXfqI8ggMgsurNreXymUOa
   w==;
X-CSE-ConnectionGUID: FnLcogvvSf+h19prakT1CQ==
X-CSE-MsgGUID: j1lgUwQcQ3ycfEB4EzUpbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11971"; a="3954949"
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="3954949"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 06:11:23 -0800
X-CSE-ConnectionGUID: Y7htxKcIQZqpqFq6wYNJhw==
X-CSE-MsgGUID: FDK0PtvFRbC2gRpIiTQ4jw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="10573856"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 06:11:13 -0800
Date: Thu, 19 Nov 2026 22:11:10 +0800
From: kernel test robot <yi1.lai@intel.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
	aubrey.li@linux.intel.com, yu.c.chen@intel.com, ltp@lists.linux.it,
	cgroups@vger.kernel.org, rcu@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	luca abeni <luca.abeni@santannapisa.it>,
	Yuri Andriaccio <yurand2000@gmail.com>,
	Yuri Andriaccio <yuri.andriaccio@santannapisa.it>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>, Davidlohr Bueso <dave@stgolabs.net>,
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Qais Yousef <qyousef@layalina.io>,
	John Ogness <john.ogness@linutronix.de>, yi1.lai@intel.com
Subject: Re: [PATCH v3 6/8] sched: Limit sysctl sched_rt_{period|runtime}_us
 to RT_GROUP_SCHED
Message-ID: <202611192004.cca8bf73-lkp@intel.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261113-sched_dl-v3-6-a76ffa1cdeee@linutronix.de>


Hello,

kernel test robot noticed "ltp.proc_sched_rt01.fail" on:

commit: 4f1021f29368df79a6e79ec87cafa29d99a4601a ("[PATCH v3 6/8] sched: Limit sysctl sched_rt_{period|runtime}_us to RT_GROUP_SCHED")
url: https://github.com/intel-lab-lkp/linux/commits/Sebastian-Andrzej-Siewior/sched-deadline-Reject-debugfs-dl_server-writes-for-not-active-CPUs/20261113-115022
patch link: https://lore.kernel.org/all/20261113-sched_dl-v3-6-a76ffa1cdeee@linutronix.de/
patch subject: [PATCH v3 6/8] sched: Limit sysctl sched_rt_{period|runtime}_us to RT_GROUP_SCHED

in testcase: ltp
version: ltp-x86_64-686a331b6-1_20261114 with following parameters:

	test: sched

config: x86_64-rhel-9.4-ltp
compiler: gcc-14
test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-4790T CPU @ 2.70GHz (Haswell) with 16G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)


If you fix the issue in a separate patch/commit (i.e. not just a new version of the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <yi1.lai@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202611192004.cca8bf73-lkp@intel.com


PATH=/lkp/benchmarks/ltp:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/lkp/lkp/src/bin
2026-11-19 03:55:21 cd /lkp/benchmarks/ltp
2026-11-19 03:55:21 export LTP_RUNTIME_MUL=2
2026-11-19 03:55:21 export LTPROOT=/lkp/benchmarks/ltp
2026-11-19 03:55:21 kirk -f sched
Host information
	Hostname:   lkp-hsw-d05
	Python:     3.13.5 (main, Jun 13 2026, 14:18:01) [GCC 14.2.0]
	Directory:  /tmp/kirk.root/tmpmzwqb43l

Connecting to SUT: default

Suite: sched
────────────
 [1;37mpth_str01:  [0m [1;32mpass [0m  (0.016s)
 [1;37mpth_str02:  [0m [1;32mpass [0m  (0.151s)
 [1;37mpth_str03:  [0m [1;32mpass [0m  (0.017s)
 [1;37mtime-schedule01:  [0m [1;32mpass [0m  (0.250s)
 [1;37mtrace_sched01:  [0m [1;32mpass [0m  (0.021s)
 [1;37mcfs_bandwidth01:  [0m [1;32mpass [0m  (15.085s)
 [1;37mhackbench01:  [0m [1;32mpass [0m  (49.279s)
 [1;37mhackbench02:  [0m [1;32mpass [0m  (19.554s)
 [1;37mstarvation:  [0m [1;36mskip [0m  (0.076s)
 [1;37mproc_sched_rt01:  [0m [1;31mfail [0m  (0.015s)
 [1;37msched_cli_serv:  [0m [1;32mpass [0m  (5.043s)
 [1;37msched_stress:  [0m [1;32mpass [0m  (1m 12s)
 [1;37mautogroup01:  [0m [1;32mpass [0m  (0.075s)
 [1;37msched_football:  [0m [1;32mpass [0m  (5.469s)

Execution time: 2m 47s

Disconnecting from SUT: default

Target information
──────────────────
Kernel:   Linux 7.4.0-rc2+ #1 SMP PREEMPT Thu Nov 19 11:18:29 CST 2026
Cmdline:  ip=::::lkp-hsw-d05::dhcp
          root=/dev/ram0
          RESULT_ROOT=/result/ltp/sched/lkp-hsw-d05/debian-13-x86_64-20250902.cgz/x86_64-rhel-9.4-ltp/gcc-14/4f1021f29368df79a6e79ec87cafa29d99a4601a/0
          BOOT_IMAGE=/pkg/linux/x86_64-rhel-9.4-ltp/gcc-14/4f1021f29368df79a6e79ec87cafa29d99a4601a/vmlinuz-7.4.0-rc2+
          branch=internal-devel/devel-hourly-20261117-024418
          job=/lkp/jobs/scheduled/lkp-hsw-d05/ltp-sched-debian-13-x86_64-20250902.cgz-4f1021f29368-20261119-35324-11d62tm-0.yaml
          user=lkp
          ARCH=x86_64
          kconfig=x86_64-rhel-9.4-ltp
          commit=4f1021f29368df79a6e79ec87cafa29d99a4601a
          intremap=posted_msi
          max_uptime=7200
          LKP_SERVER=internal-lkp-server
          nokaslr
          selinux=0
          debug
          apic=debug
          sysrq_always_enabled
          rcupdate.rcu_cpu_stall_timeout=100
          net.ifnames=0
          printk.devkmsg=on
          panic=-1
          softlockup_panic=1
          nmi_watchdog=panic
          oops=panic
          load_ramdisk=2
          prompt_ramdisk=0
          drbd.minor_count=8
          systemd.log_level=err
          ignore_loglevel
          console=tty0
          earlyprintk=ttyS0,115200
          console=ttyS0,115200
          vga=normal
          rw
          keep_initrds=/osimage/pkg/debian-13-x86_64-20250902.cgz/ltp-x86_64-686a331b6-1_20261114.cgz
          acpi_rsdp=0x000f0490
Machine:  unknown
Arch:     x86_64
RAM:      14033756 kB
Swap:     0 kB
Distro:   debian 13

────────────────────────
      TEST SUMMARY
────────────────────────
Suite:   sched
Runtime: 2m 47s
Runs:    14

Results:
    Passed:   22
    Failed:   3
    Broken:   1
    Skipped:  1
    Warnings: 0

 [1;31mBroken: [0m
    • proc_sched_rt01

 [1;31mFailures: [0m
    • proc_sched_rt01

Session stopped
LTP test details
----------------
starvation: starvation.c:115: TCONF: Skip test due to slow kernel configuration
proc_sched_rt01: proc_sched_rt01.c:45: TFAIL: echo 0 > /proc/sys/kernel/sched_rt_period_us expected EINVAL: EBADF (9)
proc_sched_rt01: proc_sched_rt01.c:47: TFAIL: echo -1 > /proc/sys/kernel/sched_rt_period_us expected EINVAL: EBADF (9)
proc_sched_rt01: proc_sched_rt01.c:53: TFAIL: echo -2 > /proc/sys/kernel/sched_rt_runtime_us expected EINVAL: EBADF (9)
proc_sched_rt01: proc_sched_rt01.c:62: TBROK: Failed to open FILE '/proc/sys/kernel/sched_rt_period_us' for reading: ENOENT (2)


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20261119/202611192004.cca8bf73-lkp@intel.com

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


