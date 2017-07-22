From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/4] cgroup: Allow bypass mode in subtree_control
Date: Sat, 22 Jul 2017 09:50:30 -0400
Message-ID: <20170722135030.GC3329631@devbig577.frc2.facebook.com>
References: <1500669293-21792-1-git-send-email-longman@redhat.com>
 <1500669293-21792-3-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hNRsxL3ZYXNQ/3AqI9Xif0dp+ypQMHaHGOM7eXigjAw=;
        b=SzIBr2JVdLg0mFTroKs9RBdWFTgVoj3tMUZAxXG/4Rw8OPhw/SKsF1s8DaNnR92GGM
         36EKhNE5eLeetpxFV0orpQUxVBOatvR5m0WiYMA9XL6BMsnPPYLIB/Hirs2iG0x0/jbG
         WDXj/T67xt+Brn3WQrfe4EswPXn2s54fyQhV8bHvexokd4MC+TLJBLjqeS1PrJkf7jY6
         mUWFe+QSqDZpwPfpmAtgEHl1XNibrt79nYl/w3uV8OAk51Lkz51Suq/QF8onEX01Hiud
         QuanacsFanyb8EUD1XxXO4LqEOqTXrpD7gHRjZx9SqqTVLYCjRFITMfB4q785zBcRDvq
         d7jw==
Content-Disposition: inline
In-Reply-To: <1500669293-21792-3-git-send-email-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

Hello, Waiman.

On Fri, Jul 21, 2017 at 04:34:51PM -0400, Waiman Long wrote:
> The special prefix '#' attached to a controller name can now be written
> into the cgroup.subtree_control file to set that controller in bypass
> mode in all the child cgroups. The controller will show up in the
> children's cgroup.controllers file, but the corresponding control knobs
> will be absent. However, that controller can be enabled or bypassed
> in its children by writing to their respective subtree_control files.
> 
> This mode can be useful to non-domain controllers or controllers where
> there are costs to each additional layer of hierarchy. This mode will
> also allow more freedom in how each controller can shape its effective
> hierarchy independent of each others.

While this continues to be an interesting idea.  I'm still having a
bit of hard time with the change.  The biggest blocks are

* As raised a couple times before, how would this work in terms of
  resource ownership and delegation?  The last time we spoke about
  this, I felt that we were mostly talking past each other.  I think
  it'd really help to think about / explain how this would work with
  delegation to clarify who owns what.

* While the idea is interesting, I think we need more concrete
  usecases to justify the addition and make sure that we aren't doing
  something misguided.  Can you please illustrate / give examples of
  how this would be useful?

Thanks.

-- 
tejun
