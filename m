From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [PATCH 0/7] psi: pressure stall information for CPU, memory, and
 IO
Date: Mon, 14 May 2018 10:35:37 -0700
Message-ID: <cb81b9f2-a280-d8a9-c720-247fb9f5fa90@wdc.com>
References: <20180507210135.1823-1-hannes@cmpxchg.org>
 <010001635f4e8be9-94e7be7a-e75c-438c-bffb-5b56301c4c55-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1526320501; x=1557856501;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=RQk/Yr7237q/wKpBQjpdNBB0owXSQrmrFsHBxiyt6bM=;
  b=CTdDC2mCjcRIXSR4MiX7CivvMJ6DN54hngtsm45d+478zCm5LItDH8t0
   x29uZuWJc2K8SPlA6lWO8zMXoWg+104e6Zj9biDBl5JQ0Q/7vTKfdgIrL
   +3oWuh54IgQU/G2QLN2i76jKNCPaDhVERzYkUgFYUilLQTQf2I01BefkX
   LcX1U84JJc8NXzyByPTI/mjGcN2csl2CeCknuN1LkLCHbTqRwn0IDx4FL
   5pA8G0ZjJtb3akZITXywJlwRP5gv25kOi6nIKxLHzLsrYS/COW4pyMyva
   IGs4NPaV1FWBv+tzs8j9B/2cdXXHO8vTRSlx1XJRxuGG/bEK5RmC0eLnF
   w==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector1-wdc-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Wj52V8tLf62lkqrj2JSl73n3/Dx4KTZaAcHoKa3IFWY=;
 b=YU41tcRF+/J5vwSPcv7gq4RhZDYha2U6HgTUwlZ2MsAtzbzopWe6qf6KDfcElC6+5FC4CNzIkfl5qykP4+B//6m6HB29caemswIdCNPIZHyxjMGeqCbYiY6CAheyIisoxLufiXUnW2BpahoxPONBGnwH2Gx9WmW+M0ussSNHlW8=
In-Reply-To: <010001635f4e8be9-94e7be7a-e75c-438c-bffb-5b56301c4c55-000000@email.amazonses.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christopher Lameter <cl@linux.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, cgroups@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Balbir Singh <bsingharora@gmail.com>, Mike Galbraith <efault@gmx.de>, Oliver Yang <yangoliver@me.com>, Shakeel Butt <shakeelb@google.com>, xxx xxx <x.qendo@gmail.com>, Taras Kondratiuk <takondra@cisco.com>, Daniel Walker <danielwa@cisco.com>, Vinayak Menon <vinmenon@codeaurora.org>, Ruslan Ruslichenko <rruslich@cisco.com>, kernel-team@fb.com

On 05/14/18 08:39, Christopher Lameter wrote:
> On Mon, 7 May 2018, Johannes Weiner wrote:
>> What to make of this number? If CPU utilization is at 100% and CPU
>> pressure is 0, it means the system is perfectly utilized, with one
>> runnable thread per CPU and nobody waiting. At two or more runnable
>> tasks per CPU, the system is 100% overcommitted and the pressure
>> average will indicate as much. From a utilization perspective this is
>> a great state of course: no CPU cycles are being wasted, even when 50%
>> of the threads were to go idle (and most workloads do vary). From the
>> perspective of the individual job it's not great, however, and they
>> might do better with more resources. Depending on what your priority
>> is, an elevated "some" number may or may not require action.
> 
> This looks awfully similar to loadavg. Problem is that loadavg gets
> screwed up by tasks blocked waiting for I/O. Isnt there some way to fix
> loadavg instead?

The following article explains why it probably made sense in 1993 to 
include TASK_UNINTERRUPTIBLE in loadavg and also why this no longer 
makes sense today:

http://www.brendangregg.com/blog/2017-08-08/linux-load-averages.html

Bart.
