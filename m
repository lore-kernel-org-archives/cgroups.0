Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794716617;
	b=CzBmuaolTQt87jLU+BSnhQci7639B2xZH/WhkVsgvlRkoaJ/TNCLZPoYvlvGnVPhVxo/
	 xVRmhbmXYS2n0dypuA9K4x2KbWSQZTxsDcgLiwXmEINg664FAaX9N2Ev9/dGvSZ2PlNQd
	 ZefmRTkGqGGJ4TpVoMZ02LGAGSyfABlGdkSX3pIe8tt6JizU2OY69bilT4BuBevw+4eA2
	 nN5vJ/iPzhISLVYBQ8qju0at9g971yKD5tzqZGP4d5esfLFJb7tEAK04fqPuI24gvLVwK
	 ZliZaaK0zN6Jrcg2sHksI7fuWWQXC/Foh/8RhJUpwyFDhoZgjnzoCCFgFMLe+RYPKJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794716617;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=A4I4qu/iwSH9El3GjPAfCR6Msrnw2D8e/uEUG113PAM=;
	b=tLN7aPehvL1MjuBPEEMhg30KZsMa7Sqem5sKlu0CXi72mZVkw50h+y6aqEgUPTDvPLB/
	 Syce++tBNISKEAxKCGe/hZwrTWTWRQ2sl/nheGenhcDGPf4MOE4nU0vXsyYNGY5/J6jky
	 /sLWmQUKJo0gJfuD4Dx4qPZHcGLydVesY3+EDiwbaotDK8GFkXmMBm/07JWBEMrY0yTi6
	 sVvXQb95P3+C2mB6fKqjyeVUcNidjxxuiICxr+K7aGgQt7gsnBTvLyCNl6u/m/uVocvmG
	 rlNuTXiZnp5RfhVR1SnXzZ1xQ0yGbIoB08yJqb1Li0yWGXp+fh9An/AG24/GbD6QH+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jmC61Bve;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C8C606A323;
	Sun, 15 Nov 2026 04:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jmC61Bve
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38ABF1F000C4;
	Sun, 15 Nov 2026 04:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794716617;
	bh=A4I4qu/iwSH9El3GjPAfCR6Msrnw2D8e/uEUG113PAM=;
	h=From:Date:Subject:To:Cc;
	b=jmC61BvepYRA0P/xbjjR6VV829gwlfHqVed7ADgROAY47YEf9tYfqGlMHZ06ekpOA
	 VpPy+u1tROFdvnB9BFm3y1lpVoeuQEaVPyeDwY/4/q41hQaZwS9Vt5p7NEnOVBeGGo
	 ZavjeyUksnty3ZX/93Z3IwvrTpm2hE/uVGaMjDykn9VP3c4ZeNs7U96vO+61Ooqucr
	 69om0NzX22WYgZp19IzMYNLRY7qddy+9D4/QLqCAXNmEgTa4Q22PNqkN8qzJNb68CV
	 KDfATnVSAehIB1YPZs2hU1A7Nnif26SzOUH+s9qSi+8ghZm5v4VT4176vL/QYA5bbL
	 mEJuL03xkXDLA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Sat, 14 Nov 2026 21:23:26 -0700
Subject: [PATCH] blk-throttle: Avoid unsequenced accesses to jiffies in
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
Message-Id: <20261114-blk-throttle-wunsequenced-v1-1-d28ed5553ff3@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/yXMwQ6CMAyA4VchPduEDmKMr2I8sFKkSoauG5oQ3
 p2px+/w/yuYRBWDc7VClEVN51BAhwp47MJNUPticLU7ElGLfnpgGuOc0iT4zsHklSWw9Mg8NPW
 pcw2Th9I/owz6+b0v178t+7tw+g5h23ZfaRVbfQAAAA==
X-Change-ID: 20261114-blk-throttle-wunsequenced-ccf308a23c1b
To: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
 Jens Axboe <axboe@kernel.dk>
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, stable@vger.kernel.org, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2551; i=nathan@kernel.org;
 h=from:subject:message-id; bh=QkGwnED++mIJD2hpQCP/OIux2aV3aOzS1no61B7/dRw=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDFk/jY+Er4jMLfJbc/2W8FRt1R6pC+yaGza4RMRtjOvZE
 JS5OfBFRykLgxgXg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZhINRsjwxsBuekFWpPjpFss
 7q3ons05+e26CZ49zFUb97R0x868lcLwP+q96kcbO/t77AeWqhgdX2CRXdTtXlHhv86Fa4vRllt
 HWAA=
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
 block/blk-throttle.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index c5e26551956a..a1db2babd846 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -454,6 +454,7 @@ static void throtl_schedule_pending_timer(struct throtl_service_queue *sq,
 					  unsigned long expires)
 {
 	unsigned long max_expire = jiffies + 8 * DFL_THROTL_SLICE;
+	unsigned long j;
 
 	/*
 	 * Since we are adjusting the throttle limit dynamically, the sleep
@@ -465,8 +466,9 @@ static void throtl_schedule_pending_timer(struct throtl_service_queue *sq,
 	if (time_after(expires, max_expire))
 		expires = max_expire;
 	mod_timer(&sq->pending_timer, expires);
+	j = jiffies;
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

