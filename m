From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [rfc][patch 3/3] mm, memcg: introduce own oom handler to iterate
 only over its own threads
Date: Thu, 28 Jun 2012 17:55:34 +0900
Message-ID: <4FEC1C06.70802@jp.fujitsu.com>
References: <alpine.DEB.2.00.1206251846020.24838@chino.kir.corp.google.com> <alpine.DEB.2.00.1206251847180.24838@chino.kir.corp.google.com> <4FE94968.6010500@jp.fujitsu.com> <alpine.DEB.2.00.1206261323260.8673@chino.kir.corp.google.com> <alpine.DEB.2.00.1206262229380.32567@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1206262229380.32567-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

(2012/06/27 14:35), David Rientjes wrote:
> On Tue, 26 Jun 2012, David Rientjes wrote:
>
>> It's still not a perfect solution for the above reason.  We need
>> tasklist_lock for oom_kill_process() for a few reasons:
>>
>>   (1) if /proc/sys/vm/oom_dump_tasks is enabled, which is the default,
>>       to iterate the tasklist
>>
>>   (2) to iterate the selected process's children, and
>>
>>   (3) to iterate the tasklist to kill all other processes sharing the
>>       same memory.
>>
>> I'm hoping we can avoid taking tasklist_lock entirely for memcg ooms to
>> avoid the starvation problem at all.  We definitely still need to do (3)
>> to avoid mm->mmap_sem deadlock if another thread sharing the same memory
>> is holding the semaphore trying to allocate memory and waiting for current
>> to exit, which needs the semaphore itself.  That can be done with
>> rcu_read_lock(), however, and doesn't require tasklist_lock.
>>
>> (1) can be done with rcu_read_lock() as well but I'm wondering if there
>> would be a significant advantage doing this by a cgroup iterator as well.
>> It may not be worth it just for the sanity of the code.
>>
>> We can do (2) if we change to list_for_each_entry_rcu().
>>
>
> It turns out that task->children is not an rcu-protected list so this
> doesn't work.

Can't we use sighand->lock to iterate children ?


Thanks,
-Kame
