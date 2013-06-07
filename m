From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/3] memcg: simplify mem_cgroup_reclaim_iter
Date: Fri, 7 Jun 2013 16:25:57 -0700
Message-ID: <20130607232557.GL14781@mtj.dyndns.org>
References: <20130605143949.GQ15576@cmpxchg.org>
 <20130605172212.GA10693@mtj.dyndns.org>
 <20130605194552.GI15721@cmpxchg.org>
 <20130605200612.GH10693@mtj.dyndns.org>
 <20130605211704.GJ15721@cmpxchg.org>
 <20130605222021.GL10693@mtj.dyndns.org>
 <20130605222709.GM10693@mtj.dyndns.org>
 <20130606115031.GE7909@dhcp22.suse.cz>
 <20130607005242.GB16160@htj.dyndns.org>
 <20130607073754.GA8117@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=dttXree+acSECPyYOfRXE7t2c9ZfEsbZ/IJSRxkMs1k=;
        b=xnCH1ByNUkuRK7Glwx0ci5dO88mwT6p7XuVcVOPYBe3ers4SPEjWxeDmuDQnuDh/sk
         vbDePPZgEqsDOfLIMurLFfqVpNnEHH5oHNain/PP/xon4T5c2h1ju5xKU8p8L6bPvux6
         P7AfaHVtrWJCVLQKsvFrKRPChNOXFKwc6lBJ98j9VmUrimIZWHhCkTvq0VjFcEFDZ09/
         OED/OOfZjYpFTUwLYeVllpdLgz+lbzZa0xTyD+8Mh6Pz4pBE5wI4t/mugtkNQsMTZZeh
         g9z97E/4eZg4AWVr3QZBwUfO4wWLiDI7+B6d3VfNVfvcR87n2M9wijmAxH6Sjz//ri7G
         5KIw==
Content-Disposition: inline
In-Reply-To: <20130607073754.GA8117@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, bsingharora@gmail.com, cgroups@vger.kernel.org, linux-mm@kvack.org, lizefan@huawei.com

Hello, Michal.

On Fri, Jun 07, 2013 at 09:37:54AM +0200, Michal Hocko wrote:
> > Oh yeah, it is racy.  That's what I meant by "not having to be
> > completely strict".  The race window is small enough and it's not like
> > we're messing up refcnt or may end up with use-after-free. 
> 
> But it would potentially pin (aka leak) the memcg for ever.

It wouldn't be anything systemetic tho - race condition's likliness is
low and increases with the frequency of reclaim iteration, which at
the same time means that it's likely to remedy itself pretty soon.
I'm doubtful it'd matter.  If it's still bothering, we sure can do it
from RCU callback.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
