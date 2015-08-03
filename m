From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 2/4] cgroup: define controller file conventions
Date: Mon, 3 Aug 2015 09:36:01 -0400
Message-ID: <20150803133601.GA18536@cmpxchg.org>
References: <1438547024-23497-1-git-send-email-tj@kernel.org>
 <1438547024-23497-3-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1438547024-23497-3-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Sun, Aug 02, 2015 at 04:23:42PM -0400, Tejun Heo wrote:
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
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
