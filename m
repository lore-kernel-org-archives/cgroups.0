From: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [cgroup:blkcg-cfq-hierarchy 18/18]
 /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1:
 /dev/shm/build-error-mips-fuloong2e_defconfig/10257-10576-136: No space left
 on devicemake[3]: Warning: File `scripts/Makefile.host' has modification
 time 3.6e+08 s in the future
Date: Thu, 20 Dec 2012 17:11:20 +0800
Message-ID: <20121220091120.GC8074@localhost>
References: <50d2a863.TEK+QRhleDioyP1G%fengguang.wu@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <50d2a863.TEK+QRhleDioyP1G%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Sorry! Please ignore this internal build system error.
I'll prevent it from happening again!

On Thu, Dec 20, 2012 at 01:55:47PM +0800, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git blkcg-cfq-hierarchy
> head:   945010db297e9dbe05453af789490f21b99ea8a0
> commit: 945010db297e9dbe05453af789490f21b99ea8a0 [18/18] cfq-iosched: add hierarchical cfq_group statistics
> config: make ARCH=mips fuloong2e_defconfig
> 
> All warnings:
> 
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10257-10263-104: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10257-10264-206: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10257-10270-206: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10257-10276-379: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10257-10288-391: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10257-10293-431: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10257-10305-437: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10257-10322-431: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10257-10337-437: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10257-10372-393: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10257-10401-393: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10257-10423-395: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10257-10426-395: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10257-10445-395: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10257-10457-389: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10257-10472-395: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10257-10483-383: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10257-10498-407: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10257-10516-407: No space left on device
> make[2]: Warning: File `arch/mips/wrppmc/Platform' has modification time 3.6e+08 s in the future
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10257-10566-46: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10257-10568-94: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10257-10570-46: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10257-10575-38: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10257-10576-136: No space left on devicemake[3]: Warning: File `scripts/Makefile.host' has modification time 3.6e+08 s in the future
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10568-10584-628: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10568-10711-1: No space left on device
> make[3]: warning:  Clock skew detected.  Your build may be incomplete.
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10257-10715-29: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10257-10717-46: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10257-10723-37: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10257-10725-112: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10725-10729-50: No space left on device
> make[3]: Warning: File `scripts/Makefile.host' has modification time 3.6e+08 s in the future
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10725-10731-85: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10725-10733-134: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10725-10789-85: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10725-10793-134: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10725-10830-85: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10725-10835-134: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10725-10863-85: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10725-10867-134: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10725-10884-726: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10725-10886-139: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10725-10885-139: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10725-10887-142: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10725-10894-85: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10725-10898-134: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10725-10904-85: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10725-10906-134: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10725-10925-85: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10725-10927-134: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10725-10946-85: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10725-10948-134: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10725-10967-865: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10725-12248-275: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10725-12281-26: No space left on device
> /dev/shm/bash-redirect-mips-fuloong2e_defconfig: line 1: /dev/shm/build-error-mips-fuloong2e_defconfig/10725-12283-46: No space left on device
> make[3]: warning:  Clock skew detected.  Your build may be incomplete.
> make[2]: warning:  Clock skew detected.  Your build may be incomplete.
> 
> ---
> 0-DAY kernel build testing backend         Open Source Technology Center
> Fengguang Wu, Yuanhan Liu                              Intel Corporation
