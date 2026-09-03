Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CB232937A;
	Thu,  3 Sep 2026 12:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788437050; cv=none; b=uSGtZ8ZTDn2x8NMBFgTkugrBRpAZywLVpIjiYI/wjTe6ZFCrB10Fm7LwnrV8PArEMwaQRMY4Y23qgiRe8b9CDtzQBczPRwcQKCZFldL9yLosIO9aJFQbikNGg0REoHLsiU9HtqnFCb80y1Eb/nXQogWICZH9twU/e+TC9PrsHlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788437050; c=relaxed/simple;
	bh=M6A05OEKRI8aV92fPYmcQc5HME2uGARcHn1GvM9pIvI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=JcpNHEh8UtCz+B1EzkyioHndYXUI7Qt0ovFYHT9VdfzTDkbuSFYVC/xvK8mwqLSKm6efmfoq/2mI6J7RLHuQcblkzx/heZahQjCGxdBdkUXs2KqEfLUKJjVPKr36qHkW4ODMnWAdQXpAnJ6C0FtXwZdn4klGKn0sN0j2+LLqmNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=pkDzc2ze; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="pkDzc2ze"
Received: from mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:65a0:0:640:e1de:0])
	by forwardcorp1d.mail.yandex.net (postfix) with ESMTPS id A961A80769;
	Thu, 03 Sep 2026 15:03:57 +0300 (MSK)
Received: from [127.0.1.1] (unknown [2a02:6bf:8009:1403:13e2:aa39:7988:f1b2])
	by mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net (smtpcorp) with ESMTPSA id u3kPrH5XViE0-YIPre64s;
	Thu, 03 Sep 2026 15:03:57 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1788437037;
	bh=Df7xCZqqZ1aQpHN0K+/HVHczZNeqgBe2XscfGWdDMak=;
	h=Cc:Message-Id:To:From:Date:Subject;
	b=pkDzc2zeIK9qWmv9suqN7qXgDw0NIoUb51rgR3X0sx52gV+ny/lAag6jWuMyjegT4
	 CqnGCvkzHybQmhfguQdlv8Mvu4bEylJDmzoP1C087jdGciJ8qGcFi9Fo+zMaCeA9jY
	 DJhRhXfOzgMiVwOx7Jw2Le8LdAklBMX9Kj5Xeqvo=
Authentication-Results: mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Mikhail Rudenko <xyzzy@yandex-team.ru>
Date: Thu, 03 Sep 2026 14:54:17 +0300
Subject: [PATCH] blk-throttle: reject IOPS limits above UINT_MAX for legacy
 interface
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260903-throttl-truncation-fix-v1-1-c6a864c8bc17@yandex-team.ru>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWM0QqDMAxFf0XyvECtMuh+RfbQdlEzRpU0joH47
 8vc47ncc3aoJEwVbs0OQm+uvBSD9tJAnmOZCPlhDN75qwuuQ51lUX2hylZyVLvjyB/s+pRdCiH
 63oPJq5DNZ3i4/7lu6UlZfzU4ji9lJG9negAAAA==
X-Change-ID: 20260903-throttl-truncation-fix-34bc0b99a242
To: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
 Jens Axboe <axboe@kernel.dk>
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Mikhail Rudenko <xyzzy@yandex-team.ru>
X-Mailer: b4 0.15.2

tg_set_conf(), used for blkio.throttle.{read,write}_iops_device legacy
blkio cgroup sysfs knobs, parses limits as u64 but stores them in
unsigned int, silently truncating values above UINT_MAX. In addition
to being an obvios correctness issue, this may result in division by
zero in tg_within_iops_limit(), if the value is truncated to zero.

Reject such values with -EINVAL and explicitly use UINT_MAX as
a sentinel value for IOPS limits.

Fixes: 3a8b31d396b2 ("blkcg: restructure blkio_group configruation setting")
Cc: stable@vger.kernel.org
Signed-off-by: Mikhail Rudenko <xyzzy@yandex-team.ru>
---
This was found by a local Sashiko instance when reviewing an unrelated
patch. Idk if Assisted-by: is required in this case. This patch was
written manually, though.

Exact commit for Fixes: was a bit difficult to track, since the code
went through multiple refactorings. I believe that it's 3a8b31d396b2,
where (temp > THROTL_IOPS_MAX) check was dropped. Anyway, all the
maintained LTS releases are affected.
---
 block/blk-throttle.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index ffc3b70065d4..d2d46aeb24e1 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1377,8 +1377,12 @@ static ssize_t tg_set_conf(struct kernfs_open_file *of,
 	ret = -EINVAL;
 	if (sscanf(ctx.body, "%llu", &v) != 1)
 		goto unprep;
+
+	if (!is_u64 && v > UINT_MAX)
+		goto unprep;
+
 	if (!v)
-		v = U64_MAX;
+		v = is_u64 ? U64_MAX : UINT_MAX;
 
 	tg = blkg_to_tg(ctx.blkg);
 	tg_update_carryover(tg);

---
base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
change-id: 20260903-throttl-truncation-fix-34bc0b99a242

Best regards,
--  
Mikhail Rudenko <xyzzy@yandex-team.ru>

