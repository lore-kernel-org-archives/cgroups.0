From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v4 2/2] cpusets,isolcpus: add file to show isolated cpus
 in cpuset
Date: Mon, 2 Mar 2015 10:12:13 +0100
Message-ID: <20150302091213.GI21418@twins.programming.kicks-ass.net>
References: <1424882288-2910-1-git-send-email-riel@redhat.com>
 <1424882288-2910-3-git-send-email-riel@redhat.com>
 <54EEFE15.3010005@huawei.com>
 <20150226121231.6fcba7e8@annuminas.surriel.com>
 <54F4000B.5000901@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54F4000B.5000901@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan@huawei.com>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org, Clark Williams <williams@redhat.com>, Ingo Molnar <mingo@redhat.com>, Luiz Capitulino <lcapitulino@redhat.com>, David Rientjes <rientjes@google.com>, Mike Galbraith <umgwanakikbuti@gmail.com>, cgroups@vger.kernel.org

On Mon, Mar 02, 2015 at 02:15:39PM +0800, Zefan Li wrote:
> Hi Rik,
> 
> > Subject: cpusets,isolcpus: add file to show isolated cpus in cpuset
> > 
> > The previous patch makes it so the code skips over isolcpus when
> > building scheduler load balancing domains. This makes it hard to
> > see for a user which of the CPUs in a cpuset are participating in
> > load balancing, and which ones are isolated cpus.
> > 
> > Add a cpuset.isolcpus file with info on which cpus in a cpuset are
> > isolated CPUs.
> > 
> > This file is read-only for now. In the future we could extend things
> > so isolcpus can be changed at run time, for the root (system wide)
> > cpuset only.
> > 
> 
> One Question, why not add a /sys/devices/system/cpu/isolated instead?

It would leave userspace to calculate the result for any one cpuset
itself. Furthermore, is that /sys thing visible for all nested
containers?
