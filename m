From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 14/14] cgroup: implement css_tryget()
Date: Sun, 11 May 2014 08:38:37 -0400
Message-ID: <20140511123837.GC22945@htj.dyndns.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
 <1399671091-23867-15-git-send-email-tj@kernel.org>
 <20140511045459.GA25009@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=+nN1xSNXnlgs2YgVMswUUYAOGrD+graFwXk9WWAJfo0=;
        b=WpQw7STpDo7umHhWrhVdS8clwgbXM42hIOaRTAnOGXZXvKxy1fe0ax4Pha80L+LN2l
         50Fsa9zTR0DpFZa6+7Eb7LTxzM7Fxm28OCO9z9pIGyY8tva0MI5itgzwLtT01THUQPZG
         z7WJl+Df5aknGR+3Bv0saOH6IqvppOdKxWjGkW5yJqHC+LoGPVekllljlYzKZjByw67M
         aOSMYKG5tQAXysLEgONh8H52M3uXqO0byh3EsYGozEPn/J0kQSrrkhDx5sEyQd3bCfHN
         Sr5i9gdV3JXQ2wzE61+Wshfjr+SLtfQer6+2Kwjz0zFNFQTUdcOZL4gbajHZo3jtQQsr
         Nynw==
Content-Disposition: inline
In-Reply-To: <20140511045459.GA25009-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, May 11, 2014 at 12:54:59AM -0400, Johannes Weiner wrote:
> >  /**
> > + * css_tryget - try to obtain a reference on the specified css
> > + * @css: target css
> > + *
> > + * Obtain a reference on @css unless it already has reached zero and is
> > + * being released.  This function doesn't care whether @css is on or
> > + * offline.  The caller naturally needs to ensure that @css is accessible
> > + * but doesn't have to be holding a reference on it - IOW, RCU protected
> > + * access is good enough for this function.  Returns %true if a reference
> > + * count was successfully obtained; %false otherwise.
> > + */
> > +static inline bool css_tryget(struct cgroup_subsys_state *css)
> > +{
> > +	return percpu_ref_tryget(&css->refcnt);
> > +}
> 
> percpu_ref_tryget() fails once killed (transitioned from per-cpu to
> atomic mode), but exactly this happens during offlining and so this
> would actually be equivalent to css_tryget_online(), no?

Not any more.  percpu/for-3.16 already contains the updates to
percpu_ref_tryget[_live]().  percpu_ref_tryget() succeeds as long as
the refcnt is above zero.

Thanks.

-- 
tejun
