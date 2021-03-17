From: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/4] cputime,cpuacct: Include guest time in user time in
 cpuacct.stat
Date: Wed, 17 Mar 2021 18:09:53 -0400
Message-ID: <87wnu5l9e6.fsf@oracle.com>
References: <20210217120004.7984-1-arbn@yandex-team.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : content-type :
 mime-version; s=corp-2020-01-29;
 bh=g+C4PpMAyVQ7oN2PcDz/C5Bjww6w/dQDP1v816BvyMI=;
 b=v0RFd/W0SBcY8XERJ8JoU6gNBbuIXyAUsUjEV6WPwTKPo2RezsrQw3SofJSae7zB4/64
 3ePO3Tq/uodKyL8Z3Bp4ixXxj4hos3hK6/3qReQExyEKmlr2MLbyn2iguj5tBwHdIsIJ
 f9P9BWAdno5mqW4uCp23UYUTfO1PtRbuIXo0ERYJ2gcvvhC2IaQ29Lo3OeofvCmQBcb9
 wOZeoLv2hJzLOr3HNW++GB4QdEeXBg+uuS4jny/vDgqtAKJIzgesG9NaifoXTvmsuyaZ
 UmVPI9ca5tp4rIw/Y/+MUxKdo7xAXoSZ3uuQe8xXkCZKIm4wfOne7GGMoE2Yhw1Ih/t5 KA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g+C4PpMAyVQ7oN2PcDz/C5Bjww6w/dQDP1v816BvyMI=;
 b=cXENOr7E4P5zQhrwhex0NA7QYnTge1T7uF/ZxSFslEORCfjEVn3TL5wIPyRT1a6I/Ad7Fa74YkJR6aX+mJ2Xk4Ca1mturRVzxH5g/vDvkOzkuv0h7dpouzvdm6C2Qzk8O6BFzq31O8rVQzj+849XOp6C7Z5doAt5j0M7tFb08Ts=
In-Reply-To: <20210217120004.7984-1-arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrey Ryabinin <arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Boris Burkov <boris-UrQYPotlwNs@public.gmane.org>, Bharata B Rao <bharata-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrey Ryabinin <arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Andrey Ryabinin <arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org> writes:

> cpuacct.stat in no-root cgroups shows user time without guest time
> included int it. This doesn't match with user time shown in root
> cpuacct.stat and /proc/<pid>/stat.

Yeah, that's inconsistent.

> Make account_guest_time() to add user time to cgroup's cpustat to
> fix this.

Yep.

cgroup2's cpu.stat is broken the same way for child cgroups, and this
happily fixes it.  Probably deserves a mention in the changelog.

The problem with cgroup2 was, if the workload was mostly guest time,
cpu.stat's user and system together reflected it, but it was split
unevenly across the two.  I think guest time wasn't actually included in
either bucket, it was just that the little user and system time there
was got scaled up in cgroup_base_stat_cputime_show -> cputime_adjust to
match sum_exec_runtime, which did have it.

The stats look ok now for both cgroup1 and 2.  Just slightly unsure
whether we want to change the way both interfaces expose the accounting
in case something out there depends on it.  Seems like we should, but
it'd be good to hear more opinions.

> @@ -148,11 +146,11 @@ void account_guest_time(struct task_struct *p, u64 cputime)
>  
>  	/* Add guest time to cpustat. */
>  	if (task_nice(p) > 0) {
> -		cpustat[CPUTIME_NICE] += cputime;
> -		cpustat[CPUTIME_GUEST_NICE] += cputime;
> +		task_group_account_field(p, CPUTIME_NICE, cputime);
> +		task_group_account_field(p, CPUTIME_GUEST_NICE, cputime);
>  	} else {
> -		cpustat[CPUTIME_USER] += cputime;
> -		cpustat[CPUTIME_GUEST] += cputime;
> +		task_group_account_field(p, CPUTIME_USER, cputime);
> +		task_group_account_field(p, CPUTIME_GUEST, cputime);
>  	}

Makes sense for _USER and _NICE, but it doesn't seem cgroup1 or 2
actually use _GUEST and _GUEST_NICE.

Could go either way.  Consistency is nice, but I probably wouldn't
change the GUEST ones so people aren't confused about why they're
accounted.  It's also extra cycles for nothing, even though most of the
data is probably in the cache.
