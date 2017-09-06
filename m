From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH] cgroup/cpuset: remove circular dependency deadlock
Date: Wed, 6 Sep 2017 08:56:41 -0400
Message-ID: <3992b0d5-947c-e343-5c07-8da43af5646d@redhat.com>
References: <1504698535-8187-1-git-send-email-prsood@codeaurora.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1504698535-8187-1-git-send-email-prsood@codeaurora.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Prateek Sood <prsood@codeaurora.org>, tj@kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, sramana@codeaurora.org

On 09/06/2017 07:48 AM, Prateek Sood wrote:
> Remove circular dependency deadlock in a scenario where hotplug of CPU is
> being done while there is updation in cgroup and cpuset triggered from
> userspace.
>
> Example scenario:
> kworker/0:0 => kthreadd => init:729 => init:1 => kworker/0:0
>
> kworker/0:0 - lock(cpuhotplug.mutex)  [held]
>               flush(work)   [no high prio workqueue available on CPU]
>               wait_for_completion()
>
> kthreadd    - percpu_down_read(cgroup_threadgroup_rwsem)  [waiting]
>
> init:729    - percpu_down_write(cgroup_threadgroup_rwsem)   [held]
>               lock(cpuset_mutex)   [waiting]
>
> init:1      - lock(cpuset_mutex)   [held]
>               lock(cpuhotplug.mutex)   [waiting]
>
> Eliminate this dependecy by reordering locking of cpuset_mutex
> and cpuhotplug.mutex in following order
> 1. Acquire cpuhotplug.mutex
> 2. Acquire cpuset_mutex
>
> Signed-off-by: Prateek Sood <prsood@codeaurora.org>

Is this patch for the latest upstream kernel or 4.4? There is no
cpuhotplug.mutex anymore in upstream kernel. It is a per-cpu rwsem
cpu_hotplug_lock.

Cheers,
Longman
