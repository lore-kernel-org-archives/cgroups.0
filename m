From: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH v2] cgroup/cpuset: remove circular dependency deadlock
Date: Wed, 15 Nov 2017 22:48:21 +0530
Message-ID: <857d3615-f1c6-c525-62cd-111ee5df6ac6@codeaurora.org>
References: <45cdac2f-4462-e5b5-d724-8cca58e3932a@codeaurora.org>
 <1509347805-23491-1-git-send-email-prsood@codeaurora.org>
 <6f8b194f-05ec-05d4-3df6-e9eadc7f68bf@codeaurora.org>
 <20171115103742.xt7muaq2dfrs2cyd@hirez.programming.kicks-ass.net>
 <20171115170524.GU983427@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1510766315;
        bh=aqNasY6cGwEUtgUFNtfqBf1O1H5W9zaNTSl2MoSQsyE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=IkQEDTSjkGQKq1Nm/ml95homcvJTtv1ImMkT+7I8WovNtHAZweYiL+20JdVOolGj3
         5i6Am8CdVMm9iffsGZS2ytqb4zvj5GTdM4MDKp+iN+Vc4RF+StmWG94qU/M3izzDWz
         l3/1DBbH5O7YBc0ZUBvdM+s6aAaB9ZBbNRxMfcHw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1510766314;
        bh=aqNasY6cGwEUtgUFNtfqBf1O1H5W9zaNTSl2MoSQsyE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=iqcQlPtRfkzqQ6B7ye7uppCY6kdj9tpYmX7OffYad4BLW+h/Lkv7tGMEeabTvHe4k
         chlB42UnOLlbA6xvsbUf73WKaKm5gxU3qiGG3hVRz0Rvz0Wm2jTZL2FfbZ+Xa8SnVm
         XszL1EW3sWo1RuFIWjowT5iFIynXHkOuhCEyqPMk=
In-Reply-To: <20171115170524.GU983427-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sramana-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 11/15/2017 10:35 PM, Tejun Heo wrote:
> On Wed, Nov 15, 2017 at 11:37:42AM +0100, Peter Zijlstra wrote:
>> On Wed, Nov 15, 2017 at 03:56:26PM +0530, Prateek Sood wrote:
>>> Any improvement/suggestion for this patch?
>>
>> I would have done 2 patches, the first one solving the locking issue,
>> the second removing the then redundant async rebuild stuff.
>>
>> Other than that this looks OK I suppose, but I was expecting this to go
>> through the cgroup tree, TJ?
> 
> Will pick them up after -rc1.
> 
> Thanks.
> 

I have made two patches as suggested by Peter and sent for review. 

-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation
Center, Inc., is a member of Code Aurora Forum, a Linux Foundation
Collaborative Project
