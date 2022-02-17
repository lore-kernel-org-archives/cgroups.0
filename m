From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3] KVM: Move VM's worker kthreads back to the original
 cgroup before exiting.
Date: Fri, 18 Feb 2022 07:22:54 +0800
Message-ID: <202202180730.AAgeOZkF-lkp@intel.com>
References: <20220217061616.3303271-1-vipinsh@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645143683; x=1676679683;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=N32BdLCCicYvF88PVJV2JjNN97uAJo3pxS97Q2b1+KM=;
  b=JebK25hjQclsv7jqSHiEE0DjhouD4qt1Hlweeh/N3JaaLPvOya/WDJl3
   c2PnjKG1mJU6qLzaGAmlHipha9jFsT95Yg/4DMrb/NXTXgaR110a6iTsC
   I8UBubYHZRc7skItWk8OucBwc0SYrc+cZxM1teB+tUxmS7XaEnnKjPz0R
   tiosmwmc/T2cXlMHRA7YINkMxoRrRF17Mds1pXK9dWUcBmY2zjn1AYr2H
   6llKIJQL8NOTTbuV7UzINeTx2ik026zG72tzcPOd1+4t7yyEP9JIFLQya
   RsAY4lSZ02S62N1y8PDSqYcW4/KuivP+Yahwn6QOn7gU6P+3w2LYXcKRi
   w==;
Content-Disposition: inline
In-Reply-To: <20220217061616.3303271-1-vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, dmatlack-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jiangshanlai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hi Vipin,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on db6e7adf8de9b3b99a9856acb73870cc3a70e3ca]

url:    https://github.com/0day-ci/linux/commits/Vipin-Sharma/KVM-Move-VM-s-worker-kthreads-back-to-the-original-cgroup-before-exiting/20220217-141723
base:   db6e7adf8de9b3b99a9856acb73870cc3a70e3ca
config: x86_64-rhel-8.3-kselftests (https://download.01.org/0day-ci/archive/20220218/202202180730.AAgeOZkF-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/0day-ci/linux/commit/1abffef71ef85b6fb8f1296e6ef38febc4f2b007
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Vipin-Sharma/KVM-Move-VM-s-worker-kthreads-back-to-the-original-cgroup-before-exiting/20220217-141723
        git checkout 1abffef71ef85b6fb8f1296e6ef38febc4f2b007
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>


sparse warnings: (new ones prefixed by >>)
   arch/x86/kvm/../../../virt/kvm/kvm_main.c: note: in included file:
   include/linux/kvm_host.h:1877:54: sparse: sparse: array of flexible structures
   include/linux/kvm_host.h:1879:56: sparse: sparse: array of flexible structures
>> arch/x86/kvm/../../../virt/kvm/kvm_main.c:5859:54: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct task_struct *from @@     got struct task_struct [noderef] __rcu *real_parent @@
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:5859:54: sparse:     expected struct task_struct *from
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:5859:54: sparse:     got struct task_struct [noderef] __rcu *real_parent
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:538:9: sparse: sparse: context imbalance in 'kvm_mmu_notifier_change_pte' - different lock contexts for basic block
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:538:9: sparse: sparse: context imbalance in 'kvm_mmu_notifier_invalidate_range_start' - different lock contexts for basic block
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:538:9: sparse: sparse: context imbalance in 'kvm_mmu_notifier_invalidate_range_end' - different lock contexts for basic block
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:538:9: sparse: sparse: context imbalance in 'kvm_mmu_notifier_clear_flush_young' - different lock contexts for basic block
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:538:9: sparse: sparse: context imbalance in 'kvm_mmu_notifier_clear_young' - different lock contexts for basic block
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:538:9: sparse: sparse: context imbalance in 'kvm_mmu_notifier_test_young' - different lock contexts for basic block
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:2522:9: sparse: sparse: context imbalance in 'hva_to_pfn_remapped' - unexpected unlock

vim +5859 arch/x86/kvm/../../../virt/kvm/kvm_main.c

  5805	
  5806	static int kvm_vm_worker_thread(void *context)
  5807	{
  5808		/*
  5809		 * The init_context is allocated on the stack of the parent thread, so
  5810		 * we have to locally copy anything that is needed beyond initialization
  5811		 */
  5812		struct kvm_vm_worker_thread_context *init_context = context;
  5813		struct kvm *kvm = init_context->kvm;
  5814		kvm_vm_thread_fn_t thread_fn = init_context->thread_fn;
  5815		uintptr_t data = init_context->data;
  5816		int err, reattach_err;
  5817	
  5818		err = kthread_park(current);
  5819		/* kthread_park(current) is never supposed to return an error */
  5820		WARN_ON(err != 0);
  5821		if (err)
  5822			goto init_complete;
  5823	
  5824		err = cgroup_attach_task_all(init_context->parent, current);
  5825		if (err) {
  5826			kvm_err("%s: cgroup_attach_task_all failed with err %d\n",
  5827				__func__, err);
  5828			goto init_complete;
  5829		}
  5830	
  5831		set_user_nice(current, task_nice(init_context->parent));
  5832	
  5833	init_complete:
  5834		init_context->err = err;
  5835		complete(&init_context->init_done);
  5836		init_context = NULL;
  5837	
  5838		if (err)
  5839			goto out;
  5840	
  5841		/* Wait to be woken up by the spawner before proceeding. */
  5842		kthread_parkme();
  5843	
  5844		if (!kthread_should_stop())
  5845			err = thread_fn(kvm, data);
  5846	
  5847	out:
  5848		/*
  5849		 * Move kthread back to its original cgroup to prevent it lingering in
  5850		 * the cgroup of the VM process, after the latter finishes its
  5851		 * execution.
  5852		 *
  5853		 * kthread_stop() waits on the 'exited' completion condition which is
  5854		 * set in exit_mm(), via mm_release(), in do_exit(). However, the
  5855		 * kthread is removed from the cgroup in the cgroup_exit() which is
  5856		 * called after the exit_mm(). This causes the kthread_stop() to return
  5857		 * before the kthread actually quits the cgroup.
  5858		 */
> 5859		reattach_err = cgroup_attach_task_all(current->real_parent, current);
  5860		if (reattach_err) {
  5861			kvm_err("%s: cgroup_attach_task_all failed on reattach with err %d\n",
  5862				__func__, reattach_err);
  5863		}
  5864		return err;
  5865	}
  5866	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
