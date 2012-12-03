From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/5] device_cgroup: propagate local changes down the
 hierarchy
Date: Mon, 3 Dec 2012 13:36:38 -0800
Message-ID: <20121203213638.GK19802@htj.dyndns.org>
References: <20121127193501.255267751@napanee.usersys.redhat.com>
 <20121127193503.114004167@napanee.usersys.redhat.com>
 <20121203180145.GJ19802@htj.dyndns.org>
 <20121203191411.GE32112@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=1tmWra4RnpUSK6yg5dd6egE3MrOYLJ9m0ZpBkGHSmOA=;
        b=fEnRpjj6JIyvHtC1Y1Y+b6mdcDlIuy3Aa8/bjd51mHnKPynkDqZwYf4nn3HgZSVvIu
         Ob2Gcgg7MD1+Tdiu7ccASoOI4RFhRaC8b5ep1hpM5cfg4/IZiUWoCbFZq4v6KNV5GdNb
         dCdS5ue7GBXZMlXbDKHn+LAyvj/IziUDZRxi0DSSdDDAJK5BGo0IKfRuJGl1XC+ou7JE
         3Jy4157lwNAFQwCvWUlVAkuqMQkKqtPzdjvuXYQIN6M715XoMOrKOSCJpkqw0yXmKht4
         CN60cfJsYJChdJLodhHYnyR+u6ktvCYtF09la893FjeJgOpnU01R3qtvUFkx/xs/gB3E
         0OxQ==
Content-Disposition: inline
In-Reply-To: <20121203191411.GE32112-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Aristeu.

On Mon, Dec 03, 2012 at 02:14:12PM -0500, Aristeu Rozanski wrote:
> > Maybe I'm misunderstanding something but the behavior seems a bit
> > inconsistent.  So, you can't add an exception which isn't allowed by
> > your parent, right?  But, if your parent disallows an existing
> > exception, you get to keep it?  I think it would be more consistent to
> > go either
> > 
> > * Allow all settings but apply only as allowed by the parent.
> > 
> > * Deny settings disallowed by the parent.  If parent's config changes,
> >   delete configs which fall outside the new config.
> 
> I prefer this one, in fact that's what was happening before and you
> suggested to not remove local preferences when they're not valid
> anymore.

If I'm contradicting my past self, my apologies.  I'm a bit conflicted
about what to do myself.  So, you prefer to change configurations
downstream as the parent gets updated.  I think you're right.  Let's
go with that.

Thanks.

-- 
tejun
