From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH-cgroup v6 1/6] cgroup/cpuset: Add
 cpuset.cpus.exclusive.effective for v2
Date: Tue, 15 Aug 2023 19:56:16 -0400
Message-ID: <a55f6ebe-645b-ba54-f07d-38fc4f9e499a@redhat.com>
References: <20230815153027.633355-2-longman@redhat.com>
 <202308160752.IWyhJoln-lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692143781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rMdFczi5hPu9kiJwFfBReCpil7cCsPlB4yZdjOEIHlE=;
        b=BnScEvOY85/2Fx1Soq81eLTbxXUjaNvNefRe5cO7uR4bDlDSDk2og/QhZES509kvPmVsuF
        933ume4fncqrC5UoGu4Td9cqpgGvLoM1KlmB80J3QadSdJ0Ieihj9XGDwbL2gi3C/GFJTj
        28w8U4LPbVVWpxkx7rQuKsSTAWu7Ifk=
Content-Language: en-US
In-Reply-To: <202308160752.IWyhJoln-lkp@intel.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: kernel test robot <lkp@intel.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Christian Brauner <brauner@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
Cc: oe-kbuild-all@lists.linux.dev, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Giuseppe Scrivano <gscrivan@redhat.com>

On 8/15/23 19:18, kernel test robot wrote:
> Hi Waiman,
>
> kernel test robot noticed the following build warnings:
>
> [auto build test WARNING on next-20230815]
> [cannot apply to tj-cgroup/for-next v6.5-rc6 v6.5-rc5 v6.5-rc4 linus/master v6.5-rc6]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Waiman-Long/cgroup-cpuset-Add-cpuset-cpus-exclusive-effective-for-v2/20230815-233522
> base:   next-20230815
> patch link:    https://lore.kernel.org/r/20230815153027.633355-2-longman%40redhat.com
> patch subject: [PATCH-cgroup v6 1/6] cgroup/cpuset: Add cpuset.cpus.exclusive.effective for v2
> config: parisc64-defconfig (https://download.01.org/0day-ci/archive/20230816/202308160752.IWyhJoln-lkp@intel.com/config)
> compiler: hppa-linux-gcc (GCC) 12.3.0
> reproduce: (https://download.01.org/0day-ci/archive/20230816/202308160752.IWyhJoln-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202308160752.IWyhJoln-lkp@intel.com/
>
> All warnings (new ones prefixed by >>):
>
>     kernel/cgroup/cpuset.c: In function 'update_prstate':
>>> kernel/cgroup/cpuset.c:2468:30: warning: the comparison will always evaluate as 'true' for the address of 'effective_xcpus' will never be NULL [-Waddress]
>      2468 |         if ((new_prs > 0) && !cs->effective_xcpus) {

Thanks for catching that. It is a careless mistake. Will send out a fix 
version.

Cheers,
Longman

>           |                              ^
>     kernel/cgroup/cpuset.c:135:23: note: 'effective_xcpus' declared here
>       135 |         cpumask_var_t effective_xcpus;
>           |                       ^~~~~~~~~~~~~~~
>
>
> vim +2468 kernel/cgroup/cpuset.c
>
>    2435	
>    2436	/**
>    2437	 * update_prstate - update partition_root_state
>    2438	 * @cs: the cpuset to update
>    2439	 * @new_prs: new partition root state
>    2440	 * Return: 0 if successful, != 0 if error
>    2441	 *
>    2442	 * Call with cpuset_mutex held.
>    2443	 */
>    2444	static int update_prstate(struct cpuset *cs, int new_prs)
>    2445	{
>    2446		int err = PERR_NONE, old_prs = cs->partition_root_state;
>    2447		struct tmpmasks tmpmask;
>    2448	
>    2449		if (old_prs == new_prs)
>    2450			return 0;
>    2451	
>    2452		/*
>    2453		 * For a previously invalid partition root, leave it at being
>    2454		 * invalid if new_prs is not "member".
>    2455		 */
>    2456		if (new_prs && is_prs_invalid(old_prs)) {
>    2457			cs->partition_root_state = -new_prs;
>    2458			return 0;
>    2459		}
>    2460	
>    2461		if (alloc_cpumasks(NULL, &tmpmask))
>    2462			return -ENOMEM;
>    2463	
>    2464		/*
>    2465		 * Setup effective_xcpus if not set yet, it will be cleared later
>    2466		 * if partition becomes invalid.
>    2467		 */
>> 2468		if ((new_prs > 0) && !cs->effective_xcpus) {
>    2469			struct cpuset *parent = parent_cs(cs);
>    2470	
>    2471			spin_lock_irq(&callback_lock);
>    2472			cpumask_and(cs->effective_xcpus,
>    2473				    cs->cpus_allowed, parent->effective_xcpus);
>    2474			spin_unlock_irq(&callback_lock);
>    2475		}
>    2476	
>    2477		err = update_partition_exclusive(cs, new_prs);
>    2478		if (err)
>    2479			goto out;
>    2480	
>    2481		if (!old_prs) {
>    2482			/*
>    2483			 * cpus_allowed cannot be empty.
>    2484			 */
>    2485			if (cpumask_empty(cs->cpus_allowed)) {
>    2486				err = PERR_CPUSEMPTY;
>    2487				goto out;
>    2488			}
>    2489	
>    2490			err = update_parent_effective_cpumask(cs, partcmd_enable,
>    2491							      NULL, &tmpmask);
>    2492		} else if (old_prs && new_prs) {
>    2493			/*
>    2494			 * A change in load balance state only, no change in cpumasks.
>    2495			 */
>    2496			;
>    2497		} else {
>    2498			/*
>    2499			 * Switching back to member is always allowed even if it
>    2500			 * disables child partitions.
>    2501			 */
>    2502			update_parent_effective_cpumask(cs, partcmd_disable, NULL,
>    2503							&tmpmask);
>    2504	
>    2505			/*
>    2506			 * Invalidation of child partitions will be done in
>    2507			 * update_cpumasks_hier().
>    2508			 */
>    2509		}
>    2510	out:
>    2511		/*
>    2512		 * Make partition invalid & disable CS_CPU_EXCLUSIVE if an error
>    2513		 * happens.
>    2514		 */
>    2515		if (err) {
>    2516			new_prs = -new_prs;
>    2517			update_partition_exclusive(cs, new_prs);
>    2518		}
>    2519	
>    2520		spin_lock_irq(&callback_lock);
>    2521		cs->partition_root_state = new_prs;
>    2522		WRITE_ONCE(cs->prs_err, err);
>    2523		if (!is_partition_valid(cs))
>    2524			cpumask_clear(cs->effective_xcpus);
>    2525		spin_unlock_irq(&callback_lock);
>    2526	
>    2527		/* Force update if switching back to member */
>    2528		update_cpumasks_hier(cs, &tmpmask, !new_prs ? HIER_CHECKALL : 0);
>    2529	
>    2530		/* Update sched domains and load balance flag */
>    2531		update_partition_sd_lb(cs, old_prs);
>    2532	
>    2533		notify_partition_change(cs, old_prs);
>    2534		free_cpumasks(NULL, &tmpmask);
>    2535		return 0;
>    2536	}
>    2537	
>

