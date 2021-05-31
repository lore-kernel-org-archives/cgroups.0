From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC 0/7] Introduce memory allocation speed throttle in memcg
Date: Mon, 31 May 2021 11:20:46 -0700
Message-ID: <CALvZod4FUEXuqs8mKiN-WdmF2eCi29=aRG-cOaUQEDCbHdXQRA@mail.gmail.com>
References: <cover.1622043596.git.yuleixzhang@tencent.com> <CALvZod4SoCS6ym8ELTxWd6UwzUp8m_UUdw7oApAhW2WRq0BXqw@mail.gmail.com>
 <CACZOiM3VhYyzCTx4FbW=FF8WB=X46xaV53abqOVL+eHQOs8Reg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LfVhFBreFM3+hibS+ZUYxXnl8ONhxdP+w+9OFOxmAhE=;
        b=YBmR9AxxYxpwcV2YLzagXsntolLPZCaQTDTHWwWzremKSRujeGHnr7cEFxCHJDPpC8
         uaLyP5C8RRhr4s4wXlYMDiPX0c8RklFoJxwVY2bnKnNBvShdMuoNijcv/8zIs79d5SXC
         zdvUVhGtoCsnnLEyKLRSV18nJCg4OCgmpAJhGMhhMAvk0Gx5HCxFRpRoKZd1JPVFkY4B
         F2LjxX5mJqXCi72QGNSMJEayaBTXYrT/wmY5tLoc3DV26DQXybMi3YJZH00vfuCt6bo0
         6UvsBGhqYIYVdHjwjPqABXJ7CAvie8+hqdWyqFE+u0Eu2NfkhRwAUMfTtrN4qV+1fR/n
         awhg==
In-Reply-To: <CACZOiM3VhYyzCTx4FbW=FF8WB=X46xaV53abqOVL+eHQOs8Reg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: yulei zhang <yulei.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, benbjiang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, Wanpeng Li <kernellwp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On Mon, May 31, 2021 at 5:11 AM yulei zhang <yulei.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
[...]
> > Can you please explain why memory.high is not good enough for your
> > use-case? You can orchestrate the memory.high limits in such a way
> > that those certain cgroups hit their memory.high limit before causing
> > the global reclaim. You might need to dynamically adjust the limits
> > based on other workloads or unaccounted memory.
> >
>
> Yep, dynamically adjust the memory.high limits can ease the memory pressure
> and postpone the global reclaim, but it can easily trigger the oom in
> the cgroups,

Can you please elaborate a bit more on this? The memory.high has a
strong throttling mechanism, so if you are observing memory.high being
ineffective then we need to fix that. Also can you please explain a
bit more on the specific of the workload which is able to escape
memory.high throttling e.g. the normal number of processes/threads in
the workload?
