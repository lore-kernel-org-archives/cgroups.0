From: Yuwei Guan <ssawgyw@gmail.com>
Subject: [PATCH 5/5] block, bfq: change type for "bfq_large_burst_thresh"
Date: Wed,  2 Nov 2022 19:43:54 +0800
Message-ID: <20221102114354.162-6-Yuwei.Guan@zeekrlife.com>
References: <20221102114354.162-1-Yuwei.Guan@zeekrlife.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KcGv5Q7FeBS6XrUIkFhAj+jX0IyfzopjVBjybBsLOts=;
        b=NIRcuK4gA8z2XwxCgqp9Dx/4mNr7Muhwf3kBaLGGNGk+uTXlEPN4veC+ztIPfZcDpG
         dPce3bE+p52PIK48GF4y5SLT6SZn+6d+4DZWr0NDfyVRVCpSttxyUsnr1Cugrz24zEh5
         ZNu9CBU0pkTqFBoa7OV7kseKNU3xeoIijtz595GAaIIAFqWKGkjRnedDDj67q4YoaKrs
         p6IybNn6dYnYMv7z8y25J6SCMTzqlPt62Ee869kVbfuxQX/WTEeT1SOx3oRxeglKhBDy
         vQkitQenfhlIOV4Xn4qrwOaUKeDYwWQplKnaI+hJXuQW6sj+z1SWNwQDDXomw7mgCldf
         xU4A==
In-Reply-To: <20221102114354.162-1-Yuwei.Guan@zeekrlife.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: paolo.valente@linaro.org, axboe@kernel.dk, tj@kernel.org, josef@toxicpanda.com
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Yuwei.Guan@zeekrlife.com

"int" type is more suitable for "bfq_large_burst_thresh",
so change it from "unsigned long" to "int".

Signed-off-by: Yuwei Guan <Yuwei.Guan@zeekrlife.com>
---
 block/bfq-iosched.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index b022e5ec0871..df866936380e 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -701,7 +701,7 @@ struct bfq_data {
 	/* Maximum burst size above which the current queue-activation
 	 * burst is deemed as 'large'.
 	 */
-	unsigned long bfq_large_burst_thresh;
+	int bfq_large_burst_thresh;
 	/* true if a large queue-activation burst is in progress */
 	bool large_burst;
 	/*
-- 
2.34.1

