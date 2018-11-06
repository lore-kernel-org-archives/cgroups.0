From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v14 00/12] Enable cpuset controller in default hierarchy
Date: Tue, 6 Nov 2018 12:53:35 +0100
Message-ID: <20181106115335.GQ22431@hirez.programming.kicks-ass.net>
References: <1539635377-22335-1-git-send-email-longman@redhat.com>
 <20181105163656.GK4182586@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=aXvN+WbvQ97KQ8dBAud/2GgaARPjpmK4HJ5tE15KfX0=; b=Wd6GsOY1SN4rCrqabOqajUc4U
        aJr29bNAmzzIOdH9ESPYsUrxex1dxmc/i6/GABji5Jrh096Ntc7sch6urhE8ml5sfzd6dK7cjwr3I
        gp3jzrQha6iWBsVhuTfJezZpedd4Nt7N11jERUQYhw93FC8cp/igjmNqgSO4Npf8nGPAyLSU1riVI
        aDc1cM/CYx70xrzRH6fXQtJLlnGxlsVrXa2Oeq2mlv3QMiOHL8sVoIDa0z7afn/z5VEnGLR7LJGzV
        nqp/VPztyX3YryCFMSe102BK9aXcfHPfUmM0FHJ7Lf7OmF89mztg/G62q4Soe6GxDdZh3abDPRFd9
    
Content-Disposition: inline
In-Reply-To: <20181105163656.GK4182586@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Tom Hromatka <tom.hromatka@oracle.com>

On Mon, Nov 05, 2018 at 08:36:56AM -0800, Tejun Heo wrote:
> Hello,
> 
> So, this looks good to me.  Peter, I'm gonna roll the series into
> cgroup/for-4.21-cpuset.  Please holler if you have any objections /
> comments.

Mostly nits, except I think the interface for cpuset.sched.partition
needs to find another term for "not a parition", "normal" really doesn't
work for me.
