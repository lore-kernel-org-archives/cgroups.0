From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: Possible regression with cgroups in 3.11
Date: Mon, 18 Nov 2013 11:14:40 -0700
Message-ID: <20131118181440.GA2996@google.com>
References: <CA+SBX_Ogo8HP81o+vrJ8ozSBN6gPwzc8WNOV3Uya=4AYv+CCyQ@mail.gmail.com>
 <CA+SBX_OJBbYzrNX5Mi4rmM2SANShXMmAvuPGczAyBdx8F2hBDQ@mail.gmail.com>
 <5270BFE7.4000602@huawei.com>
 <alpine.LNX.2.00.1310301606080.2333@eggly.anvils>
 <20131031130647.0ff6f2c7@gandalf.local.home>
 <alpine.LNX.2.00.1310311442030.2633@eggly.anvils>
 <20131113032804.GB19394@mtj.dyndns.org>
 <20131113073806.GA23244@mtj.dyndns.org>
 <20131116002820.GA31073@google.com>
 <20131116045356.GA5618@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <linux-pci-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=1ZpLf2em/BwJ3PDDvWrKj77pLctNTMJ+poeYWjxaNnc=;
        b=PJ2KrcRMsdtpz6a8b2Cye2q9Q2OdLOtlXIvoV+4Nx6cmtOnYZyDEZC52R+sKA114f4
         wA+G4MguGqGIpXozotRM2C2DUPz+8ZDWhYNcRxB5lTQRzCam5PJz1+fXwdOYVhhTiW7r
         kan8EupEMwF8x773MzU8RCoNIU46ndBy8gXtq1w/GehWK2NgtLdWFX7xvgM1Ss1QF5wu
         39CqGrZEv+uUtXg805OtN7T33UVwHEXOhvNKnNqUzzAD8QRIgA6tTZl566sAbLDUGnwa
         QMtn7qU6oEDJpQMad+Utf+wn5WnbXlg70OiI1zyd6NS1YetoGC84KxPnWg9x7Hp61dDC
         KFkg==
Content-Disposition: inline
In-Reply-To: <20131116045356.GA5618@mtj.dyndns.org>
Sender: linux-pci-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Hugh Dickins <hughd@google.com>, Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizefan@huawei.com>, Markus Blank-Burian <burian@muenster.de>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, David Rientjes <rientjes@google.com>, Ying Han <yinghan@google.com>, Greg Thelen <gthelen@google.com>, Michel Lespinasse <walken@google.com>, cgroups@vger.kernel.org, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, Lai Jiangshan <laijs@cn.fujitsu.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alexander Duyck <alexander.h.duyck@intel.com>, Yinghai Lu <yinghai@kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>

On Sat, Nov 16, 2013 at 01:53:56PM +0900, Tejun Heo wrote:
> Hello, Bjorn.
> 
> On Fri, Nov 15, 2013 at 05:28:20PM -0700, Bjorn Helgaas wrote:
> > It would be better to fix PCI so we don't call VF driver .probe() methods
> > from inside a PF driver .probe() method, but that's a bigger project.
> 
> Yeah, if pci doesn't need the recursion, we can simply revert restore
> the lockdep annoation on work_on_cpu().
> 
> > @@ -293,7 +293,9 @@ static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
> >  	   its local memory on the right node without any need to
> >  	   change it. */
> >  	node = dev_to_node(&dev->dev);
> > -	if (node >= 0) {
> > +	preempt_disable();
> > +
> > +	if (node >= 0 && node != numa_node_id()) {
> 
> A bit of comment here would be nice but yeah I think this should work.
> Can you please also queue the revert of c2fda509667b ("workqueue:
> allow work_on_cpu() to be called recursively") after this patch?
> Please feel free to add my acked-by.

OK, below are the two patches (Alex's fix + the revert) I propose to
merge.  Unless there are objections, I'll ask Linus to pull these
before v3.13-rc1.

Bjorn



commit 84f23f99b507c2c9247f47d3db0f71a3fd65e3a3
Author: Alexander Duyck <alexander.h.duyck@intel.com>
Date:   Mon Nov 18 10:59:59 2013 -0700

    PCI: Avoid unnecessary CPU switch when calling driver .probe() method
    
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
    
    [bhelgaas: disable preemption, open bugzilla, rework comments & changelog]
    Link: https://bugzilla.kernel.org/show_bug.cgi?id=65071
    Link: http://lkml.kernel.org/r/CAE9FiQXYQEAZ=0sG6+2OdffBqfLS9MpoN1xviRR9aDbxPxcKxQ@mail.gmail.com
    Link: http://lkml.kernel.org/r/20130624195942.40795.27292.stgit@ahduyck-cp1.jf.intel.com
    Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
    Acked-by: Tejun Heo <tj@kernel.org>

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 9042fdbd7244..add04e70ac2a 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -288,12 +288,24 @@ static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
 	int error, node;
 	struct drv_dev_and_id ddi = { drv, dev, id };
 
-	/* Execute driver initialization on node where the device's
-	   bus is attached to.  This way the driver likely allocates
-	   its local memory on the right node without any need to
-	   change it. */
+	/*
+	 * Execute driver initialization on node where the device is
+	 * attached.  This way the driver likely allocates its local memory
+	 * on the right node.
+	 */
 	node = dev_to_node(&dev->dev);
-	if (node >= 0) {
+	preempt_disable();
+
+	/*
+	 * On NUMA systems, we are likely to call a PF probe function using
+	 * work_on_cpu().  If that probe calls pci_enable_sriov() (which
+	 * adds the VF devices via pci_bus_add_device()), we may re-enter
+	 * this function to call the VF probe function.  Calling
+	 * work_on_cpu() again will cause a lockdep warning.  Since VFs are
+	 * always on the same node as the PF, we can work around this by
+	 * avoiding work_on_cpu() when we're already on the correct node.
+	 */
+	if (node >= 0 && node != numa_node_id()) {
 		int cpu;
 
 		get_online_cpus();
@@ -305,6 +317,8 @@ static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
 		put_online_cpus();
 	} else
 		error = local_pci_probe(&ddi);
+
+	preempt_enable();
 	return error;
 }
 
commit 2dde5285d06370b2004613ee4fd253e95622af20
Author: Bjorn Helgaas <bhelgaas@google.com>
Date:   Mon Nov 18 11:00:29 2013 -0700

    Revert "workqueue: allow work_on_cpu() to be called recursively"
    
    This reverts commit c2fda509667b0fda4372a237f5a59ea4570b1627.
    
    c2fda509667b removed lockdep annotation from work_on_cpu() to work around
    the PCI path that calls work_on_cpu() from within a work_on_cpu() work item
    (PF driver .probe() method -> pci_enable_sriov() -> add VFs -> VF driver
    .probe method).
    
    84f23f99b507 ("PCI: Avoid unnecessary CPU switch when calling driver
    .probe() method) avoids that recursive work_on_cpu() use in a different
    way, so this revert restores the work_on_cpu() lockdep annotation.
    
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
    Acked-by: Tejun Heo <tj@kernel.org>

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 987293d03ebc..5690b8eabfbc 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2840,19 +2840,6 @@ already_gone:
 	return false;
 }
 
-static bool __flush_work(struct work_struct *work)
-{
-	struct wq_barrier barr;
-
-	if (start_flush_work(work, &barr)) {
-		wait_for_completion(&barr.done);
-		destroy_work_on_stack(&barr.work);
-		return true;
-	} else {
-		return false;
-	}
-}
-
 /**
  * flush_work - wait for a work to finish executing the last queueing instance
  * @work: the work to flush
@@ -2866,10 +2853,18 @@ static bool __flush_work(struct work_struct *work)
  */
 bool flush_work(struct work_struct *work)
 {
+	struct wq_barrier barr;
+
 	lock_map_acquire(&work->lockdep_map);
 	lock_map_release(&work->lockdep_map);
 
-	return __flush_work(work);
+	if (start_flush_work(work, &barr)) {
+		wait_for_completion(&barr.done);
+		destroy_work_on_stack(&barr.work);
+		return true;
+	} else {
+		return false;
+	}
 }
 EXPORT_SYMBOL_GPL(flush_work);
 
@@ -4814,14 +4809,7 @@ long work_on_cpu(int cpu, long (*fn)(void *), void *arg)
 
 	INIT_WORK_ONSTACK(&wfc.work, work_for_cpu_fn);
 	schedule_work_on(cpu, &wfc.work);
-
-	/*
-	 * The work item is on-stack and can't lead to deadlock through
-	 * flushing.  Use __flush_work() to avoid spurious lockdep warnings
-	 * when work_on_cpu()s are nested.
-	 */
-	__flush_work(&wfc.work);
-
+	flush_work(&wfc.work);
 	return wfc.ret;
 }
 EXPORT_SYMBOL_GPL(work_on_cpu);
