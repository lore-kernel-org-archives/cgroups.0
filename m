From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 1/4] kernfs: kvmalloc xattr value instead of kmalloc
Date: Fri, 06 Mar 2020 00:49:51 -0800
Message-ID: <58c6e6dafabea52e5b030d18b83c13e4f43ab8e3.camel@perches.com>
References: <20200305211632.15369-1-dxu@dxuuu.xyz>
         <20200305211632.15369-2-dxu@dxuuu.xyz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200305211632.15369-2-dxu@dxuuu.xyz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Daniel Xu <dxu@dxuuu.xyz>, cgroups@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org
Cc: shakeelb@google.com, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, kernel-team@fb.com

On Thu, 2020-03-05 at 13:16 -0800, Daniel Xu wrote:
> It's not really necessary to have contiguous physical memory for xattr
> values. We no longer need to worry about higher order allocations
> failing with kvmalloc, especially because the xattr size limit is at
> 64K.

So why use vmalloc memory at all?

> diff --git a/fs/xattr.c b/fs/xattr.c
']
> @@ -817,7 +817,7 @@ struct simple_xattr *simple_xattr_alloc(const void *value, size_t size)
>  	if (len < sizeof(*new_xattr))
>  		return NULL;
>  
> -	new_xattr = kmalloc(len, GFP_KERNEL);
> +	new_xattr = kvmalloc(len, GFP_KERNEL);

Why is this sensible?
vmalloc memory is a much more limited resource.

Also, it seems as if the function should set
new_xattr->name to NULL before the return.


