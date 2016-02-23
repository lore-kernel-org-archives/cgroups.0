From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] cgroup: misc fixes and cleanups
Date: Mon, 22 Feb 2016 22:27:22 -0500
Message-ID: <20160223032722.GT3965@htj.duckdns.org>
References: <1456182349-18156-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=/Xj4s5Ad3DtQY7MpB5A6LvDP7l23/Qad0OHpXqE0TNg=;
        b=Q8ceE3Kn0D3bpS6F5L1r3TBsoKUHKgTkbpI5/T4w+9S6SR+MVk4+nM28chr8KBSFPs
         8YN5kHRECGZ64YwmI+BqrCZ1DEXHeyXupsMqEe8Lhw3qAYOGx53Wz+HU5vG///DdX8Y3
         kO9Ewf4ojk+VT0OnZP8CHyjzZYH6OrGQ3qIwrzC88I9X+dxaj0QSKAQfhu/d5zH2x98j
         rGweR/NIdOpfUtyAddv416sEEtow4CFUWjtcosRooy84yBB0oSh26ggiXnQm9zi1gDbp
         IFeRYAi49oTqeUlMSdU0nq7daxRahHHKRFSPn4ouuQLbmUN6zBARaKfHoU1tDlOfSDgA
         8eFg==
Content-Disposition: inline
In-Reply-To: <1456182349-18156-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Mon, Feb 22, 2016 at 06:05:43PM -0500, Tejun Heo wrote:
>  0001-cgroup-fix-error-return-value-of-cgroup_addrm_files.patch
>  0002-Revert-cgroup-add-cgroup_subsys-css_e_css_changed.patch
>  0003-cgroup-s-child_subsys_mask-subtree_ss_mask.patch
>  0004-cgroup-convert-for_each_subsys_which-to-do-while-sty.patch
>  0005-cgroup-use-do_each_subsys_mask-where-applicable.patch
>  0006-cgroup-make-cgroup-subsystem-masks-u16.patch

Applied 1-6 to cgroup/for-4.6.

-- 
tejun
