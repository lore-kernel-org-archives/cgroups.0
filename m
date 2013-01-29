From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 5/9] devcg: prepare may_access() for hierarchy support
Date: Tue, 29 Jan 2013 11:49:01 -0800
Message-ID: <20130129194901.GF6824@mtj.dyndns.org>
References: <20130129190759.117458287@napanee.usersys.redhat.com>
 <20130129190759.993951510@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=kBp/u94biow8jM+EDdtJ21V1L52cl/XtleI2k48w6Cg=;
        b=qK+m9gTy4/Hxw08qiDl6IaATX7fPFdBR80Kztp1zvmdEw5tZjtBDHnfmMViiA1hXyY
         0XoKYuQ7ElZsZCxybZlt22lvIMBEvNfJiM1N97TCLyjuJauRFMKtXWUpmmVwktPchVCA
         CDGfuxriP/h/D90hUtUabWuA6ULBsxqeTV6fcKfxtS9wOK7LiM21J//EPRQnDG/pIiwE
         9z+rtDNFHXisbrWYg6AjZl0id35sFBROReql2q8OESIAWu/nlk0YyPe0oKhJJXNxZBUM
         4oPUOnR24eGkOdw39of8QfQyNxl/eGPivj8SWJV4aUsF4PEPoxb1pN6QdT6ew1j+zYnz
         4EMA==
Content-Disposition: inline
In-Reply-To: <20130129190759.993951510-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On Tue, Jan 29, 2013 at 02:08:04PM -0500, aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> Currently may_access() is only able to verify if an exception is valid for the
> current cgroup, which has the same behavior. With hierarchy, it'll be also used
> to verify if a cgroup local exception is valid towards its cgroup parent, which
> might have different behavior.
> 
> v2:
> - updated patch description
> - rebased on top of a new patch to expand the may_access() logic to make it
>   more clear
> - fixed argument description order in may_access()
> 
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> ---
>  security/device_cgroup.c |   44 +++++++++++++++++++++++++++-----------------
>  1 file changed, 27 insertions(+), 17 deletions(-)
> 
> --- github.orig/security/device_cgroup.c	2013-01-29 11:49:15.514669057 -0500
> +++ github/security/device_cgroup.c	2013-01-29 11:49:15.795673240 -0500
> @@ -354,9 +354,11 @@ 	return 0;
>   *		verify if a certain access is allowed.
>   * @dev_cgroup: dev cgroup to be tested against
>   * @refex: new exception
> + * @behavior: behavior of the exception
>   */
> -static int may_access(struct dev_cgroup *dev_cgroup,
> -		      struct dev_exception_item *refex)
> +static bool may_access(struct dev_cgroup *dev_cgroup,
> +		       struct dev_exception_item *refex,
> +		       enum devcg_behavior behavior)

Probably belongs to the previous patch.  Other than that,

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
