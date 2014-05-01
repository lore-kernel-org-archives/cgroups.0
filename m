From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 6/6] cgroup, memcg: implement css->id and convert
 css_from_id() to use it
Date: Thu, 1 May 2014 11:46:30 -0400
Message-ID: <20140501154630.GG31611@htj.dyndns.org>
References: <1398373333-1521-1-git-send-email-tj@kernel.org>
 <1398373333-1521-7-git-send-email-tj@kernel.org>
 <535DCBFC.4000404@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=B8sbXtxWMxhtnsDf+zboobA2oDB9sf60Hx6ngCHOoG8=;
        b=bfo+qRQgIQYSlj3dpsy2vxE+sPj2MQFvmaMm47LIuUBjBFdQFu5lqj3a3+DJ4U5RMr
         mRCh6T4ipM/1SEkgDZti06QeBKkVJndBB9PDI7fOthD1UWkvCwAGUpzFPLRDETqvk2yY
         72bNoIpwDMOumfPeDOwGaEYpw8gLPkVVQVxwp6NgOYTfvz0Wo3Wqhe2nsSbihyZAIFhT
         XLMj7PEUArmXZGdJ9385z6KiBSDtQf+gD8hAFZuriaf41TZzDiSzt8JWvXCouyjZy7l2
         0SVr/ObwtHKK93/eiwqtTugXXLOnB5OCigmx7hAMOkol9TOcUrO2Jw2fqFxLStwK3Hic
         ScYQ==
Content-Disposition: inline
In-Reply-To: <535DCBFC.4000404-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Mon, Apr 28, 2014 at 11:33:16AM +0800, Li Zefan wrote:
> On 2014/4/25 5:02, Tejun Heo wrote:
> > Until now, cgroup->id has been used to identify all the associated
> > csses and css_from_id() takes cgroup ID and returns the matching css
> > by looking up the cgroup and then dereferencing the css associated
> > with it; however, now that the lifetimes of cgroup and css are
> > separate, this is incorrect and breaks on the unified hierarchy when a
> > controller is disabled and enabled back again before the previous
> > instance is released.
> > 
> > This patch adds css->id which is a subsystem-unique ID and converts
> > css_from_id() to look up by the new css->id instead.  memcg is the
> > only user of css_from_id() and also converted to use css->id instead.
> > 
> 
> netprio_cgroup also needs to be updated.

Why?  Wouldn't it be more natural to tie that to the associated
cgroup's ID rather than the specific css instance.  It's different for
memcg as it involves css refcnts but netprio_cgroup, AFAICS, only uses
it for cgroup identification anyway.

Thanks.

-- 
tejun
