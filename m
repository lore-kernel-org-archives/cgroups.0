From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 6/9] devcg: use css_online and css_offline
Date: Tue, 29 Jan 2013 11:52:40 -0800
Message-ID: <20130129195240.GG6824@mtj.dyndns.org>
References: <20130129190759.117458287@napanee.usersys.redhat.com>
 <20130129190800.123213034@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=RuI+zgEg1UftwOxhbtKd5XvWfvIfMYmA8OutqObw29w=;
        b=b2tOzFtonw/krsUkVTTZJi0achKtMWxPWsffLkgZTu/MIt8HyJ11MiAELiC6V/fl6Z
         n6EjaXxdHAcruqfb7AgQoCNkZoncj6mKgF6nJd+/IoEs4+CXLrMUhVAjOLTUWw2nIpou
         P29sjmyH/etQesj6XCMqAGDLmQFUVjhDtmu6f2G4/f5v3QOP7oMjkjIibAgzGtQPfO9W
         NS3EwG+X3qcOzUxSp6ScXexBcLc/fUkn9NZcv6vs8jY28m1wr6xAtmp3dTfOW5ZHVydE
         yC/c7qRMlx5Y6GDq6pxSIf0LBcc1GOExfse64d3LyAwuYLpcNMC+XPB2tcG/tO+iRErm
         ZIhg==
Content-Disposition: inline
In-Reply-To: <20130129190800.123213034-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On Tue, Jan 29, 2013 at 02:08:05PM -0500, aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> Allocate resources and change behavior only when online.
> This patch is in preparation for hierarchy support.

I think the description is a bit lacking.  We need this because we
need to reliably determine whether a certain node is on the hierarchy
or not for config propagation and inheritance.  It would be nice if
you explain the synchornization implications.

> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Other than that,

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

-- 
tejun
