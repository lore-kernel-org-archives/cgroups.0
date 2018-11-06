From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v14 05/12] cpuset: Add an error state to
 cpuset.sched.partition
Date: Tue, 6 Nov 2018 12:40:17 +0100
Message-ID: <20181106114017.GM22431@hirez.programming.kicks-ass.net>
References: <1539635377-22335-1-git-send-email-longman@redhat.com>
 <1539635377-22335-6-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=lUHnAL3eQVjg1ZJe45Cj0URU8flrEIoTLoSPPCDJXkA=; b=ep2pu88/lcaE3iajrbeAfOWT0
        u1VpTQAAowkTFwyKFr4FsWBjfRKRDR7k66MtgUfqUqvDcSNgcLmVnAMdAce7N0VErbwOLcIL31mDt
        7MrnWhBWB0cNNQetTvIuaEvyI0e26+9R6OnxQvgZ094bu1I+0wwzavl9PyH+RXjhpS9TG0qceGru3
        bQPMN3XYBpElNsTP9tUVW0vSm2P0GMGI7rdznuy+pZP8xTqwb2fio20h27om9HZNu+P8fP7xx6Uqw
        xNJu5v/ymHJJ2G8YHeMmfoY+37wBCVRg0fLBhMx6V6RBQXHRZsOVtF+46tCFY9sDXM5GtsGla3Raf
      
Content-Disposition: inline
In-Reply-To: <1539635377-22335-6-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Tom Hromatka <tom.hromatka@oracle.com>

On Mon, Oct 15, 2018 at 04:29:30PM -0400, Waiman Long wrote:
> +				spin_lock_irq(&callback_lock);
> +				clear_bit(CS_CPU_EXCLUSIVE, &cp->flags);
> +				spin_unlock_irq(&callback_lock);

A single atomic bitop wrapped in a spinlock..  maybe it is correct, but
it looks suspicous.
