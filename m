From: Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH 2/7][TRIVIAL][resend] x86/kernel: cleanup some kernel-doc warnings
Date: Fri, 15 Jun 2012 21:13:22 +0800
Message-ID: <1339766008-7279-1-git-send-email-liwp.linux@gmail.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=skk/MXGIWsB2rtBSTRi22z4dJb7xgSy9hiSwfWJuRFk=;
        b=BClAfnNpSujdvJ4ujYJl2w3Fj3m2rBwdK1aqcy77GPIh2yOeE6fp8A+BnH64iJR3uH
         nAISP8r7UQOWiBPcESREXlNPOyO35436LWXTWxqIZGfAt8zIcFQoWlXCxsxrp3vjmNdh
         wmV8huLQBqJks63xtQUc8Kx/+lA0bFTX9YS8/7ZjT9cSBfJlHV9lESmFchdpayIrV7PS
         5bSououSiuyqG+lsJ5/E3mynCQ+FssP6K8ppd/IjwXmnUzFzEKi3l33xy4YMfcKCjsjG
         w/FMpFGE8HMhzM+a+zNgi1m02wKPXhw0cixz9xlSAfP8C09+lzWSwh20tEEmM6bce5mF
         wfxw==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trivial@kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Bjorn Helgaas <bhelgaas@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Christoph Lameter <cl@linux-foundation.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Jesse Barnes <jbarnes@virtuousgeek.org>, Milton Miller <miltonm@bga.com>, Nishanth Aravamudan <nacc@us.ibm.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Jason Wessel <jason.wessel@windriver.com>, Jan Kiszka <jan.kiszka@siemens.com>, David Howells <dhowells@redhat.com>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Warning(arch/x86/kernel/kgdb.c:465): No description found for parameter 'e_vector'
Warning(arch/x86/kernel/kgdb.c:465): No description found for parameter 'remcomInBuffer'
Warning(arch/x86/kernel/kgdb.c:465): No description found for parameter 'remcomOutBuffer'
Warning(arch/x86/kernel/kgdb.c:465): No description found for parameter 'linux_regs'
Warning(arch/x86/kernel/kgdb.c:465): Excess function parameter 'vector' description in 'kgdb_arch_handle_exception'
Warning(arch/x86/kernel/kgdb.c:465): Excess function parameter 'remcom_in_buffer' description in 'kgdb_arch_handle_exception'
Warning(arch/x86/kernel/kgdb.c:465): Excess function parameter 'remcom_out_buffer' description in 'kgdb_arch_handle_exception'
Warning(arch/x86/kernel/kgdb.c:465): Excess function parameter 'regs' description in 'kgdb_arch_handle_exception'
Warning(arch/x86/kernel/uprobes.c:416): No description found for parameter 'auprobe'
Warning(arch/x86/kernel/uprobes.c:416): Excess function parameter 'arch_uprobe' description in 'arch_uprobe_analyze_insn'
Warning(arch/x86/lib/csum-wrappers_64.c:125): No description found for parameter 'sum'
Warning(arch/x86/lib/csum-wrappers_64.c:125): Excess function parameter 'isum' description in 'csum_partial_copy_nocheck'

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>

---
 arch/x86/kernel/kgdb.c    |    8 ++++----
 arch/x86/kernel/uprobes.c |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 8bfb614..3f61904 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -444,12 +444,12 @@ void kgdb_roundup_cpus(unsigned long flags)
 
 /**
  *	kgdb_arch_handle_exception - Handle architecture specific GDB packets.
- *	@vector: The error vector of the exception that happened.
+ *	@e_vector: The error vector of the exception that happened.
  *	@signo: The signal number of the exception that happened.
  *	@err_code: The error code of the exception that happened.
- *	@remcom_in_buffer: The buffer of the packet we have read.
- *	@remcom_out_buffer: The buffer of %BUFMAX bytes to write a packet into.
- *	@regs: The &struct pt_regs of the current process.
+ *	@remcomInBuffer: The buffer of the packet we have read.
+ *	@remcomOutBuffer: The buffer of %BUFMAX bytes to write a packet into.
+ *	@linux_regs: The &struct pt_regs of the current process.
  *
  *	This function MUST handle the 'c' and 's' command packets,
  *	as well packets to set / remove a hardware breakpoint, if used.
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index dc4e910..f785a06 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -408,7 +408,7 @@ static int validate_insn_bits(struct arch_uprobe *auprobe, struct mm_struct *mm,
 /**
  * arch_uprobe_analyze_insn - instruction analysis including validity and fixups.
  * @mm: the probed address space.
- * @arch_uprobe: the probepoint information.
+ * @auprobe: the probepoint information.
  * Return 0 on success or a -ve number on error.
  */
 int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm)
-- 
1.7.9.5

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
