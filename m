From: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH v3 10/10] sched/psi: per-cgroup PSI accounting
 disable/re-enable interface
Date: Thu, 25 Aug 2022 20:28:39 +0800
Message-ID: <324b1d0f-42e5-8947-68cb-a3d20135f2c6@bytedance.com>
References: <20220824081829.33748-1-zhouchengming@bytedance.com>
 <20220824081829.33748-11-zhouchengming@bytedance.com>
 <YwX2jC2UQ/zeY2E8@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=o0E7YiHeVex1u0X6qaV95zV+IU6KmVTedW0VAfovtx8=;
        b=TRE19aRmzYeY60KDN1wOIIp3s3WQh2s1UiPVHSyC4h+toJTUn/oTh2+z/rhBhbwT6W
         NDeigQr3uEpitwebXfV935zr/yRXP0JDTsxyCSUw5JTINtlHZjKYcXG60i6fqttjH68I
         t/JoB4QAa0mGRFYYhWlznz5OiKOMTjBRy4TqgPJjFO3js0EKBC00oSRYeJ9dt11uCmeQ
         yhsE7wjOUDL3v6ZJEMykJvR8hjQvqCmRxoMTKurdisC/z/bcw3fE3F1j2ylZpsZaL9dH
         BBdloD+tLoAovOt6PQUfWLddZQetzIFhFIh3cfkO+ADUTA1v0pEvgxbuWN2v4QJxcGNj
         cjIA==
Content-Language: en-US
In-Reply-To: <YwX2jC2UQ/zeY2E8-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2022/8/24 17:59, Johannes Weiner wrote:
> Hi Chengming,
> 
> Thanks for incorporating all the feedback. I have a few nitpicks
> below, but with those considered, please add:
> 
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> 
> On Wed, Aug 24, 2022 at 04:18:29PM +0800, Chengming Zhou wrote:
>> @@ -5171,12 +5220,19 @@ static struct cftype cgroup_base_files[] = {
>>  	{
>>  		.name = "irq.pressure",
>>  		.flags = CFTYPE_PRESSURE,
>> +		.file_offset = offsetof(struct cgroup, psi_files[PSI_IRQ]),
>>  		.seq_show = cgroup_irq_pressure_show,
>>  		.write = cgroup_irq_pressure_write,
>>  		.poll = cgroup_pressure_poll,
>>  		.release = cgroup_pressure_release,
>>  	},
>>  #endif
>> +	{
>> +		.name = "cgroup.pressure",
>> +		.flags = CFTYPE_PRESSURE,
>> +		.seq_show = cgroup_psi_show,
>> +		.write = cgroup_psi_write,
> 
> To match the naming convention, these should be called
> cgroup_pressure_show() and cgroup_pressure_write().

I just find cgroup_pressure_write() already exists, so I change the names
to cgroup_pressure_enable_show() and cgroup_pressure_enable_write(),
since this file name is simplified from "cgroup.pressure.enable".

Thanks.

> 
>> @@ -745,6 +745,14 @@ static void psi_group_change(struct psi_group *group, int cpu,
>>  		if (set & (1 << t))
>>  			groupc->tasks[t]++;
>>  
>> +	if (!group->enabled) {
>> +		if (groupc->state_mask & (1 << PSI_NONIDLE))
>> +			record_times(groupc, now);
> 
> Thanks for the explanation in the other thread, it made sense. But can
> you please add a comment to document it? Something like:
> 
> 	/*
> 	 * On the first group change after disabling PSI, conclude
> 	 * the current state and flush its time. This is unlikely
> 	 * to matter to the user, but aggregation (get_recent_times)
> 	 * may have already incorporated the live state into times_prev;
> 	 * avoid a delta sample underflow when PSI is later re-enabled.
> 	 */
> 
> An unlikely() would also make sense on that branch.
> 
>> @@ -1081,6 +1092,40 @@ void cgroup_move_task(struct task_struct *task, struct css_set *to)
>>  
>>  	task_rq_unlock(rq, task, &rf);
>>  }
>> +
>> +void psi_cgroup_enabled_sync(struct psi_group *group)
>> +{
>> +	int cpu;
>> +
>> +	/*
>> +	 * After we disable psi_group->enabled, we don't actually
>> +	 * stop percpu tasks accounting in each psi_group_cpu,
>> +	 * instead only stop test_state() loop, record_times()
>> +	 * and averaging worker, see psi_group_change() for details.
>> +	 *
>> +	 * When disable cgroup PSI, this function has nothing to sync
>> +	 * since cgroup pressure files are hidden and percpu psi_group_cpu
>> +	 * would see !psi_group->enabled and only do task accounting.
>> +	 *
>> +	 * When re-enable cgroup PSI, this function use psi_group_change()
>> +	 * to get correct state mask from test_state() loop on tasks[],
>> +	 * and restart groupc->state_start from now, use .clear = .set = 0
>> +	 * here since no task status really changed.
>> +	 */
>> +	if (!group->enabled)
>> +		return;
> 
> Thanks for adding the comment, that's helpful.
> 
> I think the function would be a tad clearer and self-documenting if
> you called it psi_cgroup_restart(), and only call it on enabling.
> 
>> +	for_each_possible_cpu(cpu) {
>> +		struct rq *rq = cpu_rq(cpu);
>> +		struct rq_flags rf;
>> +		u64 now;
>> +
>> +		rq_lock_irq(rq, &rf);
>> +		now = cpu_clock(cpu);
>> +		psi_group_change(group, cpu, 0, 0, now, true);
>> +		rq_unlock_irq(rq, &rf);
>> +	}
>> +}
>>  #endif /* CONFIG_CGROUPS */
> 
> Thanks,
> Johannes
