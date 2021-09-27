From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup/debug: Fix lockdep splat with "%pK" format
 specifier
Date: Mon, 27 Sep 2021 14:17:47 -0400
Message-ID: <4f4f5a8c-7488-5ea6-0f1b-6ac95c259b4a@redhat.com>
References: <20210927025807.26918-1-longman@redhat.com>
 <YVH0uKGGmRjrIlFy@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632766672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=guROg9SA+ZOzGxG9ucYCki57yHW/wFcgZSDoIXaT1T0=;
        b=brjePgeOMHoBP5yObSSX3JvynDBoI5P+eJSQsgYLdOmFiboDUDZ0Yyk2tnqNor8+b+cMxG
        IEPA1poXaNrUT9ThrhmtER5qPtGGErI0rZlIuVenPpLbk/DEQLLff50v053MfdCSe3w1fS
        8TVbaK3d9aT/glScS1J1PeqPtJRKimk=
In-Reply-To: <YVH0uKGGmRjrIlFy-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 9/27/21 12:43 PM, Tejun Heo wrote:
> Hello,
>
> On Sun, Sep 26, 2021 at 10:58:07PM -0400, Waiman Long wrote:
>> The lockdep splat is caused by the fact that the debug controller use the
>> "%pK" format specifier to print out address of cset's with css_set_lock
>> held. Under some circumstances, the use of "%pK" format specifier may
>> acquire the selinux_ss.policy_rwlock.
>>
>> To avoid this possible deadlock scenario, we have to abandon the use of
>> the "%pK" format specifier and just use "%p" to always hash the cset
>> addresses. The actual cset addresses aren't that important as long as
>> they are unique for matching purpose.
> Isn't the right thing to do here making the selinux rwlock an irqsafe one?
> It's a bit crazy to have printf specifier to have restrictive locking
> requirements.

I just realize that upstream had get rid of the policy_rwlock since 
v5.10 and use RCU instead. So this patch isn't applicable then.

My original thought was that policy_rwlock were referenced over 60 times 
in security/selinux/ss/services.c whereas we only use a few %pK format 
specifier in the debug controller. Anyway, it is moot now.

Sorry for the noise.

Cheers,
Longman


