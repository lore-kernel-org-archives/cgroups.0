From: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: remove extra calls to find_existing_css_set
Date: Thu, 22 Dec 2011 16:29:44 -0800
Message-ID: <20111223002944.GK13529@google.com>
References: <1324592816-13792-1-git-send-email-msb@chromium.org>
 <1324592816-13792-2-git-send-email-msb@chromium.org>
 <20111222231203.GO17084@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=beta;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-operating-system
         :user-agent;
        bh=6MBzf6TYY+UZ1xBz1HAKK13nI+mRhdEeguV62nDdE3s=;
        b=cF21zVowXhFvbsWcAUJsgsxP7jTZrIu9qle9npNyfj/L0Fq/ff9BLM1vfe8n8u70vy
         iOgzcWUovi4fop47JAjw==
Content-Disposition: inline
In-Reply-To: <20111222231203.GO17084-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>

Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org) wrote:
> On Thu, Dec 22, 2011 at 02:26:56PM -0800, Mandeep Singh Baines wrote:
> > +out_list_teardown:
> > +	if (retval) {
> > +		for (i = 0; i < group_size; i++) {
> > +			tc = flex_array_get(group, i);
> > +			put_css_set(tc->cg);
> > +		}
> > +	}
> 
> Don't we need to put them even after success?
> 

On success, we need to keep a reference for each thread in the threadgroup.

> -- 
> tejun
