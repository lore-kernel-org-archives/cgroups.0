From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: introduce entrance for root_mem_cgroup's current
Date: Wed, 1 Feb 2023 22:30:27 -0800
Message-ID: <CALvZod4Z5CCD-zgHgYt3iRR1JG60GXCuhWm+fpzXo4ivTJx09Q@mail.gmail.com>
References: <1675312377-4782-1-git-send-email-zhaoyang.huang@unisoc.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jutdeR9oHL1XowdDfALeObIWjrp8V4004PfsmSQZg1g=;
        b=JK08Tze1A+Lyna644POZuDY/+OwdmSbAZVouxrTkjQWMsNtIsMYLDAlY5a+tX84mfe
         1KXk2GCLhu5jSM4PXK9gsNTvf/lE0Yee1v/RNeDL1i66dahCdni38Ic/HU4SNAhBd5Gu
         3lzmxA3Sa0P4ks7MMun8oeguoXBvx10wmPbjRuoyIEs63pKtLOwqgHVBRkie9pJAP2TL
         qgjgHXNYNRo6UB1a/HWfFm4hqHnLtQoO+CRpq8QrfmWDcPDel5V4s3RfGKOjexa99qCF
         Lapslwe1x8pNdKEvS5X9IWIwSim2KtcbNCvtwyBEWQ4lnDb8vvVx3xP7D2FMqYE7LnEL
         lofw==
In-Reply-To: <1675312377-4782-1-git-send-email-zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org

On Wed, Feb 1, 2023 at 8:34 PM zhaoyang.huang <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org> wrote:
>
> From: Zhaoyang Huang <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
>
> Introducing memory.root_current for the memory charges on root_mem_cgroup.

Why and how are you planning to use it?
