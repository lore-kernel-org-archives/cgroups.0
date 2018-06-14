From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v4 3/5] sched/core: Streamlining calls to
 task_rq_unlock()
Date: Thu, 14 Jun 2018 09:42:42 -0400
Message-ID: <20180614094242.36127604@gandalf.local.home>
References: <20180613121711.5018-1-juri.lelli@redhat.com>
        <20180613121711.5018-4-juri.lelli@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180613121711.5018-4-juri.lelli@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Juri Lelli <juri.lelli@redhat.com>
Cc: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org

On Wed, 13 Jun 2018 14:17:09 +0200
Juri Lelli <juri.lelli@redhat.com> wrote:

> From: Mathieu Poirier <mathieu.poirier@linaro.org>
> 
> Calls to task_rq_unlock() are done several times in function
> __sched_setscheduler().  This is fine when only the rq lock needs to be
> handled but not so much when other locks come into play.
> 
> This patch streamlines the release of the rq lock so that only one
> location need to be modified when dealing with more than one lock.
> 
> No change of functionality is introduced by this patch.
> 
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>

Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve
