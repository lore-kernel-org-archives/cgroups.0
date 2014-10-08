From: Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>
Subject: Re: [PATCH] cpusets: Make cpus_allowed and mems_allowed masks hotplug invariant
Date: Wed, 8 Oct 2014 20:24:26 +0530
Message-ID: <CAC4Lta2AS6M5upg8n9Qu5+1pqCMF3j8_cYuLAS1DH9C_BQP0PA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:date:message-id:subject:from:to:cc:content-type;
        bh=+DZ98Fn5CQWtZkbtvoIuB16efdyMBfKmMNS4MgfjJDI=;
        b=z0HTnSvLCtcwi+LAnt8QeXlJH34jCZSj0k5ja8O2ZPHyR6YpRvQfDa1BtNc4Z1iFPQ
         TXK5/7J+NhDM+xzd9EiP/GClHdL/1mUazdgLNlpJiJnEzHMm0UYbRTAcPXM3oboCRuqi
         tcDsRVrerpICLNHUaMzNUA1JftcmSiycKchFHIgz1mBmJPdSAR8NOs9N5SWDbj7MSRR4
         41EvumzPH6pKPNmkRwxZ5suoBL5A4yHZeiHOuBKlay0JcZHF6F2rz9r29aGMUZmkeXIy
         jXi4WvcxRS+e56d9iCm3ew273RhrZkaPZuu94zWDFenqhkobVHRQ9/dfwNzjfG/PTnMF
         ykNg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: svaidy@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>, rjw@rjwysocki.net, lizefan@huawei.com, Anton Blanchard <anton@samba.org>, Tejun Heo <tj@kernel.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, cgroups@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Wed, Oct 8, 2014 at 12:37 PM, Preeti U Murthy
<preeti@linux.vnet.ibm.com> wrote:
> There are two masks associated with cpusets. The cpus/mems_allowed
> and effective_cpus/mems. On the legacy hierarchy both these masks
> are consistent with each other. This is the intersection of their
> value and the currently active cpus. This means that we destroy the
> original values set in these masks on each cpu/mem hot unplug operation.
>         As a consequence when we hot plug back the cpus/mems, the tasks
> no longer run on them and performance degrades, inspite of having
> resources to run on.
>
> This effect is not seen in the default hierarchy since the
> allowed and effective masks are distinctly maintained.
> allowed masks are never touched once configured and effective masks
> alone are hotplug variant.
>
> This patch replicates the above design even for the legacy hierarchy,
> so that:
>
> 1. Tasks always run on the cpus/memory nodes that they are allowed to run on
> as long as they are online. The allowed masks are hotplug invariant.
>
> 2. When all cpus/memory nodes in a cpuset are hot unplugged out, the tasks
> are moved to their nearest ancestor which has resources to run on.

Hi Preeti,

I may be missing some thing here could you please explain when do we get
tasks move out of a cpuset after this patch and why it is even necessary?

IIUC, with default hierarchy we should never hit a case where we have empty
effective cpuset and hence remove_tasks_in_empty_cpuset should never happen. no?

if my assumption is correct then we should remove
remove_tasks_in_empty_cpuset itself...
