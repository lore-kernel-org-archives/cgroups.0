From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/7] cgroup: update and fix parsing of
 "cgroup.subtree_control"
Date: Tue, 13 May 2014 11:18:33 -0400
Message-ID: <20140513151833.GE23710@htj.dyndns.org>
References: <1399663975-315-1-git-send-email-tj@kernel.org>
 <1399663975-315-5-git-send-email-tj@kernel.org>
 <537196D7.3020302@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=HWIj35lnTs1Hv1ORLXivSz1ABvfD8DpbaDhuSHNZTAE=;
        b=vBEEAPVk+Z7buOXyz0+SopCfSTKaDN7jgNNv8OxCfJKVRHVMaceYUm2DvlGHaC3j0E
         paONd4hfxcOK+5vmLEyvfIaTPHpeTHlBIhP5AwptVYHeMOmwawXMrcSh40Ae83R2XTLn
         ppenxkjsaLN5ENdi4E4HCXGnINDTKqj6iNRPdgV6kkyBoF8QK+++daFslWsHDHu36ttY
         /O/lhdM3gMQ8CEF+G2WwQZoUU/OJcVral1tRlvo0biZfoZrhi+61iBUBDfRV7oro2Y41
         hHXYR3nhfhbypHyySLe1c+dodU1V4LFuOyHkx3ORWcHefZEpZz4O6gQ8/gjf4KCB1nDb
         Rxzg==
Content-Disposition: inline
In-Reply-To: <537196D7.3020302-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, May 13, 2014 at 11:51:51AM +0800, Li Zefan wrote:
> > diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> > index 35daf89..b81e7c0 100644
> > --- a/kernel/cgroup.c
> > +++ b/kernel/cgroup.c
> > @@ -2542,11 +2542,13 @@ static int cgroup_subtree_control_write(struct cgroup_subsys_state *dummy_css,
> >  	int ssid, ret;
> >  
> >  	/*
> > -	 * Parse input - white space separated list of subsystem names
> > -	 * prefixed with either + or -.
> > +	 * Parse input - space separated list of subsystem names prefixed
> > +	 * with either + or -.
> >  	 */
> >  	p = buffer;
> > -	while ((tok = strsep(&p, " \t\n"))) {
> > +	while ((tok = strsep(&p, " "))) {
> > +		if (tok[0] =='\0')
> 
> if (tok[0] == '\0')

Oops, updated.

Thanks.

-- 
tejun
