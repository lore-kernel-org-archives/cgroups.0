From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 8/9] devcg: refactor dev_exception_clean()
Date: Tue, 29 Jan 2013 11:55:06 -0800
Message-ID: <20130129195506.GI6824@mtj.dyndns.org>
References: <20130129190759.117458287@napanee.usersys.redhat.com>
 <20130129190800.443784569@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=EyaZ8KvltGlKHSD5/oojpFXxbbpnGzv5RMHTUT2FvBM=;
        b=l1gRTAbrKVle3+nclU+rvh233L67CVqrrY+cA2VZBTyN2kilhGyQIIG71i7x04hq6h
         FJXoCadvJQ/vXBU3O4CkF/5gRr/6faC8XjdULZ111TXmg09SlRqXaUtGUHP+GqlJWwXe
         OCi6vK7yz2fHuaSmKm5+AaAX/zMUQ2BtDl58yyt3e/HKKomZwBCKFgaCDVzvbf97E5xW
         L4dv9wmMJ/qx93T/EvONaQ8zduKnOghUVMtCl37tmr9PTVCBCzUEKBY1+tnaUa9lbCnW
         kW0ihkcicGQxUmPX0zKIuA4nddSkTdQpG+fJh5/fOarXZJxrIat0Zkfx01wG6K+Mkhh0
         kL+A==
Content-Disposition: inline
In-Reply-To: <20130129190800.443784569-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On Tue, Jan 29, 2013 at 02:08:07PM -0500, aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> This patch is in preparation for hierarchy support.

Ditto.

> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
