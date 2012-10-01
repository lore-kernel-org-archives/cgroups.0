From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 00/15] Use vdisktime based scheduling logic for cfq queues
Date: Mon,  1 Oct 2012 15:32:41 -0400
Message-ID: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

Hi,

This patches series primarily does few things.

- Intial few patches are just renaming and small cleanups so that
  reading code is easier. (Patches 1-5)

- A patch to print cfqq type (sync-noidle) in blktrace message. (Patch 6)

- Then patches to use vdisktime based scheduling logic for cfq queues.
  This is very similar to cfq group scheduling logic.

Why to change scheduling algorithm
==================================
Currently we use two scheduling algorithms at two different layers. 
vdisktime based algorithm for groups and round robin for cfq queues.
Now we are planning to do more development in cfqq so that it can
handle group hierarchies. And I think before we do that we first need
to change the code so that both queues and groups are treated same way
when it comes to scheduling. Otherwise the whole thing is a mess.

This patch series does not merge the queue and group scheduling code.
It just tries to make these similar enough so that merging of code
becomes easier in future patches.

What's the functionality impact
===============================
I don't expect much to change except that service differentiation
among various prio levels might vary a bit. In did my testing on 
a SATA disk and lauched 8 processes with prio 0-7, all doing 
sequential reads. Here are the results.

		0	1	3	4	4	5	6	7
vanilla(MB/s)  14.8     10.4    7.6     6.5     4.4     3.7     3.3     1.5
patched(MB/s)  15.0	10.7	7.3	6.6	4.8	3.4	2.2	1.6

Thanks
Vivek

Vivek Goyal (15):
  cfq-iosched: Properly name all references to IO class
  cfq-iosched: More renaming to better represent wl_class and wl_type
  cfq-iosched: Rename "service_tree" to "st"
  cfq-iosched: Rename few functions related to selecting workload
  cfq-iosched: Get rid of unnecessary local variable
  cfq-iosched: Print sync-noidle information in blktrace messages
  cfq-iosced: Do the round robin selection of workload type
  cfq-iosched: Make cfq_scale_slice() usable for both queues and groups
  cfq-iosched: make new_cfqq variable bool
  cfq-get-rid-of-slice-offset-and-always-put-new-queue-at-the-end-2
  cfq-iosched: Remove residual slice logic
  cfq-iosched: put cooperating queue at the front of service tree
  cfq-iosched: Use same scheduling algorithm for groups and queues
  cfq-iosched: Wait for queue to get busy even if this is not last
    queue in group
  cfq-ioschd: Give boost to higher prio/weight queues

 block/cfq-iosched.c |  567 +++++++++++++++++++++++++++++----------------------
 1 files changed, 324 insertions(+), 243 deletions(-)

-- 
1.7.7.6
