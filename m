From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] memcg: change behavior of moving charges at task move
Date: Fri, 23 Mar 2012 09:05:52 +0900
Message-ID: <4F6BBE60.5060605@jp.fujitsu.com>
References: <4F69A4C4.4080602@jp.fujitsu.com> <20120322142941.01e601c0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20120322142941.01e601c0.akpm@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, Linux Kernel <linux-kernel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Hugh Dickins <hughd@google.com>, "n-horiguchi@ah.jp.nec.com" <n-horiguchi@ah.jp.nec.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Glauber Costa <glommer@parallels.com>

(2012/03/23 6:29), Andrew Morton wrote:

> On Wed, 21 Mar 2012 18:52:04 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
>> As discussed before, I post this to fix the spec and implementation of task moving.
>> Then, do you think what target kernel version should be ? 3.4/3.5 ?
>> but yes, it may be late for 3.4....
> 
> Well, the key information here is "what effect does the bug have upon
> users".
> 


Ah, sorry.

Before patch:

The spec was
  "shared anonymous pages are not moved at task_move."
The implementation was
  "shared anonymous page whose mapcount > 2 was not moved at task_move."

After patch:

The spec is:
  "all anonymous pages mapped by the task are moved at task_move.."
The implementation is
  "all anonymous pages mapped by the task are moved at task_move."

Then, with old spec, the implementation was wrong.... shared pages may be moved.
But no one has noticed this behavior until now. 

Then, this patch tries to fix the situation by simplifying the rule.
Maybe no visible effect to users because it was broken for a long time and
this will not change behavior of task_move in most of cases. Anon pages are
not shared unless processes are in a tree. Considering memcg nature, it's hard
to think users move a process in the tree without exec().
And as I pointed out in changelog note, libcgroup etc..will not be affected by
this change.



>> In documentation, it's said that 'shared anon are not moved'.
>> But in implementation, the check was wrong.
>>
>>   if (!move_anon() || page_mapcount(page) > 2)
>>
>> Ah, memcg has been moving shared anon pages for a long time.
>>
>> Then, here is a discussion about handling of shared anon pages.
>>
>>  - It's complex
>>  - Now, shared file caches are moved in force.
>>  - It adds unclear check as page_mapcount(). To do correct check,
>>    we should check swap users, etc.
>>  - No one notice this implementation behavior. So, no one get benefit
>>    from the design.
>>  - In general, once task is moved to a cgroup for running, it will not
>>    be moved....
>>  - Finally, we have control knob as memory.move_charge_at_immigrate.
>>
>> Here is a patch to allow moving shared pages, completely. This makes
>> memcg simpler and fix current broken code.
>>
>> Note:
>>  IIUC, libcgroup's cgroup daemon moves tasks after exec().
>>  So, it's not affected.
>>  libcgroup's command "cgexec" does move itsef to a memcg and call exec()
>>  without fork(). it's not affected.
>>
>> Changelog:
>>  - fixed PageAnon() check.
>>  - remove call of lookup_swap_cache()
>>  - fixed Documentation.
> 
> But you forgot to tell us :(
> 

Sorry.

-Kame


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
