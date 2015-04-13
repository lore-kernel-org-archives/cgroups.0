From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH V2] cpuset: Add knob to make allowed masks hotplug
 invariant on legacy hierarchy
Date: Mon, 13 Apr 2015 17:05:15 +0200
Message-ID: <20150413150515.GV21418@twins.programming.kicks-ass.net>
References: <20150410141118.11284.36206.stgit@preeti.in.ibm.com>
 <20150413145052.GC2596@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150413145052.GC2596@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>, svaidy@linux.vnet.ibm.com, nacc@linux.vnet.ibm.com, rjw@rjwysocki.net, linux-kernel@vger.kernel.org, lizefan@huawei.com, anton@samba.org, bharata@linux.vnet.ibm.com, cgroups@vger.kernel.org, paulmck@linux.vnet.ibm.com, mingo@kernel.org, serge@hallyn.com

On Mon, Apr 13, 2015 at 10:50:52AM -0400, Tejun Heo wrote:
> On Fri, Apr 10, 2015 at 07:41:52PM +0530, Preeti U Murthy wrote:
> > Moreover the default hierarchy keeps the allowed masks hotplug invariant
> > too. So the patch is not bringing about a fundamental change in the
> > design of cgroups.
> 
> This is gonna be a new behavior anyway and I don't follow why you just
> can't use the default hierarchy (well, of course except for that it
> isn't ready yet but no matter what we do this is gonna take another
> devel cycle so what's the difference?).  It's not like the default
> hierarchy requires invasive changes.  I'm not convinced this calls for
> yet another operation mode.

So TJ and me don't often seem to agree on cgroup stuffs, but here we do
;-)
