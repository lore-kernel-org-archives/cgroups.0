From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET v2 cgroup/for-4.6] cgroup, perf_event: make perf_event
 work on v2 hierarchy
Date: Thu, 3 Mar 2016 10:06:54 -0500
Message-ID: <20160303150654.GF11029@mtj.duckdns.org>
References: <1456351975-1899-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Aj6DvDDSnUrBL7HoDk6RivtyiCHbqksve8T4GREAMfc=;
        b=AEAUeSOLeg13LEPunYBLzsd9l7LuYipDd5FRKXCCcjS6ib7Cg2UWW+ezwpKT7vwqza
         MV92Hbs7jXifaRKL2Daxuilyl7Fvk/goSl+Et1kzqMSkBeHhUGno6KmOu6vIkPtWxmMY
         7kmSWylNrtiYHDuNqta4rG4sCQq2lJ450SYDgEAIAhQ8qWxJb0OBswSsOFsCwfwrVHsl
         woNyzqqBw7SRmWKk7BTy1mej9e8ZRjUBtbFA/9QHxmz3dNKAx5yAJAc2QbufHY5gv//o
         CrBSd/Bp3pKqJEklvMeZ4ob0gyXtqrKpeOuG9q4Otq0q0qsW5XDD3UXHEKwT7qqEi2LF
         uTQg==
Content-Disposition: inline
In-Reply-To: <1456351975-1899-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

On Wed, Feb 24, 2016 at 05:12:53PM -0500, Tejun Heo wrote:
> This patchset makes perf_event implicitly enabled on the v2 hierarchy
> so that cgroup v2 path automatically works with "perf record --cgroup"
> as long as perf_event controller is available and not mounted on a
> legacy hierarchy.  "perf record" is updated so that it searches for
> both v1 hierarchy w/ perf_event on it and v2 hierarchy.  The v1
> hierarchy is used if exists; otherwise, v2 is used, making the
> transition transparent to users.

All the prerequisite patches are now available in cgroup/for-4.6
branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.6

If the perf_event changes look okay, we can either apply the first
patch to cgroup/for-4.6, pull that into perf tree and aply the perf
change there or route both through cgroup tree.  Ideas?

Thanks.

-- 
tejun
