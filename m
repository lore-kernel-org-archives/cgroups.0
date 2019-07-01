From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v8 8/8] rcu/tree: Setschedule gp ktread to SCHED_FIFO
 outside of atomic region
Date: Mon, 1 Jul 2019 21:13:08 +0200
Message-ID: <20190701191308.GE3402@hirez.programming.kicks-ass.net>
References: <20190628080618.522-1-juri.lelli@redhat.com>
 <20190628080618.522-9-juri.lelli@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ipn4fix027HY4nDGg4ZOEnVhpfAVctRuNAZ2QjAiS5g=; b=UpqdSARnV7FfcONeqXzNCy0EI
        DfBNv33im8tXzEphgieqWUaMIsGAxnYOm3bob+51nLyp246R8hWDi1sDgf6lr5YWFlKF3SghT0ZzS
        Vx4XeXfvRzye3mgCOEVb9nT4RD6e/jCwHRnOyln5a6SzTPCmLM2l2F0bxPIn5yc+9lfGZSq5oF3m6
        HfNRaDqnEp49sOihn9f3VpVRCQT98ipZe+y2YVbYE/Xg+2cYU5SOA6kIlSv057KtYGVYAHMFQpaB0
        jeaBCwJAWMs746NOdgU9Vwmime6gqDOmoME02wIW7L+fr0VnFxga0ZhmC4ulwqy5AESxXmnGWftB6
Content-Disposition: inline
In-Reply-To: <20190628080618.522-9-juri.lelli@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Juri Lelli <juri.lelli@redhat.com>
Cc: mingo@redhat.com, rostedt@goodmis.org, tj@kernel.org, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org

On Fri, Jun 28, 2019 at 10:06:18AM +0200, Juri Lelli wrote:
> sched_setscheduler() needs to acquire cpuset_rwsem, but it is currently
> called from an invalid (atomic) context by rcu_spawn_gp_kthread().
> 
> Fix that by simply moving sched_setscheduler_nocheck() call outside of
> the atomic region, as it doesn't actually require to be guarded by
> rcu_node lock.

Maybe move this earlier in the series such that the bug doesn't manifest
in bisection?
