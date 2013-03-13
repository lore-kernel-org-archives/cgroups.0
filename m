From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: consolidate cgroup_attach_task() and cgroup_attach_proc()
Date: Wed, 13 Mar 2013 09:43:29 +0800
Message-ID: <513FD9C1.4020604@huawei.com>
References: <513FD395.7000906@huawei.com> <20130313011939.GC2999@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130313011939.GC2999-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2013/3/13 9:19, Tejun Heo wrote:
> On Wed, Mar 13, 2013 at 09:17:09AM +0800, Li Zefan wrote:
>> These two functions share most of the code.
>>
>> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> ---
>>
>> v2: Not necessary to move cgroup_attach_task_all().
> 
> I supposed this one is the one to apply?
> 

yep.
