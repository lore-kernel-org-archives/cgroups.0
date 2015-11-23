From: Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.4-fixes] cgroup: make css_set pin its css's
 to avoid use-afer-free
Date: Mon, 23 Nov 2015 17:23:44 -0500
Message-ID: <20151123222344.GA6117@codemonkey.org.uk>
References: <20151123195541.GA19072@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151123195541.GA19072-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org

On Mon, Nov 23, 2015 at 02:55:41PM -0500, Tejun Heo wrote:
 > A css_set represents the relationship between a set of tasks and
 > css's.  css_set never pinned the associated css's.  This was okay
 > because tasks used to always disassociate immediately (in RCU sense) -
 > either a task is moved to a different css_set or exits and never
 > accesses css_set again.
 > 
 > Unfortunately, afcf6c8b7544 ("cgroup: add cgroup_subsys->free() method
 > and use it to fix pids controller") and patches leading up to it made
 > a zombie hold onto its css_set and deref the associated css's on its
 > release.  Nothing pins the css's after exit and it might have already
 > been freed leading to use-after-free.
 > 
 > Fix it by making css_set pin the associate css's until its release.

This gets me booting again, thanks Tejun!

	Dave
