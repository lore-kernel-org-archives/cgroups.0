From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: implement css->id
Date: Sun, 4 May 2014 15:18:11 -0400
Message-ID: <20140504191811.GB26279@htj.dyndns.org>
References: <1398373333-1521-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=lJwXKVDelnmCzzZr9rjh6O2c4iWMsbG5OlhR7XWNCIk=;
        b=cu+wHCCE6/yc4++L4mJJNcEJQy3SmRWAQmWmsu8cwDigwtYcz0zlyY7PjPxwtJUpQC
         u+8JdxVdwDNLjLI2NrkLCLj3DFux/+/ggLaD4eGuu4sHIJrMZY4tdwHXCiRooPER4Duc
         dk74aep988yDOQs+xqVUZTSiTOaYZRcFjqlt5BhSAcy0whPNoH5AvKW3Qz/hBt0vVhEm
         oaIugVEpHi+VzRKs2CbuMpoy/Bbh00ERjYd3oVzUqxuLUZAIbZ3+qaT/L4mWOn8L5y0l
         ogkCAlXgjEG9dTxl2P/3qelpfRRD37IVW+7l2hbrOG4/hRsdXyuQnko8Mk7EMPuIB8BL
         MsUw==
Content-Disposition: inline
In-Reply-To: <1398373333-1521-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Thu, Apr 24, 2014 at 05:02:07PM -0400, Tejun Heo wrote:
> Hello,
> 
> Until now, cgroup->id has been used to identify all the associated
> csses and css_from_id() takes cgroup ID and returns the matching css
> by looking up the cgroup and then dereferencing the css associated
> with it; however, now that the lifetimes of cgroup and css are
> separate, this is incorrect and breaks on the unified hierarchy when a
> controller is disabled and enabled back again before the previous
> instance is released.

Aplied to cgroup/for-3.16.  I was a bit worried about possible
conflicts with other memcg changes but they don't seem to conflict
anywhere.

Thanks.

-- 
tejun
