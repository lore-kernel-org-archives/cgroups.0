From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 08/11] cpuset: separate configured masks and efffective
 masks
Date: Fri, 23 Aug 2013 15:46:47 +0800
Message-ID: <52171367.90005@huawei.com>
References: <52148F52.0@huawei.com> <52148FCA.8010704@huawei.com> <20130821140846.GH19286@mtj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130821140846.GH19286-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>

On 2013/8/21 22:08, Tejun Heo wrote:
> On Wed, Aug 21, 2013 at 06:00:42PM +0800, Li Zefan wrote:
>> @@ -2261,7 +2271,8 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
>>  	/* synchronize mems_allowed to N_MEMORY */
>>  	if (mems_updated) {
>>  		mutex_lock(&callback_mutex);
>> -		top_cpuset.mems_allowed = new_mems;
>> +		if (!sane)
>> +			top_cpuset.mems_allowed = new_mems;
> 
> Can you please further explain how the top cgroup behaves?
> 

top_cpuset.cpus_allowed will always be cpu_active_mask if sane_behavior
is not set, otherwise it will always be cpu_possible_mask. While
top_cpuset.effective_cpus will always be cpu_active_mask in either
case.
