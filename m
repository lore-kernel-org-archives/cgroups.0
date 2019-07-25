From: Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH v9 3/8] cpuset: Rebuild root domain deadline accounting
 information
Date: Thu, 25 Jul 2019 16:07:37 +0200
Message-ID: <20190725140737.GM25636@localhost.localdomain>
References: <20190719140000.31694-1-juri.lelli@redhat.com>
 <20190719140000.31694-4-juri.lelli@redhat.com>
 <20190725135351.GA108579@gmail.com>
 <20190725135615.GB108579@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190725135615.GB108579@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ingo Molnar <mingo@kernel.org>
Cc: peterz@infradead.org, mingo@redhat.com, rostedt@goodmis.org, tj@kernel.org, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, longman@redhat.com, dietmar.eggemann@arm.com, cgroups@vger.kernel.org

Hi,

On 25/07/19 15:56, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@kernel.org> wrote:
> 
> > 
> > * Juri Lelli <juri.lelli@redhat.com> wrote:
> > 
> > > When the topology of root domains is modified by CPUset or CPUhotplug
> > > operations information about the current deadline bandwidth held in the
> > > root domain is lost.
> > > 
> > > This patch addresses the issue by recalculating the lost deadline
> > > bandwidth information by circling through the deadline tasks held in
> > > CPUsets and adding their current load to the root domain they are
> > > associated with.
> > > 
> > > Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> > > Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
> > 
> > Was this commit written by Mathieu? If yes then it's missing a From line. 
> > If not then the Signed-off-by should probably be changed to Acked-by or 
> > Reviewed-by?
> 
> So for now I'm assuming that the original patch was written by Mathieu, 
> with modifications by you. So I added his From line and extended the SOB 
> chain with the additional information that you modified the patch:
> 
>     Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
>     Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
>     Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
>     [ Various additional modifications. ]
>     Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>     Signed-off-by: Ingo Molnar <mingo@kernel.org>
> 
> Let me know if that's not accurate!

Looks good to me, thanks. And sorry for the confusion.

Best,

Juri
