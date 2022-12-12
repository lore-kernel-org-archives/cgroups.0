From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH-block v2 1/3] bdi, blk-cgroup: Fix potential UAF of blkcg
Date: Mon, 12 Dec 2022 17:16:38 -0500
Message-ID: <b60f19c9-1e40-d621-dae5-f42bf99d6e90@redhat.com>
References: <20221211222058.2946830-1-longman@redhat.com>
 <20221211222058.2946830-2-longman@redhat.com>
 <Y5enmzQM7BIiEv9n@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670883409;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8jEJGlD5zSDTeu+llNmFOn5ERqJjpd9o8G/piU1li3s=;
        b=K9m0r0dmaYxqLqrpXmr8X/ZIhGKOoCiHYTE2UxTGsYI+CQtTDWSR3FYHmdWLiwMqlJsRKZ
        NuHaWeC2mPuu03zBYn3mC5bZYZ9Y8Dg8d8zUNQmSme4j5AzapiRy1ZGzWAchv+MraAgtlt
        gT4aCO5nwb5KtjP3pZaMru5aHbLFJCc=
Content-Language: en-US
In-Reply-To: <Y5enmzQM7BIiEv9n-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, "Dennis Zhou (Facebook)" <dennisszhou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yi Zhang <yi.zhang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


On 12/12/22 17:13, Tejun Heo wrote:
> On Sun, Dec 11, 2022 at 05:20:56PM -0500, Waiman Long wrote:
>>   static void blkcg_destroy_blkgs(struct blkcg *blkcg)
>>   {
>> +	/*
>> +	 * blkcg_destroy_blkgs() shouldn't be called with all the blkcg
>> +	 * references gone.
>> +	 */
>> +	if (WARN_ON_ONCE(!css_tryget(&blkcg->css)))
>> +		return;
> Wouldn't it make more sense to use percpu_ref_is_zero()? It's not like the
> obtained extra reference does anything, right?

Yes, that makes sense. Will incorporate the change in the next version.

Thanks,
Longman

