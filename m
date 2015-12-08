From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/7] cgroup: introduce cgroup namespaces
Date: Tue, 8 Dec 2015 14:46:00 -0500
Message-ID: <20151208194600.GH30240@mtj.duckdns.org>
References: <1449529582-4075-1-git-send-email-serge.hallyn@ubuntu.com>
 <1449529582-4075-4-git-send-email-serge.hallyn@ubuntu.com>
 <20151208160453.GB30240@mtj.duckdns.org>
 <20151208193431.GB14814@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=UZA7CG7h1XXSLaGdLaCUqPgCcQsufA8+d955EFFR/U8=;
        b=sN8TNYWfLo4W9nIUrvlUCZNcnn5ffpMVAQ9Uw+Nv22omYkY7OsLjDt980+IW9eQRQQ
         BKGNT9SvPPWcxi1y3N1YQmjGrGT/tdNz5ASyttOTnDKyq1am6gxC4OKHouo2k6I0OXmQ
         4VDwUfU8jAa4+Qq20IBjDGsJzcsY7fu+rvDRcT4jiIZeN0PgVU7koF5ltBZ5ET7ESMt6
         idUruMw98CzqyL9+UXv/KpDuJqvGEnReOc8ZZZHunoscR5OPlXydNOu7JgChO+MjdczD
         DG+qhfQB8X0cGG14ko31Q7Qq9aGzp2NSW6a2Syb3/yTPBShMN8+8iY4I7hnY0saz1OCt
         Nmtg==
Content-Disposition: inline
In-Reply-To: <20151208193431.GB14814-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

Hello, Serge.

On Tue, Dec 08, 2015 at 01:34:31PM -0600, Serge E. Hallyn wrote:
> > I'd prefer collecting all ns related declarations in a single place.
> 
> I can group some of them, but free_cgroup_ns needs the
> cgroup_namespace definition, put_cgroup_ns() needs free_cgroup_ns(),
> and free_cgroup_ns() is static in the !CONFIG_CGROUPS case and a
> non-static function in the other case.
> 
> So I'm going to put both get_cgroup_ns() and put_cgroup_ns() at the
> end of the file, with the struct namespace define at the top.  Is
> that sufficient?

I wouldn't even mind creating a separate #ifdef section for NS stuff
if that's wnat's necessary for collecting everything into one spot.

Thanks.

-- 
tejun
