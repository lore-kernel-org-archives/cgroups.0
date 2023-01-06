From: hanjinke <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH v3] blk-throtl: Introduce sync and async
 queues for blk-throtl
Date: Sat, 7 Jan 2023 02:07:38 +0800
Message-ID: <c839ba6c-80ac-6d92-af64-5c0e1956ae93@bytedance.com>
References: <20221226130505.7186-1-hanjinke.666@bytedance.com>
 <20230105161854.GA1259@blackbody.suse.cz>
 <20230106153813.4ttyuikzaagkk2sc@quack3> <Y7hTHZQYsCX6EHIN@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=//4YyY+R3Zvxj//qrfQ/8SUpcqPL2BUP4S2f+8LppsI=;
        b=GjNGe87iarMz9xzLWJbvuTpMDWCQA2+W1WVxnP+fJYjnmMv7m/6p9+01ELwcZGYByN
         sp+8DGsECa67c/twZDqrpNNIeNrZR84IzoPJgyp25dPCHvXXT7VlsAXvjYRBKMK9KT0K
         U3WxvQeLLXYTtteKi9iuV0Xmx18QLICl7dsCCpXPElWxet+sH1a4y7Y7TWBiTaU4nhZo
         80fA6E6O8WzBkJgHlTbZ5T2b4qjLpExO7alWown5M6oReIgqYyQXQq3dayus2N1Ut+S8
         V+J0Tf2Bq4Y+HIoRdcE92fZz0DNtzggABrgBoSijo2SFq+rEuHkMXS8gQRQAQeGL/gRn
         RKmQ==
In-Reply-To: <Y7hTHZQYsCX6EHIN-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yinxin.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org



在 2023/1/7 上午12:58, Tejun Heo 写道:

> 
> Jinke, is the case you described in the original email what you actually saw
> in production or a simplified test case for demonstration? If the latter,
> can you describe actual problems seen in production?
> 
> Thanks.
> 

Hi

In our internal scenario, iocost has been deployed as the main io 
isolation method and is gradually spreading。

But for some specific scenarios with old kernel versions, blk-throtl
is alose needed. The scenario described in my email is in the early 
stage of research and extensive testing for it. During this period，some 
priority inversion issues amoug cgroups or within one cgroup have been 
observed. So I send this patch to try to fix or mitigate some of these 
issues.

Thanks

Jinke
