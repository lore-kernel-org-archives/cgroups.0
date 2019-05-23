From: Roman Gushchin <guro@fb.com>
Subject: Re: [mm] e52271917f:
 BUG:sleeping_function_called_from_invalid_context_at_mm/slab.h
Date: Thu, 23 May 2019 21:00:46 +0000
Message-ID: <20190523210040.GA8420@tower.DHCP.thefacebook.com>
References: <20190514213940.2405198-6-guro@fb.com>
 <20190523005858.GJ19312@shao2-debian>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ClXmZI/N8fwomQ8i6o2AXSf9bNgp0rLsWx833fh4w7w=;
 b=oyz/0Gh3XwjNR0oV+t3VLB0rHM+XdWjakeoqcANNGJD2oebAcnO8BM5XPXWUew0qud6s
 pkAAPEwMSl+j7Yg89U8dLSJxr5YjZ29tVzWX7TT1p2GG1SzIvFyuYntHn3G6y9YE0tTc
 gJ/qwyA++j9+/2tp4bb2+v/QxuMhoceKs88= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ClXmZI/N8fwomQ8i6o2AXSf9bNgp0rLsWx833fh4w7w=;
 b=PLZ9cqz2KZq65koeqD8iXRwBudhiGAyk5JVjfYRsOv1kA9inn4eYt4DmhNd6INkgWu1rAOwc2DcFTBjwimXBxEqHYckOzsgfxTZ5tLeq5RyZeddQGNLr/Div8May8XsBnMsEchBKPFvywYzW0BKpavGJVTqX4JlaxBbvDtN5tOs=
In-Reply-To: <20190523005858.GJ19312@shao2-debian>
Content-Language: en-US
Content-ID: <14F14FC4BCF487408A51CD4FB01F9AD2@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: kernel test robot <rong.a.chen@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeelb@google.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, Christoph Lameter <cl@linux.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "lkp@01.org" <lkp@01.org>

On Thu, May 23, 2019 at 08:58:58AM +0800, kernel test robot wrote:
> FYI, we noticed the following commit (built with gcc-7):
>=20
> commit: e52271917f9f5159c791eda8ba748a66d659c27e ("[PATCH v4 5/7] mm: rew=
ork non-root kmem_cache lifecycle management")
> url: https://github.com/0day-ci/linux/commits/Roman-Gushchin/mm-reparent-=
slab-memory-on-cgroup-removal/20190517-173841
>=20
>=20
> in testcase: nvml
> with following parameters:
>=20
> 	group: obj
> 	test: non-pmem
>=20
>=20
>=20
> on test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -=
m 8G
>=20
> caused below changes (please refer to attached dmesg/kmsg for entire log/=
backtrace):
>=20
>=20
> +------------------------------------------------------------------------=
------+------------+------------+
> |                                                                        =
      | ff756a15f3 | e52271917f |
> +------------------------------------------------------------------------=
------+------------+------------+
> | boot_successes                                                         =
      | 5          | 4          |
> | boot_failures                                                          =
      | 861        | 852        |
> | BUG:kernel_reboot-without-warning_in_test_stage                        =
      | 738        | 163        |
> | BUG:kernel_hang_in_boot_stage                                          =
      | 120        | 122        |
> | BUG:soft_lockup-CPU##stuck_for#s                                       =
      | 4          | 1          |
> | RIP:free_unref_page                                                    =
      | 1          |            |
> | Kernel_panic-not_syncing:softlockup:hung_tasks                         =
      | 4          | 1          |
> | RIP:free_reserved_area                                                 =
      | 3          | 1          |
> | BUG:sleeping_function_called_from_invalid_context_at_mm/slab.h         =
      | 0          | 560        |
> | BUG:scheduling_while_atomic                                            =
      | 0          | 561        |
> | WARNING:at_lib/usercopy.c:#_copy_to_user                               =
      | 0          | 116        |
> | RIP:_copy_to_user                                                      =
      | 0          | 116        |
> | WARNING:at_arch/x86/kernel/fpu/signal.c:#copy_fpstate_to_sigframe      =
      | 0          | 534        |
> | RIP:copy_fpstate_to_sigframe                                           =
      | 0          | 532        |
> | WARNING:at_arch/x86/kernel/signal.c:#do_signal                         =
      | 0          | 527        |
> | RIP:do_signal                                                          =
      | 0          | 526        |
> | WARNING:at_lib/usercopy.c:#_copy_from_user                             =
      | 0          | 389        |
> | RIP:_copy_from_user                                                    =
      | 0          | 388        |
> | kernel_BUG_at_mm/vmalloc.c                                             =
      | 0          | 304        |
> | invalid_opcode:#[##]                                                   =
      | 0          | 304        |
> | RIP:__get_vm_area_node                                                 =
      | 0          | 301        |
> | Kernel_panic-not_syncing:Fatal_exception_in_interrupt                  =
      | 0          | 294        |
> | Kernel_panic-not_syncing:Aiee,killing_interrupt_handler                =
      | 0          | 155        |
> | WARNING:at_fs/read_write.c:#vfs_write                                  =
      | 0          | 15         |
> | RIP:vfs_write                                                          =
      | 0          | 15         |
> | BUG:sleeping_function_called_from_invalid_context_at_kernel/locking/rws=
em.c  | 0          | 101        |
> | BUG:sleeping_function_called_from_invalid_context_at_include/linux/uacc=
ess.h | 0          | 54         |
> | Kernel_panic-not_syncing:Attempted_to_kill_init!exitcode=3D            =
        | 0          | 47         |
> | BUG:sleeping_function_called_from_invalid_context_at_lib/iov_iter.c    =
      | 0          | 1          |
> | BUG:sleeping_function_called_from_invalid_context_at_fs/dcache.c       =
      | 0          | 57         |
> | BUG:sleeping_function_called_from_invalid_context_at_mm/memory.c       =
      | 0          | 1          |
> | BUG:sleeping_function_called_from_invalid_context_at_kernel/locking/mut=
ex.c  | 0          | 104        |
> | BUG:kernel_hang_in_test_stage                                          =
      | 0          | 5          |
> | WARNING:at_arch/x86/include/asm/uaccess.h:#strncpy_from_user           =
      | 0          | 4          |
> | RIP:strncpy_from_user                                                  =
      | 0          | 4          |
> | WARNING:at_fs/read_write.c:#vfs_read                                   =
      | 0          | 4          |
> | RIP:vfs_read                                                           =
      | 0          | 4          |
> | BUG:sleeping_function_called_from_invalid_context_at_mm/filemap.c      =
      | 0          | 3          |
> | BUG:sleeping_function_called_from_invalid_context_at_mm/page_alloc.c   =
      | 0          | 8          |
> | BUG:sleeping_function_called_from_invalid_context_at_mm/gup.c          =
      | 0          | 1          |
> | BUG:sleeping_function_called_from_invalid_context_at_include/linux/free=
zer.h | 0          | 1          |
> | BUG:sleeping_function_called_from_invalid_context_at/kb                =
      | 0          | 1          |
> +------------------------------------------------------------------------=
------+------------+------------+
>=20
>=20
> If you fix the issue, kindly add following tag
> Reported-by: kernel test robot <rong.a.chen@intel.com>

Hi!

It seems that it's caused by unbalanced rcu_read_lock(),
which already has been fixed in v5.

Thanks!
