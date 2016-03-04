From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/4] mm: Convert printk(KERN_<LEVEL> to pr_<level>
Date: Fri, 4 Mar 2016 07:42:33 -0500
Message-ID: <20160304124233.GC13868@htj.duckdns.org>
References: <cover.1457047399.git.joe@perches.com>
 <c12953a0177b3fd04945b042cb10495130c08bec.1457047399.git.joe@perches.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UMOkbzmQpKQ4auObuK3LuovSONl7tXCUpC819NcopEc=;
        b=CH746LeKkdnzgYx3WvB4wIdSJYv6VNVsVDLa39DfYDfGww8FJaKBN571PAx7HnGUpz
         6ERh1GHNsw6iroWB/NInqxUAYhrvxXu6kXyn880UcOkGZn5llZmIwBbJBnQwW0l4srWU
         UorZuHpZnPNizcGCXNL8FLrQa4Ax9PmDBYFCJ8NZK5SOcU3yOZqXceNdBnnksj71tu94
         aogXkVD382s81E5h9zl+YFI2p6w4AwpS28YYBWYnSOqBOF4lsVMzFYKDhxUJ9F5Nd3xK
         d7aLE8r/s5Mc5uquxQGQPW9/RJdZwkYByP7e8Og3B3TQGKZkgyypTrE58P26nuKBacpb
         NNPQ==
Content-Disposition: inline
In-Reply-To: <c12953a0177b3fd04945b042cb10495130c08bec.1457047399.git.joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vegard Nossum <vegardno-6miFZF/5cTBuMpJDpNschA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, Christoph Lameter <cl-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Mar 03, 2016 at 03:25:33PM -0800, Joe Perches wrote:
> Most of the mm subsystem uses pr_<level> so make it consistent.
> 
> Miscellanea:
> 
> o Realign arguments
> o Add missing newline to format
> o kmemleak-test.c has a "kmemleak: " prefix added to the
>   "Kmemleak testing" logging message via pr_fmt
> 
> Signed-off-by: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>

For percpu,

 Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
