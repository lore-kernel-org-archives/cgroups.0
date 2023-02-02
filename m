From: Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm: introduce entrance for root_mem_cgroup's current
Date: Thu, 2 Feb 2023 14:36:55 +0800
Message-ID: <CAGWkznG6s0RN=gj+nUEfO5KuZw84fxG_KcHMazJu-yJ4OQH5CQ@mail.gmail.com>
References: <1675312377-4782-1-git-send-email-zhaoyang.huang@unisoc.com> <CALvZod4Z5CCD-zgHgYt3iRR1JG60GXCuhWm+fpzXo4ivTJx09Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sjq+FUKGizOs7h66douqWeyIbS6vjmS9C/mxYaq9ggI=;
        b=CEYtJidcoUV7ecHhyZdegKvU786pxfV7Cf5FxLFE3398jNQPQRDXZQko1jktTqOQDl
         DNp9x9yxTsrtdziww+YiXSRZBQ00pRbftQWRDPtF6zMZt1pSLaL53NVdTn5F0W/VKXxq
         TFCWzWoKWKWDRncDMD1Lxc7OTNziHidFFUxN77rhfHInT8P4UvLHiwLlJ9M7+/DZYlWr
         57CpK7zWr/v6jEZewb1/xshww6dRPzpF6qUHj+S1NGacrbzyrootvWW+lLM903u9tAvk
         YYFyuAL4FOxrUDOtRiLB1xirQme2ThIH/lee4JcanhSaZ5BdxW1xF7d7Zb1vOaD/z3PZ
         dWWg==
In-Reply-To: <CALvZod4Z5CCD-zgHgYt3iRR1JG60GXCuhWm+fpzXo4ivTJx09Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org

On Thu, Feb 2, 2023 at 2:30 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Wed, Feb 1, 2023 at 8:34 PM zhaoyang.huang <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > From: Zhaoyang Huang <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
> >
> > Introducing memory.root_current for the memory charges on root_mem_cgroup.
>
> Why and how are you planning to use it?
root_mem_cgroup is lack of such statistic entry for debug purpose,
which is the counterpart of memory.current within other memcgs
