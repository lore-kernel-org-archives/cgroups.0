From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] device_cgroup: lock assert fails in dev_exception_clean()
Date: Wed, 23 Jan 2013 08:36:40 -0800
Message-ID: <20130123163640.GB2373@mtj.dyndns.org>
References: <1358460018-14717-1-git-send-email-jerry.snitselaar@oracle.com>
 <1358460018-14717-2-git-send-email-jerry.snitselaar@oracle.com>
 <20130117220642.GE16568@mtj.dyndns.org>
 <20130117231341.GA14588@cantor.us.oracle.com>
 <20130123043140.GA5913@cantor.us.oracle.com>
 <20130123142939.GC17632@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=Vp9Yrj8BAdlWfhfhTZTZr520JAe22EgHAbBt3qHeGcw=;
        b=BGlyexUp/BpAX2I7VKizSYHz5kTA7pPJA2Jr63wZPGEUfLkoUN6BkQcK7qb/CXRkYI
         YGEoJT6a4H+w4PsEYg5SP05BHjqS6UC8hVD8doHqQnzBt3zOhA580f5mR0thlHLPTb8u
         ++zvWxI9AwoxaBxt2Lx4hHRz3/5fQGSnhjPUFOl/drVygVfEcr7ByBVRk+abYSliEe1Q
         fy79GpKuv6Rqlq83otTTGOIOMX/lOrA+S5Na/bQne4qJmtlncslZY6HsuRxQ4ZfLnNrb
         6cx1mZxEjjQrcOPGLgq++fpEn7tNFuPBd+2LHyDxLgifmnkguLSRaDd87rjCnxD/HVNc
         8BYg==
Content-Disposition: inline
In-Reply-To: <20130123142939.GC17632-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jerry Snitselaar <jerry.snitselaar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jan 23, 2013 at 09:29:39AM -0500, Aristeu Rozanski wrote:
> Hi Jerry,
> On Tue, Jan 22, 2013 at 09:31:41PM -0700, Jerry Snitselaar wrote:
> > The original patch I sent to James and lkml got pulled in to linus. Is
> > the correct thing to do here put the list cleanup code back in
> > devcgroup_css_free and drop the call to dev_exception_clean along with
> > change my patch made like this?
> 
> I think this is what was suggested (not tested):

Yeap.

Thanks.

-- 
tejun
