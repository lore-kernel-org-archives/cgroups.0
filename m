From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v14 04/12] cpuset: Add new v2 cpuset.sched.partition flag
Date: Tue, 6 Nov 2018 12:35:38 +0100
Message-ID: <20181106113538.GK22431@hirez.programming.kicks-ass.net>
References: <1539635377-22335-1-git-send-email-longman@redhat.com>
 <1539635377-22335-5-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=QM4hvYp9M8WCw+TKG7IEIs4GRbuBxcFezGbs72Qu0ME=; b=u0IAF1St1Wpe7TnAmPmm8OeEr
        F+Zqs6iTZufRWi83teDoGp96/aImqTTaRTSqECKAd5Tjn9V9lKrFl4ftSFcTTD20ouR0wMBT5ClNj
        eXMhQd4JXUdndPqUCgg2I6QJTNQ0oxtv6UrZWo3C94/H7HzREFyJcJ2yhVWgflV6u5GRIInODRgK6
        0lgFiDxwBUJN6HrwZJQNyR72J7m+tX2Q9silfTl8Ga3yzHOEGcKX3Hro5atHtMum+WQmeaXnD2tzJ
        3+dXG2s19xJQ6HPZQlpAD/2bCqweNhxbpyq93SOriHpLXyYO552/uI7n1V090ddjjBGZ7Ck4L4q0l
      
Content-Disposition: inline
In-Reply-To: <1539635377-22335-5-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Tom Hromatka <tom.hromatka@oracle.com>

On Mon, Oct 15, 2018 at 04:29:29PM -0400, Waiman Long wrote:
> + * Called with cpuset_mutex held.
> + */
> +static int update_parent_subparts_cpumask(struct cpuset *cpuset, int cmd,
> +					  struct cpumask *newmask,
> +					  struct tmpmasks *tmp)
> +{
> +	struct cpuset *parent = parent_cs(cpuset);
> +	int adding;	/* Moving cpus from effective_cpus to subparts_cpus */
> +	int deleting;	/* Moving cpus from subparts_cpus to effective_cpus */
> +

I much prefer doing away with that "called with * held" comment crud and
add:

	lockdep_assert_held(&cpuset_mutex);


