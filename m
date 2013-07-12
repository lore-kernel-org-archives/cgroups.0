From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] vmpressure: make sure memcg stays alive until all
 users are signaled
Date: Fri, 12 Jul 2013 17:20:09 +0800
Message-ID: <51DFCA49.4080407@huawei.com>
References: <20130710184254.GA16979@mtj.dyndns.org> <20130711083110.GC21667@dhcp22.suse.cz> <51DE701C.6010800@huawei.com> <20130711092542.GD21667@dhcp22.suse.cz> <51DE7AAF.6070004@huawei.com> <20130711093300.GE21667@dhcp22.suse.cz> <20130711154408.GA9229@mtj.dyndns.org> <20130711162215.GM21667@dhcp22.suse.cz> <20130711163238.GC9229@mtj.dyndns.org> <20130712084039.GA13224@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130712084039.GA13224-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Anton Vorontsov <anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

>> especially while shutting down objects as they enter a lingering stage
>> where they're de-registered but not destroyed and you should be
>> careful which parts of the object are still accessible.  I haven't
>> read it carefully but here I'm not sure whether it's safe to do event
>> related operations after removal.  From cgroup core side, event list
>> is shut down synchronously from cgroup_destroy_locked().  It doesn't
>> seem like that part is explicitly built to remain accessible
>> afterwards.
> 
> /me goes and checks the code
> 
> vmpressure_event sends signals to _registered_ events but those are
> unregistered from the work queue context by cgroup_event_remove (via
> vmpressure_unregister_event) queued from cgroup_destroy_locked.
> 
> I am not sure what are the guarantees for ordering on the workqueue but
> this all suggests that either vmpressure_event sees an empty vmpr->events
> or it can safely send signals as cgroup_event_remove is pending on the
> queue.
> 
> cgroup_event_remove drops a reference to cgrp->dentry after everything
> is unregistered and event->wait removed from the wait queue so
> cgroup_free_fn couldn't have been called yet and so memcg is still
> alive. This means that even css_get/put is not necessary.
> 
> So I guess we are safe with the code as is but this all is really
> _tricky_ and deserves a fat comment. So rather than adding flushing work
> item code we should document it properly.
> 
> Or am I missing something?
> 

But if I read the code correctly, even no one registers a vmpressure event,
vmpressure() is always running and queue the work item.
