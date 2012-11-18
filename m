From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.8] netcls_cgroup: implement hierarchy
 support
Date: Sun, 18 Nov 2012 06:25:34 -0800
Message-ID: <20121118142534.GF7306@mtj.dyndns.org>
References: <1353123062-23193-1-git-send-email-tj@kernel.org>
 <20121117.220421.1904738911212014470.davem@davemloft.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=pitZjGVZzdptvMBE+4SlcXBW2qVwpLQsTEeZWB1Iifo=;
        b=nQTuoc9HMg8jnEmDgnGYY9O2sI6wciQ1Zg7HMUdZcWZqslo/RFCRAE9PvyL2mFk5vP
         qRTwZnwx7GrEtEZlq1KVE+HB/Rv/y/4AiQGHzJRZWy/45M15PkhtHNqiWnwqg6qhZU4W
         vnEMthLCpl22oXdGsOl+J5uBXIXpcRuqWktgYsG1TWRI0CYVYoJ2O87tlJHNl7A2YzF6
         69oSYW9itI2+RPkNZF1nuSy8CP1KWIc0FJ1pzKI3DVqe0tUNiTzsLFSnW0WoK9ZwbVbe
         Y2Id/7Qcr8X5nXF2YgnQ9GREcVounNghVjeAjOlJAydceRG8THjYug5+oHRuIgcEsEgu
         SlNQ==
Content-Disposition: inline
In-Reply-To: <20121117.220421.1904738911212014470.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org, serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, tgraf-G/eBtMaohhA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Sat, Nov 17, 2012 at 10:04:21PM -0500, David Miller wrote:
> > This patchset implements proper hierarchy support for netcls_cgroup.
> > Pretty simliar to the netprio one[3].  Simpler as each cgroup has
> > single config value instead of array of them.
> > 
> > This patchset contains the following three patches.
> > 
> >  0001-netcls_cgroup-introduce-netcls_mutex.patch
> >  0002-netcls_cgroup-introduce-cgroup_cls_state-is_local.patch
> >  0003-netcls_cgroup-implement-proper-hierarchy-support.patch
> > 
> > This patchset is on top of
> 
> I guess you therefore want to put it through your cgroup tree?

Yeap.

> Acked-by: David S. Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>

Great, I forgot to cc you on netprio_cgroup changes.  It's similar to
this one but larger partly because the configuration is per
cgroup-netdev pair.  Would it be okay to route the following through
the cgroup tree?

  https://lkml.org/lkml/2012/11/16/514

Thanks.

-- 
tejun
