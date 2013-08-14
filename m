From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cpuset: remove redundant checks in file write
 functions
Date: Wed, 14 Aug 2013 09:30:48 -0400
Message-ID: <20130814133048.GC28628@htj.dyndns.org>
References: <5209892D.8070502@huawei.com>
 <52098941.4070600@huawei.com>
 <20130813150549.GF26596@mtj.dyndns.org>
 <520AE4FC.5090702@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=zO15be400q0PlxDDaFNbAXmxeJfXvcXh6bofy3AHnUU=;
        b=JK358SryKmvOUiRkIamy+nmetfTGEQ1duejUSXd+ec6U8IUnAi8mLVDcCLQifSH0An
         1UKIMvtWglCOHrizb76GnJCLnawFiBLj+dVaq2KS8syslj1EcHWyicQwhuvqfpq5MxAZ
         Kh0zwUgRDfXzpnDbIYRZOOK5/MI83SwH0KdeGkhjJRO0NZ8HNZKdJGNcaq/zYOOzaglM
         +jYECMKAWQEU8ZqVmDr6C6C6oy4SgrJ2iml5g01XwRcFSqrYJ0IZZIR2z/oVGVGBWMcD
         ji9FITWXZREmDocrhmSOqyDd6KyxohSAT7vDByein622wxk24HUU9Rn6zVFtaJ8zwLWz
         FoFg==
Content-Disposition: inline
In-Reply-To: <520AE4FC.5090702-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Li.

On Wed, Aug 14, 2013 at 10:01:32AM +0800, Li Zefan wrote:
> But most controllers don't check this in those read/write functions.
> It shoudn't do any harm not checking online/offline status.

It depends on the specific controller.  For controllers which make
clear distinction between online and offline states for, say,
hierarchical config propagation, it could lead to buggy behavior if
the function body afterwards assume that the current node is online.
I don't know whether this is the case for the functions converted here
but even if so the patch needs to update the description.

Thanks.

-- 
tejun
