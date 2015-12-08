From: Andy Whitcroft <apw@canonical.com>
Subject: cgroup pids controller -- WARN_ON_ONCE triggering
Date: Tue, 8 Dec 2015 14:58:51 +0000
Message-ID: <20151208145851.GJ9837@bark>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Martin Pitt <martin.pitt@ubuntu.com>

The commit below attempts to fix up pid controller charging:

  commit afcf6c8b75444382e0f9996157207ebae34a8848
  Author: Tejun Heo <tj@kernel.org>
  Date:   Thu Oct 15 16:41:53 2015 -0400

    cgroup: add cgroup_subsys->free() method and use it to fix pids controller

Since this change we are seeing system hangs in early boot on multiple
architecures.  We have a console log on ppc64el [1] which fingers
pids_cancel().  Manual debugging on amd64 VMs seems to indicate that we
are now tripping the WARN_ON_ONCE() below:

  static void pids_cancel(struct pids_cgroup *pids, int num)
  {
        /*
         * A negative count (or overflow for that matter) is invalid,
         * and indicates a bug in the `pids` controller proper.
         */
        WARN_ON_ONCE(atomic64_add_negative(-num, &pids->counter));
  }

Converting this to a printk I was able to obtain confirmation that we are
indeed seeing this go negative in some cases.

Reverting the above commit seems to resolve the early boot issues in
my testing.

-apw

[1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1523586
