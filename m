From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 00/11] per-cgroup cpu-stat
Date: Thu, 6 Jun 2013 17:06:37 -0700
Message-ID: <20130607000637.GT5045@htj.dyndns.org>
References: <1369825402-31046-1-git-send-email-glommer@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=sao2J3J9EG2fmEAm5Z/OvdQu+SBW3O6TmBb/WmG/3jg=;
        b=xswtiN0UAXB0E5L8HCakJ7T6Z1CL9BtLwOt+Ehhbxgbcl0KOGrIuggQ7ld0nRFXRJ0
         d/hvT3koqks7nvkuQA+znkOmjLO3y0FzUzC/k/heQMZMNkld6h5JAqn/jPz/zdeq9uwq
         WFTKPAOMRkcZGEodbeX/yYY5ym8JeGc8C9UFA095n2Ydg4VLBqOw9CaxdRpb60+GACtq
         tB4O79o2Vy7pa45StRIejBePnXyIA8KgQYf/bSOh0KFNkjQ6jjjlRIzfgxg+IMpxkV+C
         NDIWwZd7RH/F9a4oT9zZAQn1sn49lFmDKi9Qx7Tw83wIE5GqalQAt+zYmbYaaXnm0kht
         QmEA==
Content-Disposition: inline
In-Reply-To: <1369825402-31046-1-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Wed, May 29, 2013 at 03:03:11PM +0400, Glauber Costa wrote:
> I am coming again with this series, hoping this is a better time for you all to
> look at it.
> 
> I am *not* going as far as marking cpuacct deprecated, because I think it
> deserves a special discussion (even though my position in this matter is widely
> known), but all the infrastructure to make it happen is here. But after this,
> it should be a matter of setting a flag (or not).

Things look generally good to me upto patch 6.  Maybe we can combine
"adding cpuacct stats to cpu" and "re-using schedstats" but no strong
opinion.  Peter, what do you think?

Thanks.

-- 
tejun
