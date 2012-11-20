From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 7/7] netprio_cgroup: allow nesting and inherit config on
	cgroup creation
Date: Tue, 20 Nov 2012 06:40:36 -0800
Message-ID: <20121120144036.GP15971@htj.dyndns.org>
References: <1353400211-5182-1-git-send-email-tj@kernel.org>
	<1353400211-5182-8-git-send-email-tj@kernel.org>
	<50AB45EA.2050507@monom.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=63lA+CuyKI21+PxNbTBu740eMmsTXz2fLd4HtHb01pc=;
	b=mP9nCyaXtf20fgzcx6Si+7EJFsIBg6d5r/P9PufOsZ3yAEQ7Mgwk44RqK4FoTU1IG/
	R0NyuAeePHcrf06rRnILEiGYT/LCej2flqHABb+2h9lpW8bB/aZbUhYL57NPWXvVFBED
	+3pAT294t4Cv9KOY2gqk/cd1YosUstpq4FS8qtc9w/ZpybBJl77R03aro4g378GugBiK
	IOKedeV6cwhL6KWppAmNPigsnIdPWpj/9+GiOhgIpiUVZpqtD1q20ncuWKhBm8dJ2L2N
	ayoAg/L2br45XOwYMLqPEL6hby6CrVqYrHG2zDZErxhqb/hTEE3aWb7x9MmkYY5GaR0L
	UCFw==
Content-Disposition: inline
In-Reply-To: <50AB45EA.2050507-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
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
To: Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Cc: nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, tgraf-G/eBtMaohhA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org

Hello, Daniel.

On Tue, Nov 20, 2012 at 09:57:14AM +0100, Daniel Wagner wrote:
> >-static void cgrp_css_free(struct cgroup *cgrp)
> >+static int cgrp_css_online(struct cgroup *cgrp)
> >  {
> >-	struct cgroup_netprio_state *cs = cgrp_netprio_state(cgrp);
> >+	struct cgroup *parent = cgrp->parent;
> >  	struct net_device *dev;
> >+	int ret = 0;
> >+
> >+	if (!parent)
> >+		return 0;
> 
> BTW, parent is always != NULL, because the root cgroup will be
> attached to the dummytop cgroup.

Hmmm?  I'm confused.  When ->css_online() is called for dummytop in
cgroup_init_subsys(), its parent is NULL.  What am I missing?

Thanks.

-- 
tejun
