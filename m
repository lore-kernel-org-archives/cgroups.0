From: =?UTF-8?Q?Arkadiusz_Mi=c5=9bkiewicz?= <a.miskiewicz@gmail.com>
Subject: Re: pids.current with invalid value for hours [5.0.0 rc3 git]
Date: Sat, 26 Jan 2019 03:41:47 +0100
Message-ID: <6da6ca69-5a6e-a9f6-d091-f89a8488982a@gmail.com>
References: <df806a77-3327-9db5-8be2-976fde1c84e5@gmail.com>
 <20190117122535.njcbqhlmzozdkncw@mikami>
 <1d36b181-cbaf-6694-1a31-2f7f55d15675@gmail.com>
 <96ef6615-a5df-30af-b4dc-417a18ca63f1@gmail.com>
 <1cdbef13-564d-61a6-95f4-579d2cad243d@gmail.com>
 <20190125163731.GJ50184@devbig004.ftw2.facebook.com>
 <a95d004a-4358-7efc-6d21-12aac4411b32@gmail.com>
 <480296c4-ed7a-3265-e84a-298e42a0f1d5@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FXYnc+feRAb5IL5ih0l/fztceExppPTojg+0FF9QPB8=;
        b=kOSko4twlZRBrZ/q8QvTd0GneHJSaTzxE+k3+urR6J/GMuCFgoRwLhNgIJ6gXlwtSF
         bs47kTGeMgZB4igWHfPEjwC9mBk0SpShhWN7sJzPTNOv3H9gH8StpUA3+71Ow7pEzSdn
         Yixiweozd4Ub4SSyqBfG9obUBEZsC0V3nHSnKuHy0g+i0n/NgwbTsV4EKr/zVWzoq8YA
         c5SrixdzB5VBflVU9FKzntFvcTmRGe68mwZsMKi1+zI1MnDVthpvH0kUhByv+vFpGQqc
         G1QTOdo26s3Thw2W6YF1HHgkRRRb6I5yLHlsaqnpc9IKPu9D1RkkdivYeIcZGJMV/tf5
         kfRw==
In-Reply-To: <480296c4-ed7a-3265-e84a-298e42a0f1d5@I-love.SAKURA.ne.jp>
Content-Language: pl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, Aleksa Sarai <asarai@suse.de>, Jay Kamat <jgkamat@fb.com>, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>

On 26/01/2019 02:27, Tetsuo Handa wrote:
> On 2019/01/26 4:47, Arkadiusz Miśkiewicz wrote:
>>> Can you please see whether the problem can be reproduced on the
>>> current linux-next?
>>>
>>>  git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
>>
>> I can reproduce on next (5.0.0-rc3-next-20190125), too:
>>
> 
> Please try this patch.

Doesn't help:

[root@xps test]# python3 cg.py
Created cgroup: /sys/fs/cgroup/test_2149
Start: pids.current: 0
Start: cgroup.procs:
0: pids.current: 97
0: cgroup.procs:
1: pids.current: 14
1: cgroup.procs:
2: pids.current: 14
2: cgroup.procs:
3: pids.current: 14
3: cgroup.procs:
4: pids.current: 14
4: cgroup.procs:
5: pids.current: 14
5: cgroup.procs:
6: pids.current: 14
6: cgroup.procs:
7: pids.current: 14
7: cgroup.procs:
8: pids.current: 14
8: cgroup.procs:
9: pids.current: 14
9: cgroup.procs:
10: pids.current: 14
10: cgroup.procs:
11: pids.current: 14
11: cgroup.procs:
[root@xps test]# ps aux|grep python
root      3160  0.0  0.0 234048  2160 pts/2    S+   03:34   0:00 grep python
[root@xps test]# uname -a
Linux xps 5.0.0-rc3-00104-gc04e2a780caf-dirty #289 SMP PREEMPT Sat Jan
26 03:29:45 CET 2019 x86_64 Intel(R)_Core(TM)_i9-8950HK_CPU_@_2.90GHz
PLD Linux


kernel config:
http://ixion.pld-linux.org/~arekm/cgroup-oom-kernelconf-2.txt

dmesg:
http://ixion.pld-linux.org/~arekm/cgroup-oom-2.txt


> 
> Subject: [PATCH v2] memcg: killed threads should not invoke memcg OOM killer
> From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> To: Andrew Morton <akpm@linux-foundation.org>,
>  Johannes Weiner <hannes@cmpxchg.org>, David Rientjes <rientjes@google.com>
> Cc: Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org,
>  Kirill Tkhai <ktkhai@virtuozzo.com>,
>  Linus Torvalds <torvalds@linux-foundation.org>
> Message-ID: <01370f70-e1f6-ebe4-b95e-0df21a0bc15e@i-love.sakura.ne.jp>
> Date: Tue, 15 Jan 2019 19:17:27 +0900
> 
> If $N > $M, a single process with $N threads in a memcg group can easily
> kill all $M processes in that memcg group, for mem_cgroup_out_of_memory()
> does not check if current thread needs to invoke the memcg OOM killer.
> 
>   T1@P1     |T2...$N@P1|P2...$M   |OOM reaper
>   ----------+----------+----------+----------
>                         # all sleeping
>   try_charge()
>     mem_cgroup_out_of_memory()
>       mutex_lock(oom_lock)
>              try_charge()
>                mem_cgroup_out_of_memory()
>                  mutex_lock(oom_lock)
>       out_of_memory()
>         select_bad_process()
>         oom_kill_process(P1)
>         wake_oom_reaper()
>                                    oom_reap_task() # ignores P1
>       mutex_unlock(oom_lock)
>                  out_of_memory()
>                    select_bad_process(P2...$M)
>                         # all killed by T2...$N@P1
>                    wake_oom_reaper()
>                                    oom_reap_task() # ignores P2...$M
>                  mutex_unlock(oom_lock)
> 
> We don't need to invoke the memcg OOM killer if current thread was killed
> when waiting for oom_lock, for mem_cgroup_oom_synchronize(true) can count
> on try_charge() when mem_cgroup_oom_synchronize(true) can not make forward
> progress because try_charge() allows already killed/exiting threads to
> make forward progress, and memory_max_write() can bail out upon signals.
> 
> At first Michal thought that fatal signal check is racy compared to
> tsk_is_oom_victim() check. But an experiment showed that trying to call
> mark_oom_victim() on all killed thread groups is more racy than fatal
> signal check due to task_will_free_mem(current) path in out_of_memory().
> 
> Therefore, this patch changes mem_cgroup_out_of_memory() to bail out upon
> should_force_charge() == T rather than upon fatal_signal_pending() == T,
> for should_force_charge() == T && signal_pending(current) == F at
> memory_max_write() can't happen because current thread won't call
> memory_max_write() after getting PF_EXITING.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Fixes: 29ef680ae7c2 ("memcg, oom: move out_of_memory back to the charge path")
> Fixes: 3100dab2aa09 ("mm: memcontrol: print proper OOM header when no eligible victim left")
> Cc: stable@vger.kernel.org # 4.19+
> ---
>  mm/memcontrol.c | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index af7f18b..79a7d2a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -248,6 +248,12 @@ enum res_type {
>  	     iter != NULL;				\
>  	     iter = mem_cgroup_iter(NULL, iter, NULL))
>  
> +static inline bool should_force_charge(void)
> +{
> +	return tsk_is_oom_victim(current) || fatal_signal_pending(current) ||
> +		(current->flags & PF_EXITING);
> +}
> +
>  /* Some nice accessors for the vmpressure. */
>  struct vmpressure *memcg_to_vmpressure(struct mem_cgroup *memcg)
>  {
> @@ -1389,8 +1395,13 @@ static bool mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	};
>  	bool ret;
>  
> -	mutex_lock(&oom_lock);
> -	ret = out_of_memory(&oc);
> +	if (mutex_lock_killable(&oom_lock))
> +		return true;
> +	/*
> +	 * A few threads which were not waiting at mutex_lock_killable() can
> +	 * fail to bail out. Therefore, check again after holding oom_lock.
> +	 */
> +	ret = should_force_charge() || out_of_memory(&oc);
>  	mutex_unlock(&oom_lock);
>  	return ret;
>  }
> @@ -2209,9 +2220,7 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	 * bypass the last charges so that they can exit quickly and
>  	 * free their memory.
>  	 */
> -	if (unlikely(tsk_is_oom_victim(current) ||
> -		     fatal_signal_pending(current) ||
> -		     current->flags & PF_EXITING))
> +	if (unlikely(should_force_charge()))
>  		goto force;
>  
>  	/*
> 


-- 
Arkadiusz Miśkiewicz, arekm / ( maven.pl | pld-linux.org )
