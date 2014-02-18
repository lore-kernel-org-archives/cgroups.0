From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.14-fixes] cgroup: update
 cgroup_enable_task_cg_lists() to grab siglock
Date: Tue, 18 Feb 2014 18:25:56 -0500
Message-ID: <20140218232556.GM31892@mtj.dyndns.org>
References: <20140213182931.GB17608@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=txBRKSoDs6AEQ/LvnUJnuTUlw0mDMhRv3Ew59wZ2Pwc=;
        b=W2ELH8VcGNjTzFjD1WQwbIljK94ZEhXH34zvCtWy4Hx7r+cGvjKRlY1fwzo/AzpkYS
         77D8bdm7ArxfMhLbBXVzRObI8uAPj9meechJvcZqQnlnlWOvqoNuci/YoBENzqI4TqeY
         PqTMVyWvNGEWuYcEgBKZxO/ckdiJSsfLP7zBk5G5whOd/kYYpojHQ0grPMCgrnfp23KF
         q/QvbgN9slFkVtc0P8L9uxFWliMPkT4QVX25MGWZxF1TjJ+wJmBvvhiH1gavZVvPkd0d
         1NfvhrKbFxKaZtb7pAv/i2cpAvXy/3gfIxLr3M9dW/27K+ANMEfKkzmJNMDB9+ujBkdq
         cJfA==
Content-Disposition: inline
In-Reply-To: <20140213182931.GB17608-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Feb 13, 2014 at 01:29:31PM -0500, Tejun Heo wrote:
> Currently, there's nothing preventing cgroup_enable_task_cg_lists()
> from missing set PF_EXITING and race against cgroup_exit().  Depending
> on the timing, cgroup_exit() may finish with the task still linked on
> css_set leading to list corruption.  Fix it by grabbing siglock in
> cgroup_enable_task_cg_lists() so that PF_EXITING is guaranteed to be
> visible.
> 
> This whole on-demand cg_list optimization is extremely fragile and has
> ample possibility to lead to bugs which can cause things like
> once-a-year oops during boot.  I'm wondering whether the better
> approach would be just adding "cgroup_disable=all" handling which
> disables the whole cgroup rather than tempting fate with this
> on-demand craziness.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Applied to cgroup/for-3.14-fixes.

Thanks.

-- 
tejun
