From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 09/11] memcg: propagate kmem limiting information to
 children
Date: Mon, 25 Jun 2012 15:49:42 -0700
Message-ID: <20120625224942.GN3869@google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com>
 <1340633728-12785-10-git-send-email-glommer@parallels.com>
 <20120625182907.GF3869@google.com>
 <4FE8E7EB.2020804@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=u4w55TkKVPJm+P4EF21OILaJXVNAnfyijvsi9JJeVnc=;
        b=KfWG+9/50c0uQ9VuyR2TBl8HQJnL9pg7bUN6/a40DD5eKiy5nlMdTRNv5gVabwbK9l
         tQDXNLyStUQx3u5SOk12xD2npMAWIboB2RzeLQIlGTt9c0U0lmhv0WNMh/yQTkcc2+CJ
         dSE0R5XhrWxw4pn3KN+D/o1rV/RrI4/FfiilIci10fhrZyZ/FVxHEnqApcL4l9We1oby
         8ggF1eD3JKeKfXr/XLTTZcs+VU7ThncBGn0I0foSYrq7C7xhfLqL6tDSNRMBYo0qgXkl
         K09yCaqVJwJAp/V3KcnpzfWbube1p3x8HLoqu064btnPKE2EGT9cvblSHbQF0ifDrn6R
         wyrQ==
Content-Disposition: inline
In-Reply-To: <4FE8E7EB.2020804-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hello, Glauber.

On Tue, Jun 26, 2012 at 02:36:27AM +0400, Glauber Costa wrote:
> >Is the volatile declaration really necessary?  Why is it necessary?
> >Why no comment explaining it?
> 
> Seems to be required by set_bit and friends. gcc will complain if it
> is not volatile (take a look at the bit function headers)

Hmmm?  Are you sure gcc includes volatile in type check?  There are a
lot of bitops users in the kernel but most of them don't use volatile
decl on the variable.

> >>+			 */
> >>+			parent = parent_mem_cgroup(iter);
> >>+			while (parent && (parent != memcg)) {
> >>+				if (test_bit(KMEM_ACCOUNTED_THIS, &parent->kmem_accounted))
> >>+					goto noclear;
> >>+					
> >>+				parent = parent_mem_cgroup(parent);
> >>+			}
> >
> >Better written in for (;;)?  Also, if we're breaking on parent ==
> >memcg, can we ever hit NULL parent in the above loop?
> 
> I can simplify to test parent != memcg only, indeed it is not
> expected to be NULL (but if it happens to be due to any kind of bug,
> we protect against NULL-dereference, that is why I like to write
> this way)

I personally don't really like that.  It doesn't really add meaningful
protection (if that happens the tree walking is already severely
broken) while causes confusion to future readers of the code (when can
parent be NULL?).

Thanks.

-- 
tejun
