From: Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: Re: [PATCH 3/4] sched/cpuacct: fix user/system in shown cpuacct.usage*
Date: Wed, 17 Mar 2021 18:22:57 -0400
Message-ID: <87r1kdl8se.fsf@oracle.com>
References: <20210217120004.7984-1-arbn@yandex-team.com>
 <20210217120004.7984-3-arbn@yandex-team.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : content-type :
 mime-version; s=corp-2020-01-29;
 bh=LA5ZAQhYLUaED6CdchMqR50MvS+2+CLaZ4yN89QwO5Y=;
 b=PItloUqEikd9la4gfSg3nDRFUk2fvjs9jt29zNUbROCUHmJ2VtPygsEYO3Xv9Gba4yb0
 2gyGdBLE0wwWY3Su9/jqPGWjr2QB8mF3uhuiQgNp3218bHAiaHaHn2v6Ol+y1BnLAb4q
 2xIgWJtoD5PJ8IwIJWZ/OuZdoC7OgKPhX2aRPoj/dngy6ZejUUy0+dKaDZ/ZYEfeVp+6
 uj9uvttAOgAQ7Dnt26TUVM5NcTV5+kkpeDyZudemZgC+bAU+3q6Vlw8qco5VbGsD6/Uq
 MytuI/QT3r621nE6Lrmu0wy4lQkeaxTo0GZzQP7/fvFyHX2GJrEcHoOjIbM57pXbIUA3 ng== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LA5ZAQhYLUaED6CdchMqR50MvS+2+CLaZ4yN89QwO5Y=;
 b=NWofWmnJCIIU36S436WsIIdhhvj2UjxVqR2C8v8DXYmZ4/uEvyRJvY6S44xE5sKOo3ggPvxNGf+Tj7mgfeFuq0pNtiIFsT6RaxNasTrFoYh6PW44N+515x/o1nIjnATHXwiLobxkQ7lDqN2BfeTN4SNDEjlxYF+Ek4lrrwu2dLU=
In-Reply-To: <20210217120004.7984-3-arbn@yandex-team.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrey Ryabinin <arbn@yandex-team.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: Boris Burkov <boris@bur.io>, Bharata B Rao <bharata@linux.vnet.ibm.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Andrey Ryabinin <arbn@yandex-team.com>, stable@vger.kernel.org

Andrey Ryabinin <arbn@yandex-team.com> writes:

> cpuacct has 2 different ways of accounting and showing user
> and system times.
>
> The first one uses cpuacct_account_field() to account times
> and cpuacct.stat file to expose them. And this one seems to work ok.
>
> The second one is uses cpuacct_charge() function for accounting and
> set of cpuacct.usage* files to show times. Despite some attempts to
> fix it in the past it still doesn't work. E.g. while running KVM
> guest the cpuacct_charge() accounts most of the guest time as
> system time. This doesn't match with user&system times shown in
> cpuacct.stat or proc/<pid>/stat.

I couldn't reproduce this running a cpu bound load in a kvm guest on a
nohz_full cpu on 5.11.  The time is almost entirely in cpuacct.usage and
_user, while _sys stays low.

Could you say more about how you're seeing this?  Don't really doubt
there's a problem, just wondering what you're doing.

> diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
> index 941c28cf9738..7eff79faab0d 100644
> --- a/kernel/sched/cpuacct.c
> +++ b/kernel/sched/cpuacct.c
> @@ -29,7 +29,7 @@ struct cpuacct_usage {
>  struct cpuacct {
>  	struct cgroup_subsys_state	css;
>  	/* cpuusage holds pointer to a u64-type object on every CPU */
> -	struct cpuacct_usage __percpu	*cpuusage;

Definition of struct cpuacct_usage can go away now.

> @@ -99,7 +99,8 @@ static void cpuacct_css_free(struct cgroup_subsys_state *css)
>  static u64 cpuacct_cpuusage_read(struct cpuacct *ca, int cpu,
>  				 enum cpuacct_stat_index index)
>  {
> -	struct cpuacct_usage *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
> +	u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
> +	u64 *cpustat = per_cpu_ptr(ca->cpustat, cpu)->cpustat;
>  	u64 data;

There's a BUG_ON below this that could probably be WARN_ON_ONCE while
you're here

> @@ -278,8 +274,8 @@ static int cpuacct_stats_show(struct seq_file *sf, void *v)
>  	for_each_possible_cpu(cpu) {
>  		u64 *cpustat = per_cpu_ptr(ca->cpustat, cpu)->cpustat;
>  
> -		val[CPUACCT_STAT_USER]   += cpustat[CPUTIME_USER];
> -		val[CPUACCT_STAT_USER]   += cpustat[CPUTIME_NICE];
> +		val[CPUACCT_STAT_USER] += cpustat[CPUTIME_USER];
> +		val[CPUACCT_STAT_USER] += cpustat[CPUTIME_NICE];

unnecessary whitespace change?
