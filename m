From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v4] cpuset: Enable cpuset controller in default hierarchy
Date: Fri, 9 Mar 2018 23:17:36 +0100
Message-ID: <20180309221736.GB5926@hirez.programming.kicks-ass.net>
References: <1520609707-16582-1-git-send-email-longman@redhat.com>
 <1520613285.12489.36.camel@gmx.de>
 <1c3fe7b0-2600-c46d-1527-d3aaf024bb91@redhat.com>
 <1520619426.27998.18.camel@gmx.de>
 <55809fe4-98ba-5566-86ed-457acfef0e1c@redhat.com>
 <1520624424.27998.76.camel@gmx.de>
 <53de9683-01b7-bac4-8b70-dc1f93ede600@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=RkBtt9tkDV2iE1mC4U9xJKGNKhy+fjgAoK0SGEwOeqY=; b=eBsc/FouOixWF0VWe2ql4g/6j
        l/5HCk87r1LqJNNhZtVnYwgXlVdpHGrxi0Y9bjIMc86pXVDUEwrN1qTS4iCSdRFVnWcR1Ns2RVbZZ
        AbcUlXfiTHNn/6cgpAUXi7exKOsCRCDrjagPnmsx9MHnvzT+tiCxSW8ja5RTMlKT/SR7BbRqVLd/I
        rrMPIoyQJznr2zq9lZcbWuRcH6V3X4EjG4mxDwqLasHP0NcwUSIHHsLmhdk1BjRSBePaPrSN+guxU
        Qf7obgKT5ZT7vFqIeTV9m2v6yDXBh1WYzWFqwci7zyY2gYBH4XtvsXprwtdh4r9vea6+RT+9Wm3L2
    
Content-Disposition: inline
In-Reply-To: <53de9683-01b7-bac4-8b70-dc1f93ede600@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>

On Fri, Mar 09, 2018 at 03:43:34PM -0500, Waiman Long wrote:
> The isolcpus= parameter just reduce the cpus available to the rests of
> the system. The cpuset controller does look at that value and make
> adjustment accordingly, but it has no dependence on exclusive cpu/mem
> features of cpuset.

The isolcpus= boot param is donkey shit and needs to die. cpuset _used_
to be able to fully replace it, but with the advent of cgroup 'feature'
this got lost.

And instead of fixing it, you're making it _far_ worse. You completely
removed all the bits that allow repartitioning the scheduler domains.

Mike is completely right, full NAK on any such approach.
