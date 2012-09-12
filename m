From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [patch] cgroups: trivial fixes for
 Documentation/cgroups/cgroups.txt
Date: Wed, 12 Sep 2012 12:02:42 -0700
Message-ID: <20120912190242.GT7677@google.com>
References: <504F1E74.10709@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=fa99pcL70CPx2aa/ZnBXf5Sgwvr0OvHEes8pmmSzOKY=;
        b=havvrVezrlEdx4Rewp4uQvD1XYsHuTOVOzCYB95vcmY7e7+FP5AyygtwiB6ACEYuJu
         4Dpwrb2KuQHsudWSBxkhxpcb7Jsg0mVXK2GI/rLjNmn6mJDAgZGdw47/v6ZSjve15LmB
         yo9eBIsyQ1IdfibxgCsEzkqS1IT8+ON5rarYM29VA1aMz7s7PvNCtnRbLlm/YkcZl8Qi
         FjIgzgIMVuXEf+Le5vtmiVjYLTl8c99KYpYwHIMKns25YYXmk3NAMasiiXOzn+GynjeV
         m1l19bJsfngWluaA5k3esT9+eNforR62NDKVXXPa91P2TUOh+uHD8FPa1OUb6dMaS0pX
         9I9w==
Content-Disposition: inline
In-Reply-To: <504F1E74.10709-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>, Rob Landley <rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org>

On Tue, Sep 11, 2012 at 01:20:20PM +0200, Michael Kerrisk wrote:
> While reading through Documentation/cgroups/cgroups.txt, I found a
> number of minor wordos and typos. The patch below is a conservative
> handling of some of these: it provides just a number of "obviously
> correct" fixes to the English that improve the readability
> of the document somewhat. Obviously some more significant
> fixes could be made to the document, but some of those 
> may not be in the "obviously correct" category.

Applied to cgroup/for-3.7.  Thanks!

-- 
tejun
