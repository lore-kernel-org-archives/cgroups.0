From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: + hugetlb-cgroup-simplify-pre_destroy-callback.patch added to
 -mm tree
Date: Fri, 20 Jul 2012 17:08:10 +0900
Message-ID: <500911EA.1030004@jp.fujitsu.com>
References: <20120718212637.133475C0050@hpza9.eem.corp.google.com> <20120719113915.GC2864@tiehlicka.suse.cz> <87r4s8gcwe.fsf@skywalker.in.ibm.com> <20120719123820.GG2864@tiehlicka.suse.cz> <87ipdjc15j.fsf@skywalker.in.ibm.com> <5008AEC2.9090707@jp.fujitsu.com> <5008B25D.5000902@jp.fujitsu.com> <20120720080136.GB12434@tiehlicka.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20120720080136.GB12434@tiehlicka.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko@suse.cz>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, akpm@linux-foundation.org, mm-commits@vger.kernel.org, liwanp@linux.vnet.ibm.com, Tejun Heo <htejun@gmail.com>, Li Zefan <lizefan@huawei.com>, cgroups mailinglist <cgroups@vger.kernel.org>, linux-mm@kvack.org

(2012/07/20 17:01), Michal Hocko wrote:
> On Fri 20-07-12 10:20:29, KAMEZAWA Hiroyuki wrote:
> [...]
>> Hmm, can't cgroup_lock() be implemented as
>>
>>
>> void cgroup_lock()
>> {
>> 	get_online_cpus()
>> 	lock_memory_hotplug()
>> 	mutex_lock(&cgroup_mutex);
>> }
>
> This is really ugly and it wouldn't help much anyway. Notifier which
> takes the cgroup_lock is called when cpu_hotplug.lock is held already.

Hm ? IIUC, notifer will not work until put_online_cpu() is called.

> You would need to call cgroup_lock() before taking the cpu_hotplug.lock
> and remove it from notifiers. I think this should be doable but I didn't
> have too much time to look deeper into it.
>



--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
