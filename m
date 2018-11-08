From: Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH v5 4/5] sched/core: Prevent race condition between cpuset
 and __sched_setscheduler()
Date: Thu, 8 Nov 2018 17:23:48 +0100
Message-ID: <20181108162348.GF18091@localhost.localdomain>
References: <20180903142801.20046-1-juri.lelli@redhat.com>
 <20180903142801.20046-5-juri.lelli@redhat.com>
 <20181003154230.4b8792fb@gandalf.local.home>
 <20181004090401.GB12774@localhost.localdomain>
 <16587a21-ed6e-809d-78a8-5f76d1787665@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16587a21-ed6e-809d-78a8-5f76d1787665@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman9394@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org

Hi,

On 08/11/18 10:49, Waiman Long wrote:
> On 10/04/2018 05:04 AM, Juri Lelli wrote:

[...]

> > +/**
> > + * cpuset_read_only_lock - Grab the callback_lock from cpuset subsystem.
> > + *
> > + * Description: As described in full details the comment above cpuset_mutex
> > + * and callback_lock definitions, holding callback_lock gives the holder
> > + * read-only access to cpusets. Even though it might look counter-intuitive
> > + * (as callback_lock is a spinlock), in fact a task must hold both
> > + * callback_lock _and_ cpuset_mutex to modify cpusets (write access).
> > + */
> > +void cpuset_read_only_lock(void)
> > +{
> > +	raw_spin_lock(&callback_lock);
> > +}
> > +
> > +/**
> > + * cpuset_read_only_unlock - Release the callback_lock from cpuset subsystem.
> > + */
> > +void cpuset_read_only_unlock(void)
> > +{
> > +	raw_spin_unlock(&callback_lock);
> > +}
> > +
> 
> Maybe you can drop the "_only" part to be consistent with the rwlock
> APIs (read_lock/write_lock).

I called it this way because it looked more descriptive of which kind of
guarantee the holder gets using these. Can change of course, what others
think?

Thanks for reviewing!

Best,

- Juri
