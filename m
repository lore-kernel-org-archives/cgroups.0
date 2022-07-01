From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Question] The system may be stuck if there is a cpu cgroup
 cpu.cfs_quato_us is very low
Date: Sat, 2 Jul 2022 05:15:43 +0900
Message-ID: <Yr9V755mL6jr20c2@mtj.duckdns.org>
References: <5987be34-b527-4ff5-a17d-5f6f0dc94d6d@huawei.com>
 <YrlrBmF3oOfS3+fq@mtj.duckdns.org>
 <f0f55f89-14db-de29-c182-32539f8d4e4d@huawei.com>
 <xm26czeoioju.fsf@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FKcO/SCOzVEFqjsxTXwwvXLK9141GPhQIT81OrUhUD8=;
        b=GLj2L+xs0nzM+HVU1wsfkOPJDQ6JWIefMw43krHXTkq/Ez2BSuy1s2nxPvy+dPmt7K
         Znt15z2omq0hydFdGh9v2Ism2wVYJxpiajCUt6oZ4ktj7yX9U5hiISqfsvrY9tqrZtWE
         dPZa46JpmGQ2RoUcPDnDhnQfc4aGUYXXGRkLunZx4ktENzcX37VwLgFrxERNffW87PkX
         dvb3atYQgmpzWFDwwlXtJlxjFC+FG8xipe5cecfpI5CuHVIDIujMmlJrhC95Z9OTTKHX
         S1+vgjWLUoKkvncK721jLfm25KwmjC+RQXzdOEjDR0/C8fgugv1YXSvvb9m/Aq3bgquC
         eO1w==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <xm26czeoioju.fsf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Benjamin Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Zhang Qiao <zhangqiao22-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, mgorman-l3A5Bk7waGM@public.gmane.org

On Fri, Jul 01, 2022 at 01:08:21PM -0700, Benjamin Segall wrote:
> Yes, fixing (kernel) priority inversion due to CFS_BANDWIDTH requires a
> serious reworking of how it works, because it would need to dequeue
> tasks individually rather than doing the entire cfs_rq at a time (and
> would require some effort to avoid pinging every throttling task to get
> it into the kernel).

Right, I don't have a good idea on evolving the current implementation
into something correct. As you pointed out, we need to account along
the sched_group tree but conditionally enforce on each thread.

Thanks.

-- 
tejun
