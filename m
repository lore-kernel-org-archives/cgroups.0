From: Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH v2] cgroup: fix cgroup_rmdir() vs close(eventfd) race
Date: Mon, 18 Feb 2013 18:39:14 +0800
Message-ID: <512204D2.6020701@huawei.com>
References: <5121C647.7030608@huawei.com> <20130218103613.GB3394@shutemov.name>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130218103613.GB3394@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Tejun Heo <tj@kernel.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On 2013/2/18 18:36, Kirill A. Shutemov wrote:
> On Mon, Feb 18, 2013 at 02:12:23PM +0800, Li Zefan wrote:
>> commit 205a872bd6f9a9a09ef035ef1e90185a8245cc58 ("cgroup: fix lockdep
>> warning for event_control") solved a deadlock by introducing a new
>> bug.
>>
>> Move cgrp->event_list to a temporary list doesn't mean you can traverse
>> this list locklessly, because at the same time cgroup_event_wake() can
>> be called and remove the event from the list. The result of this race
>> is disastrous.
>>
>> We adopt the way how kvm irqfd code implements race-free event removal,
>> which is now described in the comments in cgroup_event_wake().
>>
>> Signed-off-by: Li Zefan <lizefan@huawei.com>
>> ---
>>  kernel/cgroup.c | 50 ++++++++++++++++++++++++++++++++++----------------
>>  1 file changed, 34 insertions(+), 16 deletions(-)
>>
>> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>> index 26c071c..65c8101 100644
>> --- a/kernel/cgroup.c
>> +++ b/kernel/cgroup.c
>> @@ -217,6 +217,10 @@ struct cgroup_event {
>>  	 */
>>  	struct list_head list;
>>  	/*
>> +	 * Need to notify userspace when this event is removed?
>> +	 */
>> +	bool signal_on_remove;
>> +	/*
>>  	 * All fields below needed to unregister event when
>>  	 * userspace closes eventfd.
>>  	 */
>> @@ -3833,8 +3837,17 @@ static void cgroup_event_remove(struct work_struct *work)
>>  			remove);
>>  	struct cgroup *cgrp = event->cgrp;
>>  
>> +	remove_wait_queue(event->wqh, &event->wait);
>> +
>>  	event->cft->unregister_event(cgrp, event->cft, event->eventfd);
>>  
>> +	/*
>> +	 * If this event is to be removed due to cgroup removal,
>> +	 * we notify userspace.
>> +	 */
>> +	if (event->signal_on_remove)
>> +		eventfd_signal(event->eventfd, 1);
> 
> It's safe to notify anyway, isn't it? Let's just drop signal_on_remove.
> 

should be. just tried to be conservative to make sure I fix the bug without changing
any behavior.

> Otherwise, look good.
> 
> Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
> 
