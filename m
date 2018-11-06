From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v14 12/12] cpuset: Show descriptive text when reading
 cpuset.sched.partition
Date: Tue, 6 Nov 2018 12:52:20 +0100
Message-ID: <20181106115220.GP22431@hirez.programming.kicks-ass.net>
References: <1539635377-22335-1-git-send-email-longman@redhat.com>
 <1539635377-22335-13-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=GFyEAi/5ntHNaVjY7w8ti5shFbhzc/6OhXu7odl5N4E=; b=BKzqVnDq6A5rInnH4ONRw4+BK
        G/QyJjPFMMjpvvFBZa/DTjQWJm8NEetKTs8CmEmB2vlX7ARuVEj6ceMXi/eLE04uZmBnEB4SXyISN
        AGVVHYDBKqq42MTLzLmMfwIP3q+IOvfncWom4J6bNSWdNxN23N/nmdmJ03WVFpRoHIJsI+mtU4W/z
        5wOYaDNR2J+zyo4PD2A1fwLMZD170trr19XYHKLP6GTAj/hbXqnnN6hH9562esJzlOd3WgYXgT+xN
        ezjAVsp0SmKW+7wHdjVH/LARVjC6AWS+gF9yWjMTa7zPRh5hOlSyxIAka8FpqLISXSU8SwVLw4LBX
    
Content-Disposition: inline
In-Reply-To: <1539635377-22335-13-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Tom Hromatka <tom.hromatka@oracle.com>

On Mon, Oct 15, 2018 at 04:29:37PM -0400, Waiman Long wrote:
> Currently, cpuset.sched.partition returns the values, 0, 1 or -1 on
> read. A person who is not familiar with the partition code may not
> understand what they mean.
> 
> In order to make cpuset.sched.partition more user-friendly, it will
> now display the following descriptive text on read:
> 
>   "normal" - A normal cpuset, not a partition root
>   "partition" - A partition root
>   "partition invalid" - An invalid partition root

As a person who is familiar with it: "normal" doesn't make sense.

It either is or is not a parition. normal doesn't some into it.
