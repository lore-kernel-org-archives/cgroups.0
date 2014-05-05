From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] device_cgroup: check if exception removal is allowed
Date: Mon, 5 May 2014 11:21:34 -0400
Message-ID: <20140505152134.GK11231@htj.dyndns.org>
References: <20140424193254.GR29214@redhat.com>
 <20140502152930.GF10204@htj.dyndns.org>
 <20140505151431.GK29214@redhat.com>
 <20140505151621.GJ11231@htj.dyndns.org>
 <20140505151858.GL29214@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=0dIcL+TdYKpPtd6+9zP0tc1F3WHG68ognf8druxw4FQ=;
        b=rYuzTiIFgNhuUqFTnLSxUUc+gqQ2/UoA5ffQk09YVQ4nWv0YE9ZLIFZWRqSPqgj/8q
         phzZsiPab54pOGH1Y+kYdvwm8vBRPrxMjo+FJAHMoJXLDz1vF7npkbbG0+4yJqcdyBwi
         0l+Qub45E4PLlLC1y3yYjDPoSf/XvkbTjkLkQ0jkac56BggX6NekFChG3/QiSpaI1JtW
         eyiUny42ApeeXJAFaO+AzrIIEXcNK2rZGU+vMaFHquhoaHqJq69NAn/BPcksLW9rx+9S
         3rYwet93JuK2VPsddighvDVSvN7PxZaoMQ98pkaAwTTFsn9aS/vM6Mx4Z9PqCBxS2ec3
         WE8g==
Content-Disposition: inline
In-Reply-To: <20140505151858.GL29214-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, May 05, 2014 at 11:18:59AM -0400, Aristeu Rozanski wrote:
> [PATCH v3 1/2] device_cgroup: check if exception removal is allowed
> 
> When the device cgroup hierarchy was introduced in
> 	bd2953ebbb53 - devcg: propagate local changes down the hierarchy
> 
> a specific case was overlooked. Consider the hierarchy bellow:
> 
> 	A	default policy: ALLOW, exceptions will deny access
> 	 \
> 	  B	default policy: ALLOW, exceptions will deny access
> 
> There's no need to verify when an new exception is added to B because
> in this case exceptions will deny access to further devices, which is
> always fine. Hierarchy in device cgroup only makes sure B won't have
> more access than A.
> 
> But when an exception is removed (by writing devices.allow), it isn't
> checked if the user is in fact removing an inherited exception from A,
> thus giving more access to B.
> 
> Example:
> 
> 	# echo 'a' >A/devices.allow
> 	# echo 'c 1:3 rw' >A/devices.deny
> 	# echo $$ >A/B/tasks
> 	# echo >/dev/null
> 	-bash: /dev/null: Operation not permitted
> 	# echo 'c 1:3 w' >A/B/devices.allow
> 	# echo >/dev/null
> 	#
> 
> This shouldn't be allowed and this patch fixes it by making sure to never allow
> exceptions in this case to be removed if the exception is partially or fully
> present on the parent.
> 
> v3: missing '*' in function description
> v2: improved log message and formatting fixes
> 
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: Aristeu Rozanski <arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.15-fixes.

Thanks.

-- 
tejun
