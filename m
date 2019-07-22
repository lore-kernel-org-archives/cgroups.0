From: Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH v9 4/8] sched/deadline: Fix bandwidth accounting at all
 levels after offline migration
Date: Mon, 22 Jul 2019 13:07:33 +0200
Message-ID: <5da6abab-00ff-9bb4-f24b-0bf5dfcd4c35@arm.com>
References: <20190719140000.31694-1-juri.lelli@redhat.com>
 <20190719140000.31694-5-juri.lelli@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190719140000.31694-5-juri.lelli@redhat.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Juri Lelli <juri.lelli@redhat.com>, peterz@infradead.org, mingo@redhat.com, rostedt@goodmis.org, tj@kernel.org
Cc: linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, longman@redhat.com, cgroups@vger.kernel.org

On 7/19/19 3:59 PM, Juri Lelli wrote:

[...]

> @@ -557,6 +558,38 @@ static struct rq *dl_task_offline_migration(struct rq *rq, struct task_struct *p
>  		double_lock_balance(rq, later_rq);
>  	}
>  
> +	if (p->dl.dl_non_contending || p->dl.dl_throttled) {
> +		/*
> +		 * Inactive timer is armed (or callback is running, but
> +		 * waiting for us to release rq locks). In any case, when it
> +		 * will file (or continue), it will see running_bw of this

s/file/fire ?

> +		 * task migrated to later_rq (and correctly handle it).

Is this because of dl_task_timer()->enqueue_task_dl()->task_contending()
setting dl_se->dl_non_contending = 0 ?

[...]
