From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: Possible regression with cgroups in 3.11
Date: Fri, 15 Nov 2013 17:28:20 -0700
Message-ID: <20131116002820.GA31073@google.com>
References: <CA+SBX_MQVMuzWKroASK7Cr5J8cu9ajGo=CWr7SRs+OWh83h4_w@mail.gmail.com>
 <525CB337.8050105@huawei.com>
 <CA+SBX_Ogo8HP81o+vrJ8ozSBN6gPwzc8WNOV3Uya=4AYv+CCyQ@mail.gmail.com>
 <CA+SBX_OJBbYzrNX5Mi4rmM2SANShXMmAvuPGczAyBdx8F2hBDQ@mail.gmail.com>
 <5270BFE7.4000602@huawei.com>
 <alpine.LNX.2.00.1310301606080.2333@eggly.anvils>
 <20131031130647.0ff6f2c7@gandalf.local.home>
 <alpine.LNX.2.00.1310311442030.2633@eggly.anvils>
 <20131113032804.GB19394@mtj.dyndns.org>
 <20131113073806.GA23244@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <linux-pci-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=AQpaWZrVQjX/JwJc0TXMnuHtcYrrKZ4mMIwtKUstktM=;
        b=f/7Qh8lipcYP4um3mI4jX9rSUzxZkzo+kY18JT0x7ReHtyuHkD/b3o2vdPzCBhDo6X
         3dWcP7leHQvKwWhD+2OVZKyR3QJKbyuPmTJRU1t/XxVI/JLKDrT59e3IoO+i/oNQ8RqD
         zP4bMnQALyS2Blp63lCTEC2BxOZaTw68qGFB93MOIQThnFAqsTXlaAHC1KZBsYNThcEL
         goZYMt8jwcGcxXZg6BLmZC9A4tNsw18v+tfgeexZAYtAqOLDtJxjUlgH2+2lBJFUKl1u
         5cLGIeowLizUH0bb+A4pERLENfpTVNV5z6wBNfqxYVcwOxWaFY6DrNfdtRHvat/tqosE
         G1JA==
Content-Disposition: inline
In-Reply-To: <20131113073806.GA23244@mtj.dyndns.org>
Sender: linux-pci-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Hugh Dickins <hughd@google.com>, Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizefan@huawei.com>, Markus Blank-Burian <burian@muenster.de>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, David Rientjes <rientjes@google.com>, Ying Han <yinghan@google.com>, Greg Thelen <gthelen@google.com>, Michel Lespinasse <walken@google.com>, cgroups@vger.kernel.org, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, Lai Jiangshan <laijs@cn.fujitsu.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alexander Duyck <alexander.h.duyck@intel.com>, Yinghai Lu <yinghai@kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>

On Wed, Nov 13, 2013 at 04:38:06PM +0900, Tejun Heo wrote:
> Hey, guys.
> 
> cc'ing people from "workqueue, pci: INFO: possible recursive locking
> detected" thread.
> 
>   http://thread.gmane.org/gmane.linux.kernel/1525779
> 
> So, to resolve that issue, we ripped out lockdep annotation from
> work_on_cpu() and cgroup is now experiencing deadlock involving
> work_on_cpu().  It *could* be that workqueue is actually broken or
> memcg is looping but it doesn't seem like a very good idea to not have
> lockdep annotation around work_on_cpu().
> 
> IIRC, there was one pci code path which called work_on_cpu()
> recursively.  Would it be possible for that path to use something like
> work_on_cpu_nested(XXX, depth) so that we can retain lockdep
> annotation on work_on_cpu()?

I'm open to changing the way pci_call_probe() works, but my opinion is
that the PCI path that causes trouble is a broken design, and we shouldn't
complicate the work_on_cpu() interface just to accommodate that broken
design.

The problem is that when a PF .probe() method that calls
pci_enable_sriov(), we add new VF devices and call *their* .probe()
methods before the PF .probe() method completes.  That is ugly and
error-prone.

When we call .probe() methods for the VFs, we're obviously already on the
correct node, because the VFs are on the same node as the PF, so I think
the best short-term fix is Alexander's patch to avoid work_on_cpu() when
we're already on the correct node -- something like the (untested) patch
below.

Bjorn


PCI: Avoid unnecessary CPU switch when calling driver .probe() method

From: Bjorn Helgaas <bhelgaas@google.com>

If we are already on a CPU local to the device, call the driver .probe()
method directly without using work_on_cpu().

This is a workaround for a lockdep warning in the following scenario:

  pci_call_probe
    work_on_cpu(cpu, local_pci_probe, ...)
      driver .probe
        pci_enable_sriov
          ...
            pci_bus_add_device
              ...
                pci_call_probe
                  work_on_cpu(cpu, local_pci_probe, ...)

It would be better to fix PCI so we don't call VF driver .probe() methods
from inside a PF driver .probe() method, but that's a bigger project.

This patch is due to Alexander Duyck <alexander.h.duyck@intel.com>; I merely
added the preemption disable.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=65071
Link: http://lkml.kernel.org/r/CAE9FiQXYQEAZ=0sG6+2OdffBqfLS9MpoN1xviRR9aDbxPxcKxQ@mail.gmail.com
Link: http://lkml.kernel.org/r/20130624195942.40795.27292.stgit@ahduyck-cp1.jf.intel.com
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/pci-driver.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 454853507b7e..accae06aa79a 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -293,7 +293,9 @@ static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
 	   its local memory on the right node without any need to
 	   change it. */
 	node = dev_to_node(&dev->dev);
-	if (node >= 0) {
+	preempt_disable();
+
+	if (node >= 0 && node != numa_node_id()) {
 		int cpu;
 
 		get_online_cpus();
@@ -305,6 +307,8 @@ static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
 		put_online_cpus();
 	} else
 		error = local_pci_probe(&ddi);
+
+	preempt_enable();
 	return error;
 }
 
