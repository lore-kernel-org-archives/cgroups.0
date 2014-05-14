From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: use css->refcnt for cgroup
 reference counting
Date: Wed, 14 May 2014 13:04:04 -0400
Message-ID: <20140514170404.GC15690@htj.dyndns.org>
References: <1399670015-23463-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=C3COIr04c2JldHH16KHta7jqDEv9UzBpOtYUqEyYHvY=;
        b=uF5mLEP05zVnLo2VvrEwPdLtgH6EGkop1dkQm1mVUKSfBdtZsBB1sk+V1r10KvSYPv
         J3VFCiggQXhpGt2Do/Eiy5gqyOhSMa5ZK1iJiiW2pH9HksOGWrXusZZAfrqEWpNBIpZE
         WNvDEowIXBAqDo0yA6lzNyBZCw8HgjZk/XpjYiEfa3b3ke3J9+dA6ukOFUNrbU7yfEDR
         WsequLmf+NcqfmMhNZ6vO8AxpiRQwCxYgMVQhl+t7UpLwPwAEiUxJNwkgCDcp789j2TO
         KJFqDWyRRXC9bTNj8cJ7C80Tu9mtanPRbm/kO/HATmkjnSBKEEg8Wdr1xFDr5lT2Wqvg
         KEsA==
Content-Disposition: inline
In-Reply-To: <1399670015-23463-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, May 09, 2014 at 05:13:26PM -0400, Tejun Heo wrote:
> Hello,
> 
> Currently, cgroup and css (cgroup_subsys_state) are separately
> reference counted.  cgroup->refcnt is an atomic_t and css->refcnt is a
> percpu_ref.  css is becoming the primary structural block and used
> widely in various operaitons.  cgroup already has a css embedded in it
> (cgroup->dummy_css) to use as its proxy in such operations; however,
> there still are quite a few differences between cgroup and css
> handling limitng how cgroup->dummy_css can be used.
> 
> This patchset makes cgroup use the embedded css's refcnt for reference
> counting.  This closes one of the gaps between an cgroup embedded css,
> which is renamed to cgroup->self early in the patchset, and a normal
> css and will allow more unified handling of cgroups and csses.  In
> addition, this makes cgroup refcnting use percpu_ref too, which is a
> lot more scalable than an atomic_t.
> 
> Ultimately, it'd make things far simpler to assign a proper
> cgroup_subsys to the cgroup embedded csses and handle them the same as
> other csses; however, we can't yet do it thanks to multiple
> hierarchies as we end up with multiple csses of the same subsystem for
> the same task, but in the very long term, if multiple hierarchies can
> be removed, that's where it's headed.
> 
> This patchset contains the following nine patches.
> 
>  0001-cgroup-use-restart_syscall-for-mount-retries.patch
>  0002-cgroup-rename-cgroup-dummy_css-to-self-and-move-it-t.patch
>  0003-cgroup-separate-out-cgroup_has_live_children-from-cg.patch
>  0004-cgroup-move-check_for_release-parent-call-to-the-end.patch
>  0005-cgroup-move-cgroup-sibling-unlinking-to-cgroup_put.patch
>  0006-cgroup-remove-cgroup_destory_css_killed.patch
>  0007-cgroup-bounce-css-release-through-css-destroy_work.patch
>  0008-cgroup-enable-refcnting-for-root-csses.patch
>  0009-cgroup-use-cgroup-self.refcnt-for-cgroup-refcnting.patch

Applied to cgroup/for-3.16.

Thanks.

-- 
tejun
