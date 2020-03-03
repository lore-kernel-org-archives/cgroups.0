From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] kernfs: Add option to enable user xattrs
Date: Tue, 3 Mar 2020 08:19:21 -0500
Message-ID: <20200303131921.GB5186@mtj.thefacebook.com>
References: <20200303013901.32150-1-dxu@dxuuu.xyz>
 <20200303013901.32150-2-dxu@dxuuu.xyz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Dq0BrbehtK7dXyNHKSd+EsOqpyv9pUXKpu+rlI2sPy0=;
        b=dS7oPsIcp/43xUk811EfREN9F0E/R1GAaoEagaxvwV3+zlqbGtVcU7P352DpRveBUL
         o4ug8Ghz4tfQvW05T4Gyz6fehTJGT2/qKzvpsMjMfvX02AcUmTQ20N14TNAQGZFw93nD
         sy98slN9mRSb1T/Ef2+8W+i8p15qvv5oODLKp2ia0CyqILrUX8bVSq8qNWdsStPTI8iD
         ixRbGieZO9m/P702VfNAqnayQ30qKfCxC9CjmDMmWjKAI5I/b0OvBlNvtrTCjxS2KEM/
         N+UQy03P/OkJ4BDnTmfPQLM0ECxCdhNsARPcejnqcqXFtL+788rMYq13pgmYk5mkgZRK
         7M4A==
Content-Disposition: inline
In-Reply-To: <20200303013901.32150-2-dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Xu <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

On Mon, Mar 02, 2020 at 05:39:00PM -0800, Daniel Xu wrote:
> +static int kernfs_vfs_user_xattr_set(const struct xattr_handler *handler,
> +				     struct dentry *unused, struct inode *inode,
> +				     const char *suffix, const void *value,
> +				     size_t size, int flags)
> +{
...
> +	if (value && atomic_inc_return(nr) > KERNFS_MAX_USER_XATTRS) {
> +		ret = -ENOSPC;
> +		goto dec_out;
> +	}

So, we limit the number of user xattrs here but

> +	ret = kernfs_vfs_xattr_set(handler, unused, inode, suffix, value,
> +				   size, flags);

This will call into simple_xattr_set() which doesn't put any further
restriction on size and just calls GFP_KERNEL kmalloc on it allowing
users incur high-order allocations. Maybe it'd make sense to limit
both the number and size?

Thanks.

-- 
tejun
