From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v10 2/9] cpuset: Add new v2 cpuset.sched.domain_root flag
Date: Thu, 21 Jun 2018 11:27:28 +0200
Message-ID: <20180621092728.GV2494@hirez.programming.kicks-ass.net>
References: <1529295249-5207-1-git-send-email-longman@redhat.com>
 <1529295249-5207-3-git-send-email-longman@redhat.com>
 <20180620142735.GM2494@hirez.programming.kicks-ass.net>
 <b44b0748-9fec-6bb0-7665-435487e5d8b3@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=JSOZVtQOypHIPrxa8fKJl9JPZDlOm7if4F1KKmt8WwI=; b=HuhiMKTwtH2WKvve7v73eWhCu
        c3hRhtjagvoQlXzwr7WIIY6/ZwFoj9ulGutKtuQ/uLQ+cjuWlxtvEmETS8eakjotcpcnio/S/pp4e
        G2NRjB6jh2DhkhqAutO6RMndfH8sDjBbdGM3AekW7HS7S08WcwIkrWHE8C3mdDtokYvdX+8f2tVbg
        Cy8o9M9gUk9GdxMKRWhbgiuSkZ8yrpB4ubxsk9ay0OR0LwCpbKoUpAIHtE9j7+qNIaDLATUSdva8U
        5/QyufwXlgftgwDkWWoFKrTzAatdkSCabLAPQAq/akL1IFgblbOiLF0Da1XwKYfazdMwjjaiMyer5
    
Content-Disposition: inline
In-Reply-To: <b44b0748-9fec-6bb0-7665-435487e5d8b3@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On Thu, Jun 21, 2018 at 03:58:06PM +0800, Waiman Long wrote:
> On 06/20/2018 10:27 PM, Peter Zijlstra wrote:
> > On Mon, Jun 18, 2018 at 12:14:01PM +0800, Waiman Long wrote:
> >> +  cpuset.sched.domain_root
> > Why are we calling this a domain_root and not a partition?
> 
> A partition can consist of several cgroups in a tree structure. That
> flag should only be set at the root of a partition. I will change the
> name to partition_root if you think this name is acceptable.

The flag indicates the 'effective_cpus' things of the current group is a
partition. The fact that it can have sub-partitions doesn't really
matter does it.

Just call it 'partition', leave out the whole root stuff, all of cgroup
is hierarchical and you can have sub-groups we don't go around calling
everything a root.
