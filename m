From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH] mm: vmscan: memcg: Add global shrink priority
Date: Thu, 19 Dec 2019 11:26:18 +0000
Message-ID: <20191219112618.GA72828@chrisdown.name>
References: <1576662179-16861-1-git-send-email-teawaterz@linux.alibaba.com>
 <20191218140952.GA255739@chrisdown.name>
 <25AA9500-B249-42C2-B162-2B8D4EE83BB0@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ZxINuY2pTedRL5AOR8tT78C1M2jclzElPJ7W9Ytee4A=;
        b=Nj6BUQEZ+CRfeqS8i/TOUwhdSD/LqqktFae+t7JfgDcNBTv07sDWW+AN6qK4jJxq2b
         bD96kwCBm+NCxbmhwMq95YWUG6nwJtQUz+B0gWcpUboDbYAvGxtqalmKIIDrPQsdQakD
         0vumq1+lukQ7gHQ8kRlgoND+EH8XGHRzhB5Qw=
Content-Disposition: inline
In-Reply-To: <25AA9500-B249-42C2-B162-2B8D4EE83BB0@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: teawater <teawaterz@linux.alibaba.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, guro@fb.com, shakeelb@google.com, Yang Shi <yang.shi@linux.alibaba.com>, tj@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

Hi Hui,

teawater writes:
>Memory.min, low, high can affect the global shrink behavior.  They can help 
>task keep some pages to help protect performance.
>
>But what I want is the low priority tasks (the tasks that performance is not 
>very important) do more shrink first.  And when low priority tasks doesn’t 
>have enough pages to be dropped and system need more free page, shrink the 
>high priority task’s pages.  Because at this time, system’s stable is more 
>important than the performance of priority task.
>With memory.min and memory.low, I have no idea to config them to support this.  
>That is why I add global shrink priority.

For sure, that's what I'm suggesting you use memory.{min,low} for -- you define 
some subset of the cgroup hierarchy as "protected", and then you bias reclaim 
away from protected cgroups (and thus *towards* unprotected cgroups) by biasing 
the size of LRU scanning. See my patch that went into 5.4 and the examples in 
the commit message:

     commit 9783aa9917f8ae24759e67bf882f1aba32fe4ea1
     Author: Chris Down <chris@chrisdown.name>
     Date:   Sun Oct 6 17:58:32 2019 -0700

         mm, memcg: proportional memory.{low,min} reclaim

You can see how we're using memory.{low,min} to achieve this in this case 
study[0]. It's not exactly equivalent technically to your solution, but the end 
goals are similar.

Thanks,

Chris

0: https://facebookmicrosites.github.io/cgroup2/docs/overview.html#case-study-the-fbtax2-project
