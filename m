From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/2] memcg: dump memory.stat during cgroup OOM for v1
Date: Fri, 28 Apr 2023 11:44:11 +0200
Message-ID: <ZEuVaxSUo7WxLn3K@dhcp22.suse.cz>
References: <20230426133919.1342942-1-yosryahmed@google.com>
 <20230426133919.1342942-3-yosryahmed@google.com>
 <ZElC127xlU2NtlqF@dhcp22.suse.cz>
 <CAJD7tkZ1cODXRuVQ3fWL0s=VsyKZqDPPNqFZec_COAXm0XfXWA@mail.gmail.com>
 <ZEqBesAJFfLZI65/@dhcp22.suse.cz>
 <CAJD7tkac7VKV6Ob8qQWzhm8Ayyk3xB0YCY6edL-TxpXV3aCzXA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1682675051; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fiJTpK/XRgtTp6ZTdBZkBeDGODxz+KV44UNCy4wvN4k=;
        b=AGa/xCEjEb3qK0MkSqbET4JkZvo2UGTc8z/NuldzPCjYt42vE3dxHHEbB6d5sy76QyDlKB
        JZvN9n3qMA7C3W9yiQNLWfKs3iEzV/H7hFRrViMiISFVM6/YwbFIvopZPQ3WQxIfW9qSHl
        k/+k/CJqK0lRhf7+++JDZcpd7axXQv0=
Content-Disposition: inline
In-Reply-To: <CAJD7tkac7VKV6Ob8qQWzhm8Ayyk3xB0YCY6edL-TxpXV3aCzXA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Chris Li <chrisl-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 27-04-23 15:12:46, Yosry Ahmed wrote:
[...]
> However, I still think this change is valuable. Like you mentioned,
> the OOM log is not set in stone, but we shouldn't just change it for
> no reason. In this case, for cgroup v1 users, the OOM log changed for
> no reason beyond a side effect of another patch. Upon upgrading our
> kernel we noticed the behavior change. This patch restores the old
> behavior without any cost really, and it makes the code a tiny bit
> more consistent.

Fair enough. Just make sure you go into more details about why this is
causing problems/inconveniences. I am slightly worried this might cause
problems to other people who would like to have the same report for both
v1 and v2 so we should at least have some solid argumetns to revert
rather than "it used has changed and we liked it more that way".

I personally do not care all that much. It kinda sucks to dump counters
that are not tracked or fully tracked in v1 because that can mislead
people and that would be a bigger problem from my POV.
-- 
Michal Hocko
SUSE Labs
