From: Hong Zhiguo <honkiko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/2] blk-throttle: simplify logic by token bucket algorithm
Date: Tue, 15 Apr 2014 15:18:21 +0800
Message-ID: <1397546303-6709-1-git-send-email-zhiguohong@tencent.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=sOKXZ1Ub3tympOI3AG5/7czHIJ55jH/BzopRJWzvdWo=;
        b=KjCPLY0iGJLXZoOxAHeI2p3oKi5iUdV5xN6AyH9ENAaXxWugzwyKVz4FfCdpviQURP
         NUzLKWfnPzXVotSRi4+bWBmzdGUxXNGle2ISGPF/r1KyIXTunF1yw6pjRHTzZY9x4eH5
         zBmhR0XrLkrOlFdjhLoNyyuGEpjrhgTnmf3JtQzAg+HANrAv7xRhRhP18RmXd40X1IvO
         gAhHlwhLWTACshuDDyO0vEbPLYXX0rof3yr2QcOo/UCK4fAMrkSrw3X8bdXXqHoxH8Cr
         7Tuey4ZkbqZdqUnP08fc5O7O+C2zaQZe096BbwO0GcKyy8DbmwfG4LJXQaMDtxp4Ad9w
         iGbA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, Hong Zhiguo <zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

From: Hong Zhiguo <zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

Based on the discussion with Vivek, Tejun and Jens.

Patch 1/2 implements basic token bucket rate limiting for blk-throttle.
Patch 2/2 adjusts some behavior for the cases pointed out by Vivek:
	- A huge bio may be allowed immediately after a long time of idle
	- When token is trimmed for above case, should not trim ancestors
	  when bio climbs up, instead, trim ancestors when bio is queued
	  on lowest child group.

Trimming of iops token is not necessary. Since a bio always costs _one_ 
iops token. Trimming it won't change the fact that current iops token is
zero or not.

Thanks Vivek for the ancestor over-trim issue and the proposed solution.
I took another method inspired by Vivek's comments but I think more decent.
Please help to review it.

Hong Zhiguo (2):
  blk-throttle: simplify logic by token bucket algorithm
  blk-throttle: trim tokens generated for an idle tree

 block/blk-throttle.c | 314 ++++++++++++++-------------------------------------
 1 file changed, 84 insertions(+), 230 deletions(-)

-- 
1.8.1.2
