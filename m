From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/4] provide a function to register more cftype files
 into memcg
Date: Wed, 21 Mar 2012 09:11:22 -0700
Message-ID: <20120321161122.GC4246@google.com>
References: <1332262256-13407-1-git-send-email-glommer@parallels.com>
 <1332262256-13407-4-git-send-email-glommer@parallels.com>
 <20120320183233.GC20832@google.com>
 <4F6982D0.1060403@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Ey28Yo2+kwc5IQta0dY5u7IKi78FWzc0kBeRup01SQU=;
        b=OxtNfk5tO4cOM+UoQCVsJ2lZbC7bu+BJzSmht7aMt3QBaC2K5e5DLuSuhnMhyGk4nr
         YAgOrCIC+T710SYe0KKdUmaGEg7Rx5B7GdUg020eicjwuZnRkeHgKqkkAM04p3cQSkdv
         UNOCrCoETYyoRH4x1I/xOlyZAxrGtvhpqR6rRohAgjeOu7A7lRK0DkXJhbQghZqDo+B+
         jLslAOHG8j3SoxEwbUSKWIjRnGEiPb+RsMdcIqnIUlKM5JuyoxmWqAkU5/3rssoAxQJg
         c7u4++RIFjGiYuOT1mw0WQynNAlN/dUsYdRItOG9hvWUCI3L1ZEkH/62tmQmwlA8Um31
         zULA==
Content-Disposition: inline
In-Reply-To: <4F6982D0.1060403-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

On Wed, Mar 21, 2012 at 11:27:12AM +0400, Glauber Costa wrote:
> >>+int mem_cgroup_register_cftype(const struct cftype *cfts)
> >>+{
> >>+	return WARN_ON(cgroup_add_cftypes(&mem_cgroup_subsys, cfts));
> >>+}
> >>+EXPORT_SYMBOL(mem_cgroup_register_cftype);
> >
> >Why not just export mem_cgroup_subsys?
> >
> 
> I'm fine either way. I usually prefer not exporting raw data like
> this, but that's 100 % taste. How do you prefer me to do it?

I think exporting subsys directly is better than implementing thin
wrapper like above.  IMHO, wrappers like above don't add any
functionality and are likely to just obfuscate what's going on.

Thanks.

-- 
tejun
