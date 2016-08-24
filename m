From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/5] Networking cgroup controller
Date: Wed, 24 Aug 2016 17:03:57 -0400
Message-ID: <20160824210357.GU8185@htj.duckdns.org>
References: <1470876798-4024-1-git-send-email-anaravaram@google.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ULh22hdG2tOsh3CTx7e89ZoKS/Xehe0ZsBBnABqdrew=;
        b=Jwvt1cwbkfK784TVL+Odc/vOw6/qTyZ12RJVbNqurLEA7+CWMvrHq5CjAzSGyEr1Gw
         ULm04UtS68Ksb/Lzqa/Gk5nzxqQDUXvxtOjqUAFCv7fCwY4ZsUrVpAbdX0DNviFzfglf
         I582Jl1wf8pGa9OJm9i8/L6xJzPu+BK3gqpOjPVSxAbVEZBeAQSBb1AVDx1bOBoZhRZV
         lFv3dyOefGZlDAUQ+bKNLhmi8/tBZh56GaWSFyBi19Gx95jXdCHp4wmyGXpOHhUMsL/F
         9UU4rmMCphUswWOH6VWsDi0qznGTxfdQfNpM7XKNbduc+9rjdIba5LThBVyYmYkcv//+
         5W7Q==
Content-Disposition: inline
In-Reply-To: <1470876798-4024-1-git-send-email-anaravaram@google.com>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Anoop Naravaram <anaravaram@google.com>
Cc: corbet@lwn.net, lizefan@huawei.com, hannes@cmpxchg.org, davem@davemloft.net, kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net, linux-doc@vger.kernel.org, cgroups@vger.kernel.org, netdev@vger.kernel.org, edumazet@google.com, maheshb@google.com, weiwan@google.com, tom@herbertland.com

Hello, Anoop.

On Wed, Aug 10, 2016 at 05:53:13PM -0700, Anoop Naravaram wrote:
> This patchset introduces a cgroup controller for the networking subsystem as a
> whole. As of now, this controller will be used for:
> 
> * Limiting the specific ports that a process in a cgroup is allowed to bind
>   to or listen on. For example, you can say that all the processes in a
>   cgroup can only bind to ports 1000-2000, and listen on ports 1000-1100, which
>   guarantees that the remaining ports will be available for other processes.
> 
> * Restricting which DSCP values processes can use with their sockets. For
>   example, you can say that all the processes in a cgroup can only send
>   packets with a DSCP tag between 48 and 63 (corresponding to TOS values of
>   192 to 255).
> 
> * Limiting the total number of udp ports that can be used by a process in a
>   cgroup. For example, you can say that all the processes in one cgroup are
>   allowed to use a total of up to 100 udp ports. Since the total number of udp
>   ports that can be used by all processes is limited, this is useful for
>   rationing out the ports to different process groups.
> 
> In the future, more networking-related properties may be added to this
> controller.

Thanks for working on this; however, I share the sentiment expressed
by others that this looks like too piecemeal an approach.  If there
are no alternatives, we surely should consider this but it at least
*looks* like bpf should be able to cover the same functionalities
without having to revise and extend in-kernel capabilities constantly.

Thanks.

-- 
tejun
