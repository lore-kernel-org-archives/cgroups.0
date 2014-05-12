From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 02/14] cgroup: remove pointless has tasks/children test
 from mem_cgroup_force_empty()
Date: Mon, 12 May 2014 10:59:27 -0400
Message-ID: <20140512145927.GA1421@htj.dyndns.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
 <1399671091-23867-3-git-send-email-tj@kernel.org>
 <20140512145324.GE9564@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Apjz7K9gaxWAf+GzRpl0XDnuqY7qkdC2bjqvd5KrHs0=;
        b=foo+vH1EvRJqC29sO7sFbQ0NW6mXHltzNpE6/hwJ37a6eWZgmbjF1mGVwEbPUmz323
         66199d92XcxuYIAr/slnydYyox9ItGWOb7rQCq+R4XmBpoS76uhFxFLBACfjmbdOWea4
         JbnFO8FS1xh0awLo4NJWhAV2wD9RRYPutBsnQSjyr/cAQQRXNlSsrLko/c2FZ2QwDbWV
         dBiSLn7JLM/GM4pj7F83aP3ctn8aG4v5OJpzG822Ttzs8iZ6OKCMZ/VO9YBd+dA9qaeL
         IWK7WcyJLDPGKbxnqJdtMcaUFBVMZyukMhp2lzVDhktehHMhRvg5TwcXMDRXUV+DzKus
         ZM3Q==
Content-Disposition: inline
In-Reply-To: <20140512145324.GE9564-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org

Hello,

On Mon, May 12, 2014 at 04:53:24PM +0200, Michal Hocko wrote:
> What do you think about the following patch instead:

As long as the direct ->children dereference is gone, I have no
objection and yes the knob's purpose seems weird at best.

> ---
> From 03f8cb2e1fd2636d859c54df9b58719fe96e0e54 Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> Date: Mon, 12 May 2014 16:34:17 +0200
> Subject: [PATCH] memcg: remove tasks/children test from from
>  mem_cgroup_force_empty
> 
> Tejun has correctly pointed out that tasks/children test in
> mem_cgroup_force_empty is not correct because there is no other locking
> which preserves this state throughout the rest of the function so both
> new tasks can join the group or new children groups can be added while
> somebody is writing to memory.force_empty. A new task would break
> mem_cgroup_reparent_charges expectation that all failures as described
> by mem_cgroup_force_empty_list are temporal and there is no way out.
> 
> The main use case for the knob as described by
> Documentation/cgroups/memory.txt is to:
> "
>   The typical use case for this interface is before calling rmdir().
>   Because rmdir() moves all pages to parent, some out-of-use page caches can be
>   moved to the parent. If you want to avoid that, force_empty will be useful.
> "
> 
> This means that reparenting is not really required as rmdir will
> reparent pages implicitly from the safe context. If we remove it from
> mem_cgroup_force_empty then we are safe even with existing tasks because
> the number of reclaim attempts is bounded. Moreover the knob still does
> what the documentation claims (modulo reparenting which doesn't make any
> difference) and users might expect. Longterm we want to deprecate the
> whole knob and put the reparented pages to the tail of parent LRU during
> cgroup removal.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

Can I roll this into my series so that I can put this before changes
which depend on direct ->children usages being removed?

Thanks.

-- 
tejun
