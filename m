From: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/4] sched/cpuacct: Make user/system times in
 cpuacct.stat more precise
Date: Wed, 17 Mar 2021 18:25:13 -0400
Message-ID: <87o8fhl8om.fsf@oracle.com>
References: <20210217120004.7984-1-arbn@yandex-team.com>
 <20210217120004.7984-4-arbn@yandex-team.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : content-type :
 mime-version; s=corp-2020-01-29;
 bh=TH6wlzcCPWtIAtCjIQQeR6qoAZ/h/vMMRA5cV1RoqlM=;
 b=Co5tePda7Zj+SjqRUU0jFLHZavEIWbBdmriYVwSAUbDZbpREbP0nV7gPhr5DmQjef+/+
 ZDAbKBp2ufM5/mwGYZPSn33VGDiJT+RKaqsGxGTGFiSgPwAATQAA8frT7tZFsCmbg46h
 esq4LaGXTlV3J7iCcUxeGObWQt2Cf+lEDHNRQE4tlMlZ4Rwq4KqU8cjRB4/ogb6RvGtr
 i1WEl6whNToq+1n3PbhbkqUMvqluawsPX6h0H6agHeiZ9tJBI6pEoYLajqMhwKZlOinP
 Kg+OIldQmGOfV4J9NiqP59CaNRafQQVLnDyiEg2ZwHo0iITeteJCgGFTGUKmosmhkW/b 8A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TH6wlzcCPWtIAtCjIQQeR6qoAZ/h/vMMRA5cV1RoqlM=;
 b=tedqUrgaGs92xvt+gNwN941uXVHhL5htHWTHStTsXmvIsM/tof9mSIrnZvi+cR6IlD+KCRzQLyIyjlfCPx7vaOZLOw0bGotO9yA6NWju4k2hSX9FQZw44MmeUgLTc2mx73ACjT+shqmkABS5c1MeMfXwyfbLV/Te3ZBLRRcabJ4=
In-Reply-To: <20210217120004.7984-4-arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrey Ryabinin <arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Boris Burkov <boris-UrQYPotlwNs@public.gmane.org>, Bharata B Rao <bharata-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrey Ryabinin <arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>

Andrey Ryabinin <arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org> writes:
>  static int cpuacct_stats_show(struct seq_file *sf, void *v)
>  {
        ...
>  	for_each_possible_cpu(cpu) {
>  		u64 *cpustat = per_cpu_ptr(ca->cpustat, cpu)->cpustat;
>  
> -		val[CPUACCT_STAT_USER] += cpustat[CPUTIME_USER];
> -		val[CPUACCT_STAT_USER] += cpustat[CPUTIME_NICE];
> -		val[CPUACCT_STAT_SYSTEM] += cpustat[CPUTIME_SYSTEM];
> -		val[CPUACCT_STAT_SYSTEM] += cpustat[CPUTIME_IRQ];
> -		val[CPUACCT_STAT_SYSTEM] += cpustat[CPUTIME_SOFTIRQ];
> +		cputime.utime += cpustat[CPUTIME_USER];
> +		cputime.utime += cpustat[CPUTIME_NICE];
> +		cputime.stime += cpustat[CPUTIME_SYSTEM];
> +		cputime.stime += cpustat[CPUTIME_IRQ];
> +		cputime.stime += cpustat[CPUTIME_SOFTIRQ];
> +
> +		cputime.sum_exec_runtime += this_cpu_read(*ca->cpuusage);
>  	}

                cputime.sum_exec_runtime += *per_cpu_ptr(ca->cpuusage, cpu);

Or the stats can all be 0...
