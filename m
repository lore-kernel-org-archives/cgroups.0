From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC][PATCH 8/9 v2] cgroup: avoid creating new cgroup under a
 cgroup being destroyed
Date: Fri, 27 Apr 2012 13:40:35 -0700
Message-ID: <20120427204035.GN26595@google.com>
References: <4F9A327A.6050409@jp.fujitsu.com>
 <4F9A36DE.30301@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=PxEpP5/sIKta6/Q2Ejz8EBZ0DmUwNT+0z+d7YFmQzs8=;
        b=Lfp4DZ3nPg/0XETFyk/f8wfQh5F0aU+JPh+OIu/p6dC5pj6e7Lq5dSJ9r3AZMh/k9/
         53sZD41AHRgaaebB6BsT8qAKqfktQyHek+7sqH3/Q78HApyo3pUV0HjhS9ANYOhtjQec
         Z5SP1Jr+GnjfS905L9VMBRuLmozxqlAGgGzU86J86rI6HlV/C/7AgVJXFtICaB9kxS+0
         ef091nymi3SiJocwqDeq+CgbBefq/KEJWHgFXebbcuMg4+2VZZdD+44t+7zIBIZjtbJE
         ENapXt0IypFzRKDYLBWEw6NcxXySuuR4drXpxBaD/XhHWdFkXUy3pa1PtJhEke8qYH6s
         iAtw==
Content-Disposition: inline
In-Reply-To: <4F9A36DE.30301-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kamezawa.hiroyuki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Fri, Apr 27, 2012 at 03:04:14PM +0900, KAMEZAWA Hiroyuki wrote:
> When ->pre_destroy() is called, it should be guaranteed that
> new child cgroup is not created under a cgroup, where pre_destroy()
> is running. If not, ->pre_destroy() must check children and
> return -EBUSY, which causes warning.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

Hmm... I'm getting confused more.  Why do we need these cgroup changes
at all?  cgroup still has cgrp->count check and
cgroup_clear_css_refs() after pre_destroy() calls.  The order of
changes should be,

* Make memcg pre_destroy() not fail; however, pre_destroy() should
  still be ready to be retried.  That's the defined interface.

* cgroup core updated to drop pre_destroy() retrying and guarantee
  that pre_destroy() invocation will happen only once.

* memcg and other cgroups can update their pre_destroy() if the "won't
  be retried" part can simplify their implementations.

So, there's no reason to be updating cgroup pre_destroy() semantics at
this point and these updates actually break cgroup API as it currently
stands.  The only change necessary is memcg's pre_destroy() not
returning zero.

Thanks.

-- 
tejun
