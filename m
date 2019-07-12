From: Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH v8 6/8] cgroup/cpuset: Change cpuset_rwsem and hotplug
 lock order
Date: Fri, 12 Jul 2019 16:04:09 +0200
Message-ID: <20190712140409.GB13885@localhost.localdomain>
References: <20190628080618.522-1-juri.lelli@redhat.com>
 <20190628080618.522-7-juri.lelli@redhat.com>
 <20190628130308.GU3419@hirez.programming.kicks-ass.net>
 <20190701065233.GA26005@localhost.localdomain>
 <20190701082731.GP3402@hirez.programming.kicks-ass.net>
 <20190701145107.GY657710@devbig004.ftw2.facebook.com>
 <20190704084924.GC9099@localhost.localdomain>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190704084924.GC9099@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com, rostedt@goodmis.org, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org, Prateek Sood <prsood@codeaurora.org>

On 04/07/19 10:49, Juri Lelli wrote:
> Hi,
> 
> On 01/07/19 07:51, Tejun Heo wrote:
> > Hello,
> > 
> > On Mon, Jul 01, 2019 at 10:27:31AM +0200, Peter Zijlstra wrote:
> > > IIRC TJ figured it wasn't strictly required to fix the lock invertion at
> > > that time and they sorted it differently. If I (re)read the thread
> > > correctly the other day, he didn't have fundamental objections against
> > > it, but wanted the simpler fix.
> > 
> > Yeah I've got no objections to the change itself, it just wasn't
> > needed at the time.  We've had multiple issues there tho, so please
> > keep an eye open after the changes get merged.
> 
> Should I take this as an indication that you had a look at the set and
> (apart from Peter's comments) you are OK with them?
> 
> If that's the case I will send a v9 out soon. Otherwise I'd kindly ask
> you to please have a look.

Gentle ping.

Thanks,

Juri
