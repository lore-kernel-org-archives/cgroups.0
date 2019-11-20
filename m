From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH -next] writeback: fix -Wformat compilation warnings
Date: Wed, 20 Nov 2019 16:17:51 -0700
Message-ID: <26dc5699-9223-3e35-65f3-955fef7a990a@kernel.dk>
References: <20191114192118.GK4163745@devbig004.ftw2.facebook.com>
 <9D52EBB0-BE48-4C59-9145-857C3247B20D@lca.pw>
 <20191115145540.GP4163745@devbig004.ftw2.facebook.com>
 <1574279778.9585.15.camel@lca.pw>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uo9mEPcaYcwnzYyWGiXlb2tEqoly25jIf2ri/BJ7dDw=;
        b=Am9AlC+yrXpYjI9tLZJABP+RtHy2I4MpTU3JDy2quw9lARH0E9nsUx5sZLzW3WsDXO
         MTT+d/n1iXXdDWbHu/+5ZNlEjJkBCfuMGQ0lkn8Y7lm/Tzm4N0xy3n8V3/0Et0gCoKEN
         La77ktcLIHHNXLrDobr2UBGIDQa807YwOkRStoKCQx7d8nF5nRTY9eGyAdB04aZCf5yD
         rO4aRJlugOJko5ct311BHN7FOI/OtYpsdzrpnaN7mckQkPbFwVkF+LgJJq63UARVC8nL
         O2ZgCy5Q6Agt+f5TU+Sl3EUB3XFTfODjPAndMGYek+NU+pNGWBS4nA0GY5D6/JQ4Jzi9
         BNsA==
In-Reply-To: <1574279778.9585.15.camel@lca.pw>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Qian Cai <cai@lca.pw>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: jack@suse.cz, gregkh@linuxfoundation.org, cgroups@vger.kernel.org, heiko.carstens@de.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org

On 11/20/19 12:56 PM, Qian Cai wrote:
> On Fri, 2019-11-15 at 06:55 -0800, Tejun Heo wrote:
>> On Thu, Nov 14, 2019 at 07:26:21PM -0500, Qian Cai wrote:
>>>
>>>
>>>> On Nov 14, 2019, at 2:21 PM, Tejun Heo <tj@kernel.org> wrote:
>>>>
>>>> Acked-by: Tejun Heo <tj@kernel.org>
>>>
>>> Tejun, suppose you will take this patch via your tree together with the series or should I Cc Andrew who normally handle this file?
>>
>> Patches in this area usually goes through Jens's block tree.
> 
> I remember that last time Jens had no interests in picking up trivial patches
> like this one. See the commit d1a445d3b86c ("include/trace/events/writeback.h:
> fix -Wstringop-truncation warnings").
> 
> Andrew, care to pick up this again?
> 
> https://lore.kernel.org/lkml/1573751861-10303-1-git-send-email-cai@lca.pw/

I'm fine with picking it up, this one isn't trivial and it's fixing
warnings. But I didn't (and don't) carry f05499a06fb4 in my tree,
so it'd be more logical to funnel this one through the tree that
has the offending commit.

-- 
Jens Axboe

