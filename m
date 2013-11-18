From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: Possible regression with cgroups in 3.11
Date: Mon, 18 Nov 2013 13:39:25 -0700
Message-ID: <20131118203925.GA26682@google.com>
References: <5270BFE7.4000602@huawei.com>
 <alpine.LNX.2.00.1310301606080.2333@eggly.anvils>
 <20131031130647.0ff6f2c7@gandalf.local.home>
 <alpine.LNX.2.00.1310311442030.2633@eggly.anvils>
 <20131113032804.GB19394@mtj.dyndns.org>
 <20131113073806.GA23244@mtj.dyndns.org>
 <20131116002820.GA31073@google.com>
 <20131116045356.GA5618@mtj.dyndns.org>
 <20131118181440.GA2996@google.com>
 <CAE9FiQW07ZAU_0bjkrwK54TAn48ByyS=kXNFwQJ-G2FFkK_W3A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=lDhJhjjnuIL3Fc/H7KzWkzCmBZ634Uwodq1zc90NcuY=;
        b=imMLJ7luBGe5P4V6y/Upk0z2XPJ9lvvTfBBtjOMoGaE8WISqXVD4wiFpilCJtxcmnb
         bVY5TAgprgLAaeVZjEaqsc12BTcqTs+wkvT3wk5EI3Og4h6Km8bbAbSNVjA/r5uwecGH
         3kEVpoiRYeJMEo9wq2FK1WfXZa6ToubWwG8P1roO04PwhaDIeaW70UmyO/rdMsivfOsg
         SR8T4pf2HuSk9nOFlUNazfYz6/expvRHtOx6iHanuW3BqceKXeE1alQkyDpcmXdFoKI8
         IgKWp/l0VlTIE8f/+mfLZIa4UfTtTCzZfdutOdPeoHWDTGIfRG1P7b3gUMkvaHGH0xOU
         sNSg==
Content-Disposition: inline
In-Reply-To: <CAE9FiQW07ZAU_0bjkrwK54TAn48ByyS=kXNFwQJ-G2FFkK_W3A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>, Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizefan@huawei.com>, Markus Blank-Burian <burian@muenster.de>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, David Rientjes <rientjes@google.com>, Ying Han <yinghan@google.com>, Greg Thelen <gthelen@google.com>, Michel Lespinasse <walken@google.com>, cgroups@vger.kernel.org, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, Lai Jiangshan <laijs@cn.fujitsu.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alexander Duyck <alexander.h.duyck@intel.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>

On Mon, Nov 18, 2013 at 11:29:32AM -0800, Yinghai Lu wrote:
> On Mon, Nov 18, 2013 at 10:14 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> >> A bit of comment here would be nice but yeah I think this should work.
> >> Can you please also queue the revert of c2fda509667b ("workqueue:
> >> allow work_on_cpu() to be called recursively") after this patch?
> >> Please feel free to add my acked-by.
> >
> > OK, below are the two patches (Alex's fix + the revert) I propose to
> > merge.  Unless there are objections, I'll ask Linus to pull these
> > before v3.13-rc1.
> >
> >
> >
> > commit 84f23f99b507c2c9247f47d3db0f71a3fd65e3a3
> > Author: Alexander Duyck <alexander.h.duyck@intel.com>
> > Date:   Mon Nov 18 10:59:59 2013 -0700
> >
> >     PCI: Avoid unnecessary CPU switch when calling driver .probe() method
> >
> >     If we are already on a CPU local to the device, call the driver .probe()
> >     method directly without using work_on_cpu().
> >
> >     This is a workaround for a lockdep warning in the following scenario:
> >
> >       pci_call_probe
> >         work_on_cpu(cpu, local_pci_probe, ...)
> >           driver .probe
> >             pci_enable_sriov
> >               ...
> >                 pci_bus_add_device
> >                   ...
> >                     pci_call_probe
> >                       work_on_cpu(cpu, local_pci_probe, ...)
> >
> >     It would be better to fix PCI so we don't call VF driver .probe() methods
> >     from inside a PF driver .probe() method, but that's a bigger project.
> >
> >     [bhelgaas: disable preemption, open bugzilla, rework comments & changelog]
> >     Link: https://bugzilla.kernel.org/show_bug.cgi?id=65071
> >     Link: http://lkml.kernel.org/r/CAE9FiQXYQEAZ=0sG6+2OdffBqfLS9MpoN1xviRR9aDbxPxcKxQ@mail.gmail.com
> >     Link: http://lkml.kernel.org/r/20130624195942.40795.27292.stgit@ahduyck-cp1.jf.intel.com
> >     Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
> >     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> >     Acked-by: Tejun Heo <tj@kernel.org>
> 
> Tested-by: Yinghai Lu <yinghai@kernel.org>
> Acked-by: Yinghai Lu <yinghai@kernel.org>

Thanks, I added these and pushed my for-linus branch for -next to
pick up before I ask Linus to pull them.

Bjorn
