From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 2/6] cgroup/cpuset: Properly handle partition root tree
Date: Wed, 11 Aug 2021 08:08:41 -1000
Message-ID: <YRQSKZB8rQUsfF2K@slm.duckdns.org>
References: <20210811030607.13824-1-longman@redhat.com>
 <20210811030607.13824-3-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XPgK+iyXy46IJH8Hj0istqzWfGCuBh53Hqdy3vFF5K4=;
        b=r7PopeTgrDc7n/bWwJ5e0f+BfBFRl6LtdflJvnIbuLrPKhqkoKkpxRUqoXMKOpzs0V
         Q4Gnet2Qeyd83m0rW2rhAHI1r3i6lVIitzHZcv//k30rtHw4yEevrtcr44drgCpAVOFa
         kEqekTBwmfWRuPmSupYTKQRxrPvxcABuszOiWjjJrZXnzWBI0HvEpD26C0FVOXhTr24+
         QJ2tHd2EfoMIJnZikWNESVpzCCC5dA+gbx+ix8M3McgtB/jYW3w4G5mHME7Ncr5oy09T
         zUmokknlszJGYu245+vvI3g6gp3mip3SjOKvWykSOL/xetEvmbOKOEfb1Rxi43R70IVB
         kubQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20210811030607.13824-3-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>

Hello,

On Tue, Aug 10, 2021 at 11:06:03PM -0400, Waiman Long wrote:
> For a partition root tree with parent and child partition roots, this
> patch will now prohibit changing parent partition root back to member
> as changes to "cpuset.cpus.partition" should not cause those child
> partition roots to become invalid.

So, the general rule is that a descendant should never be able to affect or
restrict what an ancestor can do in terms of configuration. This is because
descendant cgroups can be delegated and a system manager sitting at a higher
level in the hierarchy may not have much control over what happens under
delegated subtrees.

Given that we're promoting the error state as the first class citizen in the
interface anyway, wouldn't it be better to keep this in line too?

Thanks.

-- 
tejun
