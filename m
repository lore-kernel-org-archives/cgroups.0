From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] memcg: periodically flush the memcg stats
Date: Fri, 4 Jun 2021 22:33:11 -0400
Message-ID: <YLriZxiWo+2hMI7g@slm.duckdns.org>
References: <20210604015640.2586269-1-shakeelb@google.com>
 <20210604061816.3110-1-hdanton@sina.com>
 <20210605015421.5096-1-hdanton@sina.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=29lRJsQjuBV2gkxHmcl0YVsXyBr/DK6wvVETfCNeSS8=;
        b=aSH8OR3l/TfW20lHlGMmlBEnNYwKTY0v8ReDqkEYtQHu5zJs4KWJRoMClaKHyHg94b
         2KRQPJX8RvzkJsaPljq1XDIm2Q1SXes1rxRAhzxPRJMmLJwIch/xhYeRd2V0Hofxhxn6
         HUNSe5Tra7C39A9YWrS3wPH4b+4O2NE/qdQ1b4aE+HlNwIY2FzAwj6pFFiX2LtZBHLA3
         0PCeTq/zQXTKAwYhvjf/RTO9AJWfyeivntfDgfjMcihsdvv5Z55jRj+QLHeJjV5mVpj4
         P1+QKq6Oi/8KH06mJJNfSYgiqQ08a8ndd+4HVD6xQ/ARs0mB1nqIlRWVeS0gXkAutKck
         p69Q==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210605015421.5096-1-hdanton-k+cT0dCbe1g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hillf Danton <hdanton-k+cT0dCbe1g@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Jun 05, 2021 at 09:54:21AM +0800, Hillf Danton wrote:
> The cond_resched() in cgroup_rstat_flush_locked() matches its appearence in
> your post [1]. So does unbound IMHO.

Ah yeah, this either needs CPU_INTENSIVE or UNBOUND, prolly the latter is
better.

> And the short stuff [2] looks to me like it is incorrect to queue a work
> acquiring mutex lock on to the system_wq. IOW the unbound wq is the right
> thing for any work that might sleep.

This part doesn't make sense. Blocking from per-cpu workqueue is completely
fine. What's not fine is consuming a lot of CPU cycles.

Thanks.

-- 
tejun
