From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] cpusets: Make cpus_allowed and mems_allowed masks
 hotplug invariant
Date: Wed, 8 Oct 2014 12:18:28 +0200
Message-ID: <20141008101828.GG10832@worktop.programming.kicks-ass.net>
References: <20141008070739.1170.33313.stgit@preeti.in.ibm.com>
 <20141008080706.GC10832@worktop.programming.kicks-ass.net>
 <543505EF.7070804@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <543505EF.7070804@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: svaidy@linux.vnet.ibm.com, rjw@rjwysocki.net, lizefan@huawei.com, anton@samba.org, tj@kernel.org, paulmck@linux.vnet.ibm.com, mingo@kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 03:07:51PM +0530, Preeti U Murthy wrote:

> > I still completely hate all that.. It basically makes cpusets useless,
> > they no longer guarantee anything, it makes then an optional placement
> > hint instead.
> 
> Why do you say they don't guarantee anything? We ensure that we always
> run on the cpus in our cpuset which are online. We do not run in any
> arbitrary cpuset. We also do not wait unreasonably on an offline cpu to
> come back. What we are doing is ensuring that if the resources that we
> began with are available we use them. Why is this not a logical thing to
> expect?

Because if you randomly hotplug cpus your tasks can randomly flip
between sets.

Therefore there is no strict containment and no guarantees.

> > You also break long standing behaviour.
> 
> Which is? As I understand cpusets are meant to ensure a dedicated set of
> resources to some tasks. We cannot scheduler the tasks anywhere outside
> this set as long as they are available. And when they are not, currently
> we move them to their parents,

No currently we hard break affinity and never look back. That move to
parent and back crap is all new fangled stuff, and broken because of the
above argument.

> but you had also suggested killing the
> task. Maybe this can be debated. But what behavior are we changing by
> ensuring that we retain our original configuration at all times?

See above, by pretending hotplug is a sane operation you loose all
guarantees.

> > Also, power is insane if it needs/uses hotplug for operational crap
> > like that.
> 
> SMT 8 on Power8 can help/hinder workloads. Hence we dynamically switch
> the modes at runtime.

That's just a horrible piece of crap hack and you deserve any and all
pain you get from doing it.

Randomly removing/adding cpus like that is horrible and makes a mockery
of all the affinity interfaces we have.
