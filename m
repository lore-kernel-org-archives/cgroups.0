From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix cgroup_path() vs rename() race
Date: Sat, 26 Jan 2013 08:20:50 +0800
Message-ID: <51032162.5080007@huawei.com>
References: <51022FC7.5020607@huawei.com> <20130125164242.GA3081@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130125164242.GA3081-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2013/1/26 0:42, Tejun Heo wrote:
> On Fri, Jan 25, 2013 at 03:09:59PM +0800, Li Zefan wrote:
>> rename() will change dentry->d_name. The result of this race can
>> be worse than seeing partially rewritten name, but we might access
>> a stale pointer because rename() will re-allocate memory to hold
>> a longer name.
>>
>> Use dentry_path_raw(), and this vfs API will take care of lockings.
>>
>> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> Urgh... why do we even support rename?  :(
> 

Added in this commit many years ago:

commit 18a19cb3047e454ee5ecbc35d7acf3f8e09e0466
Author: Paul Jackson <pj-sJ/iWh9BUns@public.gmane.org>
Date:   Sun Oct 30 15:02:31 2005 -0800

    [PATCH] cpusets: simple rename

    Add support for renaming cpusets.  Only allow simple rename of cpuset
    directories in place.  Don't allow moving cpusets elsewhere in hierarchy or
    renaming the special cpuset files in each cpuset directory.

    The usefulness of this simple rename became apparent when developing task
    migration facilities.  It allows building a second cpuset hierarchy using
    new names and containing new CPUs and Memory Nodes, moving tasks from the
    old to the new cpusets, removing the old cpusets, and then renaming the new
    cpusets to be just like the old names, so that any knowledge that the tasks
    had of their cpuset names will still be valid.

    Leaf node cpusets can be migrated to other CPUs or Memory Nodes by just
    updating their 'cpus' and 'mems' files, but because no cpuset can contain
    CPUs or Nodes not in its parent cpuset, one cannot do this in a cpuset
    hierarchy without first expanding all the non-leaf cpusets to contain the
    union of both the old and new CPUs and Nodes, which would obfuscate the
    one-to-one migration of a task from one cpuset to another required to
    correctly migrate the physical page frames currently allocated to that
    task.

    Signed-off-by: Paul Jackson <pj-sJ/iWh9BUns@public.gmane.org>
    Signed-off-by: Andrew Morton <akpm-3NddpPZAyC0@public.gmane.org>
    Signed-off-by: Linus Torvalds <torvalds-3NddpPZAyC0@public.gmane.org>

