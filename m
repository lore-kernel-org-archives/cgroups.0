From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] cgroup: unexport locking interface
Date: Sun, 7 Apr 2013 09:30:45 -0700
Message-ID: <20130407163045.GB12038@htj.dyndns.org>
References: <1365118589-10619-1-git-send-email-tj@kernel.org>
 <5161064D.30000@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=zKhrvpoXN4Lvcj1n3AdXReDqxiDgEMK25s9FcwUcuqA=;
        b=cIhrO8ObRt1hZ8Mm18OaNdW0+doWdJGEg2nFk0olY3cfj39NpwKQW6Zz8lJ7GN+6NT
         +xMIejPRIHST/IBykWViNNlMhhDdQn50DSbQAL2l/1EWED1SdS+GSjwcGRq+BgrUtiDD
         RRnENnVg2LrLB//H+2+9x2HOYeYtmRsHO3xbD97uEv2Ff5FkqIHeyURYjGzqf85XT8Ak
         ZXosl8+RQp+zT+0wp7VJjjFFYiQ1V6z7oDqHdIBy8hgrHbDMw6cALKy4G+etgrzd7xHK
         /Qpmk68/C4BSKJJUgLBqTHPy9ywtawBhTUkleoakFvJZ0JyedvT1KXAYNI5uhVYk2/3x
         q5Pg==
Content-Disposition: inline
In-Reply-To: <5161064D.30000-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, Apr 07, 2013 at 01:38:21PM +0800, Li Zefan wrote:
> On 2013/4/5 7:36, Tejun Heo wrote:
> > Hello,
> > 
> > Most cgroup_mutex abuses outside cgroup core proper have been
> > eradicated but there's still one use remaining and locking interface
> > is still exported.  This patchset updates the last user and unexports
> > the locking interface and is composed of the following five patches.
> > 
> >  0001-cgroup-cpuset-replace-move_member_tasks_to_cpuset-wi.patch
> >  0002-cgroup-relocate-cgroup_lock_live_group-and-cgroup_at.patch
> >  0003-cgroup-unexport-locking-interface-and-cgroup_attach_.patch
> >  0004-cgroup-kill-cgroup_-un-lock.patch
> >  0005-cgroup-remove-cgroup_lock_is_held.patch
> > 
> 
> Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.10.

Thanks.

-- 
tejun
