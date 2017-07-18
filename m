From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.13-fixes] cgroup: create dfl_root files on
 subsys registration
Date: Tue, 18 Jul 2017 18:11:14 -0400
Message-ID: <20170718221114.GI3365493@devbig577.frc2.facebook.com>
References: <1500406336-29512-1-git-send-email-longman@redhat.com>
 <20170718195148.GC3365493@devbig577.frc2.facebook.com>
 <539870d2-8b85-2f54-61bd-4ba068e75ce0@redhat.com>
 <20170718201229.GD3365493@devbig577.frc2.facebook.com>
 <255cc198-2c10-af76-98ca-086807d11540@redhat.com>
 <20170718205009.GE3365493@devbig577.frc2.facebook.com>
 <20170718210658.GF3365493@devbig577.frc2.facebook.com>
 <20170718215746.GG3365493@devbig577.frc2.facebook.com>
 <d44b7b53-0be6-7019-169a-aa45b4d02598@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+9+8jlETWQ3DPJ2aQELwuBKIcGKwq2n6rdZ2LZLEf5g=;
        b=IPGIlAzb6IMZn6g89jEhfJEhFqP/FaIUP03Pb/Lia21eDjXXL+qUxbQEACK7k0MDBR
         EYNTmMQEpWjOOPfoxieNw99wwYx29u7CpDkQWeUGagLDjWeojx1+vpPsCaqUD4LybdLY
         0urm7NrAqMcloMjAblP2nA6t4wYTsfQgMmJM9SRe8wrOJhHrKDj99eWcw82epifXzNh6
         8FEqMXycrFpJSMDRZZ4rOO+f3qN+iJLdR5q/wBZN+95hdtN33XlZDjYbu7I2Voi1rQ4N
         HLOWeVYSz+jDFnlqYS5EH6pzwKalQwFB04tg7eTg/trDspLXUb6ksA+9dBi5U/EYqPm2
         spEw==
Content-Disposition: inline
In-Reply-To: <d44b7b53-0be6-7019-169a-aa45b4d02598-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jul 18, 2017 at 06:09:16PM -0400, Waiman Long wrote:
> On 07/18/2017 05:57 PM, Tejun Heo wrote:
> Yes, this patch fix the problem.
> 
> Tested-by:  Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Great, will route the patch through cgroup/for-4.13-fixes.

Thanks for spotting the subtle bug!

-- 
tejun
