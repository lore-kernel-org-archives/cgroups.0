From: Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH 1/4] eventfd: introduce eventfd_signal_hangup()
Date: Wed, 6 Feb 2013 09:48:20 +0800
Message-ID: <5111B664.5050606@huawei.com>
References: <510CB733.2080904@huawei.com> <510CB744.7000300@huawei.com> <20130202155858.GA13022@shutemov.name> <20130204101521.GA18322@shutemov.name> <51107F42.1090401@huawei.com> <20130205082820.GA22220@shutemov.name>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130205082820.GA22220@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Davide Libenzi <davidel@xmailserver.org>, Aaron Durbin <adurbin@google.com>, Greg Thelen <gthelen@google.com>

On 2013/2/5 16:28, Kirill A. Shutemov wrote:
> On Tue, Feb 05, 2013 at 11:40:50AM +0800, Li Zefan wrote:
>> On 2013/2/4 18:15, Kirill A. Shutemov wrote:
>>> On Sat, Feb 02, 2013 at 05:58:58PM +0200, Kirill A. Shutemov wrote:
>>>> On Sat, Feb 02, 2013 at 02:50:44PM +0800, Li Zefan wrote:
>>>>> When an eventfd is closed, a wakeup with POLLHUP will be issued,
>>>>> but cgroup wants to issue wakeup explicitly, so when a cgroup is
>>>>> removed userspace can be notified.
>>>>>
>>>>> Signed-off-by: Li Zefan <lizefan@huawei.com>
>>>
>>> Hm.. Looks like it will break eventfd semantics:
>>>
>>> 1. One eventfd can be used for deliver more then one notification from
>>> one or more cgroups. POLLHUP on removing one of cgroups is not valid.
>>>
>>> 2. It's valid to have eventfd opened only by one userspace application. We
>>> should not close it, just because cgroup is removed.
>>>
>>> I think problem with multiple threads waiting an event on eventfd should
>>> be handled in userspace.
>>>
>>
>> I didn't realize this.. and if a cgroup is removed, the woken thread may not
>> be the thread that is waiting on this cgroup.
> 
> Why? The only threads who read() or poll() the eventfd will be wake up,
> won't they? Do you have a code sample to demonstrate the issue?
> 

All the threads will be woken up, but one of them will consume the event counter,
and then all other threads will keep waiting.

>> How crappy.. I don't know how
>> userspace is going to deal with all these.
>>
>> And another bug spotted. We can pass fd of memory.usage_in_bytes of cgroup A
>> to cgroup.event_control of cgroup B, and then we won't get memory usage
>> notification from A but B! What's worse, if A and B are in different mount
>> hierarchy, boom!
> 
> I think we can ignore which cgroup event_control is belong to, and just
> use cgroup of cfile as base. It also means you can use one event_control fd
> for registering events to different cgroups. It can be handy.
> 

The most reasonal usage is, cgroup.event_control exists in the root cgroup only,
and it's used to register events to all cgroups. But I don't think we can
change the current interface that each cgroup has a cgroup.event_control, so
we'll restrict event registration as my patch does.
