From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] memcg: first step towards hierarchical controller
Date: Tue, 4 Sep 2012 11:22:54 -0700
Message-ID: <20120904182254.GA3638@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346687211-31848-1-git-send-email-glommer@parallels.com>
 <20120903170806.GA21682@dhcp22.suse.cz>
 <5045BD25.10301@parallels.com>
 <20120904130905.GA15683@dhcp22.suse.cz>
 <504601B8.2050907@parallels.com>
 <20120904143552.GB15683@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=H9M+Xb0xZb+HqQePKF92I8XyILvDGz8wc4oNfHwMKzg=;
        b=ENg7LHp6IRfOSfR85NvE2uvzv71E75X3epZjuWtWSzYdi207KToDXB7jQxyRzQpwuE
         PA2rFKNelN0E4tB5xo5OwcdPlv22EiqH4X5iey6XoJjAUw6onp3q7COv1gc2JyJ8d3WK
         DxsbB9Lg6FJ17Hz8M6sFJlLMQXSTPLcK0sl+tAjYg7zfckNTi/M4y11X7PC9tAKJDXl1
         uduLt62kYpC1tHLLjOA2k1t6DpnldLGJBK0uuTEIqr4ICw8uTnJELrT6uVy+XBeroY6E
         5sVDA2vWfl0Ha5lPWsaA4TUXpzOASU4GnOyAmbL2t8bCEwAoTN6MOhTrJmeOjhtFC2HY
         QT4Q==
Content-Disposition: inline
In-Reply-To: <20120904143552.GB15683-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello,

On Tue, Sep 04, 2012 at 04:35:52PM +0200, Michal Hocko wrote:
...
> The problem is that we don't know whether somebody has an use case which
> cannot be transformed like that. Therefore this patch starts the slow
> transition to hierarchical only memory controller by warning users who
> are using flat hierarchies. The warning triggers only if a subgroup of
> non-root group is created with use_hierarchy==0.
> 
> Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

I think this could work as the first step.  Regardless of the involved
steps, the goal is 1. finding out whether there are use cases or users
of flat hierarchy (ugh... even the name is stupid :) and 2. if so,
push them to stop doing that and give them time to do so.  While
userland growing "echo 1" to use_hierarchy isn't optimal, it isn't the
end of the world and something which can be taken care of by the
distros.

That said, I don't see how different this is from the staged way I
suggested other than requiring "echo 1" instead of a mount option.  At
any rate, the two aren't mutually exclusive and this looks good to me.

Thanks.

-- 
tejun
