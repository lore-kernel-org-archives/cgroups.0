From: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [Phishing Risk] [External] Re: [PATCH] blk-cgroup: set blkg
 iostat after percpu stat aggregation
Date: Tue, 15 Feb 2022 20:10:05 +0800
Message-ID: <c4b3b8c3-890a-59d1-623a-3341abcf290e@bytedance.com>
References: <20220213085902.88884-1-zhouchengming@bytedance.com>
 <Ygqmjsbu96+UZDw+@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Rvc5VFNuQvOUoAjdswhh5nR82Ho+mPvuJf8m7WDO3Qs=;
        b=xtE/ytqcCPY1yN5pIplQeeZomXpKV5da0WHr6CnDmO4fmr9rg8Zr9b3UABGLxx8V3u
         NDNsNtiv5jxI1QCHK7eI3QQKYPuOnQoFIk7qgfFewZ7YvL7MNyQAmr7w1JwmKQxwcAiw
         GJwoOrkN7OZ4C4IKmVNpoSCOB3apeP2UORrDJRJa1/lkq5lBbX+pSCaIM1fIYLOQep5i
         OdNRbnYd+Qc74cE8kHsyBYQNbsumy3whUl0KtR/KQb+tWGWQJ5FrYimIpbZejLR/Gefh
         cLpIHXyY/a5xV3XSh9/zfHngVTYXBqsFWdxKHGGF409sAG6RXss20rkdj+DIkw7G2Hld
         tGKQ==
Content-Language: en-US
In-Reply-To: <Ygqmjsbu96+UZDw+-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, boris-UrQYPotlwNs@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2022/2/15 2:59 上午, Tejun Heo wrote:
> On Sun, Feb 13, 2022 at 04:59:02PM +0800, Chengming Zhou wrote:
>> Don't need to do blkg_iostat_set for top blkg iostat on each CPU,
>> so move it after percpu stat aggregation.
>>
>> Fixes: ef45fe470e1e ("blk-cgroup: show global disk stats in root cgroup
>> io.stat")
> 
> I'm not sure Fixes tag is necessary here.

I'm also not sure, since the io.stat reports correct data after all. I put
the Fixes tag here in case someone wants it. Please feel free to delete it.

Thanks.

> 
>> Signed-off-by: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> 
> but other than that,
> 
> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> 
> Thanks.
> 
