From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] kernfs: Add option to enable user xattrs
Date: Wed, 4 Mar 2020 11:39:22 -0500
Message-ID: <20200304163922.GG189690@mtj.thefacebook.com>
References: <C11FYO0Q9WJU.2MLRRFOQ3E878@dlxu-fedora-R90QNFJV>
 <C11GC2SN5D18.2S00I3KONE9ZE@dlxu-fedora-R90QNFJV>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Q41tiblFE54JAr5vC6itpkRF9zh1xfIn6lFKVFQ8hPE=;
        b=jgpGs27cukeF4u6jimr8YXOzqdUGDnBvlaasW3APkR/3ylULaFPdFft2i7tjdKMoug
         K6v0nKjw50uodI+joOgqp920D8ANct5b0St90yLhBMiPOSfBrwMO9U+phnqmFMuzglpg
         884HqvfXDMjsXb50UTyzG34uXIQ9eJS65e+7fP2KA5Irn35utXNDG9ekv2KX/eIEX7gQ
         a04loJYII0g/hCdWfBKxsGrEygu86tSmz6TSKkuydhhucErZcw0NdksFDxA1hMOXyQ6E
         deVaNCkiC1C/Oli/G4zom94cs+cxd+ivOZIY2MGkg3jUkAjZQ8LR7OXBXHkOao9nR4y8
         pTIQ==
Content-Disposition: inline
In-Reply-To: <C11GC2SN5D18.2S00I3KONE9ZE@dlxu-fedora-R90QNFJV>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Xu <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

On Tue, Mar 03, 2020 at 11:37:28AM -0800, Daniel Xu wrote:
> It looks like in fs/xattr.c:setxattr, there is already:
> 
>     ...
>     if (size) {
>         if (size > XATTR_SIZE_MAX)
>             return -E2BIG;
>     ...
> 
> where XATTR_SIZE_MAX is defined as 64k. Do you want it even smaller?

Oh, I missed that. Order 5 allocations can still be on the big side
tho. Ideally, something like the following?

* Total number of bytes limit as the primary limit so that we can say
  that for a given cgroup user xattrs don't consume more than X bytes.
  We can pick an arbitrary number which is large enough for most use
  cases but not too big. e.g. 128k or whatever.

* Total number of xattrs limit. Again, some arbitrary not too low, not
  too high limit.

* Switch to kvmalloc() for attr allocation so that we don't have to
  worry about high order allocations.

Thanks.

-- 
tejun
