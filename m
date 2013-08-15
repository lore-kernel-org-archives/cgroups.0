From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.12 1/2] cgroup: fix
 cgroup_write_event_control()
Date: Thu, 15 Aug 2013 11:41:46 -0400
Message-ID: <20130815154146.GF14606@htj.dyndns.org>
References: <20130815154032.GE14606@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=yhH2VC+3pkl18uXgtLa3Us/EQsHYA5cO/16DLa5qO+g=;
        b=FovFvH0B0IS6eE0qujn3t0PB/mkIggen+UUF/uDVRDs2cy7iB8oAbyRO7Kf8Li0RbY
         YCzItpWPu8AR8vkxB+Z/iVBAdhfqvWueKc0YSlCy+eDP5+FAG+XQ588A1A+99Fbyd/q6
         WNX9G4NbNLqDKRR0L1QCCBH3qTio/2CxsIRGi7Nk4kUjWzky9vD80MjZl+nM86Is9z8C
         6Kxu2L39vaJGFg+g9isG07I19GfLAGYRo0SvhnS8hxbl+ActbqoWLGZk4wfpvE+keZ5j
         x1dziozyiWEVBDT1fFfC8I2j6pA+ubfm3iSOeNjrMT4rz2JUv9JxmQyHTc/ppOipxUu+
         yGsA==
Content-Disposition: inline
In-Reply-To: <20130815154032.GE14606-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Aug 15, 2013 at 11:40:32AM -0400, Tejun Heo wrote:
> From 994a762080e4b136171c82ac78f7d7bbf17a451d Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Date: Wed, 14 Aug 2013 23:38:21 -0400
> 
> 81eeaf0411 ("cgroup: make cftype->[un]register_event() deal with
> cgroup_subsys_state inst ead of cgroup") updated the cftype event
> methods to take @css (cgroup_subsys_state) instead of @cgroup;
> however, it incorrectly used @css passed to
> cgroup_write_event_control(), which the dummy_css for the cgroup as
> the file is a cgroup core file.  This leads to oops on event
> registration.
> 
> Fix it by using the css matching the event target file.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Oops, wrong patch.  Please ignore.  Will resend soon.

Sorry about the noise.

-- 
tejun
