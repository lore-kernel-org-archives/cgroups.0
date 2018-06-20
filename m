From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v10 2/9] cpuset: Add new v2 cpuset.sched.domain_root flag
Date: Wed, 20 Jun 2018 16:27:35 +0200
Message-ID: <20180620142735.GM2494@hirez.programming.kicks-ass.net>
References: <1529295249-5207-1-git-send-email-longman@redhat.com>
 <1529295249-5207-3-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=eMGX/vsz54Q4caqt50tNX8W2/XJte3L4ED1D2DYi3DM=; b=NTy23Fnsf7WLUGXDCU7Zw7jvu
        1M4RHZa6VjWMn91F72ExcFloyGANed3g6cq6XvBzm8yPXCl4S4CBQykPADUjAeyX2odDPvAm0QQz6
        yfxE7hqrJIbMtIDuYQO4oLeMDbDLHv/vUfqq93ZG9Y8df2nE8U2Ldw4mIGoJc+QAbYPVrMdKgmRiu
        51JP9eVTIm7Ivyx2WSRrpLyubjbWfUhd1cvrBMQXeSXBz+U1yasuhs80zQY94T1MBG5MgkAtKVHq4
        R0WtHHtz+UBNsed6zSZFwR2aYtFXi6CnktqZKGvIlj1FPjQNCs2k2jWcRWjE6tt7KUyS37zVp/8ue
      
Content-Disposition: inline
In-Reply-To: <1529295249-5207-3-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On Mon, Jun 18, 2018 at 12:14:01PM +0800, Waiman Long wrote:
> +  cpuset.sched.domain_root

Why are we calling this a domain_root and not a partition?

> +	A read-write single value file which exists on non-root
> +	cpuset-enabled cgroups.  It is a binary value flag that accepts
> +	either "0" (off) or "1" (on).  This flag is set by the parent
> +	and is not delegatable.

You still haven't answered:

  https://lkml.kernel.org/r/20180531094943.GG12180@hirez.programming.kicks-ass.net

the question stands.

> +	If set, it indicates that the current cgroup is the root of a
> +	new scheduling domain or partition that comprises itself and
> +	all its descendants except those that are scheduling domain
> +	roots themselves and their descendants.  The root cgroup is
> +	always a scheduling domain root.
> +
> +	There are constraints on where this flag can be set.  It can
> +	only be set in a cgroup if all the following conditions are true.
> +
> +	1) The "cpuset.cpus" is not empty and the list of CPUs are
> +	   exclusive, i.e. they are not shared by any of its siblings.
> +	2) The "cpuset.cpus" is also a proper subset of the parent's
> +	   "cpuset.cpus.effective".
> +	3) The parent cgroup is a scheduling domain root.
> +	4) There is no child cgroups with cpuset enabled.  This is
> +	   for eliminating corner cases that have to be handled if such
> +	   a condition is allowed.
> +
> +	Setting this flag will take the CPUs away from the effective
> +	CPUs of the parent cgroup.  Once it is set, this flag cannot be
> +	cleared if there are any child cgroups with cpuset enabled.
> +
> +	A parent scheduling domain root cgroup cannot distribute
> +	all its CPUs to its child scheduling domain root cgroups.
> +	There must be at least one cpu left in the parent scheduling
> +	domain root cgroup.
