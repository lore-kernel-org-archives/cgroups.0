From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] cgroup: removing css reference drain wait during cgroup
 removal
Date: Tue, 13 Mar 2012 15:05:51 -0700
Message-ID: <20120313220551.GF7349@google.com>
References: <20120312213155.GE23255@google.com>
 <20120313214526.GG19584@count0.beaverton.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=/2fNE8YLZSMp7a4DFgUv4QIuF2Fj1wbsGzRoJvIzc1E=;
        b=d+UWQBteeD8Rth/SacAbwfekLyP6o/vKRKZPNmQrWytWVB59DUnt+qxwcoLH4USiU+
         iBLj6Kz0x2Qoi0xRPQslIL/kE/dbsM6qudYO8PmHl4z5grDSKXlK28XahKUNgNTYxf3r
         M/zT8WUc3mIoI12JB3YYDpYbTqTG6DAtsVjVm5FyjhyjTmeOhXew9FwGtNl1qpiRVlgN
         QqO6cWA4lawMsLxgcKsU2n/djXB/ZZjx6cXl89lavaSH5c0eueQu6G6Ejw7soxcV28OL
         JV5qM/mGmpQt/Oc8VD9Sr23mu/WWAKQ+4wO1gxF6bFcWx32fOdNOLjIape6m17gT8IEg
         vHYQ==
Content-Disposition: inline
In-Reply-To: <20120313214526.GG19584-52DBMbEzqgQ/wnmkkaCWp/UQ3DHhIser@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hey, Matt.

On Tue, Mar 13, 2012 at 02:45:26PM -0700, Matt Helsley wrote:
> If you want to spend your time doing archaeology there are some old threads
> that touch on this idea (roughly around 2003-2005). One point against the
> idea that I distinctly recall:
> 
> Somewhat like configfs, object lifetimes in cgroups are determined
> primarily by the user whereas sysfs object lifetimes are primarily
> determined by the kernel. I think the closest we come to user-determined
> objects in sysfs occur through debugfs, and module loading/unloading.
> However those involve mount/umount and modprobe/rmmod rather than
> mkdir/rmdir to create and remove the objects.

The thing is that sysfs itself has been almost completely rewritten
since that time to 1. decouple internal representation from vfs
objects and 2. provide proper isolation between the userland and
kernel code exposing data through sysfs.

#1 began mostly due to the large size of dentries and inodes but, with
the benefit of hindsight, I think it just was a bad idea to piggyback
on vfs objects for object life-cycle management and locking for stuff
which is wholely described in memory with simplistic locking.

#2 was necessary to avoid hanging device detach due to open sysfs file
from userland.  sysfs now has notion of "active access" encompassing
only each show/store op invocation and it only guarantees that the
associated device doesn't go away while active accesses are in
progress.

The sysfs heritage is almost recognizable and unfortunately almost the
same set of problems (nobody wants show/store ops to be called on
unlinked css waiting for references to be drained).  As refactoring
and sharing sysfs won't be a trivial task, my plan is to first augment
cgroupfs as necessary with longer term goal of converging and later
sharing the same code with sysfs.

Thanks.

-- 
tejun
