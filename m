From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: lockdep trace from prepare_bprm_creds
Date: Sat, 9 Mar 2013 15:47:36 +0800
Message-ID: <513AE918.7020704@huawei.com>
References: <20130306223657.GA7392@redhat.com> <20130307172545.GA10353@redhat.com> <20130307180139.GD29601@htj.dyndns.org> <20130307180332.GE29601@htj.dyndns.org> <20130307191242.GA18265@redhat.com> <20130307193820.GB3209@htj.dyndns.org> <513A9A67.60909@huawei.com> <20130309032936.GT14556@mtj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130309032936.GT14556-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2013/3/9 11:29, Tejun Heo wrote:
> Hello, Li.
> 
> On Sat, Mar 09, 2013 at 10:11:51AM +0800, Li Zefan wrote:
>> On 2013/3/8 3:38, Tejun Heo wrote:
>>> On Thu, Mar 07, 2013 at 08:12:42PM +0100, Oleg Nesterov wrote:
>>>> Well yes, I agree. I think that perfomance-wise threadgroup_change_begin()
>>>> in de_thread() is fine, and perhaps it is even more clean because we are
>>>> going to do the thread-group change. The scope of cred_guard_mutex is huge,
>>>> it doesn't look very nice in threadgroup_lock().
>>>>
>>>> But we should avoid the cgroup-specific hooks as much as possible, so I
>>>> like your patch more.
>>>
>>> I don't really mind how it's done but while my approach seems to limit
>>> itself to cgroup proper, threadgroup locking is actually more invasive
>>> by meddling with cred_mutex.  As you said, yours is the cleaner and
>>> probably more permanent one here.
>>>
>>
>> Agreed.
>>
>> Now we need that patch to be resent with SOB and proper changelog.
> 
> Now that I think more about it, I think I want both patches.  It is
> bothering that threadgroup lock is nested inside cgroup_lock.  It
> always has.  I just couldn't do anything about that until recently.
> Li, can you be persuaded into getting the lock reordering patch into a
> useable shape?  :)
> 

The patch is actually already in good shape. 

I'll give it some test and then you can queue it?

We don't need both patches for 3.9, so we'll queue Oleg's fix for 3.9 and
yours for 3.10?
