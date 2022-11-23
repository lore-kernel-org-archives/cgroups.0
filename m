From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: Optimize update_tasks_nodemask()
Date: Wed, 23 Nov 2022 14:05:59 -0500
Message-ID: <a89de82d-41e7-a40f-a5a3-83ad62bf383f@redhat.com>
References: <20221123082157.71326-1-haifeng.xu@shopee.com>
 <Y35Swdpq+rJe+Tu3@slm.duckdns.org>
 <5fccf438-fdbe-1bc8-6460-b3911cc51566@redhat.com>
 <Y35sbREgYE6aIdIp@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669230366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SDRg/5ZBX3XDzjEuh83I6NIeECdfJo03H+sBbmb+sh8=;
        b=Brta+LkyS9A8u/1n42xRhg9epE0iJtV+LtHV3EmTn6IB6eqH8LOUGBU4zekJZ/1Tw9mZh7
        Cko5YvtuSjnvcUZThjDyZwYLzaFdO8Lo8FRHGPBchpc23KZC+mNcdmZhydi4FrJ4gHXakA
        yl0FyFWEF6Lzchjb/At9XD+4SYG1+pg=
Content-Language: en-US
In-Reply-To: <Y35sbREgYE6aIdIp-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "haifeng.xu" <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On 11/23/22 13:54, Tejun Heo wrote:
> On Wed, Nov 23, 2022 at 01:48:46PM -0500, Waiman Long wrote:
>> I think it is an issue anyway if different threads of a process are in
>> different cpusets with different node mask. It is not a configuration that
>> should be used at all.
> Anything memory related is in the same boat and people still use them
> reaching whatever end results they reach. Given the whole thing is pretty
> ill-defined, I don't wanna change the behavior now.
I am just saying that this is not a good config. I don't have any 
intention to change the existing behavior at all.
>
>> This patch makes update_tasks_nodemask() somewhat similar to cpuset_attach()
>> where all tasks are iterated to update the node mask but only the task
>> leaders are required to update the mm. For a non-group leader task, maybe we
>> can check if the group leader is in the same cpuset. If so, we can skip the
>> mm update. Do we need similar change in cpuset_attach()?
> The leader isn't special tho. We just wanna avoid visiting the same mm more
> than once, right?

Right, the group leader is just a marker to make it easier to avoid 
duplicating the work for the same mm. If the group leader happens to be 
in another cpuset, it will suffer some performance consequence.

Cheers,
Longman

