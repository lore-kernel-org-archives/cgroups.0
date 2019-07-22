From: Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH v9 2/8] sched/core: Streamlining calls to task_rq_unlock()
Date: Mon, 22 Jul 2019 10:21:00 +0200
Message-ID: <50f00347-ffb3-285c-5a7d-3a9c5f813950@arm.com>
References: <20190719140000.31694-1-juri.lelli@redhat.com>
 <20190719140000.31694-3-juri.lelli@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190719140000.31694-3-juri.lelli@redhat.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Juri Lelli <juri.lelli@redhat.com>, peterz@infradead.org, mingo@redhat.com, rostedt@goodmis.org, tj@kernel.org
Cc: linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, longman@redhat.com, cgroups@vger.kernel.org

On 7/19/19 3:59 PM, Juri Lelli wrote:
> From: Mathieu Poirier <mathieu.poirier@linaro.org>

[...]

> @@ -4269,8 +4269,8 @@ static int __sched_setscheduler(struct task_struct *p,
>  			 */
>  			if (!cpumask_subset(span, &p->cpus_allowed) ||

This doesn't apply cleanly on v5.3-rc1 anymore due to commit
3bd3706251ee ("sched/core: Provide a pointer to the valid CPU mask").

>  			    rq->rd->dl_bw.bw == 0) {
> -				task_rq_unlock(rq, p, &rf);
> -				return -EPERM;
> +				retval = -EPERM;
> +				goto unlock;
>  			}
>  		}
>  #endif

[...]
