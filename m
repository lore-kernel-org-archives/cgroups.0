From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/5] kernfs: implement kernfs_path_len()
Date: Thu, 9 Jul 2015 17:41:43 -0400
Message-ID: <20150709214143.GD18734@mtj.duckdns.org>
References: <1436281823-1947-1-git-send-email-tj@kernel.org>
 <1436281823-1947-5-git-send-email-tj@kernel.org>
 <559CDA8B.6040909@siteground.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=VWEEQB6bOTpZZyHdW7KWLoBhGJ2bkCxxTmjhir9On2s=;
        b=WSpXplAHu/jxp7+tJz9RB2r/8RLEB+dcIEMzfN3l0C1e/C1oRy3Ng8d0PXaMkWvrYS
         8GkWbiHMAfjPTdVdYHvSJ0wAapvgF8MxYs/JDFHHV0sqIo2DsW+xkqb/JvoZgfr+bLSJ
         +iJH9SSotsfFytHfXLAcOkhxpONpjCp7vBFi945FxwzES2U5kx+qS8xUsAGiAYbutzH+
         xDvemKYZsgMVJAmQ2m+UndGA5wrqOVjRErM7qgSl/4yy6LieLSitg351xD1EjuGUj1+W
         0mt9ahpwZwefSpEL85Xeqwkn5rLmXbQHCjrUKjJmr0BQz9/4XZvLQw3dSNa1ylYiiXvE
         0ToA==
Content-Disposition: inline
In-Reply-To: <559CDA8B.6040909-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nikolay Borisov <n.borisov-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello, Nioklay.

I restored the cc list.  Please use reply-to-all.

On Wed, Jul 08, 2015 at 11:08:43AM +0300, Nikolay Borisov wrote:
> > +size_t kernfs_path_len(struct kernfs_node *kn)
> > +{
> > +	size_t len = 0;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&kernfs_rename_lock, flags);
> > +
> > +	do {
> > +		len += strlen(kn->name) + 1;
> > +		kn = kn->parent;
> > +	} while (kn && kn->parent);
> > +
> > +	spin_unlock_irqrestore(&kernfs_rename_lock, flags);
> > +
> > +	return len;
> > +}
> > +
> 
> Can you explain the reason why you need to disable the irqs while
> executing this function? Presumably it has to do with the context of its
> usage - tracepoints but I wasn't able to find any information about the
> implications of interrupts being enabled while in a trace point?

It doesn't have much to do with the specific usage.
kernfs_rename_lock is irq-safe because we want to be able to call
functions like kernfs_name() and kernfs_path() regardless of the
current context.

Thanks.

-- 
tejun
