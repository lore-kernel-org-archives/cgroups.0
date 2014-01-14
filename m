From: Marian Marinov <mm-NV7Lj0SOnH0@public.gmane.org>
Subject: Re: RFC: cgroups aware proc
Date: Tue, 14 Jan 2014 02:58:14 +0200
Message-ID: <52D48BA6.2080701@yuhu.biz>
References: <52D35CD0.9070602@huawei.com> <52D41316.5080508@yuhu.biz>
 <20140113171238.GS31570@twins.programming.kicks-ass.net>
Reply-To: LXC development mailing-list <lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <lxc-devel-bounces-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yuhu.biz; s=default;
 t=1389661090; bh=sx0UAV8WS5Lar3CxJ3aSNu5Pw2d4HBe1pzjgaLNFnlk=;
 h=Date:From:To:CC:Subject:References:In-Reply-To;
 b=rFVYUspwZ4lYQUEYDQCK5wIRE7ccjDI9SjtDkeixitosMs/OsGFS1ZQMMr+xu4wco
 4b92+VDhhW8inJvfRh+m11Tzh9DxYLRTs1juMTYdtf4b4l/b7pDWK+5I43dmdLtinR
 abiCwUzFnOEVDyhVINv98EEoySpNgYGuC49UGoao=
In-Reply-To: <20140113171238.GS31570-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <http://lists.linuxcontainers.org/options/lxc-devel>,
 <mailto:lxc-devel-request-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxcontainers.org/pipermail/lxc-devel>
List-Post: <mailto:lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org>
List-Help: <mailto:lxc-devel-request-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linuxcontainers.org/listinfo/lxc-devel>,
 <mailto:lxc-devel-request-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org?subject=subscribe>
Errors-To: lxc-devel-bounces-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org
Sender: lxc-devel-bounces-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On 01/13/2014 07:12 PM, Peter Zijlstra wrote:
> On Mon, Jan 13, 2014 at 06:23:50PM +0200, Marian Marinov wrote:
>> Hello Peter,
>>
>> I need help with the scheduler.
>>
>> I'm currently trying to patch the /proc/loadavg to show the load that is
>> only related to the processes from the current cgroup.
>>
>> I looked trough the code and I was hoping that tsk->sched_task_group->cfs_rq
>> struct will give me the needed information, but unfortunately for me, it did
>> not.
>>
>> Can you advise me, how to approach this problem?
>
> Yeah, don't :-) Really, loadavg is a stupid metric.

Yes... stupid, but unfortunately everyone is looking at it :(

>
>> I'm totally new to the scheduler code.
>
> Luckily you won't actually have to touch much of it. Most of the actual
> loadavg code lives in the first ~400 lines of kernel/sched/proc.c, read
> and weep. Its one of the best documented bits around.

I looked trough it but I don't understand how to introduce the per cgroup calculation.

I looked trough the headers and found the following, which is already implemented.

   task->sched_task_group->load_avg
   task->sched_task_group->cfs_rq->load_avg
   task->sched_task_group->cfs_rq->load.weight
   task->sched_task_group->cfs_rq->runnable_load_avg

Unfortunately there is almost no documentation for these elements of the cfs_rq and task_group structs.

It seams to me that part of the per task group loadavg code is already present.

>
> Your proposition however is extremely expensive, you turn something
> that's already expensive O(nr_cpus) into something O(nr_cpus *
> nr_cgroups).
>
> I'm fairly sure people will not like that, esp. for something of such
> questionable use as the loadavg -- its really only a pretty number that
> doesn't mean all that much.

I know that its use is questionable but in my case I need to have it, or I will not be able to offer correct loadavg 
values in the containers.


>
>> -------- Original Message --------
>> From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>
>> Then you should add Peter, Ingo and LKML to your Cc list. :)
>
> You failed that, let me fix that.
>
>
