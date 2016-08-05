From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] Cgroup:Fix race between fork and update cpuset mask
Date: Fri, 5 Aug 2016 12:49:22 +0200
Message-ID: <20160805104922.GA857@kroah.com>
References: <1470309783-11328-1-git-send-email-chaixianping@huawei.com>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1470309783-11328-1-git-send-email-chaixianping@huawei.com>
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: chaixianping@huawei.com
Cc: lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Zhenghua Jia <jiazhenghua@huawei.com>, Leeyou <leeyou.li@huawei.com>, Lei Liu <liulei@huawei.com>

On Thu, Aug 04, 2016 at 07:23:03PM +0800, chaixianping@huawei.com wrote:
> From: chaixianping <chaixianping@huawei.com>
> 
> Fix the race between fork and update_cpumask or update_nodemask.
> Scenario as follows:
> 1)A process fork a child process, the child process have
> inherited the parent process cpus_allowed,mems_allowed
> Before being added cset->tasks list.
> 2)Update_cpumask or update_nodemask change the parent's allowed
> to a new value, *but the child still is the old value.
> after being added cset->tasks list.
> 
> Signed-off-by: Xianping Chai <chaixianping@huawei.com>

This name doesn't match your From: line :(

> Signed-off-by: Zhenghua Jia <jiazhenghua@huawei.com>
> Signed-off-by: Leeyou <leeyou.li@huawei.com>
> Signed-off-by: Lei Liu <liulei@huawei.com>
> ---
>  kernel/cpuset.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
