From: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: fix circular locking dependency
Date: Wed, 13 Dec 2017 13:20:46 +0530
Message-ID: <cca9aea2-9bff-decf-d669-8f90b928ea18@codeaurora.org>
References: <CANaxB-zT+sz=z1FFk5npnwMySdfKCBZDkM+P+=JXDkCXbh=rCw@mail.gmail.com>
 <1511868946-23959-1-git-send-email-prsood@codeaurora.org>
 <623f214b-8b9a-f967-7a3d-ca9c06151267@codeaurora.org>
 <20171204202219.GF2421075@devbig577.frc2.facebook.com>
 <20171204225825.GP2421075@devbig577.frc2.facebook.com>
 <20171204230117.GF20227@worktop.programming.kicks-ass.net>
 <20171211152059.GH2421075@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1513151458;
        bh=08J5wq8bPsGYRIHEM9dR3HAmPkUWdic5BxnH/ljjGUk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=OlsmobW+0MuQ2QxFEFz4Zj9bJIf500pzQORyj9msaNCSrox7NyDrdzzZ/fGvkMHs2
         1y/ss4VA66ztelE846KbxtpTKYAnejNCmGE/+xeqDN0zafcThJbCudMAPC7vCiXrxW
         krRKWUv+G4WmKLLS57R/mSy3V4nJAhakJuy0qQJM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1513151458;
        bh=08J5wq8bPsGYRIHEM9dR3HAmPkUWdic5BxnH/ljjGUk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=OlsmobW+0MuQ2QxFEFz4Zj9bJIf500pzQORyj9msaNCSrox7NyDrdzzZ/fGvkMHs2
         1y/ss4VA66ztelE846KbxtpTKYAnejNCmGE/+xeqDN0zafcThJbCudMAPC7vCiXrxW
         krRKWUv+G4WmKLLS57R/mSy3V4nJAhakJuy0qQJM=
In-Reply-To: <20171211152059.GH2421075-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sramana-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org

On 12/11/2017 08:50 PM, Tejun Heo wrote:
> Hello, Peter.
> 
> On Tue, Dec 05, 2017 at 12:01:17AM +0100, Peter Zijlstra wrote:
>>> AFAICS, this should remove the circular dependency you originally
>>> reported.  I'll revert the two cpuset commits for now.
>>
>> So I liked his patches in that we would be able to go back to
>> synchronous sched_domain building.
> 
> Ah, yeah, that's a separate issue but didn't we intentionally make
> that asynchronous?  IIRC, cpuset migration can take a really long time
> when the memory migration is turned on and doing that synchronously
> could mess up the system.
> 
> Thanks.
> 

Hi TJ,

This change makes the usage of cpuset_hotplug_workfn() from cpu
hotplug path synchronous. For memory hotplug it still remains
asynchronous.

Memory migration happening from cpuset_hotplug_workfn() is
already asynchronous by queuing cpuset_migrate_mm_workfn() in
cpuset_migrate_mm_wq.

cpuset_hotplug_workfn()
   cpuset_hotplug_workfn(()
      cpuset_migrate_mm()
         queue_work(cpuset_migrate_mm_wq)

It seems that memory migration latency might not have
impact with this change.

Please let me know if you meant something else by cpuset
migration taking time when memory migration is turned on.


Thanks

-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation
Center, Inc., is a member of Code Aurora Forum, a Linux Foundation
Collaborative Project
