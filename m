From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] vmpressure: make sure memcg stays alive until all
 users are signaled
Date: Fri, 12 Jul 2013 17:54:27 +0800
Message-ID: <51DFD253.3030501@huawei.com>
References: <20130711083110.GC21667@dhcp22.suse.cz> <51DE701C.6010800@huawei.com> <20130711092542.GD21667@dhcp22.suse.cz> <51DE7AAF.6070004@huawei.com> <20130711093300.GE21667@dhcp22.suse.cz> <20130711154408.GA9229@mtj.dyndns.org> <20130711162215.GM21667@dhcp22.suse.cz> <20130711163238.GC9229@mtj.dyndns.org> <20130712084039.GA13224@dhcp22.suse.cz> <51DFCA49.4080407@huawei.com> <20130712092927.GA15307@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130712092927.GA15307-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Anton Vorontsov <anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

On 2013/7/12 17:29, Michal Hocko wrote:
> On Fri 12-07-13 17:20:09, Li Zefan wrote:
> [...]
>> But if I read the code correctly, even no one registers a vmpressure event,
>> vmpressure() is always running and queue the work item.
> 
> True but checking there is somebody is rather impractical. First we
> would have to take a events_lock to check this and then drop it after
> scheduling the work. Which doesn't guarantee that the registered event
> wouldn't go away.
> And even trickier, we would have to do the same for all parents up the
> hierarchy.
> 

The thing is, we can forget about eventfd. eventfd is checked in
vmpressure_work_fn(), while vmpressure() is always called no matter what.

vmpressure()
  queue_work()
                      cgroup_diput()
                        call_rcu(cgroup_free_rcu)                        
                      ...
                      queue_work(destroy_cgroup)
                      ...
                      cgroup_free_fn()
                        mem_cgroup_destroy()
  ...
  vmpress_work_fn()

There's no guarantee that vmpressure work is run before cgroup destroy
work, I think.
