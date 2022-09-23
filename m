From: Zhongkun He <hezhongkun.hzk-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH] cgroup/cpuset: Add a new isolated
 mems.policy type.
Date: Fri, 23 Sep 2022 23:26:32 +0800
Message-ID: <ecceec1b-d201-fef5-de91-476c44151517@bytedance.com>
References: <20220904040241.1708-1-hezhongkun.hzk@bytedance.com>
 <YxWbBYZKDTrkmlOe@dhcp22.suse.cz>
 <0e5f380b-9201-0f56-9144-ce8449491fc8@bytedance.com>
 <YxXUjvWmZoG9vVNV@dhcp22.suse.cz>
 <ca5e57fd-4699-2cec-b328-3d6bac43c8ef@bytedance.com>
 <Yxc+HZ6rjcR535oN@dhcp22.suse.cz>
 <93d76370-6c43-5560-9a5f-f76a8cc979e0@bytedance.com>
 <YxmXeC7te2HAi4dX@dhcp22.suse.cz>
 <fa5e5a79-aa1a-a009-d0c8-0a39380a71b6@bytedance.com>
 <120cb50d-d617-a60a-ec24-915f826318f1@bytedance.com>
 <Yy1gP7wcoCqzRa0B@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=ZWy71aF5Z4g2M7EPQKOVM2PfzynmTIcPbYGqsH4ugQ0=;
        b=Mc/z/AW6VhBGHjGOwfn5PkruFSYFBqwRa5tn3GQM1lteEuCJ+V+6CTTP+G7dOZobuq
         SWkg0q7JprL6fPbvwir3O3D3qKy1ydWGK8W7Kf+IVk+byBRnLMC2DbHJPNBWSU9TBi8L
         VCy9giJRvqA10AGLkdx52plKJ0ZUGujwB2zWMv44LDqZYgwCHropbLoWHZ0KrdngDhws
         GGKp3HoKQvAzGeeqFPEHPEeieFN5NfrQtixeYoOb3q1x11vmTs681STsJInjzjbG2HER
         BS9VPdRm5uNaGZMm5QmPMjCheLjyDIeN8yS14WY2ESUAL5Kc/XQgKtaI5foIEeeb2JTf
         fTKA==
In-Reply-To: <Yy1gP7wcoCqzRa0B-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

> 
> set_mempolicy is a per task_struct operation and so should be pidfd
> based API as well. If somebody requires a per-thread-group setting then
> the whole group should be iterated. I do not think we have any
> precendence where pidfd operation on the thread group leader has side
> effects on other threads as well.

Hi Michal,

I got it, thanks for your suggestions and reply.
