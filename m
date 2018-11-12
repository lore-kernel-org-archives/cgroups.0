From: Paolo Valente <paolo.valente@linaro.org>
Subject: [PATCH 11/12] doc, bfq-iosched: fix a few clerical errors
Date: Mon, 12 Nov 2018 10:56:31 +0100
Message-ID: <20181112095632.69114-12-paolo.valente@linaro.org>
References: <20181112095632.69114-1-paolo.valente@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=95cHSgXhObq6AUCu/Rr/+wEQTPHLVt9I8/orFJ2tnV8=;
        b=ZntydDL3A95QZ0Q9bqPS7efY9/AnOcRfFMoWhJjuF9Gk55eXToWWO0MFVufb41xZUb
         nHLiTbmFBZG9+1cdt8aSYqRhhgzNW6mvo/J47vdQ+DPObGyWLAiX1dVnw6VnyGsWrHIX
         7rTjNGD9VyfMoQr33985it7yVDU+01tI7ZnNQ=
In-Reply-To: <20181112095632.69114-1-paolo.valente@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Angelo Ruocco <angeloruocco90@gmail.com>, Dennis Zhou <dennis@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Liu Bo <bo.liu@linux.alibaba.com>, Bart Van Assche <bvanassche@acm.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, ulf.hansson@linaro.org, linus.walleij@linaro.org, broonie@kernel.org, bfq-iosched@googlegroups.com, oleksandr@natalenko.name, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Paolo Valente <paolo.valente@linaro.org>

This commit fixes a few clerical errors in
Documentation/block/bfq-iosched.txt.

Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
---
 Documentation/block/bfq-iosched.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/block/bfq-iosched.txt b/Documentation/block/bfq-iosched.txt
index 8d8d8f06cab2..6d7dd5ab8554 100644
--- a/Documentation/block/bfq-iosched.txt
+++ b/Documentation/block/bfq-iosched.txt
@@ -42,7 +42,7 @@ sustainable throughputs, on the same systems as above:
 
 BFQ works for multi-queue devices too.
 
-The table of contents follow. Impatients can just jump to Section 3.
+The table of contents follows. Impatients can just jump to Section 3.
 
 CONTENTS
 
@@ -51,7 +51,7 @@ CONTENTS
  1-2 Server systems
 2. How does BFQ work?
 3. What are BFQ's tunables and how to properly configure BFQ?
-4. BFQ group scheduling
+4. Group scheduling with BFQ
  4-1 Service guarantees provided
  4-2 Interface
 
@@ -294,7 +294,7 @@ too.
 per-process ioprio and weight
 -----------------------------
 
-Unless the cgroups interface is used (see "4. BFQ group scheduling"),
+Unless the cgroups interface is used (see "4. Group scheduling with BFQ"),
 weights can be assigned to processes only indirectly, through I/O
 priorities, and according to the relation:
 weight = (IOPRIO_BE_NR - ioprio) * 10.
-- 
2.16.1

