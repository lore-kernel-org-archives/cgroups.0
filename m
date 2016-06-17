From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3] cgroup: remove unnecessary 0 check from css_from_id()
Date: Fri, 17 Jun 2016 14:17:24 -0400
Message-ID: <20160617181724.GO3262@mtj.duckdns.org>
References: <20160616034244.14839-1-hannes@cmpxchg.org>
 <20160616200617.GD3262@mtj.duckdns.org>
 <20160617162310.GA19084@cmpxchg.org>
 <20160617162427.GC19084@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=F6hj6GlJeosvKHb0bvUXbeO+X42B2Nj9Y0m9vE2cWmY=;
        b=oJqKUTPu1nMFFHzsLbHjsS4CZnOe0vPVHJM+mYhwGoaOgTkUMZLJUkr8Ou4+R99w9m
         Tj9kbxbPFI7x5L3UqtHIGQLQGCWBOrmmGr3bHvhLakY6q04vvfWCl7WmwFaeNfZSi62J
         q/IXUDglaHYAM7Ejbf9h0A6UvD4wqaIb5kmaNTrXV+KcLSoNpGhzbwA+FewjdpvClVNp
         G3GNe0T9giVcqYNmlqhfnXSIW7DtZ0g9ioWhSF4SymIW+d/p2WEvJ3tyAyNJG5rEw0mN
         ZDn2DmkmtnICj5hzJGsl4GyleLz1DTUMK8qJd0OEZiUzO5fdJiCp2iJuLmUmxeLXSozL
         JQGw==
Content-Disposition: inline
In-Reply-To: <20160617162427.GC19084-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, Jun 17, 2016 at 12:24:27PM -0400, Johannes Weiner wrote:
> css_idr allocation starts at 1, so index 0 will never point to an
> item. css_from_id() currently filters that before asking idr_find(),
> but idr_find() would also just return NULL, so this is not needed.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Applied 1-2 to cgroup/for-4.8.

Thanks.

-- 
tejun
