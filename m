From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 7/9] cgroup_freezer: introduce
 CGROUP_FREEZING_[SELF|PARENT]
Date: Thu, 8 Nov 2012 06:42:39 -0800
Message-ID: <20121108144239.GF12973@htj.dyndns.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-8-git-send-email-tj@kernel.org>
 <20121108124755.GG31821@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-pm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=sAA00YWHeCNhPE46sUW8qyClKVJpgfF3T8k8bYTjgPY=;
        b=W+bnjxMPodWTYG+OiTW9IuLsXvCwZ/4l5SBmHVoIzXytWbG0v0akx7QIyUbvxMG0X1
         H/+Ce7Jzj+4Lxg0a2RXskusIx5P/ryp2SKe8Pm6CwzgfGkJmVIwW/O9UcbmgP4Ni9Cez
         KXb1Qh8TcVYoXGsApOHHbo5HgHNGsWAmC30jOlRfhrgpHlQtujNL2JE1AvCtUQIuBsi6
         yYevBL3p5EOVEedEVWvABpWKtUquRC8bDrV/sePNQNLo6BLTZY1faD5BNZw9wsz7LWAC
         mMqevY48zUR5d/Ui1QDAm89KMRAJxLCk/w5k+0dQb9g/L/4ZQDAeB4nDzB4wsKU/OkNS
         3tJg==
Content-Disposition: inline
In-Reply-To: <20121108124755.GG31821@dhcp22.suse.cz>
Sender: linux-pm-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: lizefan@huawei.com, rjw@sisk.pl, containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, fweisbec@gmail.com

Hello,

On Thu, Nov 08, 2012 at 01:47:55PM +0100, Michal Hocko wrote:
> On Sat 03-11-12 01:38:33, Tejun Heo wrote:
> > Introduce FREEZING_SELF and FREEZING_PARENT and make FREEZING OR of
> > the two flags.  This is to prepare for full hierarchy support.
> > 
> > freezer_apply_date() is updated such that it can handle setting and
> > clearing of both flags.  The two flags are also exposed to userland
> > via read-only files self_freezing and parent_freezing.
> > 
> > Other than the added cgroupfs files, this patch doesn't introduce any
> > behavior change.
> 
> OK, I can imagine that this might be useful to find the first parent
> group that needs to be thawed to unfreeze the group I am interested
> in. Could you also update Documentation/cgroups/freezer-subsystem.txt to
> clarify the intended usage?

Ooh, right.  Will update the doc in the last patch.

> Minor nit. Same as mentioned in the previous patch freezer_apply_state
> should get enum freezer_state_flags state parameter.

But it isn't an enum value.

Thanks.

-- 
tejun
