From: Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH v4 2/5] sched/topology: Adding function
 partition_sched_domains_locked()
Date: Thu, 14 Jun 2018 15:47:31 +0200
Message-ID: <20180614134731.GD12032@localhost.localdomain>
References: <20180613121711.5018-1-juri.lelli@redhat.com>
 <20180613121711.5018-3-juri.lelli@redhat.com>
 <20180614093536.612712f6@gandalf.local.home>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180614093536.612712f6@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Steven Rostedt <rostedt@goodmis.org>
Cc: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org

On 14/06/18 09:35, Steven Rostedt wrote:
> On Wed, 13 Jun 2018 14:17:08 +0200
> Juri Lelli <juri.lelli@redhat.com> wrote:

[...]

> > +/*
> > + * Call with hotplug lock held
> > + */
> > +void partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
> > +			     struct sched_domain_attr *dattr_new)
> > +{
> > +	lockdep_assert_cpus_held();
> 
> Is the above assert really necessary? The assert will happen in
> partition_sched_domains_locked() anyway.

Indeed, it seems of little use.

Thanks,

- Juri
