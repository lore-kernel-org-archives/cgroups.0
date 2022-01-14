From: cruzzhao <cruzzhao-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v2 3/3] sched/core: Force idle accounting per cgroup
Date: Fri, 14 Jan 2022 19:13:12 +0800
Message-ID: <1cca28c3-c84d-415e-9b33-6687e4ff2cbb@linux.alibaba.com>
References: <1641894961-9241-1-git-send-email-CruzZhao@linux.alibaba.com>
 <1641894961-9241-4-git-send-email-CruzZhao@linux.alibaba.com>
 <Yd89Lv3VuaaFVm4h@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <Yd89Lv3VuaaFVm4h-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



在 2022/1/13 上午4:42, Tejun Heo 写道:
> Hello,
> 
> On Tue, Jan 11, 2022 at 05:56:01PM +0800, Cruz Zhao wrote:
>> +#ifdef CONFIG_SCHED_CORE
>> +void cpuacct_account_forceidle(int cpu, struct task_struct *tsk, u64 cputime)
>> +{
>> +	struct cpuacct *ca;
>> +	u64 *fi;
>> +
>> +	rcu_read_lock();
>> +	/*
>> +	 * We have hold rq->core->__lock here, which protects ca->forceidle
>> +	 * percpu.
>> +	 */
>> +	for (ca = task_ca(tsk); ca; ca = parent_ca(ca)) {
>> +		fi = per_cpu_ptr(ca->forceidle, cpu);
>> +		*fi += cputime;
>> +	}
> 
> Please don't do this. Use rstat and integrate it with other stats.
> 
> Thanks.
> 

Thanks for suggestions, I'll try to do this using rstat. BTW, is it ok
to integrate it with cgroup_base_stat?

Best,
Cruz Zhao
