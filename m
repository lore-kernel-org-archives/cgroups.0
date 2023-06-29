From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 1/3] cpuset: Allow setscheduler regardless of manipulated
 task
Date: Thu, 29 Jun 2023 09:25:05 -0400
Message-ID: <67d72bc7-a277-9210-6f40-d3d94f2643a0@redhat.com>
References: <20230629091146.28801-1-mkoutny@suse.com>
 <20230629091146.28801-2-mkoutny@suse.com>
 <15c607d9-c1fa-ca11-d675-8f2b3a6fd15b@redhat.com>
 <4fowzgkh7yo5ku2fsrptyi7jzikynjtq4zpfcx7k26vk4k6zj3@ubnupp5jqgle>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688045110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i//cZqpn/yGjitEFiKBEUSmAX16ZZkd1c4DKwvAzqBQ=;
        b=JSXvlkBx3HVdI9qj0MUw/mcx1zjp13bwPrBKdIlh7/ojR5oket5dNvhm95Bn/SUYxlKkyp
        qo0AukpL94n5sH1dSRkKSHK5N06AOsX23+YdgRh8FtcP2l90azH0FgZgztjvqgLhEBuOEF
        0JLGqLMNWilOVA0y/+5IbKwKb35ZdUw=
Content-Language: en-US
In-Reply-To: <4fowzgkh7yo5ku2fsrptyi7jzikynjtq4zpfcx7k26vk4k6zj3@ubnupp5jqgle>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, Zefan Li <lizefan.x@bytedance.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>


On 6/29/23 08:26, Michal Koutn=C3=BD wrote:
> On Thu, Jun 29, 2023 at 08:11:33AM -0400, Waiman Long <longman@redhat.com=
> wrote:
>> So I think you should just use
>> cgroup_subsys_on_dfl(cpuset_cgrp_subsys) as the v2 check if your focus
>> is just to prevent problem when enabling cpuset controller.
> I thought the bare cgroup_subsys_on_dfl(cpuset_cgrp_subsys) is not used
> in cpuset.c but I was wrong -- yes, I'll change this.
>
>> This change will likely conflict with the latest cpuset change on tracki=
ng #
>> of dl tasks in a cpuset. You will have to, at least, move the dl task ch=
eck
>> before the security_task_setscheduler() check.
>>
>> Another fact about cpuset controller enabling is that both cpus_allowed =
and
>> mems_allowed are empty at that point. You may also add these checks as a
>> preconditions for disabling the security_task_setscheduler check.
> Ah, I will rebase on fresh mainline (or do you mean another reference?).

Yes, those changes have just been merged into the mainline.

Cheers,
Longman

