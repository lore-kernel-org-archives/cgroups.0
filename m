From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: A issue when migrating a process's memory using cgroup
Date: Thu, 10 Apr 2014 16:28:25 +0800
Message-ID: <53465629.2060202@huawei.com>
References: <53464970.8060404@huawei.com> <534650AB.4070709@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <534650AB.4070709-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: xiexiangyou <xiexiangyou-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zhouxiangjiu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, luonengjun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On 2014/4/10 16:04, Li Zefan wrote:
> On 2014/4/10 15:34, xiexiangyou wrote:
>> Hi all,
>>
>> I met a problem when I migrate a process's memory using cgroup.
>> Two processes, process A and Process B. Process A has 20G memory, I migrate it from node0 to node1, by writing "1" to "cpuset.mems".
>> It will consume 20s time. At the time, I write process B's "cpuset.cpus" to bind the cpus. But setting "cpuset.cpus" is block untill
>> the first operation is finished.
>>
>>
>> So I read the cpuset code in kernel. In the function of "cpuset_write_resmask", Common handling for a write to a "cpus" or "mems" file,
>> It grabs the "cgroup_mutex" first, and release it until finish writing "cpus" or "mems". But if migrate large size memory
>> of a process using cpuset, it will consume much time. At the time, other handling for write to "cpuset.cpus" and "cpuset.mems"
>> will blocked because of "cgroup_mutex".
>>
>> In this case, I think the "cgroup_mutex" in "cpuset_write_resmask" should be replace by littler granularity lock.
>>
> 
> Yeah, in newer kernels we no longer grab cgroup_mutex in cpuset_write_resmask().
> 

But it will still block, because cpuset_mutex is still a global lock,
not a per cpuset lock.
