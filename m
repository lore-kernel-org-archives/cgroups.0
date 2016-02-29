From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.6-ns] cgroup: fix and restructure error
 handling in copy_cgroup_ns()
Date: Mon, 29 Feb 2016 16:23:39 -0500
Message-ID: <20160229212339.GC3965@htj.duckdns.org>
References: <20160217185811.GA3472@mwanda>
 <20160218164658.GD13177@mtj.duckdns.org>
 <20160218202112.GZ5273@mwanda>
 <20160218202650.GH13177@mtj.duckdns.org>
 <20160218212648.GA5273@mwanda>
 <20160228135933.GT3965@htj.duckdns.org>
 <20160229085000.GC26955@ubuntumail>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AudnCeiDYq1ImTloGpQTqpkoAv/FAhgvWnpJV8kEw9o=;
        b=v8lk8Qig637mxGDN7ZQtPaU9jHK1GkaaBorpZKjauDYGiC8UlQ1HZdp9TeiFyINA4A
         r493cURXwrnVRF4yYMVUjUHnkSZ9ZrzJpY35zb1I65A4VwKhv3BK185lCkQ4Szru0VGm
         FwWGBv6b31AMgVTjzSppv8xKAeIYiLXfXCUZv7718Nti9lIuOvAgTmgHbzDWiZigbnES
         JpKhy7DGY4YaR9t4KXxt6xOV4Gn1JTsacv28XrTVlB7DoR4CpRR/oVOYnMrBjkwVtFP7
         EJVaodqRJh7fJ0YxzufCvGUj3Y1IXQu404pAcEbM7thmm81mYxbDa+HpKHskjxgftGYV
         8zTQ==
Content-Disposition: inline
In-Reply-To: <20160229085000.GC26955@ubuntumail>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

On Mon, Feb 29, 2016 at 08:50:00AM +0000, Serge Hallyn wrote:
> Quoting Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org):
> > copy_cgroup_ns()'s error handling was broken and the attempt to fix it
> > d22025570e2e ("cgroup: fix alloc_cgroup_ns() error handling in
> > copy_cgroup_ns()") was broken too in that it ended up trying an
> > ERR_PTR() value.
> > 
> > There's only one place where copy_cgroup_ns() needs to perform cleanup
> > after failure.  Simplify and fix the error handling by removing the
> > goto's.
> > 
> > Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> 
> It certainly looks cleaner, thanks.
> 
> Acked-by: Serge E. Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-4.6-ns.

Thanks.

-- 
tejun
