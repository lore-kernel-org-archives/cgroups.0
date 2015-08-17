From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2 1/3] cgroup: define controller file conventions
Date: Mon, 17 Aug 2015 23:34:26 +0200
Message-ID: <20150817213426.GB29138@cmpxchg.org>
References: <1438641689-14655-1-git-send-email-tj@kernel.org>
 <1438641689-14655-2-git-send-email-tj@kernel.org>
 <20150804193101.GI17598@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150804193101.GI17598-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, Aug 04, 2015 at 03:31:01PM -0400, Tejun Heo wrote:
> From 6abc8ca19df0078de17dc38340db3002ed489ce7 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Date: Tue, 4 Aug 2015 15:20:55 -0400
> 
> Traditionally, each cgroup controller implemented whatever interface
> it wanted leading to interfaces which are widely inconsistent.
> Examining the requirements of the controllers readily yield that there
> are only a few control schemes shared among all.
> 
> Two major controllers already had to implement new interface for the
> unified hierarchy due to significant structural changes.  Let's take
> the chance to establish common conventions throughout all controllers.
> 
> This patch defines CGROUP_WEIGHT_MIN/DFL/MAX to be used on all weight
> based control knobs and documents the conventions that controllers
> should follow on the unified hierarchy.  Except for io.weight knob,
> all existing unified hierarchy knobs are already compliant.  A
> follow-up patch will update io.weight.
> 
> v2: Added descriptions of min, low and high knobs.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
