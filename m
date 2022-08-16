From: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH v2 09/10] sched/psi: per-cgroup PSI stats
 disable/re-enable interface
Date: Tue, 16 Aug 2022 21:06:21 +0800
Message-ID: <904851a7-7b01-8689-3ec1-2a61f8244841@bytedance.com>
References: <20220808110341.15799-1-zhouchengming@bytedance.com>
 <20220808110341.15799-10-zhouchengming@bytedance.com>
 <YvprI6ZL8dVWGyBO@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=+6Yo80pVz7R1wbuugd0h39oHv4cQk8t0dTgRXP4VwBI=;
        b=Bm1NhmX8UPNf1PtLuZHAgWfhESmLqjvmDF7oLG7Sjrob5ZBRioBQbZD8IbmfhUAuPy
         26Pg0XP9e55a3u5kuQ5ryXTN1eqIwUYiGNTjeFnhmdbLM55bc0FxevMk8+WBBXcBYJT5
         CC+fEv2AnVaO1iGODXOqJPnAoaTxd2O8NqgXkv2mZ6mBh9kYG0x+9EMHXgGOCIk3qAR1
         n1LKoZW0wxTfg0Fcd1tVZGBrJarWd6ATeB6MjzrMVXM8Uq9zR3Tc0GPRV7NUamgreV0Y
         sIsQn/MuuGInwkkJosYPYxp8cPCoQUm4kieEJnct/L+ITnY3CRyDKA7UUzqyiZWg54Tf
         3LGA==
Content-Language: en-US
In-Reply-To: <YvprI6ZL8dVWGyBO-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

On 2022/8/15 23:49, Johannes Weiner wrote:
> On Mon, Aug 08, 2022 at 07:03:40PM +0800, Chengming Zhou wrote:
>> +static ssize_t cgroup_psi_write(struct kernfs_open_file *of,
>> +				char *buf, size_t nbytes, loff_t off)
>> +{
>> +	ssize_t ret;
>> +	int enable;
>> +	struct cgroup *cgrp;
>> +	struct psi_group *psi;
>> +
>> +	ret = kstrtoint(strstrip(buf), 0, &enable);
>> +	if (ret)
>> +		return ret;
>> +
>> +	if (enable < 0 || enable > 1)
>> +		return -ERANGE;
>> +
>> +	cgrp = cgroup_kn_lock_live(of->kn, false);
>> +	if (!cgrp)
>> +		return -ENOENT;
>> +
>> +	psi = cgroup_ino(cgrp) == 1 ? &psi_system : &cgrp->psi;
>> +	psi_cgroup_enable(psi, enable);
> 
> I think it should also add/remove the pressure files when enabling and
> disabling the aggregation, since their contents would be stale and
> misleading.
> 
> Take a look at cgroup_add_dfl_cftypes() and cgroup_rm_cftypes()

Ok, I will look.

> 
>> @@ -5115,6 +5152,12 @@ static struct cftype cgroup_base_files[] = {
>>  		.release = cgroup_pressure_release,
>>  	},
>>  #endif
>> +	{
>> +		.name = "cgroup.psi",
>> +		.flags = CFTYPE_PRESSURE,
>> +		.seq_show = cgroup_psi_show,
>> +		.write = cgroup_psi_write,
>> +	},
>>  #endif /* CONFIG_PSI */
>>  	{ }	/* terminate */
>>  };
>> diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
>> index 58f8092c938f..9df1686ee02d 100644
>> --- a/kernel/sched/psi.c
>> +++ b/kernel/sched/psi.c
>> @@ -181,6 +181,7 @@ static void group_init(struct psi_group *group)
>>  {
>>  	int cpu;
>>  
>> +	group->enabled = true;
>>  	for_each_possible_cpu(cpu)
>>  		seqcount_init(&per_cpu_ptr(group->pcpu, cpu)->seq);
>>  	group->avg_last_update = sched_clock();
>> @@ -700,17 +701,16 @@ static void psi_group_change(struct psi_group *group, int cpu,
>>  	groupc = per_cpu_ptr(group->pcpu, cpu);
>>  
>>  	/*
>> -	 * First we assess the aggregate resource states this CPU's
>> -	 * tasks have been in since the last change, and account any
>> -	 * SOME and FULL time these may have resulted in.
>> -	 *
>> -	 * Then we update the task counts according to the state
>> +	 * First we update the task counts according to the state
>>  	 * change requested through the @clear and @set bits.
>> +	 *
>> +	 * Then if the cgroup PSI stats accounting enabled, we
>> +	 * assess the aggregate resource states this CPU's tasks
>> +	 * have been in since the last change, and account any
>> +	 * SOME and FULL time these may have resulted in.
>>  	 */
>>  	write_seqcount_begin(&groupc->seq);
>>  
>> -	record_times(groupc, now);
>> -
>>  	/*
>>  	 * Start with TSK_ONCPU, which doesn't have a corresponding
>>  	 * task count - it's just a boolean flag directly encoded in
>> @@ -750,6 +750,14 @@ static void psi_group_change(struct psi_group *group, int cpu,
>>  		if (set & (1 << t))
>>  			groupc->tasks[t]++;
>>  
>> +	if (!group->enabled) {
>> +		if (groupc->state_mask & (1 << PSI_NONIDLE))
>> +			record_times(groupc, now);
> 
> Why record the nonidle time? It's only used for aggregation, which is
> stopped as well.

I'm considering of this situation: disable at t2 and re-enable at t3

state1(t1) --> state2(t2) --> state3(t3)

If aggregator has get_recent_times() in [t1, t2], groupc->times_prev[aggregator]
will include that delta of (t - t1).

Then re-enable at t3, the delta of (t3-t1) is discarded, may make that aggregator
see times < groupc->times_prev[aggregator] ?

Maybe I missed something, not sure whether this is a problem.


> 
>> @@ -1088,6 +1097,23 @@ void cgroup_move_task(struct task_struct *task, struct css_set *to)
>>  
>>  	task_rq_unlock(rq, task, &rf);
>>  }
>> +
>> +void psi_cgroup_enable(struct psi_group *group, bool enable)
>> +{
>> +	struct psi_group_cpu *groupc;
>> +	int cpu;
>> +	u64 now;
>> +
>> +	if (group->enabled == enable)
>> +		return;
>> +	group->enabled = enable;
>> +
>> +	for_each_possible_cpu(cpu) {
>> +		groupc = per_cpu_ptr(group->pcpu, cpu);
>> +		now = cpu_clock(cpu);
>> +		psi_group_change(group, cpu, 0, 0, now, true);
> 
> This loop deserves a comment, IMO.

I add some comments as below, could you help take a look?

+
+void psi_cgroup_enable(struct psi_group *group, bool enable)
+{
+       int cpu;
+       u64 now;
+
+       if (group->enabled == enable)
+               return;
+       group->enabled = enable;
+
+       /*
+        * We use psi_group_change() to disable or re-enable the
+        * record_times(), test_state() loop and averaging worker
+        * in each psi_group_cpu of the psi_group, use .clear = 0
+        * and .set = 0 here since no task status really changed.
+        */
+       for_each_possible_cpu(cpu) {
+               now = cpu_clock(cpu);
+               psi_group_change(group, cpu, 0, 0, now, true);
+       }
+}

Thanks!

