From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/6] cgroup: implement cgroup v2 thread support
Date: Wed, 19 Jul 2017 13:48:42 -0400
Message-ID: <20170719174842.GR3365493@devbig577.frc2.facebook.com>
References: <20170717020721.3612468-1-tj@kernel.org>
 <20170717020721.3612468-6-tj@kernel.org>
 <20170717141409.sqafufjupsiffnri@hirez.programming.kicks-ass.net>
 <825f2eaa-568a-a156-f04d-9235b20e2614@redhat.com>
 <5fa00590-551f-85d2-511b-ef4033781228@redhat.com>
 <20170718171034.GE585283@devbig577.frc2.facebook.com>
 <df14a222-f1f8-3415-b29a-2712c9e77f94@redhat.com>
 <20170719162937.GP3365493@devbig577.frc2.facebook.com>
 <e6a9daf1-461d-080c-a301-12cdad5e2b73@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=D/ZJltHrr3k2oUkc+EDWL2qkusvOcM0y9E47zTks7Ks=;
        b=okVR4yqfxJ1JBmfMqupc2C3X5MOvgU46kXCe1BQJ0cMWdL5kJ68kWGxl29MOjC1mgs
         SbYPcCOLRLZoecbhNDQLithfsradSF+uBRvV36jVZBXArzaENmorYfxUmMBCEqdOttpq
         7DSyXLrFBRGyXZs24ezCqoGVEAO1C5G51+u3WWTQDM6mvRgjGldhyxsKwa4twJ+UG65K
         IjFKLKfbyVbIoqoDLiIkDvxSvpwnyrdraVkIuoIlVcsRnyVGEtK2sr5DQTAq1K7/dtbA
         L6iLbC1IJ0jkHZcQMUiuVdWnjrsW993HPHxtDbKBlhlbkC7x6AiKJABpZet/Hk3psb9Y
         BhIQ==
Content-Disposition: inline
In-Reply-To: <e6a9daf1-461d-080c-a301-12cdad5e2b73-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

Hello, Waiman.

On Wed, Jul 19, 2017 at 01:09:38PM -0400, Waiman Long wrote:
> For me, that is the only good reason why we should keep the current
> behavior. So I am fine with that.
> 
> + cgrp->dom_cgrp = cgrp->dom_cgrp;
> 
> However, I am still puzzled by above line of code, should it be just
> 
>   cgrp->dom_cgrp = cgrp;

Oh I see.  Yeah, that's just a silly (harmless) bug.  The field gets
properly initialized in init_cgroup_housekeeping().  I'll remove that
line.

Thanks!

-- 
tejun
