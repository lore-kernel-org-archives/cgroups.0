From: Jianyu Zhan <nasa4836@gmail.com>
Subject: Re: [PATCH 2/4] mm/memcontrol.c: use accessor to get id from css
Date: Tue, 22 Apr 2014 16:08:04 +0800
Message-ID: <CAHz2CGW62TMEVuqj8ixpPP_hOW6r4Q6VkZRtG_kKc6ibd2V=jA@mail.gmail.com>
References: <cover.1398147734.git.nasa4836@gmail.com> <2c63c535f8202c6b605300a834cdf1c07d1bafc3.1398147734.git.nasa4836@gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=S+4m7v1GfHSvxXNpUwYvSUMM3FzquLJ0xbmMNbwSY1c=;
        b=yFrNLmSib7ay3RcC1Vkhdsb0c1C9Ws7pAqtZdS2vkd3o+Al4SSOYZE20ztkY8Sc3Kw
         T8Zd2THA/RPl16aatV9cdb8VY9D1i9HJOwxbVqhH+V2paE87wDJ6mtPK15VJY8SUQn/W
         Kv0Qb+oth2LurXsZKFKqUroMU4Ro9Qczvmz0zHgRyxTC1y+UEgjBWrydrCx9PPMV8bqo
         73Gysum8ec3PVwXw8i+1M4o6wfr7EXZzyZFUukXqxtueTmbyOKF0cvyhgZVVhOQc2S6y
         28xcaxorAI8qp4xk7KB2fPbN93bHhZ4DS+OyNXG0NrGQQgEDHENcHYj58ZCHAcsntctC
         Ac8A==
In-Reply-To: <2c63c535f8202c6b605300a834cdf1c07d1bafc3.1398147734.git.nasa4836@gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>, kamezawa.hiroyu@jp.fujitsu.com
Cc: Cgroups <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Jianyu Zhan <nasa4836@gmail.com>

On Tue, Apr 22, 2014 at 2:30 PM, Jianyu Zhan <nasa4836@gmail.com> wrote:
> This is a prepared patch for converting from per-cgroup id to
> per-subsystem id.
>
> We should not access per-cgroup id directly, since this is implemetation
> detail. Use the accessor css_from_id() instead.
>
> This patch has no functional change.

Hi,  I'm sorry.  This patch should be applied on top of its previous patch:
https://lkml.org/lkml/2014/4/22/54

Sorry for my fault , not cc'ing this mail-list in that patch.

Thanks,
Jianyu Zhan

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
