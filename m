From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 2/9] devcg: reorder device exception functions
Date: Tue, 29 Jan 2013 11:44:29 -0800
Message-ID: <20130129194429.GC6824@mtj.dyndns.org>
References: <20130129190759.117458287@napanee.usersys.redhat.com>
 <20130129190759.567563910@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=kjI/qVHOKJzClHma9IdrsJTGyX57ICVH89BER2pHE6k=;
        b=mgIhTf7GwWz6IMIv2+9j6safKNkfnyvvQbs9q+BjdO8iWGWQRLRIWlJ41ABiR7m+jy
         ze8Eo0FbFpPb44DbOEvYaGEL8TX0SXP7w60YHmPxaN4+4qCvaFXRYInUMOSHLZo2hS+v
         d+AlrllJ7Gx0xMYqR0u1+urJWxSbbEZLMd/tudUUfvF5WCCPKL2smoZVW0IuXR6TeOYV
         cO3IFpiBK4J/eeIcx0VqLnGZKKWpUvayL3dSt0RSF349VDz4f3HMJaCQeYDmpKmBxZOh
         d0nHpVsCZ90PIo8Y13rHi5rSzElDaRbPg+1nzRrFteR4FWuWxILluEsC71Ao06AQrqJ4
         PPZQ==
Content-Disposition: inline
In-Reply-To: <20130129190759.567563910-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On Tue, Jan 29, 2013 at 02:08:01PM -0500, aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> In preparation for the next patch, reorder dev_exception_add() and
> dev_exception_rm().

It would be nice to have something like "this change doesn't introduce
any functional changes".

> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
