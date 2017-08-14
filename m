From: David Rientjes <rientjes@google.com>
Subject: Re: [v5 3/4] mm, oom: introduce oom_priority for memory cgroups
Date: Mon, 14 Aug 2017 15:44:04 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1708141543500.63207@chino.kir.corp.google.com>
References: <20170814183213.12319-1-guro@fb.com> <20170814183213.12319-4-guro@fb.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=JVwR6GTWzvypWlYJLMo+2J3cuZQcNv3VPmeBw+hYf30=;
        b=Zm5OVCcPPVpk356vt8JZRJ5wXefoEH2TWe3DxUcv7HVNqErh91P8r6ITM5mCb1kQ7X
         MFOcDxTiOl5HbYhpUYJw1RbvDAn/YDUlxLvtGhi04szzTOHFHMyxeElWfNfsYv54GKjo
         nsi+YmA4HfkiTmnkAE+Dle8iINgrrSQQg2KiFtSbycLnCxVEsR1qMvRinFCKjnstdkSJ
         I7x/2SLHAPpGYPPI2LIUoDz96dJ4/ddewQIcYU1OhDmw8EjP8IWjeHHUFyqGuKiZV38g
         1fqpiEcuM0H/PRUS5yS4xl8J5QKkbbL1Q/DiF+Gh3qiug6Xcoiblz0xDNolNDW5pzBgO
         aPrg==
In-Reply-To: <20170814183213.12319-4-guro@fb.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 14 Aug 2017, Roman Gushchin wrote:

> Introduce a per-memory-cgroup oom_priority setting: an integer number
> within the [-10000, 10000] range, which defines the order in which
> the OOM killer selects victim memory cgroups.
> 
> OOM killer prefers memory cgroups with larger priority if they are
> populated with elegible tasks.
> 
> The oom_priority value is compared within sibling cgroups.
> 
> The root cgroup has the oom_priority 0, which cannot be changed.
> 
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: kernel-team@fb.com
> Cc: cgroups@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org

Tested-by: David Rientjes <rientjes@google.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
