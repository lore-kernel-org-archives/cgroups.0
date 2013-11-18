From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Mon, 18 Nov 2013 11:29:32 -0800
Message-ID: <CAE9FiQW07ZAU_0bjkrwK54TAn48ByyS=kXNFwQJ-G2FFkK_W3A@mail.gmail.com>
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
	<20131118181440.GA2996@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=IxxxXPJgaXFFB6SVAwqJDD8TFFdQUVyvc+5OWrQeVQc=;
        b=OY9clk3wn8PXjKhCX//GJQTo4VRVwRUDdZQbiLFiBV43b7ZICv7odgZ/U4VgR1f5Qc
         /k+lgGdfUz9uV4Ykc7ATaLLKDwGwtg+WbfRx5tDUox7Of03sWUsiuy7B+LVBlNhwD5Er
         /yLA0LRzMNUmL3ppLcw6g65V7qYpd0jaUbAJ9WzNg/X6tLb83/9BB7scKx5W7y92JOIw
         JUkgsUmwYY37QpM2ye9xQZ0eoflWs7dGvqR9nLOg9zJceMS70CTqE8iOcKg5UwKPxbZh
         Pg1JruHzPTZAKISoRtAC5ttU/2lkx4uaCU3YGQCbPbd6RWC81VYLsrFXY2x9LwRPNa5/
         isTw==
In-Reply-To: <20131118181440.GA2996-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Srivatsa S. Bhat" <srivatsa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, Alexander Duyck <alexander.h.duyck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Nov 18, 2013 at 10:14 AM, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>> A bit of comment here would be nice but yeah I think this should work.
>> Can you please also queue the revert of c2fda509667b ("workqueue:
>> allow work_on_cpu() to be called recursively") after this patch?
>> Please feel free to add my acked-by.
>
> OK, below are the two patches (Alex's fix + the revert) I propose to
> merge.  Unless there are objections, I'll ask Linus to pull these
> before v3.13-rc1.
>
>
>
> commit 84f23f99b507c2c9247f47d3db0f71a3fd65e3a3
> Author: Alexander Duyck <alexander.h.duyck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Date:   Mon Nov 18 10:59:59 2013 -0700
>
>     PCI: Avoid unnecessary CPU switch when calling driver .probe() method
>
>     If we are already on a CPU local to the device, call the driver .probe()
>     method directly without using work_on_cpu().
>
>     This is a workaround for a lockdep warning in the following scenario:
>
>       pci_call_probe
>         work_on_cpu(cpu, local_pci_probe, ...)
>           driver .probe
>             pci_enable_sriov
>               ...
>                 pci_bus_add_device
>                   ...
>                     pci_call_probe
>                       work_on_cpu(cpu, local_pci_probe, ...)
>
>     It would be better to fix PCI so we don't call VF driver .probe() methods
>     from inside a PF driver .probe() method, but that's a bigger project.
>
>     [bhelgaas: disable preemption, open bugzilla, rework comments & changelog]
>     Link: https://bugzilla.kernel.org/show_bug.cgi?id=65071
>     Link: http://lkml.kernel.org/r/CAE9FiQXYQEAZ=0sG6+2OdffBqfLS9MpoN1xviRR9aDbxPxcKxQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org
>     Link: http://lkml.kernel.org/r/20130624195942.40795.27292.stgit-+uVpp3jiz/Q1YPczIWDRvLvm/XP+8Wra@public.gmane.org
>     Signed-off-by: Alexander Duyck <alexander.h.duyck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>     Signed-off-by: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>     Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Tested-by: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Acked-by: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

>
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index 9042fdbd7244..add04e70ac2a 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -288,12 +288,24 @@ static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
>         int error, node;
>         struct drv_dev_and_id ddi = { drv, dev, id };
>
> -       /* Execute driver initialization on node where the device's
> -          bus is attached to.  This way the driver likely allocates
> -          its local memory on the right node without any need to
> -          change it. */
> +       /*
> +        * Execute driver initialization on node where the device is
> +        * attached.  This way the driver likely allocates its local memory
> +        * on the right node.
> +        */
>         node = dev_to_node(&dev->dev);
> -       if (node >= 0) {
> +       preempt_disable();
> +
> +       /*
> +        * On NUMA systems, we are likely to call a PF probe function using
> +        * work_on_cpu().  If that probe calls pci_enable_sriov() (which
> +        * adds the VF devices via pci_bus_add_device()), we may re-enter
> +        * this function to call the VF probe function.  Calling
> +        * work_on_cpu() again will cause a lockdep warning.  Since VFs are
> +        * always on the same node as the PF, we can work around this by
> +        * avoiding work_on_cpu() when we're already on the correct node.
> +        */
> +       if (node >= 0 && node != numa_node_id()) {
>                 int cpu;
>
>                 get_online_cpus();
> @@ -305,6 +317,8 @@ static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
>                 put_online_cpus();
>         } else
>                 error = local_pci_probe(&ddi);
> +
> +       preempt_enable();
>         return error;
>  }
