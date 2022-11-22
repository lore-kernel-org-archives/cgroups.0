From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] kselftest/cgroup: Add cleanup() to test_cpuset_prs.sh
Date: Tue, 22 Nov 2022 10:26:09 -1000
Message-ID: <Y30wYVzuCGK/0Zxp@slm.duckdns.org>
References: <20221118101330.251332-1-kamalesh.babulal@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ql2FYZtChC8kHpVI2e9mEHckclAXpvmwn/fO5tPh578=;
        b=elh+z0q1qqevOLCYpwBkrBAb6yjmtaCYgataLx2FY3l8CrqJmnwjYJWWkb5XE113YF
         wt+kf4HIRlorudrICrtnK9/H2DPLaZSXNrbpt8G62NLJIKN8sfcQUFdKwfg06jc0C5+p
         8Gtx4MymzEdA0l8pyQ1Cf2LPpu2Wp+22iPTyGXFjEnggAQxp1UPsc++daU16duq13EKY
         a2VTX51iWrP73LKhnvgT0RVcYOFWdyJDccZ5b8xGiTGmp43Ls+jmMr1jHEkDDh3SyE1e
         x8u9Div/D2HUKk1ec770Bu2vK+iXmlPe3ItbyjMQdRWapEXVc54OAKYChtCcD2e+K3ke
         q0uQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221118101330.251332-1-kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tom Hromatka <tom.hromatka-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Nov 18, 2022 at 03:43:30PM +0530, Kamalesh Babulal wrote:
> Install a cleanup function using the trap command for signals EXIT,
> SIGINT, SIGQUIT and SIGABRT.  The cleanup function will perform:
> 1. Online the CPUs that were made offline during the test.
> 2. Removing the cgroups created.
> 3. Restoring the original /sys/kernel/debug/sched/verbose value,
>    currently it's left turned on, irrespective of the original
>    configuration value.
> 
> the test performs steps 1 and 2, on the successful runs, but not during
> all of the failed runs.  With the cleanup(), the system will perform all
> three steps during failed/passed test runs.
> 
> Signed-off-by: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Applied cgroup/for-6.2.

Thanks.

-- 
tejun
