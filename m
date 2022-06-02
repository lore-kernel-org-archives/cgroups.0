From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 4/4] blk-cgroup: Document the design of new lockless
 iostat_cpu list
Date: Thu, 2 Jun 2022 15:12:53 -0400
Message-ID: <3ba0799f-c008-bbdf-bbc1-626d8bb4b821@redhat.com>
References: <20220602133543.128088-2-longman@redhat.com>
 <20220602185401.162937-1-longman@redhat.com>
 <YpkJ6rDTR24ScuEq@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654197179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ura6WzJRfDCe639hKtMahR5YURQ9sPrCG1JQZM8gR34=;
        b=S6rlxM7HbD3d17TGM8/czeA9cqUqnGMJOgaUcnCv4POcNr/+40EqpJz230hOZx4ngvC7Xd
        kSrYTZoTBNdQAjiyG0cuMpAxGGUlavwKFYBpTcCwE6+7L+23uaoSRxlOB9o5K25stG1odS
        ML3GeucOvtYqSRnNBrx3M4Hr/zhljHU=
Content-Language: en-US
In-Reply-To: <YpkJ6rDTR24ScuEq-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 6/2/22 15:05, Tejun Heo wrote:
> On Thu, Jun 02, 2022 at 02:54:01PM -0400, Waiman Long wrote:
>> A set of percpu lockless lists per block cgroup (blkcg) is added to
>> track the set of recently updated iostat_cpu structures. Add comment
>> in the code to document the design of this new set of lockless lists.
>>
>> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>
> Thanks.

I have just realized that I forgot to free the percpu blkcg->lhead in 
blkcg_css_free(). I will send out v6 with this change as well as 
integrating this documentation patch back. Sorry for the omission.

Thanks,
Longman

