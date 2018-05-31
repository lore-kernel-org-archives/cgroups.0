From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v9 3/7] cpuset: Add cpuset.sched.load_balance flag to v2
Date: Thu, 31 May 2018 12:44:13 +0200
Message-ID: <20180531104413.GH12180@hirez.programming.kicks-ass.net>
References: <1527601294-3444-1-git-send-email-longman@redhat.com>
 <1527601294-3444-4-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=WREf3ESta4uEybD9RMP7dluESP93K0Uhm/lUkF60ykE=; b=JEgbALcl9+R0g4uTQF6XTbnOZ
        YkPKCVZK7At7NTmyDYjZPNrOAB1T5EHhsMT2+SezDkW1r/txC+yUkO0eOwSeFn/qZW5RadpVuXvz/
        dCyO5EuknrKafTVZ7UVzo1C1GpiZV1k4aP3gjYX884zbVQGzF+xe6Pwt85f4Z8bwBfU8zsjSLxaZV
        G8aNm3h/mq9sIC4zhRRDMj4l9CHus2ZXpAlv1XzX3usvXjCb7mLDgwAL4eEpFbPJX/rOVjAW+6hcw
        iltINkgCilJ8BipIvzLCDbDUmPeSIZ/x6Vtv4fE/BHmb3YruDJodPT4QhwJhy+sRdvm2rfB+vQRqC
    
Content-Disposition: inline
In-Reply-To: <1527601294-3444-4-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On Tue, May 29, 2018 at 09:41:30AM -0400, Waiman Long wrote:
> diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
> index e7534c5..681a809 100644
> --- a/Documentation/cgroup-v2.txt
> +++ b/Documentation/cgroup-v2.txt
> @@ -1542,6 +1542,32 @@ Cpuset Interface Files
>  	Further changes made to "cpuset.cpus" is allowed as long as
>  	the first condition above is still true.
>  
> +	A parent scheduling domain root cgroup cannot distribute all
> +	its CPUs to its child scheduling domain root cgroups

This I think wants to be in the previous patch

>                                                            unless
> +	its load balancing flag is turned off.

And this is indeed for here.
