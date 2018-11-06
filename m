From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v14 05/12] cpuset: Add an error state to
 cpuset.sched.partition
Date: Tue, 6 Nov 2018 12:37:12 +0100
Message-ID: <20181106113712.GL22431@hirez.programming.kicks-ass.net>
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
         bh=nhV7MP9fmom1olzqQQOBdE69jYgH85uDi+QqRtqAtg8=; b=WPmdbnofwrpymTzT3W5uqbalC
        yXkbFo768UY/COShyd5oe5c/+DoDMcPiDFDEILxY+/wsrTsSwSUZ4F05ry8gNXXwaE5gHDPLs8QTC
        8FOM6qPfvhqcAWFF4hlWMrzKVwo9XHGgxrVAVxG+ZumK+LJlNl3izMYnOdazqgP+8wfFSSQVOK+id
        6eylgHIMpBHZgN8MdD3Avg4w7iz6BYU7Mi5gH8AH+esD0/JhIveGhdjryxAsGVHr9CcS/xdcFXBt2
        +cRP7RsEAQh4WglbaXK9j++C8OZn1Lhy1XQldL9yfTI+TYrJ4ztw0+qI2LCjq1LVDeK76dBmdObhS
      
Content-Disposition: inline
In-Reply-To: <1539635377-22335-6-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Tom Hromatka <tom.hromatka@oracle.com>

On Mon, Oct 15, 2018 at 04:29:30PM -0400, Waiman Long wrote:
> Handling error returned by update_parent_subparts_cpumask() in
> update_cpumasks_hier() is problematic as the states may become
> inconsistent. To avoid that and increase flexibility in handling other
> error cases, a new error state (-1) is added to the partition_root_state
> flag. This new error state is set internally and user cannot write this
> value to "cpuset.sched.partition".
> 
> In this error state, the partition root becomes an erroneous one. It is
> no longer a real partition root, but the CS_CPU_EXCLUSIVE flag will
> still be set as it can be changed back to a real one if appropriate
> change happens later on.

I feel this Changelog should be much more explicit about the reasons
this -1 state can happen. As is, I've got no clue.
