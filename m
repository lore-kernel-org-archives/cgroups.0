From: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH v4 00/10] sched/psi: some optimizations and extensions
Date: Wed, 7 Sep 2022 09:55:06 +0800
Message-ID: <94fdf793-a568-704e-b6f8-093b8b7fe24a@bytedance.com>
References: <20220825164111.29534-1-zhouchengming@bytedance.com>
 <be071d5a-ff2d-d06e-2f89-f2ca247dd19e@bytedance.com>
 <YxdcfX4Ss/9k8qA9@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=xyD4Pb2btMZ+ktk/ltP1p8JWsLx2B7oKf49IB7a3hmw=;
        b=s3UYPk0Ct+f4DGBqXw94s4gfbvQOJzYetBO/7uEBLrzkQYgmjrZFhZYfFuuFVSg4RJ
         4m242WFFh3Rh9XzSI4nfxcVJsRwB+1dnA9Qn8rjnyUb6L/6oikLS1XP/QoSrMGIgis/j
         ZqHXIiLsjL+XYncZn0mcNZjCsxMrdMH2G8B1oiPBRtPQBEDzmGSnKfr8RVISEnSq/MGb
         I51ZIKIWki5K+9nENzI3tP0HMLtrsjlkRDqb01/9P1XEdTBLpytUoIwOVVd1rSrmimzA
         tkmpu+guejoPlmp2WTMCZSA8o5Ypk51i0GiSJRl9VC4n1fD2MRP4cyewoBbvTe8aDEf9
         38YQ==
Content-Language: en-US
In-Reply-To: <YxdcfX4Ss/9k8qA9-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

On 2022/9/6 22:43, Peter Zijlstra wrote:
> On Tue, Sep 06, 2022 at 09:13:27PM +0800, Chengming Zhou wrote:
> 
> Ah, I see Johannes has acked them all, I missed that.
> 
>>> Chengming Zhou (9):
>>>   sched/psi: fix periodic aggregation shut off
>>>   sched/psi: don't create cgroup PSI files when psi_disabled
>>>   sched/psi: save percpu memory when !psi_cgroups_enabled
>>>   sched/psi: move private helpers to sched/stats.h
>>>   sched/psi: optimize task switch inside shared cgroups again
>>>   sched/psi: add PSI_IRQ to track IRQ/SOFTIRQ pressure
>>>   sched/psi: consolidate cgroup_psi()
>>>   sched/psi: cache parent psi_group to speed up groups iterate
>>>   sched/psi: per-cgroup PSI accounting disable/re-enable interface
>>>
>>> Johannes Weiner (1):
>>>   sched/psi: remove NR_ONCPU task accounting
> 
> For future reference:
> 
>   https://www.kernel.org/doc/html/latest/process/maintainer-tip.html
> 
> Note all patches violate 1.2.2 for not starting the patch description
> with a uppercase letter. I'll go manually fix up this time.

Sorry about that, thanks for the reference and your manual fix up!

