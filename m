From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/4] kernfs: make kernfs_path*() behave in the style of
 strlcpy()
Date: Tue, 9 Aug 2016 15:58:13 -0400
Message-ID: <20160809195813.GF4906@mtj.duckdns.org>
References: <1470720204-4605-1-git-send-email-tj@kernel.org>
 <1470720204-4605-3-git-send-email-tj@kernel.org>
 <20160809153305.GB30775@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pe2FNYQ26GARDit3JxoeZ2oTfFWFNU37U3G1Ny8mumg=;
        b=TG9Y2HHIsWEmOxpQcfj2WoyRh7e9XhikWMpIcMttQGJ3xgCdstvpoFcaHzndGCSf8H
         qafMvSSf2LybAnI++FNB1RWCqnCmQxMuK7gwPI27xpt3FKe0RSo5TF1t2Q5TEwMFfjM8
         H4wEEtEN5bQ/fhknNDmmRELOwlXhpB54qjlBgs4O51knX7ZP+zb53aDW256X7zLrxW77
         j/W0gQJh8c7mKxJ5W6CW3DJo9q9IjxorH8hLe1gg6XEFlTs83YwYM/xrrBS3Jg0kwxXW
         SNShW0C/Z/9Te4TNHCVMalpG5zuomme9UnX02kczjKiMc3URKabIztI7dmu3omT5mo/l
         dGgA==
Content-Disposition: inline
In-Reply-To: <20160809153305.GB30775-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Hello, Serge.

On Tue, Aug 09, 2016 at 10:33:05AM -0500, Serge E. Hallyn wrote:
> > +	for (i = depth_to - 1; i >= 0; i--) {
> > +		for (kn = kn_to, j = 0; j < i; j++)
> > +			kn = kn->parent;
> 
> This is O(n^2) where n is the path depth.  It's not a hot path, though, do
> we care?

I don't think it matters.  It's a slow path and cgroup hierarchies
aren't supposed to be super deep to begin with.  If it ever does, we
can replace the cgroup->ancestor_ids[] array with ancestor pointer
array and walk that instead.

Thanks.

-- 
tejun
