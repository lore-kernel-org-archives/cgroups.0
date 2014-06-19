From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: docker crashes rcuos in __blkg_release_rcu
Date: Thu, 19 Jun 2014 16:26:40 -0400
Message-ID: <20140619202640.GA9814@mtj.dyndns.org>
References: <alpine.DEB.2.02.1406081816540.17948@jlaw-desktop.mno.stratus.com>
 <20140609174708.GA31499@redhat.com>
 <20140609182728.GB31499@redhat.com>
 <20140610143906.0d2f35d0@jlaw-desktop.mno.stratus.com>
 <20140611163229.GA12974@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=c95mA25K/lxTl3YwQ9/HqSh9HtBBy2rajttKGhc2GWg=;
        b=kzKTTY0PiuKN2C9y1ZIcOnCgjWjIQWCREkiqREKCITGqCyT+rH8BIgoB/Wiclp3IOm
         TG/3iymiqXZyHV0RU/zvgiJFT2vaevktIocTFjsXQFRezxhgm+L3DmhAsKU0YuQZzqyD
         3ZwkO5pgdw0H23yhcEdr2+4tg0Ycpn0qTSMN00JAo+e6o9FZE5ujgPMS7iquAbwCM4wG
         h7zeeBxeCMDKFf/st29m+KJLcvQhO5TAocdTPdZ8ablm2zXpPJEbfjfEMZDicGFpaC67
         wzpqIN5dDv4syxNORJBBi/J3lAQYFcfAcm/j9TjgdrWhFGDDhQLWiEYazwICFTJ0IUpw
         8oVw==
Content-Disposition: inline
In-Reply-To: <20140611163229.GA12974-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Joe Lawrence <joe.lawrence-7+ureL1bLXNBDgjK7y7TUQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Sorry about the late reply.

On Wed, Jun 11, 2014 at 12:32:29PM -0400, Vivek Goyal wrote:
> Tejun, any thoughts on how to solve this issue. Delaying blkg release
> in rcu context and then expecting queue to be still present is causing
> this problem.

Heh, this is hilarious.  If you look at the comment right above
__blkg_release_rcu(), it says

 * A group is RCU protected, but having an rcu lock does not mean that one
 * can access all the fields of blkg and assume these are valid.  For
 * example, don't try to follow throtl_data and request queue links.
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

And yet the code brazenly derefs the ->q link to access the lock there
and causes oops.  This is from 2a4fd070ee85 ("blkcg: move bulk of
blkcg_gq release operations to the RCU callback").  I stupidly didn't
realize what I was doing even while moving the comment itself.

Well, the obvious solution is making blkg ref an atomic.  I was
planning to convert it to percpu_ref anyway.  We can first convert it
to atomic_t for -stable and then to percpu_ref.  Will prep a patch.

Thanks for tracking it down!

-- 
tejun
