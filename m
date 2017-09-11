From: David Rientjes <rientjes@google.com>
Subject: Re: [v8 1/4] mm, oom: refactor the oom_kill_process() function
Date: Mon, 11 Sep 2017 13:51:17 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1709111349321.102819@chino.kir.corp.google.com>
References: <20170911131742.16482-1-guro@fb.com> <20170911131742.16482-2-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=L/BTyf2lzPtw6uFd8HIkYzaUZLzNPbk8fWxVpx9QkYA=;
        b=K3CLhTQl767l9Ae30bWECgPOCSY7RpCMiX+3zbz+JDHrJbYMkK8IwNMdjGsTD+XLoD
         WIrLZ9qugyJuXtEzT5/1IZxj5lWAfuK22XyGUY1Tr4hv7FsKdV/dgc+Crel82NbLFFwl
         +Qy6ftnpNoAJb4mLN3d72KdBnmumcHm7RUxCtQSTD2YSsWUirGVD1qM8iwgKrkuQCrFn
         c5fiBaqZBqkvIgpkFHsY0PLAxBp+wIvqdMgwc8bd/T39JFkZoOIujzvbrDNQhQdwDAk7
         GWgzTRF8BkZomtG0rsGS9A5wMjkqEb+VzbUhA/nFbvQ/yAaoJN4i1gCWNqRJdGAsEtu4
         STAQ==
In-Reply-To: <20170911131742.16482-2-guro@fb.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 11 Sep 2017, Roman Gushchin wrote:

> The oom_kill_process() function consists of two logical parts:
> the first one is responsible for considering task's children as
> a potential victim and printing the debug information.
> The second half is responsible for sending SIGKILL to all
> tasks sharing the mm struct with the given victim.
> 
> This commit splits the oom_kill_process() function with
> an intention to re-use the the second half: __oom_kill_process().
> 
> The cgroup-aware OOM killer will kill multiple tasks
> belonging to the victim cgroup. We don't need to print
> the debug information for the each task, as well as play
> with task selection (considering task's children),
> so we can't use the existing oom_kill_process().
> 
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: kernel-team@fb.com
> Cc: cgroups@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org

Acked-by: David Rientjes <rientjes@google.com>

https://marc.info/?l=linux-kernel&m=150274805412752
