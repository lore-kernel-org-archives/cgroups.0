From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v4 00/10] sched/psi: some optimizations and extensions
Date: Tue, 6 Sep 2022 16:43:09 +0200
Message-ID: <YxdcfX4Ss/9k8qA9@hirez.programming.kicks-ass.net>
References: <20220825164111.29534-1-zhouchengming@bytedance.com>
 <be071d5a-ff2d-d06e-2f89-f2ca247dd19e@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Jx46skhkYJ7CRZ0Qm2k8P6SrP0P68ycbdV/aTLvLqRE=; b=NZnEwekYJDhfBID21ehPz4VPhB
        kMsNTUZWCVo3xCgP3gXXbsHeAgXYdPwC3KIgIiuG2fhaBrd7WB5A1WuY0xke7TV9h8WLtsUeWjpHm
        otfpdfYaVqF1HNcjENHzZocgs2UpVFKV/FfKAdbUpDbb83unT/KRxCQSrWdgBhxLWYdsn/zzTwMYF
        DEm7B5ZyJtS8c2mbEH0+EN6bin+ZFXeQEyOiniVwIEUtFLrrW2MXgZnO0N+uF3D+YKMnTj/1SOBbD
        BHA3AgC5E/QSycFaXcosebs6LqOfpq8PmRh6+B0ljbJe9OqCsNgjBU6PffHz/j7n2yyZtMlrn5m/p
        evQDbwXw==;
Content-Disposition: inline
In-Reply-To: <be071d5a-ff2d-d06e-2f89-f2ca247dd19e-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

On Tue, Sep 06, 2022 at 09:13:27PM +0800, Chengming Zhou wrote:

Ah, I see Johannes has acked them all, I missed that.

> > Chengming Zhou (9):
> >   sched/psi: fix periodic aggregation shut off
> >   sched/psi: don't create cgroup PSI files when psi_disabled
> >   sched/psi: save percpu memory when !psi_cgroups_enabled
> >   sched/psi: move private helpers to sched/stats.h
> >   sched/psi: optimize task switch inside shared cgroups again
> >   sched/psi: add PSI_IRQ to track IRQ/SOFTIRQ pressure
> >   sched/psi: consolidate cgroup_psi()
> >   sched/psi: cache parent psi_group to speed up groups iterate
> >   sched/psi: per-cgroup PSI accounting disable/re-enable interface
> > 
> > Johannes Weiner (1):
> >   sched/psi: remove NR_ONCPU task accounting

For future reference:

  https://www.kernel.org/doc/html/latest/process/maintainer-tip.html

Note all patches violate 1.2.2 for not starting the patch description
with a uppercase letter. I'll go manually fix up this time.
