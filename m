From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Question] Do we need remote charging for cpu and cpuacct subsys?
Date: Fri, 2 Jul 2021 12:26:37 -1000
Message-ID: <YN+Sne76dhKBzV/R@mtj.duckdns.org>
References: <60decdb6.1c69fb81.6130e.7642@mx.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=s1+mLyUtQCUAV2WWOyntQZbuF/k3KJ0qXJL3GSGY5Z0=;
        b=pkTu+y8uzUfmpZpZxCfdGhCWkpcTGT3XhbgnYRrJFo3EgmPEcB3ALvb6y+gtv5+gSL
         La6StCuj7lYmwwBsJcW7PrHmxk4aQkkXzF4cwVMXc2Kh7TlMTfgJYznDFlOjCJMPiLap
         ZCSGypci0hedQ3zs4jdoBdL8rppevZvttyoTAkUowR6LjAIz5mkPRy3xhGdFIIFTZO+2
         IoqT81yCdISrkdFmvAyWIwzlpIm6sKutr2CIikiJwr8ubW8IH+P1KdTXsxTaCILBrJye
         LdzmVgd4oilzQ2OzNrAtOJRderLjqc1N8bgJJX9J0I74PTaYjpUT/X97KBU6QqfLH31E
         w35g==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <60decdb6.1c69fb81.6130e.7642-ATjtLOhZ0NVl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Lee <haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Fri, Jul 02, 2021 at 08:26:27AM -0000, Hao Lee wrote:
> memcg currently has a remote charging mechanism that can charge usage to other
> memcg instead of the one the task belongs to.
> 
> In our environment, we need to account the cpu usage consumed by some kworkers
> to a specific cgroup. Thus, we want to introduce a remote-charging mechanism to
> cpu and cpuacct subsys in our kernel.
> 
> I want to know if the community has a plan to do this?
> What will the community approach look like?

Yeah, we need sth like this to account for cpu cycles spent in commont path
but caused by specific cgroups - e.g. memory reclaim, net packet rx and so
on. There were some mentions of needing somthing like that but haven't been
any patchsets or concrete efforts that I know of.

Thanks.

-- 
tejun
