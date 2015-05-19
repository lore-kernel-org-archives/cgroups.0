From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] mm, memcg: Optionally disable memcg by default using
 Kconfig
Date: Tue, 19 May 2015 17:15:41 +0200
Message-ID: <20150519151541.GJ6203@dhcp22.suse.cz>
References: <20150519104057.GC2462@suse.de>
 <20150519141807.GA9788@cmpxchg.org>
 <20150519144345.GF2462@suse.de>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=9eb7nQt2cC0VN2+8cch6nYKfi6dHmo23KFN+FWJSUr0=;
        b=tPoafzIT8FuLqyjFeN+s5y1ZMhpYAIvANckZSjkFXBRB26x56BuaHTEcwwf4xnFxUv
         QTCxDY+O+PpvYWWUHTmYMEp4uJfkumjsQQdw2BXgyW6ZDN08hCfJV7cqjBE014NtJjAz
         zTzzezxYhfsR7hY2ZrzNtxkyTjlAZ3vHid+vXb33lQ2/K0jSM8V2P1peigKYkMaVJp7i
         uieuh2m8aa33xoUWzhCKqFK6ZfMxc6ZFLoLhNbOhxID96evv29R3MWPBVij0+1FrZfYL
         AnK2YQYLvtm+cMOyi2bNQjNLqZZp48s2YyveHAA3dSHLX0ewxJF4ZsyZgCHNZYaiI72y
         ghBg==
Content-Disposition: inline
In-Reply-To: <20150519144345.GF2462@suse.de>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>

[Let's CC Ben here - the email thread has started here:
http://marc.info/?l=linux-mm&m=143203206402073&w=2 and it seems Debian
is disabling memcg controller already so this might be of your interest]

On Tue 19-05-15 15:43:45, Mel Gorman wrote:
[...]
> After I wrote the patch, I spotted that Debian apparently already
> does something like this and by coincidence they matched the
> parameter name and values. See the memory controller instructions on
> https://wiki.debian.org/LXC#Prepare_the_host . So in this case at least
> upstream would match something that at least one distro in the field
> already uses.

I've read through
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=534964 and it seems
that the primary motivation for the runtime disabling was the _memory_
overhead of the struct page_cgroup
(https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=534964#152). This is
no longer the case since 1306a85aed3e ("mm: embed the memcg pointer
directly into struct page") merged in 3.19.

I can see some point in disabling the memcg due to runtime overhead.
There will always be some, albeit hard to notice. If an user really need
this to happen there is a command line option for that. The question is
who would do CONFIG_MEMCG && !MEMCG_DEFAULT_ENABLED.  Do you expect any
distributions go that way?
Ben, would you welcome such a change upstream or is there a reason to
change the Debian kernel runtime default now that the memory overhead is
mostly gone (for 3.19+ kernels of course)?
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
