From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] netprio_cgroup: Fix unlimited memory leak of v2
 cgroups
Date: Fri, 22 May 2020 11:26:40 +0800
Message-ID: <37ad9c6e-b8e9-d23a-f168-fca2292ef5c5@huawei.com>
References: <939566f5-abe3-3526-d4ff-ec6bf8e8c138@huawei.com>
 <2fcd921d-8f42-9d33-951c-899d0bbdd92d@huawei.com>
 <20200508225829.0880cf8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200509210214.408e847a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <5ec6ef43d98e7_3bbf2ab912c625b4eb@john-XPS-13-9370.notmuch>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5ec6ef43d98e7_3bbf2ab912c625b4eb-GYDld3P+uZbG4UIVCGB8E+wMoONJIhNL@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, yangyingliang <yangyingliang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Kefeng Wang <wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, huawei.libin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, guofan5-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Network Developers <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2020/5/22 5:14, John Fastabend wrote:
> Jakub Kicinski wrote:
>> On Fri, 8 May 2020 22:58:29 -0700 Jakub Kicinski wrote:
>>> On Sat, 9 May 2020 11:32:10 +0800 Zefan Li wrote:
>>>> If systemd is configured to use hybrid mode which enables the use of
>>>> both cgroup v1 and v2, systemd will create new cgroup on both the default
>>>> root (v2) and netprio_cgroup hierarchy (v1) for a new session and attach
>>>> task to the two cgroups. If the task does some network thing then the v2
>>>> cgroup can never be freed after the session exited.
>>>>
>>>> One of our machines ran into OOM due to this memory leak.
>>>>
>>>> In the scenario described above when sk_alloc() is called cgroup_sk_alloc()
>>>> thought it's in v2 mode, so it stores the cgroup pointer in sk->sk_cgrp_data
>>>> and increments the cgroup refcnt, but then sock_update_netprioidx() thought
>>>> it's in v1 mode, so it stores netprioidx value in sk->sk_cgrp_data, so the
>>>> cgroup refcnt will never be freed.
>>>>
>>>> Currently we do the mode switch when someone writes to the ifpriomap cgroup
>>>> control file. The easiest fix is to also do the switch when a task is attached
>>>> to a new cgroup.
>>>>
>>>> Fixes: bd1060a1d671("sock, cgroup: add sock->sk_cgroup")  
>>>
>>>                      ^ space missing here
>>>
>>>> Reported-by: Yang Yingliang <yangyingliang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>>> Tested-by: Yang Yingliang <yangyingliang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>>> Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>
>> Fixed up the commit message and applied, thank you.
> 
> Hi Zefan, Tejun,
> 
> This is causing a regression where previously cgroupv2 bpf sockops programs
> could be attached and would run even if netprio_cgroup was enabled as long
> as  the netprio cgroup had not been configured. After this the bpf sockops
> programs can still be attached but only programs attached to the root cgroup
> will be run. For example I hit this when I ran bpf selftests on a box that
> also happened to have netprio cgroup enabled, tests started failing after
> bumping kernel to rc5.
> 
> I'm a bit on the fence here if it needs to be reverted. For my case its just
> a test box and easy enough to work around. Also all the production cases I
> have already have to be aware of this to avoid the configured error. So it
> may be fine but worth noting at least. Added Alexei to see if he has any
> opinion and/or uses net_prio+cgroubv2. I only looked it over briefly but
> didn't see any simple rc6 worthy fixes that would fix the issue above and
> also keep the original behavior.
> 

Me neither. If we really want to keep the original behavior we probably need
to do something similar to what netclassid cgroup does, which is to iterate
all the tasks in the cgroup to update netprioidx when netprio cgroup is
configured, and we also need to not update netprioidx when a task is attached
to a new cgroup.

> And then while reviewing I also wonder do we have the same issue described
> here in netclasid_cgroup.c with the cgrp_attach()? It would be best to keep
> netcls and netprio in sync in this regard imo. At least netcls calls
> cgroup_sk_alloc_disable in the write_classid() hook so I suspect it makes
> sense to also add that to the attach hook?
> 

Fortunately we don't have this issue in netclassid cgroup. :)

Because task_cls_classid() remains 0 as long as netclassid cgroup is not
configured.
