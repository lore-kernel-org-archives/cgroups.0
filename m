From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 1/2] arch: invoke oom-killer from page fault
Date: Wed, 5 Jun 2013 21:43:04 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1306052142490.27104@chino.kir.corp.google.com>
References: <1370488193-4747-1-git-send-email-hannes@cmpxchg.org> <alpine.DEB.2.02.1306052053360.25115@chino.kir.corp.google.com> <20130606043620.GA9406@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-arch-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=eMyZNfij2h1LSSW3rByFmeYxOV+5S8/Zi1B9xb8ik28=;
        b=J7shm5Pv4+zGrX2Ru3UIe0V+Pk/nj4tnY22cx7cAAVDRoV/6/4R5j2zKcfLzPwfNYQ
         R9ccCgJVhvN0E44l9JtUqG2d+5j7qhM4zJTebne+HolmxvFK5UaWMpXcF55dhQfjzr8A
         GChxSovnv/jhucyGuOC4GCsaTt3dgSzKlXejyLBNhWx4uSuXs2znlZf5i/npwI4NVK4X
         G7ULB5AmCiv3ZdBngNzWwLLU6FNmuCfhK1PwGKtqoswLLsS+e0hZWbUg2KO90mp2Q9Fb
         h6hn7qMc7uXKs9guYno89Va0EZIkAkepQJvLpAZJIPWPME6l9fqihetw/K3Lvvdp9id1
         pOdw==
In-Reply-To: <20130606043620.GA9406@cmpxchg.org>
Sender: linux-arch-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 6 Jun 2013, Johannes Weiner wrote:

> From: Johannes Weiner <hannes@cmpxchg.org>
> Subject: [patch] mm: invoke oom-killer from remaining unconverted page fault
>  handlers
> 
> A few remaining architectures directly kill the page faulting task in
> an out of memory situation.  This is usually not a good idea since
> that task might not even use a significant amount of memory and so may
> not be the optimal victim to resolve the situation.
> 
> Since '1c0fe6e mm: invoke oom-killer from page fault' (2.6.29) there
> is a hook that architecture page fault handlers are supposed to call
> to invoke the OOM killer and let it pick the right task to kill.
> Convert the remaining architectures over to this hook.
> 
> To have the previous behavior of simply taking out the faulting task
> the vm.oom_kill_allocating_task sysctl can be set to 1.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: David Rientjes <rientjes@google.com>
