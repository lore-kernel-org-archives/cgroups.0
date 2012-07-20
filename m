From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: + hugetlb-cgroup-simplify-pre_destroy-callback.patch added to
 -mm tree
Date: Fri, 20 Jul 2012 10:01:36 +0200
Message-ID: <20120720080136.GB12434@tiehlicka.suse.cz>
References: <20120718212637.133475C0050@hpza9.eem.corp.google.com>
 <20120719113915.GC2864@tiehlicka.suse.cz>
 <87r4s8gcwe.fsf@skywalker.in.ibm.com>
 <20120719123820.GG2864@tiehlicka.suse.cz>
 <87ipdjc15j.fsf@skywalker.in.ibm.com>
 <5008AEC2.9090707@jp.fujitsu.com>
 <5008B25D.5000902@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5008B25D.5000902-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mm-commits-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liwanp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri 20-07-12 10:20:29, KAMEZAWA Hiroyuki wrote:
[...]
> Hmm, can't cgroup_lock() be implemented as
> 
> 
> void cgroup_lock()
> {
> 	get_online_cpus()
> 	lock_memory_hotplug()
> 	mutex_lock(&cgroup_mutex);
> }

This is really ugly and it wouldn't help much anyway. Notifier which
takes the cgroup_lock is called when cpu_hotplug.lock is held already.
You would need to call cgroup_lock() before taking the cpu_hotplug.lock
and remove it from notifiers. I think this should be doable but I didn't
have too much time to look deeper into it.
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
