From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCHSET] kernfs, cgroup: reimplement "cgroup.procs" reading
 for v2
Date: Wed, 21 Dec 2016 10:59:22 +0100
Message-ID: <20161221095922.GF27395@kroah.com>
References: <20161220161222.15234-1-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161220161222.15234-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, Dec 20, 2016 at 11:12:17AM -0500, Tejun Heo wrote:
> On cgroup v1, the pid listings in "cgroup.procs" and "tasks" are
> sorted which adds a lot of complications and overhead.  v2 doesn't
> have such requirement and has been intentionally using a modified
> sorting order so that the output doesn't look sorted to users.
> 
> This patchset re-implements "cgroup.procs" reading for v2 which simply
> keeps a css_task_iter open while the file is being read.  Keeping the
> iterator open makes it unnecessary to skip to the right position on
> each read segment and associated errors - e.g. incorrectly skipping
> over pids because earlier pids disappeared between the reads.
> 
> Using persistent iterator across multiple read calls requires
> ->release() callback to clean it up.  kernfs operations
> ->open/release() are added and piped through cftype.
> 
> This patchset contains the following five patches.
> 
>  0001-kernfs-make-kernfs_open_file-mmapped-a-bitfield.patch
>  0002-kernfs-add-kernfs_ops-open-release-callbacks.patch
>  0003-cgroup-add-cftype-open-release-callbacks.patch
>  0004-cgroup-reimplement-reading-cgroup.procs-on-cgroup-v2.patch
>  0005-cgroup-remove-cgroup_pid_fry-and-friends.patch
> 
> 0001 is a misc kernfs patch and 0002 adds ->open/release() to kernfs.
> 0003 pipes ->open/release() through cftype.  0004 implements the new
> cgroup.procs for v2 and 0005 removes the now unused sort order frying
> logic.
> 
> Greg, would it be okay to route the kernfs patches through
> cgroup/for-4.11?

No objection from me at all:

Acked-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
