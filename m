From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/8] cgroup: kill
	cgroup_subsys->__DEPRECATED_clear_css_refs
Date: Wed, 31 Oct 2012 09:38:48 -0700
Message-ID: <20121031163848.GC2945@htj.dyndns.org>
References: <1351657365-25055-1-git-send-email-tj@kernel.org>
	<1351657365-25055-2-git-send-email-tj@kernel.org>
	<509125D9.8070100@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=A5sN9herBvmwWKTU5OdOVOy7ump6GLqbcUhbm9qj43A=;
	b=rbZE1ZPeWJOm3HRg1iXG4K8av1GKaXFKnbqKsCtMunA5xqNe6PBZZLOe48FKNUbhNG
	ZZsW53Qe9uMgb/Wb1kK1Dk84O+Iz2q5Nx9aFzBX70NV1hCKvfmpwsnVpq/3DrUiMwdGi
	bIALhUkWV5DEg6kcXc6LQ3nAF/YynZZ8UPOjmQNywnDE0502FoJQFE3VKXGqcUrre/Xc
	VUhxpv/0EhjgI1U3MUcU4FBBHeoi0v3srrEryQ8K37cC/bLTUYB7lnq4EEl6VGHC7AOs
	pr8Mnq0Vr+Lbk4b86LBPOQCBAGfNTuFg8ia4HUPorJo3R+UGts3Jdn5VEWAHm/wg3Vtp
	RFCA==
Content-Disposition: inline
In-Reply-To: <509125D9.8070100-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

Hello, Glauber.

On Wed, Oct 31, 2012 at 05:21:29PM +0400, Glauber Costa wrote:
> > +
> > +	local_irq_disable();
> > +
> > +	/* block new css_tryget() by deactivating refcnt */
> > +	for_each_subsys(cgrp->root, ss) {
> > +		struct cgroup_subsys_state *css = cgrp->subsys[ss->subsys_id];
> > +
> > +		WARN_ON(atomic_read(&css->refcnt) < 0);
> > +		atomic_add(CSS_DEACT_BIAS, &css->refcnt);
> >  	}
> > -	/* NO css_tryget() can success after here. */
> > +
> > +	/*
> > +	 * Set REMOVED.  All in-progress css_tryget() will be released.
> > +	 * Put all the base refs.  Each css holds an extra reference to the
> > +	 * cgroup's dentry and cgroup removal proceeds regardless of css
> > +	 * refs.  On the last put of each css, whenever that may be, the
> > +	 * extra dentry ref is put so that dentry destruction happens only
> > +	 * after all css's are released.
> > +	 */
> > +	for_each_subsys(cgrp->root, ss) {
> > +		struct cgroup_subsys_state *css = cgrp->subsys[ss->subsys_id];
> > +
> > +		set_bit(CSS_REMOVED, &css->flags);
> > +		css_put(css);
> > +	}
> > +
> > +	local_irq_enable();
> > +
> >  	finish_wait(&cgroup_rmdir_waitq, &wait);
> 
> It seems to me that the main reason for doing this in two passes was to
> derive a global "failed" state on the first pass. Now that we can't
> fail, why can't you just loop through the subsystems just once ?

Later in the series, pre_destroy() happens inbetween.  The first loop
marks the CSSes and cgrp dead, ->pre_destroy()s are called, and the
later loop will put the final ref.  I'll mention it in the commit
message.

Thanks.

-- 
tejun
