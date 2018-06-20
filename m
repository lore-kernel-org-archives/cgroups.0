From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v10 5/9] cpuset: Make sure that domain roots work
 properly with CPU hotplug
Date: Wed, 20 Jun 2018 16:15:38 +0200
Message-ID: <20180620141538.GJ2494@hirez.programming.kicks-ass.net>
References: <1529295249-5207-1-git-send-email-longman@redhat.com>
 <1529295249-5207-6-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=FxjwbLB5V2s0tONoFTCK0nUFgqrtYJ0tDIalXSPoimU=; b=U1VcqErjcRcruXYokbrgi68/b
        1ufxFjeNhBcrK6Cq8f3gBFpcSzQHkhDmYPod1hYZRqj4oQx3qsgyxqkoQaE6h+9ghrKcAtcLXHMXw
        KpCfp6y0SpMWWPAoLT+FoX7uo04UojbhBBvydaTdW8s62U/gdyV3nYqApG4eGEaOQPZ6ja1XLPzrH
        bUZqq1uAA8LlkY2vwMkF9ZGixgqLrMXjIBuR6Nb3BsmFpBa3LkQYq+EYy3qJ/2o3iqkc8NkUDskAr
        iGf9krJdwYcRccC/1qxkTofZByl4wv4Q6LxFKydyfOkfpxENdz2bkmAeobYaTgoSfy3jTq+WnwaLM
      
Content-Disposition: inline
In-Reply-To: <1529295249-5207-6-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On Mon, Jun 18, 2018 at 12:14:04PM +0800, Waiman Long wrote:
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 5ee5e77..6ef3516 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1626,6 +1626,13 @@ Cpuset Interface Files
>  	2) No CPU that has been distributed to child scheduling domain
>  	   roots is deleted.
>  
> +	When all the CPUs allocated to a scheduling domain are offlined,
> +	that scheduling domain will be temporaily gone and all the
> +	tasks in that scheduling domain will migrate to another one that
> +	belongs to the parent of the scheduling domain root.  When any
> +	of those offlined CPUs is onlined again, a new scheduling domain
> +	will be re-created and the tasks will be migrated back.
> +

You should mention that this is a destructive operation. If any of the
tasks had an affinity smaller than the original cgroup, that will be
gone.
