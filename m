From: Jeff Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: enabled xattr on root hierarchy if required
Date: Sun, 26 May 2013 21:33:09 +0800
Message-ID: <51A20F15.4030606@oracle.com>
References: <519F8F40.3040601@oracle.com> <20130526041007.GD13771@mtj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130526041007.GD13771-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Alexey Kodanev <alexey.kodanev-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Hi Tejun,

On 05/26/2013 12:10 PM, Tejun Heo wrote:

> On Sat, May 25, 2013 at 12:03:12AM +0800, Jeff Liu wrote:
>> From: Jie Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>
>> If the root cgroup is alive without xattr, set extended
>> attributes on a new cgroup with xattr enabled will failed
>> with ENOTSUPP. e.g.
>>
>> # mount -t cgroup -o cpu none /cgroup1
>> # mount -t cgroup -o cpu,xattr none /cgroup2
>> # mkdir /cgroup2/test
>> # setfattr -n trusted.name -v test /cgroup2/test
>> setfattr: /cgroup2/test: Operation not supported
>>
>> This patch fix it by checking ROOT_XATTR against the new
>> mount and turn it up on the existing root hierarchy if needed.
>>
>> With this fix:
>> # mount | grep cgroup
>> none on /cgroup1 type cgroup (rw,cpu)
>> none on /cgroup2 type cgroup (rw,xattr,cpu)
>>
>> # mkdir /cgroup2/test
>> # setfattr -n trusted.name -v test /cgroup2/test
>> # getfattr -d -m - /cgroup2/test
>> getfattr: Removing leading '/' from absolute path names
>> trusted.name="test"
>>
>> Signed-off-by: Jie Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> Reported-by: Alexey Kodanev <alexey.kodanev-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>>  kernel/cgroup.c |    7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>> index a32f943..46e8cbb 100644
>> --- a/kernel/cgroup.c
>> +++ b/kernel/cgroup.c
>> @@ -1687,6 +1687,13 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
>>  		cgroup_drop_root(opts.new_root);
>>  		/* no subsys rebinding, so refcounts don't change */
>>  		drop_parsed_module_refcounts(opts.subsys_mask);
>> +
>> +		/*
>> +		 * Enable xattr on the existing root hierarchy if it is
>> +		 * specified on new mount.
>> +		 */
>> +		if (test_bit(ROOT_XATTR, &opts.flags))
>> +			test_and_set_bit(ROOT_XATTR, &root->flags);
> 
> So, while I recognize that this is broken.  This is a part of larger
> breakage - cgroup silently ignores mount option changes when
> remounted.  That's why when sane_behavior is specified, mount is
> rejected if it doesn't match the existing mount options.
> 
> I don't think fixing only this part is meaningful.  Maybe what we can
> do is adding a warning message if the mount options mismatch?

Thanks for your feedback.

With a quick study of the __DEVEL__sane_behavior, I totally agree that is
meaningful to leave a message in case of the mount options mismatch.

So IMHO the left issue is that if the __DEVEL__sane_behavior is not enabled
on the root cgroup, the new mount with mismatched options(xattr for now)
will keep up works as usual, but the user could find a warning message from
the system log to see the real cause once the related xattr operation failed.

Would you please check the revised version?   BTW, checkpatch will warn against
the pr_warning(), I chose to ignore it in order to keep the cgroup code style
in a consistent manner.

Thanks,
-Jeff


From: Jie Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

With the new __DEVEL__sane_behavior mount option was introduced,
if the root cgroup is alive with no xattr function, to mount a
new cgroup with xattr will be rejected in terms of design which
just fine.  However, if the root cgroup does not mounted with
__DEVEL__sane_hehavior, to create a new cgroup with xattr option
will succeed although after that the EA function does not works
as expected but will get ENOTSUPP for setting up attributes under
either cgroup. e.g.

# mount -t cgroup -o cpu none /cgroup1
# mount -t cgroup -o cpu,xattr none /cgroup2
# mkdir /cgroup2/test
# setfattr -n trusted.name -v test /cgroup2/test
setfattr: /cgroup2/test: Operation not supported

Instead of keeping silence in this case, it's better to drop a log
entry in warning level.  That would be helpful to understand the
reason behind the scene from the user's perspective, and this is
essentially an improvement does not break the backward compatibilities.

With this fix, above mount attemption will keep up works as usual but
the following line cound be found at the system log:

[ ...] cgroup: new mount options do not match the existing superblock

Signed-off-by: Jie Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reported-by: Alexey Kodanev <alexey.kodanev-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2a99262..09f9966 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1686,11 +1686,14 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		 */
 		cgroup_drop_root(opts.new_root);
 
-		if (((root->flags | opts.flags) & CGRP_ROOT_SANE_BEHAVIOR) &&
-		    root->flags != opts.flags) {
-			pr_err("cgroup: sane_behavior: new mount options should match the existing superblock\n");
-			ret = -EINVAL;
-			goto drop_new_super;
+		if (root->flags != opts.flags) {
+			if ((root->flags | opts.flags) &
+			    CGRP_ROOT_SANE_BEHAVIOR) {
+				pr_err("cgroup: sane_behavior: new mount options should match the existing superblock\n");
+				ret = -EINVAL;
+				goto drop_new_super;
+			} else
+				pr_warning("cgroup: new mount options do not match the existing superblock\n");
 		}
 
 		/* no subsys rebinding, so refcounts don't change */
-- 
1.7.9.5

