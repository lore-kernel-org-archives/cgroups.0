From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 1/4] kernfs: kvmalloc xattr value instead of kmalloc
Date: Mon, 09 Mar 2020 12:41:05 -0700
Message-ID: <6bbfc8b8c9c206d80de43a64bfe4b8083cc2c02f.camel@perches.com>
References: <C16IH7NEXW4J.440OGTNY7CWX@dlxu-fedora-R90QNFJV>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <C16IH7NEXW4J.440OGTNY7CWX@dlxu-fedora-R90QNFJV>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Daniel Xu <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Mon, 2020-03-09 at 11:21 -0700, Daniel Xu wrote:
> Hi Joe,

Hello Daniel.

> On Fri Mar 6, 2020 at 12:49 AM, Joe Perches wrote:
> > On Thu, 2020-03-05 at 13:16 -0800, Daniel Xu wrote:
> > > It's not really necessary to have contiguous physical memory for xattr
> > > values. We no longer need to worry about higher order allocations
> > > failing with kvmalloc, especially because the xattr size limit is at
> > > 64K.
> > 
> > So why use vmalloc memory at all?
> > 
> > 
> > > diff --git a/fs/xattr.c b/fs/xattr.c
> > ']
> > > @@ -817,7 +817,7 @@ struct simple_xattr *simple_xattr_alloc(const void *value, size_t size)
> > >  	if (len < sizeof(*new_xattr))
> > >  		return NULL;
> > >  
> > > -	new_xattr = kmalloc(len, GFP_KERNEL);
> > > +	new_xattr = kvmalloc(len, GFP_KERNEL);
> > 
> > Why is this sensible?
> > vmalloc memory is a much more limited resource.
> 
> What would be the alternative? As Greg said, contiguous memory should be
> more scarce.

If the need is to allocate from a single block of memory,
perhaps you need a submemory allocator like gen_pool.
(gennalloc.h)

Dunno.  Maybe i just don't quite understand your need.

