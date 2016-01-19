From: Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>
Subject: Re: [RFC PATCH net-next] net: Add l3mdev cgroup
Date: Tue, 19 Jan 2016 08:03:21 -0800
Message-ID: <20160119080321.0a8fe1c8@xeon-e3>
References: <1451925136-13327-1-git-send-email-dsa@cumulusnetworks.com>
	<20160104175836.GA11668@mtj.duckdns.org>
	<568ABFC3.3010803@cumulusnetworks.com>
	<20160104185936.GA3807@mtj.duckdns.org>
	<568AC534.1070308@cumulusnetworks.com>
	<20160104192301.GC3807@mtj.duckdns.org>
	<568ACF13.3030007@cumulusnetworks.com>
	<20160104200518.GD3807@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=J5PfQ1kEJRYnz5tvsf8glTyVuAcgnmmyD7weIlhjewA=;
        b=IJFZMVFo+Xm3DKMAMu2A5IQM8S4Q3VZXXbSQ3I5EVCVhr2UKWX1nd0bddZ6kCKJsxj
         abZFK32AwtGuC7QodvIZS+UupA6sbieuGFfhUJfh86MLGe16AXv8oHLB9L2oQKyPi7/9
         21XZykg8TjtJ8to8cigGSpyE56B7QWpyw7Frql74eq2m57hqsfipfBGz6Xk5C/0WAw6p
         XxlSY+GNuLfFWPbc+S58EjKe4QO/igcOJfNWUSaxNh9JM3PbnS1D4ObsmxRToxGZcCng
         8WszlaAkBC1zJqbU7qm/b7lAtV9duEdum+a2/l3/FxE3rTwl4O/lyoApWY1yQWc70q+3
         EE8Q==
In-Reply-To: <20160104200518.GD3807-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Ahern <dsa-qUQiAmfTcIp+XZJcv9eMoEEOCMrvLtNR@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shm-qUQiAmfTcIp+XZJcv9eMoEEOCMrvLtNR@public.gmane.org, roopa-qUQiAmfTcIp+XZJcv9eMoEEOCMrvLtNR@public.gmane.org

On Mon, 4 Jan 2016 15:05:18 -0500
Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> Hello,
> 
> On Mon, Jan 04, 2016 at 12:59:15PM -0700, David Ahern wrote:
> > cgroups have very nice properties that I want to leverage such as
> > parent-child inheritance and easy tracking which subsystem instance a task
> > belongs. This provides a great kernel foundation for building easy to use
> > management tools.
> > 
> > The documentation for cgroups does not restrict a controller to physical
> > resources but rather "it may be anything that wants to act on a group of
> > processes." That is exactly what I am doing here - I have a network config
> > that is applied to a group of processes similar to net_cls and net_prio (but
> > as I stated before those are orthogonal, independent settings from the L3
> > domain).
> 
> Please read the new version of cgroup documentation.
> 
>   https://git.kernel.org/cgit/linux/kernel/git/tj/cgroup.git/tree/Documentation/cgroup.txt?h=for-4.5
> 
> cgroup has experienced a lot of problems doing its main job -
> hierarchical resource control - from trying to support random things
> which want to group threads.  As shown with xt_cgroup, such
> identifying usages can be implemented in a way where the subsystem
> matches the membership rather than cgroup taking in configurations
> which belong to the subsystem, so please investigate that direction.
> 
> Thanks.
> 

Policy like this belongs in userspace not kernel.
