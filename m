From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: WARNING in try_charge
Date: Tue, 7 Aug 2018 06:50:09 +0900
Message-ID: <9c03213f-c099-378b-e9fd-ed6f2a2afdc3@i-love.sakura.ne.jp>
References: <fc6e173e-8bda-269f-d44f-1c5f5215beac@I-love.SAKURA.ne.jp>
 <0000000000006350880572c61e62@google.com>
 <20180806174410.GB10003@dhcp22.suse.cz>
 <20180806175627.GC10003@dhcp22.suse.cz>
 <078bde8d-b1b5-f5ad-ed23-0cd94b579f9e@i-love.sakura.ne.jp>
 <20180806203437.GK10003@dhcp22.suse.cz>
 <3cf8f630-73b7-20d4-8ad1-bb1c657ee30d@i-love.sakura.ne.jp>
 <20180806205519.GO10003@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180806205519.GO10003@dhcp22.suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@kernel.org>
Cc: syzbot <syzbot+bab151e82a4e973fa325@syzkaller.appspotmail.com>, cgroups@vger.kernel.org, dvyukov@google.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, syzkaller-bugs@googlegroups.com, vdavydov.dev@gmail.com

On 2018/08/07 5:55, Michal Hocko wrote:
> On Tue 07-08-18 05:46:04, Tetsuo Handa wrote:
>> On 2018/08/07 5:34, Michal Hocko wrote:
>>> On Tue 07-08-18 05:26:23, Tetsuo Handa wrote:
>>>> On 2018/08/07 2:56, Michal Hocko wrote:
>>>>> So the oom victim indeed passed the above force path after the oom
>>>>> invocation. But later on hit the page fault path and that behaved
>>>>> differently and for some reason the force path hasn't triggered. I am
>>>>> wondering how could we hit the page fault path in the first place. The
>>>>> task is already killed! So what the hell is going on here.
>>>>>
>>>>> I must be missing something obvious here.
>>>>>
>>>> YOU ARE OBVIOUSLY MISSING MY MAIL!
>>>>
>>>> I already said this is "mm, oom: task_will_free_mem(current) should ignore MMF_OOM_SKIP for once."
>>>> problem which you are refusing at https://www.spinics.net/lists/linux-mm/msg133774.html .
>>>> And you again ignored my mail. Very sad...
>>>
>>> Your suggestion simply didn't make much sense. There is nothing like
>>> first check is different from the rest.
>>>
>>
>> I don't think your patch is appropriate. It avoids hitting WARN(1) but does not avoid
>> unnecessary killing of OOM victims.
>>
>> If you look at https://syzkaller.appspot.com/text?tag=CrashLog&x=15a1c770400000 , you will
>> notice that both 23766 and 23767 are killed due to task_will_free_mem(current) == false.
>> This is "unnecessary killing of additional processes".
> 
> Have you noticed the mere detail that the memcg has to kill any task
> attempting the charge because the hard limit is 0? There is simply no
> other way around. You cannot charge. There is no unnecessary killing.
> Full stop. We do allow temporary breach of the hard limit just to let
> the task die and uncharge on the way out.
> 

select_bad_process() is called just because
task_will_free_mem("already killed current thread which has not completed __mmput()") == false
is a bug. I'm saying that the OOM killer should not give up as soon as MMF_OOM_SKIP is set.

 static bool oom_has_pending_victims(struct oom_control *oc)
 {
 	struct task_struct *p, *tmp;
 	bool ret = false;
 	bool gaveup = false;
 
 	if (is_sysrq_oom(oc))
 		return false;
 	/*
 	 * Wait for pending victims until __mmput() completes or stalled
 	 * too long.
 	 */
 	list_for_each_entry_safe(p, tmp, &oom_victim_list, oom_victim_list) {
 		struct mm_struct *mm = p->signal->oom_mm;
 
 		if (oom_unkillable_task(p, oc->memcg, oc->nodemask))
 			continue;
 		ret = true;
+		/*
+		 * Since memcg OOM allows forced charge, we can safely wait
+		 * until __mmput() completes.
+		 */
+		if (is_memcg_oom(oc))
+			return true;
 #ifdef CONFIG_MMU
 		/*
 		 * Since the OOM reaper exists, we can safely wait until
 		 * MMF_OOM_SKIP is set.
 		 */
 		if (!test_bit(MMF_OOM_SKIP, &mm->flags)) {
 			if (!oom_reap_target) {
 				get_task_struct(p);
 				oom_reap_target = p;
 				trace_wake_reaper(p->pid);
 				wake_up(&oom_reaper_wait);
 			}
 #endif
 			continue;
 		}
 #endif
 		/* We can wait as long as OOM score is decreasing over time. */
 		if (!victim_mm_stalling(p, mm))
 			continue;
 		gaveup = true;
 		list_del(&p->oom_victim_list);
 		/* Drop a reference taken by mark_oom_victim(). */
 		put_task_struct(p);
 	}
 	if (gaveup)
 		debug_show_all_locks();
 
 	return ret;
 }

