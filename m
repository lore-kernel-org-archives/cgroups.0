From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET] block: cosmetic updates to blkcg API
Date: Mon, 16 Apr 2012 13:57:21 -0700
Message-ID: <1334609847-12747-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:from:to:cc:subject:date:message-id:x-mailer;
	bh=+8A5Qw4foH18k0YMoysui6qj/V47xlauJCrLGLCZX0I=;
	b=gGbRjk2i/IvNmhSMM8r6924EM1nlZ5rxeBc256tcCO3/gUspJhnNTvYRRRxmXTjfMN
	sve2BoHEsCRLGMNMXSmtwABYTClcZWleA2LmwN1LUJH5IljSQYbWy2OWfidgrE99Q3P9
	un8PrsrJpKFcyLUIvND2AGE6w7op3ySLj21QCmIxnrvd+AVAqqo8RsCCRd6MjJc6FiqA
	8YSiDKJaN8SabkQ1j6kVJjvevUGlt2RX0Ch6mNf+WZm2qW2vHPspeH+ZtcMb4tz4hId/
	MxXs+/CDq2o3eESobpN906qICFdVKfcn4nXSFbd+vZfKx7ngmABD/32OzxFV+nY8F3tR
	VXrA==
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

Hello,

With recent blkcg updates, any out-of-tree change is already way
broken and it's a good time to clean up blkcg API for more
consistency.  This patchset makes a series of mostly cosmetic changes
in an attempt to make the blkcg API easier on the eyes.

This is finally the last patchset of the long blkcg API update effort.
I think that we now have something which at least is sane & logical
and can be improved incrementally without having to be turned upside
down.  My thanks to everyone involved for enduring the boring and
rather painful process.

This patchset contains the following six patches.

0001-blkcg-blkg_rwstat_read-was-missing-inline.patch
0002-blkcg-remove-blkio_group-path.patch
0003-blkcg-style-cleanups-for-blk-cgroup.h.patch
0004-blkcg-mass-rename-of-blkcg-API.patch
0005-blkcg-embed-struct-blkg_policy_data-in-policy-specif.patch
0006-blkcg-collapse-blkcg_policy_ops-into-blkcg_policy.patch

Other than 0002 which removes blkg->path[], none of the patches makes
any functional difference.

This patchset is on top of

  block/for-3.5/core 5bc4afb1ec "blkcg: drop BLKCG_STAT_{PRIV|POL|OFF} macros"
+ [1] [PATCHSET] block: per-queue policy activation, take#2

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git blkcg-rename

diffstat follows.

 block/blk-cgroup.c     |  253 ++++++++++++++++++++++++-------------------------
 block/blk-cgroup.h     |  240 ++++++++++++++++++++++++----------------------
 block/blk-throttle.c   |  121 +++++++++++++----------
 block/cfq-iosched.c    |  138 ++++++++++++++------------
 include/linux/blkdev.h |    4 
 5 files changed, 397 insertions(+), 359 deletions(-)

Thanks.

--
tejun

[1] https://lkml.org/lkml/2012/4/13/380
