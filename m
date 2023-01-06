From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [External] Re: [PATCH v3] blk-throtl: Introduce sync and async
 queues for blk-throtl
Date: Fri, 6 Jan 2023 08:15:59 -1000
Message-ID: <Y7hlX4T1UOmQHiGf@slm.duckdns.org>
References: <20221226130505.7186-1-hanjinke.666@bytedance.com>
 <20230105161854.GA1259@blackbody.suse.cz>
 <20230106153813.4ttyuikzaagkk2sc@quack3>
 <Y7hTHZQYsCX6EHIN@slm.duckdns.org>
 <c839ba6c-80ac-6d92-af64-5c0e1956ae93@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tFVy3Y9MVCWte671WOFf60PfUPv+ycHx3SxmfV5kFG8=;
        b=lbibIMuJyMXbJ2f2OyL1viffjumwMgpmMNynEDue06Z/2mLcY1PturmpBQ0tKz+++O
         zcR2ZA6fIwexsqo2cb8HATM3qQbVR1vIJDfjMrJwfXDravZuN2XGnn211EJY2m4Pekrz
         ZVat6RYBgxyrhjNjFOy4L1ereNBKykwwzQU/zYEZPSqFIHwOjbamjqY2NijUtQK8BrJo
         2nW31/OdZsXqJn/cfjY7+T6dm/lg933yEtQaz4xDtodbAm6qvYILdifMMTBT0N3KQvvv
         2aIxeB9W2cozL3Gk8bbaJX5HG9/ThseB+GM55mLOAURBKE3rgYfSMlL4/rdL1Nq/cJVC
         GLiA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c839ba6c-80ac-6d92-af64-5c0e1956ae93-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: hanjinke <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yinxin.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

Hello,

On Sat, Jan 07, 2023 at 02:07:38AM +0800, hanjinke wrote:
> In our internal scenario, iocost has been deployed as the main io isolation
> method and is gradually spreading。

Ah, glad to hear. If you don't mind sharing, how are you configuring iocost
currently? How do you derive the parameters?

> But for some specific scenarios with old kernel versions, blk-throtl
> is alose needed. The scenario described in my email is in the early stage of

Yeah, I think we use blk-throttle in very limited cases currently but might
need to deploy hard limits more in the future.

> research and extensive testing for it. During this period，some priority
> inversion issues amoug cgroups or within one cgroup have been observed. So I
> send this patch to try to fix or mitigate some of these issues.

blk-throttle has a lot of issues which may be difficult to address. Even the
way it's configured is pretty difficult to scale across different hardware /
application combinations and we've neglected its control performance and
behavior (like handling of shared IOs) for quite a while.

While iocost's work-conserving control does address a lot of the use cases
we see today, it's likely that we'll need hard limits more in the future
too. I've been thinking about implementing io.max on top of iocost. There
are some challenges around dynamic vrate adj semantics but it's kinda
attractive because iocost already has the concept of total device capacity.

Thanks.

-- 
tejun
