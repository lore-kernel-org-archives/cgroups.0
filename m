From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v9 1/7] cgroup/cpuset: Don't let child cpusets restrict
 parent in default hierarchy
Date: Mon, 13 Dec 2021 10:41:23 -1000
Message-ID: <Ybev80+h4JArgMDz@slm.duckdns.org>
References: <20211205183220.818872-1-longman@redhat.com>
 <20211205183220.818872-2-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=14Dwn7cQaB5yg3QXXz3HOGmIXUCfHUTFsdjkk6DpI/c=;
        b=HkXX2ZRDeFERmYakQz3KxfITmvUHxXbei6EVsg1xNl4SMDx7tdEX0sCbfY1vGo2MLx
         DB0K2/jcwikKcwcqxysyKs5c5/lGgUAv6xj0WDjU8Vs0WaVla4CxoB44BAVRWoZSQV7+
         7ZTFRBRx9WkLFtjaGKX5TMFC9obf/haau0n9Pwc7ymvBF5H3g1w/Eyh2ggT55jOuxJ94
         4AP6ggzko6rlYfv/w9IUjj9vjzj3pxWTUgOMHcRH8ICyvsvSCgwgntn78RwLo92lZMso
         /a5cJXMA1OIh0QVxvgQPxvB3CJNFlhbcUWIP6N8zCZBlhtbgNxy3m2DUjIiBr4qU95rU
         VLZQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20211205183220.818872-2-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>

On Sun, Dec 05, 2021 at 01:32:14PM -0500, Waiman Long wrote:
> In validate_change(), there is a check since v2.6.12 to make sure that
> each of the child cpusets must be a subset of a parent cpuset.  IOW, it
> allows child cpusets to restrict what changes can be made to a parent's
> "cpuset.cpus". This actually violates one of the core principles of the
> default hierarchy where a cgroup higher up in the hierarchy should be
> able to change configuration however it sees fit as deligation breaks
> down otherwise.
> 
> To address this issue, the check is now removed for the default hierarchy
> to free parent cpusets from being restricted by child cpusets. The
> check will still apply for legacy hierarchy.
> 
> Suggested-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Waiman Long <longman@redhat.com>

Applied to cgroup/for-5.17.

Thanks.

-- 
tejun
