From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v14 05/12] cpuset: Add an error state to
 cpuset.sched.partition
Date: Tue, 6 Nov 2018 12:40:55 +0100
Message-ID: <20181106114055.GN22431@hirez.programming.kicks-ass.net>
References: <1539635377-22335-1-git-send-email-longman@redhat.com>
 <1539635377-22335-6-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=kFxUuHjpTxdn+Qfxz/i90rdrGYlXVZnA2uZTtMbZrV0=; b=CUAnfLXEDB7M65oP2yZiqICKv
        wt4SCNc9cR+YnL0IjaNZQrIl3uly8CxFCsTcRu5KP53AHW9BRvTmNFere2EPALbHKaCqTSdRppM69
        CZlALiKbuBW8//ugBMz5y73i9hQS1+MI28mJ25DlbW71KTPhlYGJKvHnDkW5L4HKWqgam5wW0F/m2
        QI/t0vJhtFHOcJ9s+qSQuXpgRMPiq09jul+FkUZPU/OipKZ8+bpP3txl4jlSZunf+5do631haSjXY
        yMUu4SBqpD1YsrSf2xwxOlsQTFtE+rS/35L8eM9ZTt6STMQbPxdPflXLno4IXhBY1qF+TF31OoPIN
    
Content-Disposition: inline
In-Reply-To: <1539635377-22335-6-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Tom Hromatka <tom.hromatka@oracle.com>

On Mon, Oct 15, 2018 at 04:29:30PM -0400, Waiman Long wrote:
> +			case PRS_ENABLED:
> +				if (update_parent_subparts_cpumask(cp,
> +					partcmd_update, NULL, tmp))
> +					update_tasks_cpumask(parent);
> +				break;

That code indenting had me go WTF a few times.
