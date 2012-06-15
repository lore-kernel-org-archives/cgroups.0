From: Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH 0/7][TRIVIAL][resend] trivial patches
Date: Fri, 15 Jun 2012 21:21:39 +0800
Message-ID: <1339766499-7891-1-git-send-email-liwp.linux@gmail.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=mJNKTIu1aH1rcU860lCRO3kex3ceZzwjp4EmA/W0OWo=;
        b=KPWTwcuKafx65bcIviT3t5PLhllecJ5eBHB4VtDtjI3b+GkAQDK02Ztu1lFGCktZby
         KwKZEyjHOx9gR9zSKTPttQ4UCdoVWsxR1yH0xWbeLFUxpVTjy4hY5khRSnYhkprNSJKo
         eoJg+Nk2WIuR7lOHiYi+enV0zInM2uWTeGqPlq8aUTRrfhKUBzCtJ3M5AsTtQ/fhlbrp
         VYG7S+oUvInZDaXTkBkMyJk8jwJ1AAHOaEDl0bFAFQiUd8OiA8l+W4HovXIAdDNuazS8
         LcGg5gvEM6pVp0a9xKkpi4ycHv6P614iWfnwUJnSu5rCek0OUmIO6T1GyC2BF6pv6Jtt
         RVyg==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trivial@kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Bjorn Helgaas <bhelgaas@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Christoph Lameter <cl@linux-foundation.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Jesse Barnes <jbarnes@virtuousgeek.org>, Milton Miller <miltonm@bga.com>, Nishanth Aravamudan <nacc@us.ibm.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Jason Wessel <jason.wessel@windriver.com>, Jan Kiszka <jan.kiszka@siemens.com>, David Howells <dhowells@redhat.com>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Since these patches has already send more than one week and 
doesn't get any response, I collect them and send out a patch set.

Wanpeng Li (7)

powerpc: cleanup some kernel doc warning 
x86/kernel: cleanup some kernel doc warning  
drivers/pci: cleanup some kernel doc warning
mm: cleanup on the comments of zone_reclaim_stat
mm: cleanup some kernel doc warning
mm: cleanup page relaim comment error
mm/memory.c: cleanup coding style issue

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
--
 arch/powerpc/kernel/pci_of_scan.c |    1 -
 arch/powerpc/kernel/vio.c         |    6 +++---
 arch/x86/kernel/kgdb.c            |    8 ++++----
 arch/x86/kernel/uprobes.c         |    2 +-
 drivers/pci/setup-bus.c           |    2 +-
 include/linux/mmzone.h            |    2 +-
 mm/memblock.c                     |   12 ++++++------
 mm/memcontrol.c                   |    4 ++--
 mm/memory.c                       |    3 ++-
 mm/oom_kill.c                     |    2 +-
 mm/page_cgroup.c                  |    4 ++--
 mm/pagewalk.c                     |    1 -
 mm/percpu-vm.c                    |    1 -
 mm/vmscan.c                       |    3 ++-
 14 files changed, 25 insertions(+), 26 deletions(-)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
