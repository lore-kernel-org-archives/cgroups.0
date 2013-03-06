From: Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf: remove include of cgroup.h from perf_event.h
Date: Wed, 6 Mar 2013 12:20:41 +0100
Message-ID: <CABPqkBS7ceR1jvYq2rHMj0r7MU3yanQqdLN70FibZv+0SA-fBA@mail.gmail.com>
References: <513568A0.6020804@huawei.com>
	<CABPqkBTTn6E=FS6WiCWopcScHDVa9F6bu5-pw8Ma7TK2aunkvQ@mail.gmail.com>
	<20130306103120.GA16827@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:x-received:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        bh=mGAqTn4RjFiOEps5SI8WIOyYo+WCAk9rcOdwb5BRtMY=;
        b=fZYhD+lSvDsae9hHAyzK1IA/S5r4E07SdtDYSYUrsA3oGJyxE99y0fTx2qmy8/l/K/
         GeL8JhBLAQSvBil4IoidFdAyqkT274kawcuoVx9qoLnZchPWNMS7hMcQBUs4CRVFYCHf
         maZPRTpVXrJFowHwnnRn78DCRs3e/s1P1viEJBMnCWCAPlVZvrOCveI/CTLANiSqRCQc
         6+MvDlMAS2FWJo+sGilX3RIJjUNhBn6ZHYzbbQ77pWumcxbd5oWfs4915/g8dB6AJI6B
         pLi19Me8bweSg6VmdW5Ann0awGgxcloSRFHySLcObT2TUTSxSf7jjywn4lTbhD0J5MDy
         rm3g==
In-Reply-To: <20130306103120.GA16827@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ingo Molnar <mingo@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>

On Wed, Mar 6, 2013 at 11:31 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Stephane Eranian <eranian@google.com> wrote:
>
>> > - * This is a per-cpu dynamically allocated data structure.
>> > - */
>> > -struct perf_cgroup_info {
>> > -       u64                             time;
>> > -       u64                             timestamp;
>> > -};
>> > -
>> > -struct perf_cgroup {
>> > -       struct                          cgroup_subsys_state css;
>> > -       struct                          perf_cgroup_info *info; /* timing info, one per cpu */
>> > -};
>> > -#endif
>> > -
>> > +struct perf_cgroup;
>>
>> The problem is that you have struct perf_cgroup in the struct perf_event
>> structure. Today, this field is not referenced outside of kernel/events/core.c But
>> it is available outside this file. If someday the field is reference, your changes
>> will have to do reverted. So I am wondering what is the point of the change right
>> now?
>
> It's standard practice to not define the type for task_struct or other kernel
> subsystems.
>
> For example slab caches can be created via kmem_cache_create() anywhere in the tree,
> but the internal structure is only known to the SLAB subsystem.
>
I am fine with the change.
