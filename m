From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH v2 1/3] misc_cgroup: add support for nofile limit
Date: Thu, 29 Jul 2021 14:37:32 +0800
Message-ID: <1a5153d3-5cdc-58c5-858f-3c369d69e881@gmail.com>
References: <3fd94563b4949ffbfe10e7d18ac1df3852b103a6.1626966339.git.brookxu@tencent.com>
 <YP8ovYqISzKC43mt@mtj.duckdns.org>
 <b2ff6f80-8ec6-e260-ec42-2113e8ce0a18@gmail.com>
 <YQA1D1GRiF9+px/s@mtj.duckdns.org>
 <ca2bdc60-f117-e917-85b1-8c9ec0c6942f@gmail.com>
 <YQEKNPrrOuyxTarN@mtj.duckdns.org>
 <ed8824d5-0557-7d38-97bd-18d6795faa55@gmail.com>
 <YQF5/8Zb/iY5DS7f@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mn2QXsC9iXN6n0TPueHgxmDAwTtq1MsZU9RTs4Fr/hY=;
        b=fULRnTdszNXc8PP2zScOdaash0b/Ue5x/8SbvvdEgbnSZ9++AHkKX1BMIbqqAWS543
         T5qpIoeSR5Xfhr2XKcxJjw5LMQzQ1fJGHO5R4iJDoT+cVvAHaLN3ET04tmF9tPqzL82a
         sI5/C2o/SnRDYWLmjn5TxWbCgRbIIOjq1Cw5CiR4PUvOxMno67YpRr7f24NBUE77mRUB
         hEgl0SHs7qK6u+8gvhEp9JCJjf1m45Ucz/Grr0B2ZEf+cLeq+MGWY+A8aMvflAYUxqn7
         eHItlxuEIVouEpLW3G+j/YUt+0JpI32zgc0jJ+r1WI/qfgrK23Ne+Arkh6wdmTQa6V+d
         HXSQ==
In-Reply-To: <YQF5/8Zb/iY5DS7f-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


Thanks for your time.

Tejun Heo wrote on 2021/7/28 11:38 下午:
> Hello,
> 
> On Wed, Jul 28, 2021 at 05:47:05PM +0800, brookxu wrote:
>> But considering stability issues(k8s), There are still many production environments use
>> cgroup v1 without kmem. If kmem is enabled, due to the relatively large granularity
>> of kmem, this feature can also prevent the abnormal open behavior from making the entire
>> container unavailable? but I currently do not have this scenario.
> 
> Now we are repeating the same points. This simply doesn't justify adding a
> user-facing feature that we have to maintain for eternity.

Ok, thanks you for your patient reply.

> Thanks.
> 
