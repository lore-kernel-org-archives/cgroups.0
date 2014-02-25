From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [cgroup/task_lock] INFO: suspicious RCU usage.
Date: Tue, 25 Feb 2014 20:01:25 +0800
Message-ID: <530C8615.4020004@huawei.com>
References: <20140221021622.GB13515@localhost> <20140221154025.GB460@htj.dyndns.org> <530C5977.4090402@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <530C5977.4090402-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

>>> [main] Setsockopt(1 2b 80d1000 4) on fd 223 [17:2:768]
>>> [   27.030764] 
>>> [   27.031119] ===============================
>>> [   27.031833] [ INFO: suspicious RCU usage. ]
>>> [   27.032536] 3.14.0-rc3-02458-g837caba #2 Not tainted
>>> [   27.033378] -------------------------------
>>> [   27.044237] include/linux/cgroup.h:697 suspicious rcu_dereference_check() usage!
>>> [   27.045795] 
>>> [   27.045795] other info that might help us debug this:
>>> [   27.045795] 
>>> [   27.047114] 
>>> [   27.047114] rcu_scheduler_active = 1, debug_locks = 0
>>> [main] Setsockopt(1 c 80d1000 4) on fd 225 [39:5:0]
>>> [   27.048751] 2 locks held by trinity-c0/4479:
>>> [   27.049478]  #0:  (callback_mutex){+.+...}, at: [<81118395>] cpuset_cpus_allowed+0x1e/0x123
>>> [   27.051132]  #1:  (&(&p->alloc_lock)->rlock){+.+...}, at: [<8111839c>] cpuset_cpus_allowed+0x25/0x123
>>> [   27.052788] 
>>> [   27.052788] stack backtrace:
>>> [   27.053528] CPU: 0 PID: 4479 Comm: trinity-c0 Not tainted 3.14.0-rc3-02458-g837caba #2
>>> [   27.064971]  00000000 00000000
>>>  919eff28 81877cc3[main] Setsockopt(1 7 80d1000 4) on fd 226 [1:5:1]
>>
>> So, this is from removing task_lock from task_css_set_check() and
>> adding rcu_read_lock() in cpuset_cpus_allowed() should fix it.
> 
> Yeah, rcu_read_lock() should be sufficient.
> 
>> I'm
>> not sure how much of task_lock() locking we currently have in cpuset
>> is actually necessary tho.  Shouldn't we be able to do most with just
>> callback_mutex, if not cpuset_mutex?  Li, any ideas?
>>
> 
> task_lock() is also used to protect task->mems_allowed. I'll see if we
> can get rid of most (if not all) task_lock() lockings in cpuset.
> 

After a quick lock, I think except the one in cpuset_change_task_nodemask(), all
other task_lock() lockings can be replace by rcu_readlock().
