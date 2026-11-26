Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795671680;
	b=aqRepbrE6kV2D1R4Wgwv8DRDqJcuqiwShUezDBNmCHxuOhV2dgruZeN6rOlr1S6Y+t+N
	 ClsxNw1+TJx4pcJ6tNhUBZvqdqMHD2Ilo0NZPVptOVE3Q7E/tnwRBHEhOEFK5RRfesWJI
	 nHjAoSS8JpWl2dYQ7nNZz8hJSA7eeF9ZykAkIOoPnTKI9E8IBwZZtCxDba0SS4O3csh/P
	 vNE7ks2TdTBKAVsyX2dHPQNiLHUhE6U7TnOTI6wrfXImf6bn1cZDm/nYFPw0oU82FnS+7
	 mb9+ak74QmSaGC47E1l/wv1t+93AxNwR5nzaT2IcSQLDRXyCbkyDBD7w9iTK9GME4NQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795671680;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:Message-ID:
	 In-Reply-To:References:From:Subject:To:Cc:MIME-Version:Content-Type:
	 Content-Disposition:User-Agent;
	bh=pY8g3Te5pr8+4PaQDY1sqwdBVZLSZwW2B2TIxKwxNTo=;
	b=ynIAgiDZi+OksYqut8ZUIO3Pg4ZAjwX3EocdFClrbt3iKfhJVYqqrdzKifEi5JAOR+jJ
	 U8NzlmPNumeAgNYeX62pAF/36EqOngRzC+rmZrtV9j57AaSCVBgShkUa8kshDGJaI5iS9
	 0TdHlG3E1PN9DzAYPPMyiGEK10YKKydGo9gu2bh3uGVbjHcJX50NzpZ4hcr07KRo7XQKm
	 8vSO5Wye+jR6uN/2NmgTFkga3HL+NJ/vnfhVYhkW25F8lIyS8dn4AVsj3SRHs9Ev6Mb6Y
	 XyTU7rIL3gKdrb7mY54OHVsdLu1Xg8sjN136U5ptyh39TIkRLttUdEQ23b5YsuwUYRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=YNdcfFJL;
	arc=none smtp.remote-ip=74.125.224.45
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C56606A330
	for <cgroups@vger.kernel.org>; Thu, 26 Nov 2026 05:41:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B3C56606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=YNdcfFJL
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-67db3a48dc6so7931362d50.3
        for <cgroups@vger.kernel.org>; Wed, 25 Nov 2026 21:41:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1795671679; x=1796276479; darn=vger.kernel.org;
        h=user-agent:content-disposition:content-type:mime-version:cc:to
         :subject:from:references:in-reply-to:message-id:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=pY8g3Te5pr8+4PaQDY1sqwdBVZLSZwW2B2TIxKwxNTo=;
        b=YNdcfFJLT9nFiYuza8Tzo8Mvjb68nbjqLcJWBhigfLjutsKmLN+F37dSBKnqnbJ2uN
         DJjxECB6KL2iQlwgYdkE9txNIC4rdUe9mGfO4Zjq1s2y7ykPKXHcatVt1ERZP6xeACF8
         +2BxQREzX4puwiAfn+P/aQfas4qW7s7nqA5zA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795671679; x=1796276479;
        h=user-agent:content-disposition:content-type:mime-version:cc:to
         :subject:from:references:in-reply-to:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pY8g3Te5pr8+4PaQDY1sqwdBVZLSZwW2B2TIxKwxNTo=;
        b=W+tG60RDvp4AywGXZanyrjqztU6F22VuXsPnKZgTx1JVGOGi79z2MFHtKmy94whp9c
         BakNCHig3z4dXf074CvzJ2YT2zpmS/W4gMGKbbWF8L7zSdu/vYGVQxTvuJqis7sNSrnm
         SDuZBXP/hvDa1vDCOH2+vj7TGBEHM4mctn6PDPAA3FAufGlWqXZ7HkDqeS+dYBjc+gQz
         /R2Sdku5DtKU9Ecm4h/p3LrMuNCpQRiI8EqFm8zToRRgUcQZbAVCOkBx9dYx4Bi0Q7cW
         Ls4PoQxv18PLd4Qj+/VnDWKAVFwrsSxvdZ5Paysj1J647QMH/k1uKtn1A4t+i1lEcJEf
         lpuQ==
X-Gm-Message-State: APuU4Z8qa89kElEHR7DXrnsh2V4AboVkAT6tcfVG5s30zimaJoZ+z3O/
	mUY7LnDap1fcf5LzafCkO5jkiKkiWgfA13sGV5iAiooRfMvbgSnHG5sTq9wdRq00r5w=
X-Gm-Gg: AZFdTZcP+nswPRLiRoE1KuZY1NyPxkJIQ2oxVERDJDTkyflVgOoz1vxNPW+giZVk2Bl
	xuJRtOAUezI+EBj3MJpQ6Ct9DlsMCN0JI2tYSutJrzHG4zTkvMHV138woXf0ummiw34psckEcEx
	t8ZO9EX4MyqmSx69rls/0L2u2LgKIAVmBgjuzDAsDt3wZMCe8ExHTBoGsLAhYhB/WTEb7I79XLe
	d/afP8PGZTbFjWnzW3PcfWl1p4K1C9dD+YrO7RI2IOIAa4VjVpae1hwdoQ5lZtSjcuGnhrzhvxX
	+8rSIcq/IMMySjHFzGouddH3vyyfJAKFLkEhVR98LK6tpiVPodwG3HaRhIqv45YCdyimmhAV0YY
	UhGH5XQivymwfD5GkbBBJvvC/Bf0NvoOw7tqhmXNpquvRtgqBzaiWj2kKKRKGKOna4y1OxYORWk
	0FgHwAD6ckZ+G9pnaykqd82mevFIpwzYTbRH66eXJEZ+QO6bmJcvbql9A5O19BSHUUds0g6mPco
	PXZF9P5uCPGK6T7cC1l9Q+kp0aT4Bb/Rkpjkfo1Y8+Wqi25y0Wcr5xZNJLZX8/P1vgZ9RILAg8T
	PeXmQ4HM6LsvCZJs5gWOdg0Gt61G1Zk0wkrgrgSkQKXhx+SBRRyr2S7FtXff5hpzFnuX9AYyKEj
	27cQZ3Id3PoFxQmTdHnInqdrEdU87gzQIJCWruxBcdI6mkeqoALQxPPbGFH4BplkVWn/UJ5kzGi
	GxDYy2+hak+16YnRdnFK63ZsKrDA8IcWRcomgYn5vUMYaS4CK7muLtfEAbYuZlpot14dRRb+syi
	RGdn1fv1wlVQ9IeHilaGReF2UUWIgDtlcrISZK5eo8O
X-Received: by 2002:a05:690e:440e:b0:67d:acd0:4082 with SMTP id 956f58d0204a3-67df43f35b1mr3972170d50.42.1795671678757;
        Wed, 25 Nov 2026 21:41:18 -0800 (PST)
Received: from [172.20.0.2] (c-73-207-185-9.hsd1.ga.comcast.net. [73.207.185.9])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67df335b3aesm9571526d50.12.2026.11.25.21.41.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 21:41:17 -0800 (PST)
Date: Wed, 25 Nov 2026 21:41:15 -0800
Message-ID: <27716decb1032bb5d00ab8a4560179e082d8a2c0.1795671629.git.chris@chrisdown.name>
In-Reply-To: <cover.1795671629.git.chris@chrisdown.name>
References: <cover.1795671629.git.chris@chrisdown.name>
From: Chris Down <chris@chrisdown.name>
Subject: [PATCH v3 1/2] cgroup: Fix divide error on long fractions in
 cgroup_parse_float()
To: tj@kernel.org,
    hannes@cmpxchg.org,
    mkoutny@suse.com,
    shakeel.butt@linux.dev
Cc: cgroups@vger.kernel.org,
    linux-kernel@vger.kernel.org
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

cgroup_parse_float() parses the decimal values written to
cpu.uclamp.min, cpu.uclamp.max and io.cost.qos. When there are too many
digits, it rounds the fraction with:

  frac = DIV_ROUND_CLOSEST_ULL(frac, power_of_ten(flen - dec_shift));

do_div() takes a 32-bit divisor, so power_of_ten() is
truncated to its low 32 bits. That gives the wrong divisor from
10^10 onwards and zero at 10^32, because 2^32 divides 10^32.

This means that as it is now, writing "0." followed by 34 zeros to
cpu.uclamp.min or cpu.uclamp.max divides by zero.

The files belong to whoever owns the cgroup, so the owner of a
delegated subtree can do the same without any privilege:

  # mkdir /sys/fs/cgroup/d
  # cd /sys/fs/cgroup/d
  # chown 1000:1000 . cgroup.procs cgroup.subtree_control cgroup.threads
  # echo +cpu > cgroup.subtree_control
  # setpriv --reuid=1000 --regid=1000 --clear-groups sh
  $ mkdir x
  $ echo 0.0000000000000000000000000000000000 > x/cpu.uclamp.min

  Oops: divide error: 0000 [#1] SMP KASAN NOPTI
  CPU: 3 UID: 1000 PID: 178 Comm: sh Not tainted 7.4.0-rc1
  RIP: 0010:cgroup_parse_float (kernel/cgroup/cgroup.c:7553)
  RCX: 0000000000000000
  Call Trace:
   cpu_uclamp_write (kernel/sched/core.c:9677 kernel/sched/core.c:9700)
   kernfs_fop_write_iter (fs/kernfs/file.c:345)
   vfs_write (fs/read_write.c:595 fs/read_write.c:687)
   ksys_write (fs/read_write.c:739)
   do_syscall_64 (arch/x86/entry/syscall_64.c:84)
   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)

Unfortunately the writer dies holding the kernfs active reference on
cpu.uclamp.min, so subsequent operations deadlock in kernfs_drain(),
even in unrelated cgroups:

  task:rmdir state:D
   kernfs_drain (fs/kernfs/dir.c:539)
   __kernfs_remove (fs/kernfs/dir.c:1578)
   kernfs_remove_by_name_ns (fs/kernfs/dir.c:1796)
   cgroup_addrm_files (kernel/cgroup/cgroup.c:4596)
   css_clear_dir (kernel/cgroup/cgroup.c:1770)
   kill_css_sync (kernel/cgroup/cgroup.c:6274)
   cgroup_destroy_locked (kernel/cgroup/cgroup.c:6394)
   cgroup_rmdir (kernel/cgroup/cgroup.c:6442)
   [...]
  task:mkdir state:D
   __mutex_lock (kernel/locking/mutex.c:821)
   cgroup_kn_lock_live (kernel/cgroup/cgroup.c:1713)
   cgroup_mkdir (kernel/cgroup/cgroup.c:6161)
   [...]

To fix this, stop scanning the fraction as a number, and leave any
trailing digits alone. That avoids needing to divide, and thus the risk
of overflow.

(Dividing with div64_u64() and capping the exponent would also solve
this, but it would keep scanning the fraction into an s64, which long
fractions can still overflow. kstrtodec64() truncates rather than
rounds and is inconveniently too new for most stable trees, so let's do
it this way.)

Fixes: a5e112e6424a ("cgroup: add cgroup_parse_float()")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Down <chris@chrisdown.name>
---
 kernel/cgroup/cgroup.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index b3657e72db99..f6df19241772 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -29,6 +29,7 @@
 
 #include <linux/bpf-cgroup.h>
 #include <linux/cred.h>
+#include <linux/ctype.h>
 #include <linux/errno.h>
 #include <linux/init_task.h>
 #include <linux/kernel.h>
@@ -7541,18 +7542,28 @@ static u64 power_of_ten(int power)
 int cgroup_parse_float(const char *input, unsigned dec_shift, s64 *v)
 {
 	s64 whole, frac = 0;
-	int fstart = 0, fend = 0, flen;
+	int wlen = 0;
+	unsigned int i;
+	const char *p;
 
-	if (!sscanf(input, "%lld.%n%lld%n", &whole, &fstart, &frac, &fend))
-		return -EINVAL;
-	if (frac < 0)
+	if (sscanf(input, "%lld%n", &whole, &wlen) != 1)
 		return -EINVAL;
 
-	flen = fend > fstart ? fend - fstart : 0;
-	if (flen < dec_shift)
-		frac *= power_of_ten(dec_shift - flen);
-	else
-		frac = DIV_ROUND_CLOSEST_ULL(frac, power_of_ten(flen - dec_shift));
+	p = input + wlen;
+	if (*p == '.')
+		p++;
+
+	for (i = 0; i <= dec_shift; i++) {
+		int digit = 0;
+
+		if (isdigit(*p))
+			digit = *p++ - '0';
+
+		if (i < dec_shift)
+			frac = frac * 10 + digit;
+		else if (digit >= 5)
+			frac++;
+	}
 
 	*v = whole * power_of_ten(dec_shift) + frac;
 	return 0;
-- 
2.56.1

