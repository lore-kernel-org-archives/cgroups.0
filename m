From: Zhongkun He <hezhongkun.hzk@bytedance.com>
Subject: Re: [Phishing Risk] Re: [Phishing Risk] Re: [Phishing Risk]
 [External] Re: [PATCH] cgroup/cpuset: Add a new isolated mems.policy type.
Date: Fri, 9 Sep 2022 11:00:57 +0800
Message-ID: <262052c8-c03c-24c4-9163-5df8e9f312be@bytedance.com>
References: <20220902063303.1057-1-hezhongkun.hzk@bytedance.com>
 <YxT/liaotbiOod51@slm.duckdns.org>
 <c05bdeac-b354-0ac7-3233-27f8e5cbb38a@bytedance.com>
 <YxeBGeOaQxvlPLzo@slm.duckdns.org>
 <d323bd95-476b-0901-855e-14c8796d1b23@bytedance.com>
 <Yxi4EYxMaPNkL+of@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=43jwGnS59LTzri1tkRF1HTsqNOy+AaUcwDQj3xSUi9Y=;
        b=qM7Qs8uwZ40xVP0T/DV9fdTIwI8Ar1eOIcgUKjE3i9KoFTMohzGLYbHkhwyqZe7E0d
         Q1YmX6zciTiD7MuhNmdVrE3y0P4WyTeQNRE/4WUPtdHtX1LOLatHiueeuNJBzYIqHTpA
         izuKDQlivt/6Fj0DEObTu6oJxDRZHjHxZZ8xP8xpJ1uwQwOzEv8vAI5YduienxUtn/xc
         grqIzRFQMPivQAgRzcDBA5D5Cxh/ZUJJEXrkD/TbmOzd3d5owHGQyD1twfxhyyKqvrit
         uFpsDm70Mcz7N4AZJ6rjz1dFaGIsnntIj0ZXETPId6ungfNrNRz5p7IpTS7QqyD4AR2f
         GkFQ==
In-Reply-To: <Yxi4EYxMaPNkL+of@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: lizefan.x@bytedance.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Tejun,
> Hello,
> 
> On Wed, Sep 07, 2022 at 08:06:30PM +0800, Zhongkun He wrote:
>> It would be better if one process had a way to dynamically modify the
>> mempolicy of another process. But unfortunately there is no interface or
>> system call to do that in userspace.
> 
> If you need to change the properties dynamically, I suggest adding this as a
> dynamic per-process interface first. That's more generic and useful for more
> cases.
> 
> Thanks.

Got it, thanks for your suggestion and reply.
