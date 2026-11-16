Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794800288;
	b=OUr65sfGFPjssltT8C93HTWFCodEhVugbc/XHFjyU0xtWnU4NUB9tWP6V68wtFShEHH1
	 e0zyJ5QePMZEmasUXaacUVXPXV5b4mlitvOTUQdLKmL/+yKGqdIemu61z+LSZKuz/BmoO
	 E8FWCFxaJwe9km576JBybRR7VSpo09CWbaY+6ymE5ksY5L47uDxxzydaS3Wf3QTvtIjeL
	 2oemRsHCBGKfGld+OrzvhY4zUUO308fiYYOERQzZbkM07rW3Qvj2zkFcKyf2D5Phm0LQm
	 SvPL41vGJy6sati/cgJ72dj2l5ClqgQRYz/kGAWxg1LdJ7GgEDihw8F565JtWRlxJLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794800288;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=Msgd0NATVk+Deh7ARJ6zRdTSPp77qlTcudhDUDfWd/g=;
	b=0gpt2DDy17K47z6ogbQU2ekzyYEdVdRORfZV+99YNwF1+rpi3fUhlAsGlVgXMycqT0SL
	 bYA8djcaXrQ3RZ7CA1LkXbeTnm88yNfCRI/ueCuDbP6rbbA8FnEPKxCDssnqbgY9QdB27
	 M1o5rzUAix2s7zEKJ+5luY8JskG4+/srqVgOEQlHn9ZQ7jtB5+pWc8FF3eE2XIrX+o/Jx
	 b1Nh4mSU2BrdwqrUVuhVtK7VvwtRug6whcSvEOF1O7TNukxGHJlm6CYUCnxpb2TVNACsD
	 Zl2omcEyUIjn8KFljmP946tZxf8L73hVNAc6K2IN4sqZ5HRIrCArQ9jYKWQaLiSmPWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YosgrFBI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A75606A31C;
	Mon, 16 Nov 2026 03:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YosgrFBI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D387B1F000C4;
	Mon, 16 Nov 2026 03:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794800287;
	bh=Msgd0NATVk+Deh7ARJ6zRdTSPp77qlTcudhDUDfWd/g=;
	h=From:Date:Subject:To:Cc;
	b=YosgrFBIhZ970IDZCA81XrArA7Nl6Z9x9ixYiw8bmoVP+meP9znfgx9LnUfq6MvSP
	 LZxVZIan5rX4tZf2ph/FDBp23cDbwTqnQw36RhoIvR/ieSjRDvWebskv4mmNmoOmUU
	 oaEdDfx+9EsznKyFmGHtjJV/y3kBtq2rDpAM5vUCAeysndrKlcgrsGi5PRZkA4lOlC
	 vb9lgtCpSZMzVQsrIT6yrZjbf+zTAftAJsu2+PmNDSI9QRt6PPViS6UYQxFQCndIaO
	 XGWr4YF/pk37ykHXycc8OMhUbYEPAdipcp06PV+SU/BnAcSwcRBULUtUhZICpoMI3W
	 cRJNX1jh4x72w==
From: Nathan Chancellor <nathan@kernel.org>
Date: Sun, 15 Nov 2026 20:37:57 -0700
Subject: [PATCH v2] blk-throttle: Avoid unsequenced accesses to jiffies in
 throtl_schedule_pending_timer()
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261115-blk-throttle-wunsequenced-v2-1-1d297c891b82@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/42NQQ6CMBBFr0K6dgzTiiGuvIdhAe0UKqTVaUEN4
 e4CXsDlS95/fxaR2FEUl2wWTJOLLvgV5CETuqt9S+DMykLm8oyIJ2iGHlLHIaWB4DX6SM+RvCY
 DWluVl7VUGhux7h9M1r339q36cRybO+m0BTejczEF/uznE27ePz8TAoKRJZmiKJS16toTexqOg
 VtRLcvyBe60FUHVAAAA
X-Change-ID: 20261114-blk-throttle-wunsequenced-ccf308a23c1b
To: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
 Jens Axboe <axboe@kernel.dk>
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, stable@vger.kernel.org, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2881; i=nathan@kernel.org;
 h=from:subject:message-id; bh=HDprAJyUPEVxg+gggrc0F17vpUYJT+ZMNUoLcllntCA=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDFm/qmZFhv3bttnO9eiDHfvfZ9v9+Llpk+Rk8QDxxWvW8
 YaLJmfu6ihlYRDjYpAVU2Spfqx63NBwzlnGG6cmwcxhZQIZwsDFKQATOa/M8L9WYbd/tvrkzmvM
 ZUEO/OsDeSZYPL9853/Uxa5zmzek39vByDDfcetG3+LZ28RPVkVXfllsfZerffLBJearf3BUqc1
 ST+AGAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

After a recent improvement in clang to warn on unsequenced accesses to
volatile variables [1], two instances appear in
throtl_schedule_pending_timer(), which can break the build with
CONFIG_WERROR=y / W=e:

  block/blk-throttle.c:469:25: error: unsequenced accesses to volatile qualified 'jiffies' [-Werror,-Wunsequenced]
    469 |                    expires - jiffies, jiffies);
        |                              ~~~~~~~  ^
  block/blk-throttle.c:469:25: error: unsequenced accesses to volatile qualified 'jiffies' [-Werror,-Wunsequenced]
    469 |                    expires - jiffies, jiffies);
        |                              ~~~~~~~  ^

Per C11 5.1.2.3.2, accessing a volatile object is a side effect. Per C11
6.5.2, unsequenced side effects on the same scalar object are undefined
behavior. Per C11 6.5.2.2.10/12, the evaluation of arguments in a
function call is indeterminately sequenced, meaning any side effects in
the arguments are unsequenced.

Add a local variable to hold the value of jiffies before the function
call so that there are no unsequenced side effects, clearing up the
warning.

Cc: stable@vger.kernel.org
Fixes: 69df0ab030c9 ("blk-throttle: separate out throtl_service_queue->pending_timer from throtl_data->dispatch_work")
Closes: https://github.com/ClangBuiltLinux/linux/issues/2191
Link: https://github.com/llvm/llvm-project/commit/955715460eaf9188c241c74750637fc82dfcc423 [1]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
Changes in v2:
- Reuse value of jiffies in max_expire to avoid
  -Wunused-but-set-variable for j when CONFIG_BLK_DEV_IO_TRACE is
  disabled (Sashiko)
- Link to v1: https://patch.msgid.link/20261114-blk-throttle-wunsequenced-v1-1-d28ed5553ff3@kernel.org
---
 block/blk-throttle.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index c5e26551956a..8e58e50bce4d 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -453,7 +453,8 @@ static void throtl_dequeue_tg(struct throtl_grp *tg)
 static void throtl_schedule_pending_timer(struct throtl_service_queue *sq,
 					  unsigned long expires)
 {
-	unsigned long max_expire = jiffies + 8 * DFL_THROTL_SLICE;
+	unsigned long j = jiffies;
+	unsigned long max_expire = j + 8 * DFL_THROTL_SLICE;
 
 	/*
 	 * Since we are adjusting the throttle limit dynamically, the sleep
@@ -466,7 +467,7 @@ static void throtl_schedule_pending_timer(struct throtl_service_queue *sq,
 		expires = max_expire;
 	mod_timer(&sq->pending_timer, expires);
 	throtl_log(sq, "schedule timer. delay=%lu jiffies=%lu",
-		   expires - jiffies, jiffies);
+		   expires - j, j);
 }
 
 /**

---
base-commit: ab43ec385580b8f8abf72d70fa3acbf4e4f098a5
change-id: 20261114-blk-throttle-wunsequenced-ccf308a23c1b

Best regards,
--  
Cheers,
Nathan

