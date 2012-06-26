From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: "Regression" with cd3d09527537
Date: Tue, 26 Jun 2012 16:43:03 +0400
Message-ID: <4FE9AE57.4090007@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

I've recently started seeing a lockdep warning at the end of *every* 
"init 0" issued in my machine. Actually, reboots are fine, and that's 
probably why I've never seen it earlier. The log is quite extensively, 
but shows the following dependency chain:

[   83.982111] -> #4 (cpu_hotplug.lock){+.+.+.}:
[...]
[   83.982111] -> #3 (jump_label_mutex){+.+...}:
[...]
[   83.982111] -> #2 (sk_lock-AF_INET){+.+.+.}:
[...]
[   83.982111] -> #1 (&sig->cred_guard_mutex){+.+.+.}:
[...]
[   83.982111] -> #0 (cgroup_mutex){+.+.+.}:

I've recently fixed bugs with the lock ordering imposed by cpusets
on cpu_hotplug.lock through jump_label_mutex, and initially thought it 
to be the same kind of issue. But that was not the case.

I've omitted the full backtrace for readability, but I run this with all 
cgroups disabled but the cpuset, so it can't be sock memcg (after my 
initial reaction of "oh, fuck, not again"). That jump_label is there for 
years, and it comes from the code that disables socket timestamps.
(net_enable_timestamp)

After a couple of days of extensive debugging, with git bisect failing 
to pinpoint a culprit, I've got to that patch
"cgroup: always lock threadgroup during migration" as the one that would
trigger the bug.

The problem is, what this patch does is start calling threadgroup_lock
everytime, instead of conditionally. In that sense, it of course did not 
create the bug, only made it (fortunately) always visible.

Thing is, I honestly don't know what would be a fix for this bug.
We could hold the threadgroup_lock before the cgroup_lock, but that 
would hold it for way too long.

This is just another incarnation of the cgroup_lock creating nasty 
dependencies with virtually everything else, because we hold it for 
everything we do. I fear we'll fix this, and another one will just wake 
up any time.

What do you think, Tejun?
