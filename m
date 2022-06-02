From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 2/3] blk-cgroup: Return -ENOMEM directly in
 blkcg_css_alloc() error path
Date: Thu, 2 Jun 2022 13:17:18 -0400
Message-ID: <6674e652-b083-2859-3cba-9eca6c721fba@redhat.com>
References: <20220601211824.89626-1-longman@redhat.com>
 <20220602133543.128088-3-longman@redhat.com>
 <YpjiYPscJst5iuyv@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654190242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6YpvaMVW61kZDAQpHfhp/j+cfCfwUKP7vhTQl8WVi3M=;
        b=EtUibsxCQRglE7LWFxqX5oNapuVRPB2qi3FJLa5add+D30LtJC255PYHRKhzFRee7kYcwu
        CiHxLwt+VOaxvQE4xsvQfO1KHQC2ExPDkjEM/PUeWbilPnBQYdgYJUnBqyjbLWjd/zE85S
        LMZqSpFRFbiWWMdPCr+itXgcAPpA3FU=
Content-Language: en-US
In-Reply-To: <YpjiYPscJst5iuyv-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 6/2/22 12:16, Tejun Heo wrote:
> On Thu, Jun 02, 2022 at 09:35:42AM -0400, Waiman Long wrote:
>> For blkcg_css_alloc(), the only error that will be returned is -ENOMEM.
>> Simplify error handling code by returning this error directly instead
>> of setting an intermediate "ret" variable.
>>
>> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>
> But I don't understand why this would trigger warning. Can you please
> elaborate why this is needed.
>
> Thanks.

I forgot to set "ret" in my original patch 2 in case of allocation 
error. I didn't got a warning in my own build, maybe I didn't explicitly 
enable more warning. I could have modified the patch to set "ret" on 
error, but the "ret" setting looks duplicative to me and so I added this 
patch to get rid of it.

Thanks,
Longman

