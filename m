From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.5-fixes] cgroup: fix alloc_cgroup_ns() error
 handling in copy_cgroup_ns()
Date: Thu, 18 Feb 2016 23:21:12 +0300
Message-ID: <20160218202112.GZ5273@mwanda>
References: <20160217185811.GA3472@mwanda>
 <20160218164658.GD13177@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160218164658.GD13177-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Sorry, I was feeling like a jerk yesterday.

I obviously could have fixed this myself but I wanted to make a point
about one error label, do-everything style "future proof" error
handling.  It is a trap for the unwary.

Now the code calls kfree(-ENOMEM).  It's a very predictable mistake.

regards,
dan carpenter
