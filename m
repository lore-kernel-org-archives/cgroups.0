From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] device_cgroup: add lockdep asserts
Date: Tue, 6 Nov 2012 12:29:45 -0800
Message-ID: <20121106202945.GU30069@mtj.dyndns.org>
References: <20121106171612.GH30069@mtj.dyndns.org>
 <20121106174036.GA28916@sergelap>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=1TMxyp9zwexqs85Stn6gTO1EeRGEwKuOcfFglD3bURM=;
        b=tEWFjq2XLN5vRL0znuE9SpFwCe9DtG0imnEVwhDiPY9/jmYI9py6vK9RuXTwQh3d74
         854Te2LHKKZLUvukJM9wJ3F3sU+vRLGAWzA9QzF7BTYkj3EMT6DkrFtkQk2OfEmYFU7l
         JVaWXNcam5L33l8el7z0ZlzhchIiA/4hfu2PtqeKUiYbkhwkZ55X2PQeErGwTmFCX7fJ
         NzAztXLZH+loDXJ2Bmg13KRJXfxZ7TfmR/UXNbYsEuquMEBulfiDodUFhuvxDfjr+DsT
         N3jPG7N+RLTV0R4WeQ8x4lPmoe8qAnfri2iFKrPi18jUZVvNI5cYFDl+i5ZQ8r+SYUBG
         7fAw==
Content-Disposition: inline
In-Reply-To: <20121106174036.GA28916@sergelap>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Nov 06, 2012 at 11:40:36AM -0600, Serge Hallyn wrote:
> Quoting Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org):
> > device_cgroup uses RCU safe ->exceptions list which is write-protected
> > by devcgroup_mutex and has had some issues using locking correctly.
> > Add lockdep asserts to utility functions so that future errors can be
> > easily detected.
> > 
> > Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Cc: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > Cc: Serge E. Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> 
> Acked-by: Serge E. Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.8.

Thanks.

-- 
tejun
