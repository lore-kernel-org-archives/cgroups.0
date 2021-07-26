From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 3/9] cgroup/cpuset: Fix violation of cpuset locking
 rule
Date: Mon, 26 Jul 2021 13:10:16 -1000
Message-ID: <YP9A2Im5r30s58g1@slm.duckdns.org>
References: <20210720141834.10624-1-longman@redhat.com>
 <20210720141834.10624-4-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lGwxyaND0AFp6xjSOU+CS8ALMUm6RpLJV/rJQAwgaMY=;
        b=FI4linOnbFeTgynUKUdl3/vUVKX3cRbtNpKAnixhYKJ47quOI03wHetguN2dJW9MN9
         2RNaBEc+FSEEv7qPVV3tL+r9OpkNZydEbR3oxv/QFVRDpbvAbZQPnIo5fKdZXbgpAdUJ
         jCsYwZKodRp6pEDf74/79+8VeQsw/Wguz1O0u/oIVopDTLYKhhBZkS8bR4BKklZ/lfkN
         2xz3FyahK53ItsEWRnDlEiasq96F4I2mdQE0JPDW3BDoW6+CnxDuj3qOyZ63prmF7pPG
         1peP2KLMKD6Zk1GhKeKwe5eOg+WmVBSNuUZqfLL0sQ11OX33McU/Tajd8kut5ZQqId/o
         2qlA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20210720141834.10624-4-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>

On Tue, Jul 20, 2021 at 10:18:28AM -0400, Waiman Long wrote:
> The cpuset fields that manage partition root state do not strictly
> follow the cpuset locking rule that update to cpuset has to be done
> with both the callback_lock and cpuset_mutex held. This is now fixed
> by making sure that the locking rule is upheld.
> 
> Fixes: 3881b86128d0 ("cpuset: Add an error state to cpuset.sched.partition")
> Fixes: 4b842da276a8 ("cpuset: Make CPU hotplug work with partition)
> Signed-off-by: Waiman Long <longman@redhat.com>

Applied to cgroup/for-5.15.

Thanks.

-- 
tejun
