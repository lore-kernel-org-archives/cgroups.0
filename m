From: Zhang Qiao <zhangqiao22-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [Question] The system may be stuck if there is a cpu cgroup
 cpu.cfs_quato_us is very low
Date: Thu, 7 Jul 2022 14:59:13 +0800
Message-ID: <66a1d60d-b6a7-7d7e-6c70-e75456bc828c@huawei.com>
References: <5987be34-b527-4ff5-a17d-5f6f0dc94d6d@huawei.com>
 <YrlrBmF3oOfS3+fq@mtj.duckdns.org>
 <f0f55f89-14db-de29-c182-32539f8d4e4d@huawei.com>
 <xm26czeoioju.fsf@google.com> <Yr9V755mL6jr20c2@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Yr9V755mL6jr20c2-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, mgorman-l3A5Bk7waGM@public.gmane.org



在 2022/7/2 4:15, Tejun Heo 写道:
> On Fri, Jul 01, 2022 at 01:08:21PM -0700, Benjamin Segall wrote:
>> Yes, fixing (kernel) priority inversion due to CFS_BANDWIDTH requires a
>> serious reworking of how it works, because it would need to dequeue
>> tasks individually rather than doing the entire cfs_rq at a time (and
>> would require some effort to avoid pinging every throttling task to get
>> it into the kernel).
> 
> Right, I don't have a good idea on evolving the current implementation
> into something correct. As you pointed out, we need to account along
> the sched_group tree but conditionally enforce on each thread.
> 
> Thanks.
> 

Understood. Thanks for your detailed explanation.

Thanks.
