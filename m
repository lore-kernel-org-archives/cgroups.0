From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 net] inet_diag: add cgroup id attribute
Date: Fri, 3 Apr 2020 09:38:17 -0400
Message-ID: <20200403133817.GW162390@mtj.duckdns.org>
References: <20200403095627.GA85072@yandex-team.ru>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kYnZHxpPGf7DaV2eyxdpVvKIQEJ0x8tV886Kl8XWxiA=;
        b=lrvUKqCgKFfiT00Eui7HGLx0wjeLy4R+GU/a2axO0G1VoL90GmeCpeKV+aGHLYBEnZ
         Syo4J2xHK1ckt26K8Que5Cq5POPiP25pcS5yM288zGSG276nU6nYUzm2EeIvBiOuKOY+
         kC7UxBeXCyDyXAphAhamhn7xgvNCl7p2hRM+6qW/7yBTAYHa5bo0Tq6QxyBV/r5JlDuC
         oo6iYqhiBeYusnpK1SIZlI2/wY/VVZd0rbIiicvHfb+c5zlvTS0v+80b4lNJlfkDAW87
         OvCHrn5h667rPGJbAE341oPeh/RbdJyEucU77d6z8wCc0T65DVrQyfRDcnPHpcDDmciV
         nmyw==
Content-Disposition: inline
In-Reply-To: <20200403095627.GA85072@yandex-team.ru>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: davem@davemloft.net, netdev@vger.kernel.org, khlebnikov@yandex-team.ru, cgroups@vger.kernel.org, bpf@vger.kernel.org

On Fri, Apr 03, 2020 at 12:56:27PM +0300, Dmitry Yakunin wrote:
> This patch adds cgroup v2 ID to common inet diag message attributes.
> Cgroup v2 ID is kernfs ID (ino or ino+gen). This attribute allows filter
> inet diag output by cgroup ID obtained by name_to_handle_at() syscall.
> When net_cls or net_prio cgroup is activated this ID is equal to 1 (root
> cgroup ID) for newly created sockets.
> 
> Some notes about this ID:
> 
> 1) gets initialized in socket() syscall
> 2) incoming socket gets ID from listening socket
>    (not during accept() syscall)

How would this work with things like inetd? Would it make sense to associate the
socket on the first actual send/recv?

Thanks.

-- 
tejun
