Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793562976;
	b=jTMaxLAo20csQhrHSCyN/PL2ZtzYEVkqGfCZSNgDntDF1QLrM/csCvPkCmUR06cndgI8
	 AGKoZQVeNMd1nr7o5H7hgSpyhn9UxTzU/x7NRWgYIIOKRRQVDPwEt0s6L2gayyN0PKHav
	 +MKHRG8YlnueHIvD9qkvyADnA2iSU150C6bCblYvIS/BLWQvPbgsM6VItZ/aRZnIvmh2p
	 s5qSiX2DqikyiYrU+jscjklIXcS1+jIgZq41ausddn8qIGnkBN5R7psk7/i2dLGaIRSUY
	 ZiRdz6bNNk6EBbo8vDFmxhaf+QHI9MsJXsFeYni2uJ/WOloHCshENVqAlKuiHh/lhWQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793562976;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=KkSdsnG+BikklEniaj4Q/jttRVObYiAieT3WyHniuSE=;
	b=kyJ06Z1JMaw0lEp44T+6W++7IYWU89AvJJ5SNR6LUscz3ecEZ6d4jAraqMcXzuw03inO
	 CqXrO0+HsGWIRRIinV4F5WdgEbxB27p9jrqnBHhC6v6gPvzSxxnvO5bljpknnIT3DkYPF
	 OhAGwz7gYoxzyv4rzS7+WGV9cr7Z9RwQ2ao4fujmmw6wg6p0oGUzxDUJSzjvVGDFYHloz
	 MlgEoXSTg2rTF8IOEes8Hd9Db/oKRBVFLWgI+FcHiv7FKbeTaLcW9aYTCjawS7nATzSte
	 ycRMBSjz6oyxfc7oJE8fIIj+Pfj5AtcsDBOGp4Zeg1NS9qEX51dnJdfVjvqRNhZiJ6Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tkz6qqX2;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60720606A324;
	Sun,  1 Nov 2026 19:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tkz6qqX2
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793562976;
	b=cO/pDw7+2RWtBAj/oL+dgnaL+bX2+X4CSwHff3Sf9YynmwNqL2MZcy7t1W1n89Mxkisc
	 v9MaRN1RUQJpObgsq+Mm26CoBhFOOmUr0Fvgvj86IIgMP7CvpuYwnkTIKIbSHT+QPriE3
	 Gjra0yOs0ROlOBr/0wcOpmSDDlZs8VBhLrYqml8GM9mUFONXMUnL8QgX+EnCAHnlMF5Zo
	 IXVMb6tz1nIwDlX/c+8wnSW9/614x2Iqw7UC55a8axV9hciErxFR/l10ZPQTXDHXdDH2L
	 vS69MH0FAPEDPoGyRb7W/WQGrHn00j+0c03jhjSfhBff4nQEjL0cbGZk7K0e6plZu9A==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793562976;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=KkSdsnG+BikklEniaj4Q/jttRVObYiAieT3WyHniuSE=;
	b=ynpQWKzLvw6Tkne0COGo7PUPkZ9gk5f7IYawoG8eeBJy5AYYXwWdrikMTXwLPWkc80IW
	 k/0GK2YzyWHOnM22BRda80ai/qerbuEuP1zqMJ4w7o7I3SL8C4MmZ5SdJzhg+O+uJ5Nd9
	 MZCgNaePcJm5zYJhE8I3KCp9mPZrcmcIKE3v5KZt16mkuoWb2wCeIHms+NFxkM9JDqy9X
	 6KmJoaD2Rctxyuvb6GYV0/Le5OjLpgoAPspaYnZIS9zOnRZAMWOdv1txj/MDWHBvLQoLo
	 HHHUQ68tNOPi43FoQkJ0QpenfJHJrx9dXlBaDJ2TZenvBQxMN4RGSKRHAvgqSz+ccig==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 92AEC1F000C1;
	Sun,  1 Nov 2026 19:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793562976;
	bh=KkSdsnG+BikklEniaj4Q/jttRVObYiAieT3WyHniuSE=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=Tkz6qqX2nxZdNGf5ydwqblRNBWs8hFYnLIyJm7MqhBJxLFmBra8LUKfXf1D8yNes8
	 UoBhRaOZXOK5B1XoRgBztURbcdCmb1OaIkuDQppHo2g2fgEwmwtjXk1uup+A0d9oX0
	 qzICd40zDLtqbpFwCACt3LpVVf6nyOz3gV3Zl7UjsqeWV5/3p+IOfkVHkyD1+2lK+6
	 qvgVr30wt+QD7doMXRbEyeLeZ4aYFUCi5DHuHzhAs0k1Hx33vKOE6K6QuWYdAuCZ4u
	 oxTW7OkSS8XXkMNC3cIyW7SsM39TLm6IfNzzERxwzWD3KpQCgJ5ZAvrdJ4iN+ZKMwV
	 bBncI5SPGJzKg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id E78AB4625B;
	Sun,  1 Nov 2026 19:56:14 +0000 (UTC)
From: Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org>
Date: Sun, 01 Nov 2026 14:56:15 -0500
Subject: [PATCH] cgroup: arm the notify timer only while the file exists
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
Message-Id: <20261101-cgroup-notify-timer-v1-1-060c07b81aeb@columbia.edu>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQrCMBBA0auUWTuQidSgVxEXNp3EEUzKJJVK6
 d0bdfkW/69QWIULXLoVlN9SJKcGOnTgH/cUGWVsBmvsicgQ+qh5njDlKuGDVV6saMi587H3HOw
 IrZyUgyy/6/X2d5mHJ/v6XcG27bcM03d3AAAA
X-Change-ID: 20261101-cgroup-notify-timer-0177935cef2d
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, cgroups@vger.kernel.org, 
 linux-kernel@vger.kernel.org, tz2294@columbia.edu, stable@vger.kernel.org, 
 Mani Tofigh <mt4022@columbia.edu>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793562974; l=3928;
 i=mt4022@columbia.edu; s=20261026; h=from:subject:message-id;
 bh=60CvO+jfXOPrHcfReXmW+4kGYjYut7KkK2ugXS8x2o8=;
 b=ccope1IVV72NxQTvKWk4fob2aYpuP+89xl0/LH5ma9uin0a9lufbzf1Q+PjrigtqxOsrNZgqM
 b+PqUMuc6CTATGB286ZcljzcPq4UVSWpls/f02dcNU+BOykeI0fi/Og
X-Developer-Key: i=mt4022@columbia.edu; a=ed25519;
 pk=gljCMQDuxyKPmd5y37CRpEJGSPXDV1MyAnHBhCgXl0I=
X-Endpoint-Received: by B4 Relay for mt4022@columbia.edu/20261026 with
 auth_id=1322
X-Original-From: Mani Tofigh <mt4022@columbia.edu>
Reply-To: mt4022@columbia.edu
Content-Transfer-Encoding: 7bit

From: Mani Tofigh <mt4022@columbia.edu>

cgroup_rm_file() clears cfile->kn under cfile->lock and then deletes the
notify timer.  Since commit 4616120fca7f ("cgroup: add lockless
fast-path checks to cgroup_file_notify()"), cgroup_file_notify() checks
kn and arms the timer without that lock and can arm it right after it
was deleted:

  Task A (memcg charge)                  Task B (subtree_control write)
  cgroup_file_notify()
    READ_ONCE(cfile->kn) != NULL
                                         cgroup_rm_file()
                                           cfile->kn = NULL
                                           timer_delete_sync()
    timer_reduce(&cfile->notify_timer)
      /* timer queued again */

If the css is only hidden, showing it again runs timer_setup() on the
still queued timer and corrupts the timer wheel:

  [   14.324093] ODEBUG: init active (active state 0) object: 0000000009e526fd object type: timer_list hint: cgroup_file_notify_timer+0x0/0x10
  [   14.324123] WARNING: lib/debugobjects.c:629 at debug_print_object+0x1a4/0x3b0, CPU#1: cgnotify/64
  [   14.329806] CPU: 1 UID: 0 PID: 64 Comm: cgnotify Tainted: G        W            7.3.0-17087-gd865f2677c44 #1 PREEMPT
  [   14.335109] RIP: 0010:debug_print_object+0x1ae/0x3b0
  [   14.354351] Call Trace:
  [   14.354927]  <TASK>
  [   14.356650]  __debug_object_init+0x203/0x3c0
  [   14.361799]  timer_init_key+0x2c/0x240
  [   14.362682]  cgroup_addrm_files+0x754/0xc40
  [   14.366744]  css_populate_dir+0x12e/0x440
  [   14.368636]  cgroup_apply_control_enable+0x2f3/0xb60
  [   14.371769]  cgroup_subtree_control_write+0x740/0xc10
  [   14.376924]  cgroup_file_write+0x19e/0x700
  [   14.381809]  kernfs_fop_write_iter+0x337/0x510
  [   14.382818]  vfs_write+0x545/0x1250
  [   14.386491]  ksys_write+0xfa/0x200
  [   14.390144]  do_syscall_64+0xfb/0x590
  [   14.390994]  entry_SYSCALL_64_after_hwframe+0x77/0x7f

If the css is freed instead, the timer can fire on freed memory.

Arm the timer under cfile->lock after checking kn again and keep only
the kn and timer_pending() checks outside the lock.  With the fix, the
timer stays idle once the file is removed.

This bug was identified and confirmed with the help of a deterministic
hypervisor currently under development.  The C reproducer below however
hits it within a minute.

Fixes: 4616120fca7f ("cgroup: add lockless fast-path checks to cgroup_file_notify()")
Cc: stable@vger.kernel.org
Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
---
Reproducer: https://github.com/manitofigh/files/blob/main/linux-repros/cgnotify.c
---
 kernel/cgroup/cgroup.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index a284225f8dc9..b3657e72db99 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4806,19 +4806,21 @@ void cgroup_file_notify(struct cgroup_file *cfile)
 	if (!READ_ONCE(cfile->kn))
 		return;
 
-	last = READ_ONCE(cfile->notified_at);
-	next = last + CGROUP_FILE_NOTIFY_MIN_INTV;
-	if (time_in_range(jiffies, last, next)) {
-		timer_reduce(&cfile->notify_timer, next);
-		if (timer_pending(&cfile->notify_timer))
-			return;
-	}
+	if (timer_pending(&cfile->notify_timer))
+		return;
 
 	spin_lock_irqsave(&cfile->lock, flags);
 	if (cfile->kn) {
-		kn = cfile->kn;
-		kernfs_get(kn);
-		WRITE_ONCE(cfile->notified_at, jiffies);
+		last = cfile->notified_at;
+		next = last + CGROUP_FILE_NOTIFY_MIN_INTV;
+
+		if (time_in_range(jiffies, last, next)) {
+			timer_reduce(&cfile->notify_timer, next);
+		} else {
+			kn = cfile->kn;
+			kernfs_get(kn);
+			cfile->notified_at = jiffies;
+		}
 	}
 	spin_unlock_irqrestore(&cfile->lock, flags);
 

---
base-commit: cbbddb6b08cc9900a87cccaa9b22bbe06aa4f50a
change-id: 20261101-cgroup-notify-timer-0177935cef2d

Best regards,
--  
Mani Tofigh <mt4022@columbia.edu>


