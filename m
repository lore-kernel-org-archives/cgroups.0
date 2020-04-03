From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 net] inet_diag: add cgroup id attribute
Date: Fri, 3 Apr 2020 09:41:47 -0400
Message-ID: <20200403134147.GX162390@mtj.duckdns.org>
References: <20200403095627.GA85072@yandex-team.ru>
 <20200403133817.GW162390@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QTPwH9DQl2UBuEZwi2ElzFxHr6i9n+qwPg8+9YYUPWU=;
        b=BlmAatI+0g6pDfys0U/vI1PhD3GeHN/sSx1hu7RAVbVo0+y/29CoJxdl7uHv0LnBmx
         7mnjkgS4saBRKLO5wcj00f3fzQY/7TV6CfLIaGb/MGZbcaCE9DMOIXv0XptC/WbJCKqL
         aoX7O/xYWolJ6Jy0CADhtVfq1vMiMkAnF1LgP/cR/D5tFEyYof/V0gRFwELyzGZb3J4i
         8vxN11sMQMLPYAZAdin7ogRLDcdXvvXcjivzwf0bK8ALpMW8AYtpIPRPRqBhqkw3RHe8
         UYGLTFtPa6IeiOACSFqCi0NQeTgu8Cbc0McCGw5cTRtnRwb5Fl8Crnddnb0BPNk1RC2s
         0DRQ==
Content-Disposition: inline
In-Reply-To: <20200403133817.GW162390@mtj.duckdns.org>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: davem@davemloft.net, netdev@vger.kernel.org, khlebnikov@yandex-team.ru, cgroups@vger.kernel.org, bpf@vger.kernel.org

On Fri, Apr 03, 2020 at 09:38:17AM -0400, Tejun Heo wrote:
> On Fri, Apr 03, 2020 at 12:56:27PM +0300, Dmitry Yakunin wrote:
> > This patch adds cgroup v2 ID to common inet diag message attributes.
> > Cgroup v2 ID is kernfs ID (ino or ino+gen). This attribute allows filter
> > inet diag output by cgroup ID obtained by name_to_handle_at() syscall.
> > When net_cls or net_prio cgroup is activated this ID is equal to 1 (root
> > cgroup ID) for newly created sockets.
> > 
> > Some notes about this ID:
> > 
> > 1) gets initialized in socket() syscall
> > 2) incoming socket gets ID from listening socket
> >    (not during accept() syscall)
> 
> How would this work with things like inetd? Would it make sense to associate the
> socket on the first actual send/recv?

Oh, it's not a problem with your patch as you're just following the associated
ptr, so we can have that discussion separately. Looks good to me from cgroup
side. Please feel free to add my acked-by.

Thanks.

-- 
tejun
