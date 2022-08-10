From: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH v2 09/10] sched/psi: per-cgroup PSI stats
 disable/re-enable interface
Date: Wed, 10 Aug 2022 08:39:05 +0800
Message-ID: <fcd0bd39-3049-a279-23e6-a6c02b4680a7@bytedance.com>
References: <20220808110341.15799-1-zhouchengming@bytedance.com>
 <20220808110341.15799-10-zhouchengming@bytedance.com>
 <YvKd6dezPM6UxfD/@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=ocEP/lNDBd9drcOoXjaUPHob3Xt7j2o+0tElmpQe8kw=;
        b=C4FtFqDtCzEkv0O1zcdw15B+2OlUOBYzsJ+8jzPlnxWMk8K0WhIVNgtDISELPpkpJ2
         jYaoqwljoN9EI4J3bO4++EE1on9SLpz5WlGEUR6bgWI5RVwjrtsfPsfDxnsZwKldlCZ2
         MieUGAwNz+kZh2B6o+2nTjimIuZtE15+bOogRefCzNPBJlEUTtwiVpMlVJlUKBBf4AHa
         KKi3C61McekchJ5Hiw39yXSuof3TPXd+s2vikg6WDtxY9aSvjwNpnjTqr1Z5TR0dbv2n
         m2uCOjT7G57wfLV9G9GywDVNSq2r5MUmW8TkCl4E1Wo0y7qldg/xtiT5TyB+//x1IBHM
         QGhw==
Content-Language: en-US
In-Reply-To: <YvKd6dezPM6UxfD/@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

On 2022/8/10 01:48, Tejun Heo wrote:
> Hello,
> 
> On Mon, Aug 08, 2022 at 07:03:40PM +0800, Chengming Zhou wrote:
>> So this patch introduce a per-cgroup PSI stats disable/re-enable
>> interface "cgroup.psi", which is a read-write single value file that
>> allowed values are "0" and "1", the defaults is "1" so per-cgroup
>> PSI stats is enabled by default.
> 
> Given that the knobs are named {cpu|memory|io}.pressure, I wonder whether
> "cgroup.psi" is the best name. Also, it doesn't convey that it's the
> enable/disable knob. I think it needs a better name.

Yes, "cgroup.psi" is not good. What abort "pressure.enable" or "cgroup.psi_enable"?

Thanks.

