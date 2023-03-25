From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 3/5] cgroup/cpuset: Find another usable CPU if none found
 in current cpuset
Date: Sat, 25 Mar 2023 18:08:18 -0400
Message-ID: <17e804ea-64b5-97e1-d5fa-571157e15746@redhat.com>
References: <20230306200849.376804-1-longman@redhat.com>
 <20230306200849.376804-4-longman@redhat.com>
 <20230314181749.5b4k6selbgdhl3up@blackpad>
 <58a1a878-fa0b-285d-3e43-2b5103d3c770@redhat.com>
 <20230317122708.ax3m2d4zijkfdzjq@blackpad>
 <ca664da8-0f47-06b2-a94c-82b2f9a1c3aa@redhat.com>
 <20230324143247.GA27199@willie-the-truck>
 <20230324181936.5sf6xjc5a4vacuku@blackpad>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679782103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gfpzCVb7RjReIdPdxbxCD31KhV4soJYjxsJSs2syVzk=;
        b=XkXySQxTXOCDp/KTbZtXRLpcv7diNpNAJFLi21eYNbFD+OMSoW9GD9Cq83TCp17sSxz8Yu
        t5YAmnpwg3YrEJtK5RnZkKS6HClShX2FYf9dpwbWIyBeey1igGYRh2fWqNcZztS/mZnUPH
        3dtUyWILdrONrCOuHvdnEHPwlAs3xJ4=
Content-Language: en-US
In-Reply-To: <20230324181936.5sf6xjc5a4vacuku@blackpad>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Will Deacon <will@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>


On 3/24/23 14:19, Michal Koutn=C3=BD wrote:
> On Fri, Mar 24, 2023 at 02:32:50PM +0000, Will Deacon <will@kernel.org> w=
rote:
>> So approaches such as killing tasks or rejecting system calls tend not
>> to work as well, since you inevitably get divergent behaviour leading
>> to functional breakage rather than e.g. performance anomalies.
> What about temporary performance drop from 100% to 0% aka freezing the
> tasks for the duration of the mismatching affinity config?

That can be a lot of extra work to freeze it. I will prefer something=20
simpler.

Without this patch, I believe it will lead to a cpumask of 0 which will=20
cause the scheduler to pick a fallback cpu. It looks like the fallback=20
code may be able to pick up the right cpu or it may panic the system=20
(less likely).

Cheers,
Longman
>
>
>> Having said that, the behaviour we currently have in mainline seems to
>> be alright, so please don't go out of your way to accomodate these SoCs.
> I see. (Just wondering what you think about the fourth option above.)
>
> Thanks,
> Michal

