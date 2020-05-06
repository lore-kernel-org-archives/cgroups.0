From: Zefan Li <lizefan@huawei.com>
Subject: Re: cgroup pointed by sock is leaked on mode switch
Date: Wed, 6 May 2020 15:51:31 +0800
Message-ID: <1edd6b6c-ab3c-6a51-6460-6f5d7f37505e@huawei.com>
References: <03dab6ab-0ffe-3cae-193f-a7f84e9b14c5@huawei.com>
 <20200505160639.GG12217@mtj.thefacebook.com>
 <c9879fd2-cb91-2a08-8293-c6a436b5a539@huawei.com>
 <0a6ae984-e647-5ada-8849-3fa2fb994ff3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0a6ae984-e647-5ada-8849-3fa2fb994ff3@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Yang Yingliang <yangyingliang@huawei.com>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, netdev@vger.kernel.org, "Libin (Huawei)" <huawei.libin@huawei.com>, guofan5@huawei.com, wangkefeng.wang@huawei.com

On 2020/5/6 10:16, Zefan Li wrote:
> On 2020/5/6 9:50, Yang Yingliang wrotee:
>> +cc lizefan@huawei.com
>>
>> On 2020/5/6 0:06, Tejun Heo wrote:
>>> Hello, Yang.
>>>
>>> On Sat, May 02, 2020 at 06:27:21PM +0800, Yang Yingliang wrote:
>>>> I find the number nr_dying_descendants is increasing:
>>>> linux-dVpNUK:~ # find /sys/fs/cgroup/ -name cgroup.stat -exec grep
>>>> '^nr_dying_descendants [^0]'  {} +
>>>> /sys/fs/cgroup/unified/cgroup.stat:nr_dying_descendants 80
>>>> /sys/fs/cgroup/unified/system.slice/cgroup.stat:nr_dying_descendants 1
>>>> /sys/fs/cgroup/unified/system.slice/system-hostos.slice/cgroup.stat:nr_dying_descendants
>>>> 1
>>>> /sys/fs/cgroup/unified/lxc/cgroup.stat:nr_dying_descendants 79
>>>> /sys/fs/cgroup/unified/lxc/5f1fdb8c54fa40c3e599613dab6e4815058b76ebada8a27bc1fe80c0d4801764/cgroup.stat:nr_dying_descendants
>>>> 78
>>>> /sys/fs/cgroup/unified/lxc/5f1fdb8c54fa40c3e599613dab6e4815058b76ebada8a27bc1fe80c0d4801764/system.slice/cgroup.stat:nr_dying_descendants
>>>> 78
>>> Those numbers are nowhere close to causing oom issues. There are some
>>> aspects of page and other cache draining which is being improved but unless
>>> you're seeing numbers multiple orders of magnitude higher, this isn't the
>>> source of your problem.
>>>
>>>> The situation is as same as the commit bd1060a1d671 ("sock, cgroup: add
>>>> sock->sk_cgroup") describes.
>>>> "On mode switch, cgroup references which are already being pointed to by
>>>> socks may be leaked."
>>> I'm doubtful that you're hitting that issue. Mode switching means memcg
>>> being switched between cgroup1 and cgroup2 hierarchies, which is unlikely to
>>> be what's happening when you're launching docker containers.
>>>
>>> The first step would be identifying where memory is going and finding out
>>> whether memcg is actually being switched between cgroup1 and 2 - look at the
>>> hierarchy number in /proc/cgroups, if that's switching between 0 and
>>> someting not zero, it is switching.
>>>
> 
> I think there's a bug here which can lead to unlimited memory leak.
> This should reproduce the bug:
> 
>     # mount -t cgroup -o netprio xxx /cgroup/netprio
>     # mkdir /cgroup/netprio/xxx
>     # echo PID > /cgroup/netprio/xxx/tasks
>     /* this PID process starts to do some network thing and then exits */
>     # rmdir /cgroup/netprio/xxx
>     /* now this cgroup will never be freed */
> 

Correction (still not tested):

     # mount -t cgroup2 none /cgroup/v2
     # mkdir /cgroup/v2/xxx
     # echo PID > /cgroup/v2/xxx/cgroup.procs
     /* this PID process starts to do some network thing */

     # mount -t cgroup -o netprio xxx /cgroup/netprio
     # mkdir /cgroup/netprio/xxx
     # echo PID > /cgroup/netprio/xxx/tasks
     ...
     /* the PID process exits */

     rmdir /cgroup/netprio/xxx
     rmdir /cgroup/v2/xxx
     /* now looks like this v2 cgroup will never be freed */

> Look at the code:
> 
> static inline void sock_update_netprioidx(struct sock_cgroup_data *skcd)
> {
>      ...
>      sock_cgroup_set_prioidx(skcd, task_netprioidx(current));
> }
> 
> static inline void sock_cgroup_set_prioidx(struct sock_cgroup_data *skcd,
>                      u16 prioidx)
> {
>      ...
>      if (sock_cgroup_prioidx(&skcd_buf) == prioidx)
>          return ;
>      ...
>      skcd_buf.prioidx = prioidx;
>      WRITE_ONCE(skcd->val, skcd_buf.val);
> }
> 
> task_netprioidx() will be the cgrp id of xxx which is not 1, but
> sock_cgroup_prioidx(&skcd_buf) is 1 because it thought it's in v2 mode.
> Now we have a memory leak.
> 
> I think the eastest fix is to do the mode switch here:
> 
> diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
> index b905747..2397866 100644
> --- a/net/core/netprio_cgroup.c
> +++ b/net/core/netprio_cgroup.c
> @@ -240,6 +240,8 @@ static void net_prio_attach(struct cgroup_taskset *tset)
>          struct task_struct *p;
>          struct cgroup_subsys_state *css;
> 
> +       cgroup_sk_alloc_disable();
> +
>          cgroup_taskset_for_each(p, css, tset) {
>                  void *v = (void *)(unsigned long)css->cgroup->id;

