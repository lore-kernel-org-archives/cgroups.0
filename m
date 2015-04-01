From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH] Documentation/memcg: update memcg/kmem status
Date: Wed, 1 Apr 2015 18:17:17 +0300
Message-ID: <20150401151717.GE21839@esperanza>
References: <1427898636-4505-1-git-send-email-vdavydov@parallels.com>
 <20150401164431.1e88220a@lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150401164431.1e88220a-T1hC0tSOHrs@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Apr 01, 2015 at 04:44:31PM +0200, Jonathan Corbet wrote:
> On Wed, 1 Apr 2015 17:30:36 +0300
> Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> 
> > Memcg/kmem reclaim support has been finally merged. Reflect this in the
> > documentation.
> 
> So the text you've removed says not to select kmem support "unless for
> development purposes."  Do we now believe that this feature is ready for
> use in a production setting?  If the answer is "yes," I'd be happy to
> take this through the docs tree.

I added this warning because of the following issues, which made
memcg/kmem useless:

 - no reclaim support
 - lack of memcg slab caches auto destruction
 - several obvious races/bugs

They are all fixed now, so I think the answer is yes, it can be used in
production. There might be bugs that I am not aware of, of course, but
It must be safe to compile it in anyway, because memcg/kmem accounting
is disabled by default and must be enabled explicitly at runtime by
writing to cgroup/memory.kmem.limit_in_bytes.

Thanks,
Vladimir
