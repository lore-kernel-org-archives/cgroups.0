From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 4/5] sock, cgroup: add sock->sk_cgroup
Date: Tue, 17 Nov 2015 17:17:57 -0500
Message-ID: <20151117221757.GI22864@mtj.duckdns.org>
References: <1447789240-29394-1-git-send-email-tj@kernel.org>
 <1447789240-29394-5-git-send-email-tj@kernel.org>
 <20151117.162554.314531574043190960.davem@davemloft.net>
 <20151117213126.GH22864@mtj.duckdns.org>
 <564BA0BE.7050302@iogearbox.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=wFOl3L6t9KDLCHLsZKleVz076vNxEGrbuJGeEotKXJA=;
        b=EQUCQNBBScBDMSVz3/r1KjHQg69BpXeL/G0g6v3WvpniRqwu4c3y+8J7PvimpJyY1b
         KHz7k6HhHdOgzM6bmvoqwAAaOan+pofeuIA8YjBg1mXXcnusBKdaPqnXfcoVr1Mtx3dx
         RK/GzZv2juXdXC6yXSvusIOkZcmsVSYDaoKWgn9m5i2/6DYcJkq+YLbml+gL1fpzPCDW
         WsavxwaG+x5QVz+NhfEdjHGeNOqQc3RVpd83g6KDRcGTezwLdRnFDDliz4LMtNIobIlc
         iZsB5WKZRetVjSTNJh6s+vs/mdxyOpd/1kElP2NGj9r3mHfc/5+cOcYdZDfVtuOCFv+/
         256g==
Content-Disposition: inline
In-Reply-To: <564BA0BE.7050302@iogearbox.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: David Miller <davem@davemloft.net>, pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu, lizefan@huawei.com, hannes@cmpxchg.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, daniel.wagner@bmw-carit.de, nhorman@tuxdriver.com

Hello, Daniel.

On Tue, Nov 17, 2015 at 10:48:46PM +0100, Daniel Borkmann wrote:
> >Unfortunately, sk->sk_cgrp_prioidx is an arbitrary value which can be
> >configured through "net_cls.classid".  :(
> 
> Hmm, isn't net_prio independent of net_cls?

Ah, yeah, I was mixing up the two but the story is the same for both.
net_prio configures the prioidx and net_cls the classid and the two
may or may not (but more likely not) be on the same hierarchy and
definitely not on the cgroup2 hierarchy, so you can't really access
them through a single ->sk_cgroup pointer.  After all, that's why we
ended up with these controllers.

Thanks.

-- 
tejun
