From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v2 1/4] kernfs: kvmalloc xattr value instead of kmalloc
Date: Fri, 6 Mar 2020 10:37:20 +0100
Message-ID: <20200306093720.GA3630348@kroah.com>
References: <20200305211632.15369-1-dxu@dxuuu.xyz>
 <20200305211632.15369-2-dxu@dxuuu.xyz>
 <58c6e6dafabea52e5b030d18b83c13e4f43ab8e3.camel@perches.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583487443;
        bh=IyUEI189KLN7NzOaIC0uGsky+Dq/9mgX0pL869AYwTM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KBzdM3smU80fwbieeRIomBESOd0DAz9uNN+Igc9aRMBcF/aZLhWV5tX27iDxdrekL
         bIAwhkwRSbudL4mBN5282Sl4Q1//0tti6yNvgzVzwSHEg3FKbFuobj7vzH0Wuh7piN
         zBZFBkRXduhi6m4lDqWCWuM3bQ1dmvPkue2723wI=
Content-Disposition: inline
In-Reply-To: <58c6e6dafabea52e5b030d18b83c13e4f43ab8e3.camel-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: Daniel Xu <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, Mar 06, 2020 at 12:49:51AM -0800, Joe Perches wrote:
> On Thu, 2020-03-05 at 13:16 -0800, Daniel Xu wrote:
> > It's not really necessary to have contiguous physical memory for xattr
> > values. We no longer need to worry about higher order allocations
> > failing with kvmalloc, especially because the xattr size limit is at
> > 64K.
> 
> So why use vmalloc memory at all?
> 
> > diff --git a/fs/xattr.c b/fs/xattr.c
> ']
> > @@ -817,7 +817,7 @@ struct simple_xattr *simple_xattr_alloc(const void *value, size_t size)
> >  	if (len < sizeof(*new_xattr))
> >  		return NULL;
> >  
> > -	new_xattr = kmalloc(len, GFP_KERNEL);
> > +	new_xattr = kvmalloc(len, GFP_KERNEL);
> 
> Why is this sensible?

See the thread on v1

> vmalloc memory is a much more limited resource.

Large chunks of "len" is much more limited :)

thanks,

greg k-h
