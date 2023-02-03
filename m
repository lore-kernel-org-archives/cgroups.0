From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: introduce entrance for root_mem_cgroup's current
Date: Fri, 3 Feb 2023 19:18:40 +0000
Message-ID: <20230203191840.jh5akertunyk4cx7@google.com>
References: <1675312377-4782-1-git-send-email-zhaoyang.huang@unisoc.com>
 <Y9tz+0J9fw+Z+O+O@dhcp22.suse.cz> <CALvZod5E0s9Vu3wq-Fuvs9z=ViMADn3aNL0f56ELGmFzxKCtkg@mail.gmail.com>
 <Y9zM0GbmfKdvy3bL@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eZSuQF+nJSrdc5oiEMr2Huwq3nLEZDXbSVvbFcSGTVg=;
        b=kdvGxpkdksPrb8vTbUnTey3IDTfFIN/yZjMk3GpmvkGAN7QnnRU6Wm0uwX3hcaow+7
         T2nGox0V65Lb0aAooaAgQxOALFaDDn7Qve5uGl0s7QISeFrOG8kcYQelo67MvBD7yLAI
         wc+a19ViT+94h4/58b3oOPid3z4l2Fq2+c1avj5d4t2Zj0hB405MokIZ0ZN9mKkBjudm
         Z/Z2WZJhC65WygoAsw1ZZUC07Rx3Inh91guxjjrPRlS60hV0i8P93hJQx8GmRA84m9T/
         8//OzllptVYu4emQ1Ulx5izXKaecOAF8be+n3ke0lVMJtBRwjUSJrg487jTUVkl/EKPk
         46DA==
In-Reply-To: <Y9zM0GbmfKdvy3bL-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org

On Fri, Feb 03, 2023 at 09:58:56AM +0100, Michal Hocko wrote:
[...]
> > 
> > One advantage I can see is if someone is looking for usage for all top
> > containers (alive or zombie) but I wanted to know if that was the real
> > motivation behind the patch.
> 
> Isn't that just a global stats that we already display via /proc files?
> 

Things are a bit complicated for kernel memory. Let's take a simple
example where there are no processes in the root memcg. In this case the
user memory stats should be similar to the global stats under /proc
because we always charge user memory. However the kernel memory has to
be opted-in to be accounted. So, we have a lot of allocations which are
in the global stats but not in the memcg stats. We can traverse the top
level memcgs to get kernel stats and subtract it from the global stats
which will give the sum of zombie kernel memory and unaccounted kernel
memory. For debugging and history/analysis purpose, differentiating
between zombie and unaccounted makes sense.
