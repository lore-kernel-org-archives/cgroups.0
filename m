From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] perf, cgroup: implement hierarchy support for
 perf_event controller
Date: Wed, 10 Apr 2013 11:08:06 -0700
Message-ID: <20130410180806.GC17641@mtj.dyndns.org>
References: <1365474213-13354-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=/NFO83+L5xy79g5xp/U6h/DhOdNc/YcuBSE5KsQbYYY=;
        b=jnf/3oesw31wARsn6kUju1PBDeo1O7i4NmInJU0FP42dTBv39GygbtatYngAPri6LP
         gSonw0JV1T6Ng/0ikLzg3WYpm4Ue6yrHWcfEgTJHjr4GhDnPTyi51nT4DczZrRKSw3rf
         jIZy4KGl3GgnoamQjpp5KXQFmzT3lu3a39rTjxmWKk1uyRGip5+f9rk0AQ/iC2VWmucu
         B1HhhK5P020uvfQg0LbHySlge5FUmLzt0ZMr4JFdtxrOg+0OiPm5vybFQmy1ZG8AKeab
         4rDe0kRmfN5EV1IcwzkJ3W8QHrWn64RZ5BqfRpGJTwEz6TD7oLUByj5Gph2Lj6/fm12T
         tjJA==
Content-Disposition: inline
In-Reply-To: <1365474213-13354-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, acme-f8uhVLnGfZaxAyOMLChx1axOck334EZe@public.gmane.org, eranian-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, namhyung.kim-Hm3cg6mZ9cc@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Apr 08, 2013 at 07:23:30PM -0700, Tejun Heo wrote:
> perf_event cgroup controller is one of the remaining few with broken
> hierarchy support.  It turns out it's pretty easy to implement - the
> only thing necessary is making perf_cgroup_match() return %true also
> when the cgroup of the current task is a descendant of the event's
> cgroup.  This patchset implements cgroup_is_descendant() and uses it
> to implement hierarchy support in perf_event controller.

Applied to cgroup/for-3.10.

Thanks.

-- 
tejun
