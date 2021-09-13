From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup: Fix incorrect warning from
 cgroup_apply_control_disable()
Date: Mon, 13 Sep 2021 14:46:05 -0400
Message-ID: <e1190877-f5b7-b052-cd80-a7e558c379a4@redhat.com>
References: <20210910024256.7615-1-longman@redhat.com>
 <YT+TA6ItnF9xM3cR@slm.duckdns.org>
 <125c4202-68d1-1a4e-03d6-2b18f0794ba4@redhat.com>
 <dbb1a221-b3d2-5086-e47b-8a2c764d60ad@redhat.com>
 <YT+cPPyDPimHibSC@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631558768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j/URbjttbgh/qE1agh24JiENV0g90v5EslC9AJDtoVI=;
        b=RKysiDFKcvko/M+htPF8E9xQxbmZnGO7lD2F0vnmLwFQVTjoeOgCYUOdYnuPioeT32XlJc
        S0ovkqa2kONyR6tyqS3J4v0a65fov7F9Nrlt/BCY9cNbvE4Mu8fAG3bpt9FxlUyWaFT2e9
        IEe5hL4lLESTwvl/kRV2imXfGt/s2w4=
In-Reply-To: <YT+cPPyDPimHibSC-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 9/13/21 2:45 PM, Tejun Heo wrote:
> On Mon, Sep 13, 2021 at 02:43:44PM -0400, Waiman Long wrote:
>>> The problem with percpu_ref_is_dying() is the fact that it becomes true
>>> after percpu_ref_exit() is called in css_free_rwork_fn() which has an
>>> RCU delay. If you want to catch the fact that kill_css() has been
>>> called, we can check the CSS_DYING flag which is set in kill_css() by
>>> commit 33c35aa481786 ("cgroup: Prevent kill_css() from being called more
>>> than once"). Will that be an acceptable alternative?
>> Something like
>>
>> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
>> index 881ce1470beb..851e54800ad8 100644
>> --- a/kernel/cgroup/cgroup.c
>> +++ b/kernel/cgroup/cgroup.c
>> @@ -3140,6 +3140,9 @@ static void cgroup_apply_control_disable(struct cgroup
>> *cg
>>                          if (!css)
>>                                  continue;
>>
>> +                       if (css->flags & CSS_DYING)
>> +                               continue;
>> +
> So, I don't think this would be correct. It is assumed that there are no
> dying csses when control reaches this point. The right fix is making sure
> that remount path clears up dying csses before calling into this path.

Thanks for the suggestion. I will look into that.

Cheers,
Longman

