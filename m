From: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] cgroup: remove extra calls to find_existing_css_set
Date: Mon, 30 Jan 2012 14:06:33 -0800
Message-ID: <20120130220633.GT4656@google.com>
References: <1327956716-11537-1-git-send-email-msb@chromium.org>
 <20120130210128.GA27051@google.com>
 <20120130210404.GA27616@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-operating-system
         :user-agent;
        bh=BkcsX5UHXZykkRrT/WkFQBenZMJI1E1qslfdbZYA+k4=;
        b=eS9ZWkOIDtI7s+RnrSG423jsMb0eyZYMlfW7XQHEMELfK/kEQqrATyt2/BYrqxsnm8
         oiHLrGJD4wri24P2K5Dp8aLCpxYWKz/DTjtdsgIVBd3HuYq6KWxu45mezqKuAZVWVUGZ
         nycrk1KAjp8SU271hSHeZDr3plNeRdqCUAUNU=
Content-Disposition: inline
In-Reply-To: <20120130210404.GA27616-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>

Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org) wrote:
> On Mon, Jan 30, 2012 at 01:01:28PM -0800, Tejun Heo wrote:
> > Hello,
> > 
> > On Mon, Jan 30, 2012 at 12:51:56PM -0800, Mandeep Singh Baines wrote:
> > > -	/*
> > > +        /*
> > 
> > Whitespace contamination fixed.
> > 
> > Applied to cgroup/for-3.4 w/ previous Acked-by's added.  Please
> > collect them on submission.
> 
> Ooh, never mind.  I was confused with acks to other patches.  Only Li
> has acked it, right?  If somebody else also acked it, please scream.
> 

Yep. Just Li.

> Thanks.
> 
> -- 
> tejun
