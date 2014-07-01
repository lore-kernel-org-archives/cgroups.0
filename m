From: Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH cgroup/for-3.16-fixes] cpuset: break kernfs active protection
 in cpuset_write_resmask()
Date: Tue, 1 Jul 2014 09:52:40 +0800
Message-ID: <53B21468.8090500@huawei.com>
References: <53B0DD8D.5060805@huawei.com> <20140630194732.GF14807@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140630194732.GF14807@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On 2014/7/1 3:47, Tejun Heo wrote:
> Hey, Li.
> 
> Can you please test this patch and ack it?
> 
...
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Li Zefan <lizefan@huawei.com>

Tested-by: Li Zefan <lizefan@huawei.com>

Thanks!

> ---
>  kernel/cpuset.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
