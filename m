From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] blkcg: handle dying request_queue when associating a
 blkg
Date: Wed, 12 Dec 2018 15:54:52 -0800
Message-ID: <1544658892.185366.412.camel@acm.org>
References: <20181211230308.66276-1-dennis@kernel.org>
         <1544570173.185366.397.camel@acm.org>
         <20181212040643.GA73727@dennisz-mbp.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181212040643.GA73727@dennisz-mbp.dhcp.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dennis Zhou <dennis@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>

On Tue, 2018-12-11 at 23:06 -0500, Dennis Zhou wrote:
+AD4 Hi Bart,
+AD4 
+AD4 On Tue, Dec 11, 2018 at 03:16:13PM -0800, Bart Van Assche wrote:
+AD4 +AD4 On Tue, 2018-12-11 at 18:03 -0500, Dennis Zhou wrote:
+AD4 +AD4 +AD4 diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
+AD4 +AD4 +AD4 index 6bd0619a7d6e..c30661ddc873 100644
+AD4 +AD4 +AD4 --- a/block/blk-cgroup.c
+AD4 +AD4 +AD4 +-+-+- b/block/blk-cgroup.c
+AD4 +AD4 +AD4 +AEAAQA -202,6 +-202,12 +AEAAQA static struct blkcg+AF8-gq +ACo-blkg+AF8-create(struct blkcg +ACo-blkcg,
+AD4 +AD4 +AD4  	WARN+AF8-ON+AF8-ONCE(+ACE-rcu+AF8-read+AF8-lock+AF8-held())+ADs
+AD4 +AD4 +AD4  	lockdep+AF8-assert+AF8-held(+ACY-q-+AD4-queue+AF8-lock)+ADs
+AD4 +AD4 +AD4  
+AD4 +AD4 +AD4 +-	/+ACo request+AF8-queue is dying, do not create/recreate a blkg +ACo-/
+AD4 +AD4 +AD4 +-	if (blk+AF8-queue+AF8-dying(q)) +AHs
+AD4 +AD4 +AD4 +-		ret +AD0 -ENODEV+ADs
+AD4 +AD4 +AD4 +-		goto err+AF8-free+AF8-blkg+ADs
+AD4 +AD4 +AD4 +-	+AH0
+AD4 +AD4 +AD4 +-
+AD4 +AD4 +AD4  	/+ACo blkg holds a reference to blkcg +ACo-/
+AD4 +AD4 +AD4  	if (+ACE-css+AF8-tryget+AF8-online(+ACY-blkcg-+AD4-css)) +AHs
+AD4 +AD4 +AD4  		ret +AD0 -ENODEV+ADs
+AD4 +AD4 
+AD4 +AD4 What prevents that the queue state changes after blk+AF8-queue+AF8-dying() has returned
+AD4 +AD4 and before blkg+AF8-create() returns? Are you sure you don't need to protect this
+AD4 +AD4 code with a blk+AF8-queue+AF8-enter() / blk+AF8-queue+AF8-exit() pair?
+AD4 +AD4 
+AD4 
+AD4 Hmmm. So I think the idea is that we rely on normal shutdown as I don't
+AD4 think there is anything wrong with creating a blkg on a dying
+AD4 request+AF8-queue. When we are doing association, the request+AF8-queue should
+AD4 be pinned by the open call. What we are racing against is when the
+AD4 request+AF8-queue is shutting down, it goes around and destroys the blkgs.
+AD4 For clarity, QUEUE+AF8-FLAG+AF8-DYING is set in blk+AF8-cleanup+AF8-queue() before
+AD4 calling blk+AF8-exit+AF8-queue() which eventually calls blkcg+AF8-exit+AF8-queue().
+AD4 
+AD4 The use of blk+AF8-queue+AF8-dying() is to determine whether blkg shutdown has
+AD4 already started as if we create one after it has started, we may
+AD4 incorrectly orphan a blkg and leak it. Both blkg creation and
+AD4 destruction require holding the queue+AF8-lock, so if the QUEUE+AF8-FLAG+AF8-DYING
+AD4 flag is set after we've checked it, it means blkg destruction hasn't
+AD4 started because it has to wait on the queue+AF8-lock. If QUEUE+AF8-FLAG+AF8-DYING is
+AD4 set, then we have no guarantee of knowing what phase blkg destruction is
+AD4 in leading to a potential leak.

Hi Dennis,

To answer my own question: since all queue flag manipulations are protected
by the queue lock and since blkg+AF8-create() is called with the queue lock held
the above code does not need any further protection. Hence feel free to add
the following:

Reviewed-by: Bart Van Assche +ADw-bvanassche+AEA-acm.org+AD4



