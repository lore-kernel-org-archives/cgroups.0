From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 2/6] cgroup/cpuset: Clarify the use of invalid
 partition root
Date: Sat, 26 Jun 2021 06:53:45 -0400
Message-ID: <YNcHOe3o//pIiByh@mtj.duckdns.org>
References: <20210621184924.27493-1-longman@redhat.com>
 <20210621184924.27493-3-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5IakmMrURhycOrgMfR07LYIjzM4DIOC86+dJLV+QXtE=;
        b=tJM12ZzFZGep9dgrfo5utS8xjiFj8xNgXdKhGD3A9SmaJVv55z2dbAFR71Tbmn6Sea
         IygyNuEsD+k0js/M1w4rmHPEwGAIilhGD+DNFHa8L+iIXBZipBJ9EHHHqNYTIXeg4Fex
         1EG9vUpbZN5Quo1q3/NZTu9X6LlyML8XgkDM1Ubf3CVPwWLHNe1HfkCnMVt449oWv9zB
         ei8oGQnjwQ3R4FpWQKR9KiXEY+NSGqxidKhNSsGscePbTanOWZrgBfdBgs9Ls2RuMv7Z
         qg7pkDppgBYjycxMvMR5DhVz7Fk/CB+AT5rvnP0oGp3kI/M7eHMhvJS8OX7yYZPQDhsr
         CAZg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20210621184924.27493-3-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>

Hello, Waiman.

On Mon, Jun 21, 2021 at 02:49:20PM -0400, Waiman Long wrote:
>  1) A partition root can't be changed to member if it has child partition
>     roots.
>  2) Removing CPUs from cpuset.cpus that causes it to become invalid is
>     not allowed.

I'm not a fan of this approach. No matter what we have to be able to handle
CPU removals which are user-iniated operations anyway, so I don't see why
we're adding a different way of handling a different set of operations. Just
handle them the same?

Thanks.

-- 
tejun
