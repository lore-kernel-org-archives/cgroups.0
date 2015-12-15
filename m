From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/6] cgroup: Remove prohibited white spaces
Date: Tue, 15 Dec 2015 12:06:33 -0500
Message-ID: <20151215170633.GD4026@mtj.duckdns.org>
References: <1450182045-27480-1-git-send-email-kuba.kunert@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=4GCMgqiMscSNrXzLuijlfCz0sQWTPuFS8AqoBKDG1Hc=;
        b=paUphltIJLGbQ4xfLIyojrZeJBBA0TF7zbZfrK2UaF3TeA777ZtewboWaVULzphcMQ
         5BtQY8LWCi0kKiRceCgztCwVZvAOu43YgoAIXioG2ONFKVAoLvWLt0DPfu1OAwox6g7r
         7MjS3Usfr3Z/4fgE60RIYIhHqnNkZ8dheFLeK7Qm2olHwRQEDoPbzoFOf+MACiJOLmVB
         0KeRPDvMxztap5977VB2YWY02urRuxcTeyU5+1yWuen3xQD47CUEw5LLKVwYAxO0mgE8
         1ZqpaRZlFspYYNDDKEJ345mXIG0FEWhZPESKb42rokdU7glvy1shQMA0cVCoeNHg/Kn9
         Mktw==
Content-Disposition: inline
In-Reply-To: <1450182045-27480-1-git-send-email-kuba.kunert-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jakub Kunert <kuba.kunert-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Jakub.

On Tue, Dec 15, 2015 at 01:20:40PM +0100, Jakub Kunert wrote:
> This patch fixes the checkpatch.pl error:
> 
> ERROR: space prohibited before open square bracket
> 
> Signed-off-by: Jakub Kunert <kuba.kunert-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
...
>  /* generate an array of cgroup subsystem pointers */
> -#define SUBSYS(_x) [_x ## _cgrp_id] = &_x ## _cgrp_subsys,
> +#define SUBSYS(_x)[_x ## _cgrp_id] = &_x ## _cgrp_subsys,

Don't follow the checkpatch.pl output without thinking.  No space
before opening brackets rule clearly isn't for cases like above.

-- 
tejun
