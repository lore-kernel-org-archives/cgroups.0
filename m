From: Andrey Ryabinin <arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>
Subject: Re: [PATCH 3/4] sched/cpuacct: fix user/system in shown
 cpuacct.usage*
Date: Fri, 20 Aug 2021 12:37:47 +0300
Message-ID: <e56570e5-5165-71e1-f4cc-b8ea2063aec8@yandex-team.com>
References: <20210217120004.7984-1-arbn@yandex-team.com>
 <20210217120004.7984-3-arbn@yandex-team.com> <87r1kdl8se.fsf@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com; s=default;
        t=1629452260; bh=sLLsRL1I8judTG8/a2QYuzjSJMQb61/3K6LopvtlOeY=;
        h=In-Reply-To:References:Date:Message-ID:To:Subject:From:Cc;
        b=2w+ZCtMdyCPjSweZe4Y/etikVP+u7iPFn643sumPqJQ2JlVATqzTHSdzVjCjtMBWN
         mV3b0xfKRhxqqWqcAxRSfHgU9/DCCiXINZjTho77St886lFwFg/QodJCvU7X6A+Iru
         cRyT2zIFqBCEWJ+up/+OeLdzQSPX7YiPgNPaOfnk=
In-Reply-To: <87r1kdl8se.fsf-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Boris Burkov <boris-UrQYPotlwNs@public.gmane.org>, Bharata B Rao <bharata-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 3/18/21 1:22 AM, Daniel Jordan wrote:
> Andrey Ryabinin <arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org> writes:
> 
>> cpuacct has 2 different ways of accounting and showing user
>> and system times.
>>
>> The first one uses cpuacct_account_field() to account times
>> and cpuacct.stat file to expose them. And this one seems to work ok.
>>
>> The second one is uses cpuacct_charge() function for accounting and
>> set of cpuacct.usage* files to show times. Despite some attempts to
>> fix it in the past it still doesn't work. E.g. while running KVM
>> guest the cpuacct_charge() accounts most of the guest time as
>> system time. This doesn't match with user&system times shown in
>> cpuacct.stat or proc/<pid>/stat.
> 
> I couldn't reproduce this running a cpu bound load in a kvm guest on a
> nohz_full cpu on 5.11.  The time is almost entirely in cpuacct.usage and
> _user, while _sys stays low.
> 
> Could you say more about how you're seeing this?  Don't really doubt
> there's a problem, just wondering what you're doing.
> 


Yeah, I it's almost unnoticable if you run some load in guest like qemu.

But more simple case with busy loop in KVM_RUN triggers this:

# git clone https://github.com/aryabinin/kvmsample
# make
# mkdir /sys/fs/cgroup/cpuacct/test
# echo $$ > /sys/fs/cgroup/cpuacct/test/tasks
# ./kvmsample &
# for i in {1..5}; do cat /sys/fs/cgroup/cpuacct/test/cpuacct.usage_sys; sleep 1; done
1976535645
2979839428
3979832704
4983603153
5983604157

>> diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
>> index 941c28cf9738..7eff79faab0d 100644
>> --- a/kernel/sched/cpuacct.c
>> +++ b/kernel/sched/cpuacct.c
>> @@ -29,7 +29,7 @@ struct cpuacct_usage {
>>  struct cpuacct {
>>  	struct cgroup_subsys_state	css;
>>  	/* cpuusage holds pointer to a u64-type object on every CPU */
>> -	struct cpuacct_usage __percpu	*cpuusage;
> 
> Definition of struct cpuacct_usage can go away now.
> 

Done.

>> @@ -99,7 +99,8 @@ static void cpuacct_css_free(struct cgroup_subsys_state *css)
>>  static u64 cpuacct_cpuusage_read(struct cpuacct *ca, int cpu,
>>  				 enum cpuacct_stat_index index)
>>  {
>> -	struct cpuacct_usage *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
>> +	u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
>> +	u64 *cpustat = per_cpu_ptr(ca->cpustat, cpu)->cpustat;
>>  	u64 data;
> 
> There's a BUG_ON below this that could probably be WARN_ON_ONCE while
> you're here
> 

Sure.

>> @@ -278,8 +274,8 @@ static int cpuacct_stats_show(struct seq_file *sf, void *v)
>>  	for_each_possible_cpu(cpu) {
>>  		u64 *cpustat = per_cpu_ptr(ca->cpustat, cpu)->cpustat;
>>  
>> -		val[CPUACCT_STAT_USER]   += cpustat[CPUTIME_USER];
>> -		val[CPUACCT_STAT_USER]   += cpustat[CPUTIME_NICE];
>> +		val[CPUACCT_STAT_USER] += cpustat[CPUTIME_USER];
>> +		val[CPUACCT_STAT_USER] += cpustat[CPUTIME_NICE];
> 
> unnecessary whitespace change?
> 

yup
