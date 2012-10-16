From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] block: lift the initial queue bypass mode on
 blk_register_queue() instead of blk_init_allocated_queue()
Date: Tue, 16 Oct 2012 12:11:58 -0700
Message-ID: <20121016191158.GC16166@google.com>
References: <20120919194231.GF31860@redhat.com>
 <20120920183153.GI28934@google.com>
 <20120920184219.GH4681@redhat.com>
 <20120920191716.GI4681@redhat.com>
 <20120920192038.GJ28934@google.com>
 <20120920195759.GK4681@redhat.com>
 <20120920201815.GB7264@google.com>
 <20120920210852.GC7264@google.com>
 <505C6AD4.6030206@kernel.dk>
 <CAOzFzEiCWazLEfjo=w8c+7qCce98Q6faW1uwGm-tRmCNPJUztw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=DAZLV7qaRG2olpWAKFJl/PRVwyc1c8+ti/btGyO38B4=;
        b=b32hwEiIUVn9paszeNhZ0w69dgDFk7NB9vLf9r6qQB1Km+xf8gpdGV/2PPFP6FrbTa
         fDHMjJu0mxNVFvBCfvvJS5TEwA7joO/0gZwwTlTOVBJwsoP6tGhXakNMl6BbxbuWBBZC
         nHwfaa6R2RFIO+Ce00rCSGGLfYejBn3xr2uXlW0VzstN1yga5KfcuiHol7LnNIz68bTf
         /9mhj+H90xPvq6ExIcpEtRyGTm2dvY8YP4e0iKK4C1RSngvUZrSC3vw76RA8zEVmUIPu
         1XFy0auN5jhf85Y9iylmJFswMfqDmV/mkhTmOs3wkvaCfk2VYHapUvs4W7zVHNr0kfYI
         1umg==
Content-Disposition: inline
In-Reply-To: <CAOzFzEiCWazLEfjo=w8c+7qCce98Q6faW1uwGm-tRmCNPJUztw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Oct 16, 2012 at 09:00:30PM +1100, Joseph Glanville wrote:
> Has this patch been marked for stable?

Yes, both have been marked.

Thanks.

-- 
tejun
