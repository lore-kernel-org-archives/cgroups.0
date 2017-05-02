From: Joseph Qi <jiangqi903-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] blk-cgroup: fix wrong unlock order when parse per blkg
 config
Date: Tue, 2 May 2017 09:10:38 +0800
Message-ID: <89d473b7-a62e-201f-883e-c0f500f25aec@gmail.com>
References: <be8d9709-84fe-d2df-f294-a12701675e27@gmail.com>
 <20170428212233.GE22354@htj.duckdns.org>
 <c39a752d-034e-02a0-3c46-892e42c6616a@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=Lr7Et3fSJCcghp/uIoS0snFkdVlQ01tfDv2srcX35FE=;
        b=On4JoGu5lF6NqoOTm8gm1mDxQvJG0zAiiATP9H+SNPDyMQSfNfVDcqeVadt64JZFjR
         95ufrqQVXLHYp8GXkjKPb+EZOfsrthZboZ2pj1Dbw9nLOiQcF4umudPFdRrD3FbklHfq
         UAcblpkhmdJHYI8EnOsI7v8y9+XE5trlv99oW2lczcd111jUMPfiwvI7D/DEbEADy3Ik
         DTw2q9PLbrSuDqTYXvxKqINXD5UqhTRDekD2sWdUGIlCyUF+7Yb9UDxyh7PXt9Vj8JUO
         iOyyHUey1p4b3oPtL+2EOAdJkszwB86YUJfOtveANxEuaJZhhSqZZLEMFYqX3xKIIk7l
         gq1w==
In-Reply-To: <c39a752d-034e-02a0-3c46-892e42c6616a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wenqing.lz-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org, boyu.mt-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org, qijiang.qj-gPhfCIXyaqCqndwCJWfcng@public.gmane.org

Hi Tejun,
	
I've checked the upstream mainline and found that this is already fixed
as part of your commit 457e490f2b74 ("blkcg: allocate struct blkcg_gq
outside request queue spinlock"). So I do not have to resend it any
more, thanks.

Thanks,
Joseph

On 17/5/2 08:41, Joseph Qi wrote:
> Fine, I will explain so and resend it later.
> 
> Thanks,
> Joseph
> 
> On 17/4/29 05:22, Tejun Heo wrote:
>> Hello,
>>
>> On Mon, Apr 24, 2017 at 06:52:05PM +0800, Joseph Qi wrote:
>>> From: Joseph Qi <qijiang.qj-gPhfCIXyaqCqndwCJWfcng@public.gmane.org>
>>>
>>> In case of error blkg in blkg_conf_prep, we should unlock
>>> queue->queue_lock first and then rcu, just like blkg_conf_finish.
>>
>> I get that this is inconsistent but why is this wrong?  If this is for
>> consistency, can you please explain so in the commit so that people
>> don't confuse it for an actual bug fix?
>>
>> Thanks.
>>
