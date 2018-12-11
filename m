From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] blkcg: handle dying request_queue when associating a
 blkg
Date: Tue, 11 Dec 2018 15:16:13 -0800
Message-ID: <1544570173.185366.397.camel@acm.org>
References: <20181211230308.66276-1-dennis@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181211230308.66276-1-dennis@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dennis Zhou <dennis@kernel.org>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>

On Tue, 2018-12-11 at 18:03 -0500, Dennis Zhou wrote:
+AD4 diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
+AD4 index 6bd0619a7d6e..c30661ddc873 100644
+AD4 --- a/block/blk-cgroup.c
+AD4 +-+-+- b/block/blk-cgroup.c
+AD4 +AEAAQA -202,6 +-202,12 +AEAAQA static struct blkcg+AF8-gq +ACo-blkg+AF8-create(struct blkcg +ACo-blkcg,
+AD4  	WARN+AF8-ON+AF8-ONCE(+ACE-rcu+AF8-read+AF8-lock+AF8-held())+ADs
+AD4  	lockdep+AF8-assert+AF8-held(+ACY-q-+AD4-queue+AF8-lock)+ADs
+AD4  
+AD4 +-	/+ACo request+AF8-queue is dying, do not create/recreate a blkg +ACo-/
+AD4 +-	if (blk+AF8-queue+AF8-dying(q)) +AHs
+AD4 +-		ret +AD0 -ENODEV+ADs
+AD4 +-		goto err+AF8-free+AF8-blkg+ADs
+AD4 +-	+AH0
+AD4 +-
+AD4  	/+ACo blkg holds a reference to blkcg +ACo-/
+AD4  	if (+ACE-css+AF8-tryget+AF8-online(+ACY-blkcg-+AD4-css)) +AHs
+AD4  		ret +AD0 -ENODEV+ADs

What prevents that the queue state changes after blk+AF8-queue+AF8-dying() has returned
and before blkg+AF8-create() returns? Are you sure you don't need to protect this
code with a blk+AF8-queue+AF8-enter() / blk+AF8-queue+AF8-exit() pair?

Bart.
