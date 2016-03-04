From: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 0/2] cpuacct: rename parameter in cpuusage_write for readability
Date: Fri, 4 Mar 2016 17:47:04 +0800
Message-ID: <cover.1457082730.git.zhaolei@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: zhaolei@cn.fujitsu.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org, tj@kernel.org

The name of 'reset' makes a little confusion in reading, we would
say, if we want to reset usage, return -EINVAL. That's not true.

Actually, we want to say, we only allow user to do a reset. This
patch rename reset to val and add a comment here, making the code
more readable.

Changelog v1->v2:
1: Rebase on top of 4.5-rc6
2: Fix little spelling typo in description.
3: Fix line over 80 characters
4: Add Acked-by: Tejun Heo <tj@kernel.org>

Yang Dongsheng (2):
  cpuacct: rename parameter in cpuusage_write for readability
  cpuacct: split usage into user_usage and sys_usage.

 kernel/sched/cpuacct.c | 151 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 129 insertions(+), 22 deletions(-)

-- 
1.8.5.1



