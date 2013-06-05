From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [patch 1/2] mm: memcontrol: fix lockless reclaim hierarchy
 iterator
Date: Wed, 5 Jun 2013 16:06:25 -0700
Message-ID: <20130605230625.GN10693@mtj.dyndns.org>
References: <1370472826-29959-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=TLIzLpJ+wbC1xTRB6NkfforCZyKhaI0ZudAY9L2ehwg=;
        b=ewYq0gld4YA13g4iT4TS8DxeMHzEmnSF9T29LuSeE0P/NwLKDfo8A/bEyw4k6gFnQE
         WlectBG5tNd8Nm8iqz3bsiThJoX3mz5UrWQKjDqxBRWZqdecBKDr40evxCGmz8H5N877
         geCXPC5eLDjXs9h/UsWWxDkcSvNgg3QQ/MwYcmrd6VlugwJSMrgYXfVQ6vg2GFaAyKYT
         bC99d1MBmmorJo1YI+G0R6ozY7XQpkj8Y8rWBXodTp/2mQp6Z8aiglEDq0oQWK/5Nd4h
         8GDuNrCucRY4CqBmMJj3+YsQ8q8OpLdtu8jdh1tfl7fwhiyyaDJsT+LpPMxIBzaRnVfU
         SslA==
Content-Disposition: inline
In-Reply-To: <1370472826-29959-1-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jun 05, 2013 at 06:53:45PM -0400, Johannes Weiner wrote:
> The lockless reclaim hierarchy iterator currently has a misplaced
> barrier that can lead to use-after-free crashes.
> 
> The reclaim hierarchy iterator consist of a sequence count and a
> position pointer that are read and written locklessly, with memory
> barriers enforcing ordering.
> 
> The write side sets the position pointer first, then updates the
> sequence count to "publish" the new position.  Likewise, the read side
> must read the sequence count first, then the position.  If the
> sequence count is up to date, it's guaranteed that the position is up
> to date as well:
> 
>   writer:                         reader:
>   iter->position = position       if iter->sequence == expected:
>   smp_wmb()                           smp_rmb()
>   iter->sequence = sequence           position = iter->position
> 
> However, the read side barrier is currently misplaced, which can lead
> to dereferencing stale position pointers that no longer point to valid
> memory.  Fix this.
> 
> Reported-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org [3.10+]

Reviewed-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Oops, right, the references were reversed too.

Thanks.

-- 
tejun
