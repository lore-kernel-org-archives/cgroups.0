From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 1/5] cputime, cpuacct: Include guest time in user time
 in cpuacct.stat
Date: Tue, 7 Sep 2021 07:19:05 -1000
Message-ID: <YTefCTq1KyRxYlxr@slm.duckdns.org>
References: <20210217120004.7984-1-arbn@yandex-team.com>
 <20210820094005.20596-1-arbn@yandex-team.com>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FjhWJM3JAcxJyWXW2pwc/fGwqLigw+FDFXMEyVU7A5A=;
        b=FZEOnQYIH4IFKS0zgfI8NJI7grFEyCvnUTWh0L6GR5t4Qzyg4C2zbDD+bfVKF2g1sn
         LPDXOQBb/2DbZqJ1QAfegV0z7SNUyCWA5t7/6PlwrI3CHK1MRE2Fuslxeg7GktznHPKP
         aOjvFt7QqZdYO6+bqOCDdVhASStXJbDQLCdVQZG6WzZLy4aYLd9KcT3uKjw0IayV2JE5
         SqXrgGTVqU/B+4rUtpGJPxLaUvSsSnavCYQb0Z45OlGPYRpTUeeJPojTf7e0cD14Le2t
         Q2lalSHIn6WmCwVXFkCMwWlWF9RCecqVS/23XM4qVFWUmIgg9nvyPKt3dTFLZP5Y7yQr
         16EA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20210820094005.20596-1-arbn@yandex-team.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrey Ryabinin <arbn@yandex-team.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Daniel Jordan <daniel.m.jordan@oracle.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, bharata@linux.vnet.ibm.com, boris@bur.io, stable@vger.kernel.org

On Fri, Aug 20, 2021 at 12:40:01PM +0300, Andrey Ryabinin wrote:
> cpuacct.stat in no-root cgroups shows user time without guest time
> included int it. This doesn't match with user time shown in root
> cpuacct.stat and /proc/<pid>/stat. This also affects cgroup2's cpu.stat
> in the same way.
> 
> Make account_guest_time() to add user time to cgroup's cpustat to
> fix this.
> 
> Fixes: ef12fefabf94 ("cpuacct: add per-cgroup utime/stime statistics")
> Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
> Cc: <stable@vger.kernel.org>

The fact that this has been broken for so long, prolly from the beginning,
gives me some pause but the patches looks fine to me.

For the series,

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
