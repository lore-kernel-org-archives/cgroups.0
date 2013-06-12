From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 2/2] memcg: do not sleep on OOM waitqueue with full charge
 context
Date: Wed, 12 Jun 2013 13:12:09 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1306121309500.23348@chino.kir.corp.google.com>
References: <1370488193-4747-1-git-send-email-hannes@cmpxchg.org> <1370488193-4747-2-git-send-email-hannes@cmpxchg.org> <alpine.DEB.2.02.1306052058340.25115@chino.kir.corp.google.com> <20130606053315.GB9406@cmpxchg.org> <20130606173355.GB27226@cmpxchg.org>
 <alpine.DEB.2.02.1306061308320.9493@chino.kir.corp.google.com> <20130606215425.GM15721@cmpxchg.org> <alpine.DEB.2.02.1306061507330.15503@chino.kir.corp.google.com> <20130607000222.GT15576@cmpxchg.org> <alpine.DEB.2.02.1306111454030.4803@chino.kir.corp.google.com>
 <20130612082817.GA6706@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=tSpyTRSvtimrvf+REkJDAiYbS4Obh2SHXtnmyCd949s=;
        b=M/ke47l7JJQf6Ony4/6LPaW+5w13h2uu/YhoTLZ6Pyt2KFq8E/6qSdWmFNU5n78YCg
         Xl860PKTvQFukU/Tl+o3UT/qB+c3xjF14i2B1iZ24GwTlAa46B6qY8IgXH822clE/sHu
         x6Y5wf7WJmghVK/CMyMl3DtTRKpLzUVXXXtZMoMq8hSEag2w+Ogz+nSXv8Vf/HDrb4Be
         D1FS/6DodJWFvQEdDtWDjdiFgkXDoh3rj/zq35kILrqr+XjKFmYV+VftEyWJqmHPVUpg
         5DfOlbAWD/Z08qJsL8PmnXXQo40EuRYybB1BzaTJ6f89b0TcUBprlrYpQNjDleZQmhdd
         zyWg==
In-Reply-To: <20130612082817.GA6706-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 12 Jun 2013, Michal Hocko wrote:

> > > > > > > Reported-by: Reported-by: azurIt <azurit-Rm0zKEqwvD4@public.gmane.org>
> > 
> > Ok, so the key here is that azurIt was able to reliably reproduce this 
> > issue and now it has been resurrected after seven months of silence since 
> > that thread.  I also notice that azurIt isn't cc'd on this thread.  Do we 
> > know if this is still a problem?
> 
> I have backported the patch for his 3.2 and waiting for his feedback.
> 

Ok, thanks.  I thought this was only going seven months back when it was 
reported, I missed that the issue this patch is trying to address goes 
back a 1 1/2 years to 3.2 and nobody else has reported it.  I think his 
feedback would be the key, specifically if he can upgrade to a later 
kernel first.
