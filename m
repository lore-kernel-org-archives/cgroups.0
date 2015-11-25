From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 7/8] cgroup: mount cgroupns-root when inside non-init
 cgroupns
Date: Wed, 25 Nov 2015 14:10:41 -0500
Message-ID: <20151125191041.GB14240@htj.duckdns.org>
References: <1447703505-29672-1-git-send-email-serge@hallyn.com>
 <1447703505-29672-8-git-send-email-serge@hallyn.com>
 <20151124171610.GS17033@mtj.duckdns.org>
 <20151125060156.GA678@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=HqVwIpIVWXxCq3h2VG54M/yKP4yNMrXaNMW0J+q8czo=;
        b=l3ORBhBhxeQlBFEAOA2oFvYdBfERkiCYE8EHcgWv51SA6KHmD/GlKdSDngeTpRZpG/
         g5J+vPPXI6dFdWWbVC+eAutAGYe21Y0ME1MBob8wu+geBy9SimHVp6dyY1ngMoJHLbcb
         fVj83ixFcwulRjRQvmUo5wQ2kmmhcxk3JFsPJmyTvYx+id51pRAD7rTdQKdtzeX7difY
         II0Bpr4ijQiP24g4cG8M7N+lNYtDs1/QQlI51iOd1M1EtoU1q5nr+YnenCEDzruWRQrV
         GyrrKjdiYf/J4SH4L906C21iQd7J5yimYo152+cJJoSJZb9+vMsv50cT1AjqYiHzGsFw
         JUCA==
Content-Disposition: inline
In-Reply-To: <20151125060156.GA678-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org

Hello, Serge.

On Wed, Nov 25, 2015 at 12:01:56AM -0600, Serge E. Hallyn wrote:
> that was my goal with https://git.kernel.org/cgit/linux/kernel/git/sergeh/linux-security.git/commit/?h=cgroupns.v4&id=8eb75d2bb24df59e262f050dce567d2332adc5f3
> (which was sent inline earlier in this thread in response to Eric)  Does
> that look sufficient?

Hmmm... but that wouldn't work with non-root and user ns.  I think
what's necessary is ensuring that namespace scoped mount never creates
a new hierarchy but always reuses an existing one.

Thanks.

-- 
tejun
