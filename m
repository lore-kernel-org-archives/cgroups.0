From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.5-fixes] cgroup: fix alloc_cgroup_ns() error
 handling in copy_cgroup_ns()
Date: Thu, 18 Feb 2016 15:26:50 -0500
Message-ID: <20160218202650.GH13177@mtj.duckdns.org>
References: <20160217185811.GA3472@mwanda>
 <20160218164658.GD13177@mtj.duckdns.org>
 <20160218202112.GZ5273@mwanda>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=BdNbbkznnOWwr7x49VXYEmEVbd1BhTgjTYwaZHrrsb4=;
        b=ZUryIF1FJrjeuyH5oCOGDE4wLGl2uND8ZjEBu8rGsO1AeO37D2NdeXEjAFHTBA3GEi
         EiQdiFMaJFuNjUXEwPC4z4L3P3Dy7hTib2Ltzrv6ocRR4PHdYGez/hlYpRGnWzGJv+iU
         uNOPkZtI0EmGPMKZU4DR+8jUgGLNwgzIu5vdlOwcpr2dfBA1gRvrlauIEHBm0rQCXHVS
         qVjl+m50GDizUcm1iBS+BdBbibTyEBgOQjeX1o3qxU1MdMsgjgBc06q7EVcrhYU/rD0W
         sYx+acgXR47T7b2wXlWEtc+OOZZlSq5iG4bxTCylgUOIHv4qOEFzjh5JaWZQVdNCAE9X
         QSOA==
Content-Disposition: inline
In-Reply-To: <20160218202112.GZ5273@mwanda>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Feb 18, 2016 at 11:21:12PM +0300, Dan Carpenter wrote:
> Sorry, I was feeling like a jerk yesterday.
> 
> I obviously could have fixed this myself but I wanted to make a point
> about one error label, do-everything style "future proof" error
> handling.  It is a trap for the unwary.
> 
> Now the code calls kfree(-ENOMEM).  It's a very predictable mistake.

lol let's take the chance and convert the NULL check in kfree() to
IS_ERR_OR_NULL().

Seriously tho, I don't think this is a good evidence against merged
error handling.  It's not like we don't make repeated mistakes with
split error labels.  Anyways, care to submit a proper patch?

Thanks.

-- 
tejun
