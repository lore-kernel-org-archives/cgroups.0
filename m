From: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: fix circular locking dependency
Date: Sat, 16 Dec 2017 00:34:18 +0530
Message-ID: <7c25aac5-ef23-26c6-5096-4f1ab1b53b70@codeaurora.org>
References: <CANaxB-zT+sz=z1FFk5npnwMySdfKCBZDkM+P+=JXDkCXbh=rCw@mail.gmail.com>
 <1511868946-23959-1-git-send-email-prsood@codeaurora.org>
 <623f214b-8b9a-f967-7a3d-ca9c06151267@codeaurora.org>
 <20171204202219.GF2421075@devbig577.frc2.facebook.com>
 <20171204225825.GP2421075@devbig577.frc2.facebook.com>
 <20171204230117.GF20227@worktop.programming.kicks-ass.net>
 <20171211152059.GH2421075@devbig577.frc2.facebook.com>
 <cca9aea2-9bff-decf-d669-8f90b928ea18@codeaurora.org>
 <20171213160617.GQ3919388@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1513364662;
        bh=kN/FwsEhWcKWajbJ/uKF1wgMu1fw+Nb9SWfWtemartk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=lxcSb4QnRisnXrUcsxg86aVVXTmvqufPfN0HVV7nhLVt9VyWpR2y0Su2ux/DNY9Kn
         poxg5PBnwDROr+NZ74A0TpXCQtE2+pEiw6Od9cCpZ/aG+tJxhP3dgTYHIm5CPfXY+m
         9QHNe+MqqrRFXHgz6Jy/9wQ+qlJUJyKhq+zj4qFg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1513364662;
        bh=kN/FwsEhWcKWajbJ/uKF1wgMu1fw+Nb9SWfWtemartk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=lxcSb4QnRisnXrUcsxg86aVVXTmvqufPfN0HVV7nhLVt9VyWpR2y0Su2ux/DNY9Kn
         poxg5PBnwDROr+NZ74A0TpXCQtE2+pEiw6Od9cCpZ/aG+tJxhP3dgTYHIm5CPfXY+m
         9QHNe+MqqrRFXHgz6Jy/9wQ+qlJUJyKhq+zj4qFg=
In-Reply-To: <20171213160617.GQ3919388-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sramana-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org

On 12/13/2017 09:36 PM, Tejun Heo wrote:
> Hello, Prateek.
> 
> On Wed, Dec 13, 2017 at 01:20:46PM +0530, Prateek Sood wrote:
>> This change makes the usage of cpuset_hotplug_workfn() from cpu
>> hotplug path synchronous. For memory hotplug it still remains
>> asynchronous.
> 
> Ah, right.
> 
>> Memory migration happening from cpuset_hotplug_workfn() is
>> already asynchronous by queuing cpuset_migrate_mm_workfn() in
>> cpuset_migrate_mm_wq.
>>
>> cpuset_hotplug_workfn()
>>    cpuset_hotplug_workfn(()
>>       cpuset_migrate_mm()
>>          queue_work(cpuset_migrate_mm_wq)
>>
>> It seems that memory migration latency might not have
>> impact with this change.
>>
>> Please let me know if you meant something else by cpuset
>> migration taking time when memory migration is turned on.
> 
> No, I didn't.  I was just confused about which part became
> synchronous.  So, I don't have anything against making the cpu part
> synchronous, but let's not do that as the fix to the deadlocks cuz,
> while we can avoid them by changing cpuset, I don't think cpuset is
> the root cause for them.  If there are benefits to making cpuset cpu
> migration synchronous, let's do that for those benefits.

Making CPU part synchronous can only be achieved if we retain the
patch for inverting the locking order for cpuset_mutex and
cpu_hotplug_lock.

> 
> Thanks.
> 

Peter,

Do you suggest taking both the patches:
1) Inverting locking order of cpuset_mutex and cpu_hotplug_lock.
2) Make cpuset hotplug work synchronous.

or  

 https://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git/commit/?h=for-4.15-fixes&id=e8b3f8db7aad99fcc5234fc5b89984ff6620de3d

I would leave it for you and TJ to decide on this.

Thanks



-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation
Center, Inc., is a member of Code Aurora Forum, a Linux Foundation
Collaborative Project
