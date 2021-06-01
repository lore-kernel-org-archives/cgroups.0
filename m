From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [RFC 0/7] Introduce memory allocation speed throttle in memcg
Date: Tue, 1 Jun 2021 15:45:26 +0100
Message-ID: <YLZIBpJFkKNBCg2X@chrisdown.name>
References: <cover.1622043596.git.yuleixzhang@tencent.com>
 <CALvZod4SoCS6ym8ELTxWd6UwzUp8m_UUdw7oApAhW2WRq0BXqw@mail.gmail.com>
 <CACZOiM3VhYyzCTx4FbW=FF8WB=X46xaV53abqOVL+eHQOs8Reg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=38OJXjf9apU3psNdgfiCp5ABcftQyKat/l3MsHmkX8Y=;
        b=UQ3kqRg6KLoUWQ3nlWkbFWXvc+pq1x7GyJUmyfTz8pzxAqM6/C+fUQCP4mpRpej3nc
         DVWQl8jdJXGSWCePj4rWYdSiLZTlgTiQedHeNTUEUAmWEoGZ/jSqfEWVeksFUMlvj99e
         1Mpl/9WfbjTWMfyifeHRUjGknkITJjxkXmKY4=
Content-Disposition: inline
In-Reply-To: <CACZOiM3VhYyzCTx4FbW=FF8WB=X46xaV53abqOVL+eHQOs8Reg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: yulei zhang <yulei.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, benbjiang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, Wanpeng Li <kernellwp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

yulei zhang writes:
>Yep, dynamically adjust the memory.high limits can ease the memory pressure
>and postpone the global reclaim, but it can easily trigger the oom in
>the cgroups,

To go further on Shakeel's point, which I agree with, memory.high should 
_never_ result in memcg OOM. Even if the limit is breached dramatically, we 
don't OOM the cgroup. If you have a demonstration of memory.high resulting in 
cgroup-level OOM kills in recent kernels, then that needs to be provided. :-)
