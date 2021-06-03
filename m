From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [RFC 0/7] Introduce memory allocation speed throttle in memcg
Date: Thu, 3 Jun 2021 12:38:57 +0100
Message-ID: <YLi/UeS71mk12VZ3@chrisdown.name>
References: <cover.1622043596.git.yuleixzhang@tencent.com>
 <CALvZod4SoCS6ym8ELTxWd6UwzUp8m_UUdw7oApAhW2WRq0BXqw@mail.gmail.com>
 <CACZOiM3VhYyzCTx4FbW=FF8WB=X46xaV53abqOVL+eHQOs8Reg@mail.gmail.com>
 <YLZIBpJFkKNBCg2X@chrisdown.name>
 <CACZOiM21STLrZgcnEwm8w2t82Qj3Ohy-BGbD5u62gTn=z4X3Lw@mail.gmail.com>
 <CALvZod7w1tzxvYCP54KHEo=k=qUd02UTkr+1+b5rTdn-tJt45w@mail.gmail.com>
 <CACZOiM3g6GhJgXurMPeE3A7zO8eUhoUPyUvyT3p2Kw98WkX8+g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wiKfBxTb65s9ryPk0mFCpTofRIT4fNKHgWxxNUTFSrY=;
        b=LEUQzE+TXNrsF7VkTKq1fOZ1V0WA+d+HQMLVNnkA/g+4Qw712FXlgXSf8/gadK8Bro
         Kz2E5md4HlTtFR6XSPmsArHCMFvNKKbUz8s6bvVZ8h3VmtAvpACaB0RAtlLg2BQA0irt
         RAl3xa49jeclb3y6buUFOf1iCnIe8lU5lINRo=
Content-Disposition: inline
In-Reply-To: <CACZOiM3g6GhJgXurMPeE3A7zO8eUhoUPyUvyT3p2Kw98WkX8+g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: yulei zhang <yulei.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, benbjiang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, Wanpeng Li <kernellwp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

yulei zhang writes:
>Thanks. IMHO, there are differences between these two throttlings.
>memory.high is a per-memcg throttle which targets to limit the memory
>usage of the tasks in the cgroup. For the memory allocation speed throttle(MST),
>the purpose is to avoid the memory burst in cgroup which would trigger
>the global reclaim and affects the timing sensitive workloads in other cgroup.
>For example, we have two pods with memory overcommit enabled, one includes
>online tasks and the other has offline tasks, if we restrict the memory usage of
>the offline pod with memory.high, it will lose the benefit of memory overcommit
>when the other workloads are idle. On the other hand, if we don't
>limit the memory
>usage, it will easily break the system watermark when there suddenly has massive
>memory operations. If enable MST in this case, we will be able to
>avoid the direct
>reclaim and leverage the overcommit.

Having a speed throttle is a very primitive knob: it's hard to know what the 
correct values are for a user. That's one of the reasons why we've moved away 
from that kind of tunable for blkio.

Ultimately, if you want work-conserving behaviour, why not use memory.low?
