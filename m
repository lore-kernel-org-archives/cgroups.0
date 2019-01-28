From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v3] oom, oom_reaper: do not enqueue same task twice
Date: Mon, 28 Jan 2019 19:42:31 +0100
Message-ID: <20190128184231.GS18811@dhcp22.suse.cz>
References: <72aa8863-a534-b8df-6b9e-f69cf4dd5c4d@i-love.sakura.ne.jp>
 <33a07810-6dbc-36be-5bb6-a279773ccf69@i-love.sakura.ne.jp>
 <34e97b46-0792-cc66-e0f2-d72576cdec59@i-love.sakura.ne.jp>
 <2b0c7d6c-c58a-da7d-6f0a-4900694ec2d3@gmail.com>
 <1d161137-55a5-126f-b47e-b2625bd798ca@i-love.sakura.ne.jp>
 <20190127083724.GA18811@dhcp22.suse.cz>
 <ec0d0580-a2dd-f329-9707-0cb91205a216@i-love.sakura.ne.jp>
 <20190127114021.GB18811@dhcp22.suse.cz>
 <e865a044-2c10-9858-f4ef-254bc71d6cc2@i-love.sakura.ne.jp>
 <20190128101513.f35752d6210f0781d0de8d17@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190128101513.f35752d6210f0781d0de8d17@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, Aleksa Sarai <asarai@suse.de>, Jay Kamat <jgkamat@fb.com>, Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, linux-mm <linux-mm@kvack.org>

On Mon 28-01-19 10:15:13, Andrew Morton wrote:
> On Sun, 27 Jan 2019 23:57:38 +0900 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:
> 
> > Arkadiusz reported that enabling memcg's group oom killing causes
> > strange memcg statistics where there is no task in a memcg despite
> > the number of tasks in that memcg is not 0. It turned out that there
> > is a bug in wake_oom_reaper() which allows enqueuing same task twice
> > which makes impossible to decrease the number of tasks in that memcg
> > due to a refcount leak.
> > 
> > This bug existed since the OOM reaper became invokable from
> > task_will_free_mem(current) path in out_of_memory() in Linux 4.7,
> > but memcg's group oom killing made it easier to trigger this bug by
> > calling wake_oom_reaper() on the same task from one out_of_memory()
> > request.
> > 
> > Fix this bug using an approach used by commit 855b018325737f76
> > ("oom, oom_reaper: disable oom_reaper for oom_kill_allocating_task").
> > As a side effect of this patch, this patch also avoids enqueuing
> > multiple threads sharing memory via task_will_free_mem(current) path.
> > 
> 
> Do we think this is serious enough to warrant a -stable backport?

Yes, I would go with stable backport.

-- 
Michal Hocko
SUSE Labs
