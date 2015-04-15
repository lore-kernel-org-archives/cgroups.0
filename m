From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH V2] cpuset: Add knob to make allowed masks hotplug
 invariant on legacy hierarchy
Date: Wed, 15 Apr 2015 11:36:17 -0500
Message-ID: <20150415163617.GA26177@mail.hallyn.com>
References: <20150413070117.GX24151@twins.programming.kicks-ass.net>
 <552BB3A5.9060905@linux.vnet.ibm.com>
 <20150413144311.GF5029@twins.programming.kicks-ass.net>
 <552E4E41.3030008@linux.vnet.ibm.com>
 <20150415150302.GA25089@mail.hallyn.com>
 <20150415151926.GS23123@twins.programming.kicks-ass.net>
 <20150415153035.GA25390@mail.hallyn.com>
 <20150415154802.GB30337@htj.duckdns.org>
 <20150415161534.GA25776@mail.hallyn.com>
 <20150415161811.GD30337@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150415161811.GD30337@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Peter Zijlstra <peterz@infradead.org>, Preeti U Murthy <preeti@linux.vnet.ibm.com>, svaidy@linux.vnet.ibm.com, nacc@linux.vnet.ibm.com, rjw@rjwysocki.net, linux-kernel@vger.kernel.org, lizefan@huawei.com, anton@samba.org, bharata@linux.vnet.ibm.com, cgroups@vger.kernel.org, paulmck@linux.vnet.ibm.com, mingo@kernel.org

On Wed, Apr 15, 2015 at 12:18:11PM -0400, Tejun Heo wrote:
> On Wed, Apr 15, 2015 at 11:15:35AM -0500, Serge E. Hallyn wrote:
> > The reason would be because it breaks "legacy" software.  So that
> > would only matter if Preeti needs to run such software.
> 
> Sure, I get that argument but this is changing how the contorller
> behaves in a major way.

It is.  My main counter to that would be that it is how cpusets
should always have worked :)

>   There are specifics which may make this
> particular case more justifiable but overall the combination of
> arguments is pretty weird.

And becomes harder to reason about and review/maintain.  I agree
there.

From userspace, I suppose one approach (though note it is racy) to
solving this would be to have udev rules which

. On cpu unplug, record all cgroups which were using that cpu
. on cpu plug, re-add the cpu to all recorded cgroups for that
cpu (if any), as well as to any cgroups marked (in some /etc
file) as using "all" or a percentage of all cpus.

-serge
