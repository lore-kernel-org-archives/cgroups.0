From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup namespaces: add a 'nsroot=' mountinfo field
Date: Wed, 13 Apr 2016 14:50:33 -0400
Message-ID: <20160413185033.GH3676@htj.duckdns.org>
References: <20160321234133.GA22463@mail.hallyn.com>
 <20160413175736.GC3676@htj.duckdns.org>
 <20160413184639.GA29483@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/cXXhysQnf9FWy+3jX6I4PnP0gqqgaYYThDcvKNK3Ec=;
        b=woHzVBMh3Stv25K7L2IIUMB7F7d9bQg9RWDxa6v8nAJI+dbX0sG9p8Twy5WKBZADGO
         /xpT9pxBtYvwFwlDoE7s5jIEezmJqnkkLLRA+5NM2TcSdKYgjSO3Aru46I+QmmcquPVk
         ALeNWDIHHIQVVnh04ezSuk1dFDNuDNpIaYGfcsfzpx0nfYPv9t5FAgEchNv/M/Mc7THH
         yaY931d0D4Udy7QEm9p+8JKGJfZ4jXtCv3uQlNQefJfqGR82bHghca670ekangSMbrIQ
         rm70e7TrAxRnSwBvWF2qgYQZiIDBav+VGruZpoZXwv5461ZftRDHQYKjGEx9RA9MMv66
         1BxA==
Content-Disposition: inline
In-Reply-To: <20160413184639.GA29483-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Linux Containers <containers-qjLDD68F18O7TbgM5vRIOg@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Serge.

On Wed, Apr 13, 2016 at 01:46:39PM -0500, Serge E. Hallyn wrote:
> It's not a leak of any information we're trying to hide.  I realize
> something like 8 years have passed, but I still basically go by the
> ksummit guidance that containers are ok but the kernel's first priority
> is to facilitate containers but not trick containers into thinking
> they're not containerized.  So long as the container is properly set
> up, I don't think there's anything the workload could do with the
> nsroot= info other than *know* that it is in a ns cgroup.
> 
> If we did change that guidance, there's a slew of proc info that we
> could better virtualize :)

I see.  I'm just wondering because the information here seems a bit
gratuituous.  Isn't the only thing necessary telling whether the root
is bind mounted or namescoped?  Wouldn't simple "nsroot" work for that
purpose?

Thanks.

-- 
tejun
