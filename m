From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/7] cgroup_freezer: don't stall transition to FROZEN
	for PF_NOFREEZE or PF_FREEZER_SKIP tasks
Date: Mon, 22 Oct 2012 20:34:53 +0200
Message-ID: <20121022183453.GA24687@redhat.com>
References: <1350426526-14254-1-git-send-email-tj@kernel.org> <1350426526-14254-5-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1350426526-14254-5-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: rjw-KKrjLPT3xs0@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 10/16, Tejun Heo wrote:
>
> cgroup_freezer doesn't transition from FREEZING to FROZEN if the
> cgroup contains PF_NOFREEZE tasks or tasks sleeping with
> PF_FREEZER_SKIP set.

And thus the patch looks like another bugfix to me.


Just one question, and this question is offtopic again,

> Only kernel tasks can be non-freezable (PF_NOFREEZE)

Hmm. We seem to "leak" PF_NOFREEZE if a kernel thread execs?
Perhaps do_execve_common() should do set_freezable() before return.

Or, at least, simply clear this flag along with PF_KTHREAD in
flush_old_exec().

Oleg.
