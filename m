From: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: RE: [RESEND PATCH 2/2] cpuacct: split usage into user_usage and sys_usage.
Date: Tue, 1 Mar 2016 18:35:56 +0800
Message-ID: <010801d173a6$237a2d70$6a6e8850$@cn.fujitsu.com>
References: <1450696483-2864-1-git-send-email-yangds.fnst@cn.fujitsu.com> <1450696483-2864-2-git-send-email-yangds.fnst@cn.fujitsu.com> <20151221213328.GP4026@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151221213328.GP4026@mtj.duckdns.org>
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: 'Tejun Heo' <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org

Hi, Tejun Heo

> From: linux-kernel-owner@vger.kernel.org
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Tejun Heo
> Sent: Tuesday, December 22, 2015 5:33 AM
> To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> Cc: cgroups@vger.kernel.org; linux-kernel@vger.kernel.org;
> mingo@redhat.com; peterz@infradead.org
> Subject: Re: [RESEND PATCH 2/2] cpuacct: split usage into user_usage and
> sys_usage.
> 
> On Mon, Dec 21, 2015 at 07:14:43PM +0800, Dongsheng Yang wrote:
> > Sometimes, cpuacct.usage is not detialed enough to user
> > to see how much usage a group used. We want to know how
> > much time it used in user mode and how much in kernel mode.
> 
Yang gave this patch to me :)
I'm plan to continue this function.

> cpuusage is being phased out.  If you need these stats, please
> implement it on cpu side.
> 
Currently, old stats are put in cpuacct, if we put new stats into cpu side,
we have following way:

1: Only put new stats into cpu side, and don't change old interface,
   we'll see following content in cgroup dir:
   /cgroup/cpuacct:
     cpuacct.usage
     cpuacct.usage_percpu
   /cgroup/cpu:
     cpu.usage_sys
     cpu.usage_percpu_sys
     cpu.usage_user
     cpu.usage_percpu_user
   It is obviously not unify.
2: Move old stats into cpu side, and add new stats:
   we'll see following content in cgroup dir:
   /cgroup/cpuacct:
     [NONE]
   /cgroup/cpu:
     cpu.usage
     cpu.usage_percpu
     cpu.usage_sys
     cpu.usage_percpu_sys
     cpu.usage_user
     cpu.usage_percpu_user
   It have compatibility issues with old system.
3: Clone old stats into cpu side(share one copy of code), and add new stats
   Into cpu side, we'll see following content in cgroup dir:
   /cgroup/cpuacct:
     cpuacct.usage
     cpuacct.usage_percpu
   /cgroup/cpu:
     cpu.usage
     cpu.usage_percpu
     cpu.usage_sys
     cpu.usage_percpu_sys
     cpu.usage_user
     cpu.usage_percpu_user
   It can support both old and new systems, and we can remove old interface
   in future, but we if mount both cpu and cpuacct into same dir,
   we'll see following duplicated files:
   /cgroup/cpu,cpuacct
     cpu.usage
     cpuacct.usage
     cpu.usage_percpu
     cpuacct.usage_percpu
     ...

Maybe above way3 looks having less defect, cound you talk about
your opinion on it.

Thanks
Zhaolei




