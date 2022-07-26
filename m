From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: Re: [PATCH 1/9] sched/psi: fix periodic aggregation shut off
Date: Tue, 26 Jul 2022 21:28:56 +0800
Message-ID: <22a889ae-bf61-ff39-5e13-b32c95b77d4a@linux.dev>
References: <20220721040439.2651-1-zhouchengming@bytedance.com>
 <20220721040439.2651-2-zhouchengming@bytedance.com>
 <Yt65LEyN83mTGxwF@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:message-id:date:mime-version:user-agent:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=X3USgpc6XpCOBCdiioCqbAyVXBreMm9Zz3bCF8HFN0g=;
        b=SjllR868hgxEDh9ILkhQcdktay+vVaXMkeGGP/FcsIiRKddZ/zdt4NjkmtQGTwa9tV
         upJUGxh91elveza0mjXq731muQ1YN/CezSCfg+Cl7k415dl37wR3FnyEzzB5tDGm5JXf
         pmLZGUJEYRO8EpJd0kGf3TBGMq2Ei98wTZGN9xGmdO013r8PzAObNIh7F4CK+Uisu3gP
         ZvzTxyhNs9/f65nlKQx8/A0ZmiTErr8SVeVP86X7ui5QPyfAE0AOxyLDqYWOuvdl0kSh
         3zJXGb1sQfillJcV06Rj9XDT97CzfVDFhHuWE9xHUkYNE8dCxBfJe4qTj84CSS0I98Bn
         ZY1g==
Content-Language: en-US
In-Reply-To: <Yt65LEyN83mTGxwF@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>, Chengming Zhou <zhouchengming@bytedance.com>
Cc: surenb@google.com, mingo@redhat.com, peterz@infradead.org, tj@kernel.org, corbet@lwn.net, akpm@linux-foundation.org, rdunlap@infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com, cgroups@vger.kernel.org

On 2022/7/25 23:39, Johannes Weiner wrote:
> On Thu, Jul 21, 2022 at 12:04:31PM +0800, Chengming Zhou wrote:
>> @@ -871,13 +861,23 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
>>  				clear |= TSK_MEMSTALL_RUNNING;
>>  			if (prev->in_iowait)
>>  				set |= TSK_IOWAIT;
>> +
>> +			/*
>> +			 * Periodic aggregation shuts off if there is a period of no
>> +			 * task changes, so we wake it back up if necessary. However,
>> +			 * don't do this if the task change is the aggregation worker
>> +			 * itself going to sleep, or we'll ping-pong forever.
>> +			 */
>> +			if (unlikely((prev->flags & PF_WQ_WORKER) &&
>> +				     wq_worker_last_func(prev) == psi_avgs_work))
>> +				wake_clock = false;
>>  		}
>>  
>>  		psi_flags_change(prev, clear, set);
>>  
>>  		iter = NULL;
>>  		while ((group = iterate_groups(prev, &iter)) && group != common)
>> -			psi_group_change(group, cpu, clear, set, now, true);
>> +			psi_group_change(group, cpu, clear, set, now, wake_clock);
>>  
>>  		/*
>>  		 * TSK_ONCPU is handled up to the common ancestor. If we're tasked
> 
> Wait, there is another psi_group_change() below this, which handles
> the clearing of TSK_RUNNING for common ancestors. We don't want to
> wake those either, so it needs s/true/wake_clock/ as well.

Yes, I was wrong, will fix.

Thanks!
