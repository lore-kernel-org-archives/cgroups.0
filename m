Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794107812;
	b=0YOiUemMRzXFZr6Hl3Q/CgfQtjkEFJsnhdMwcni9c2Ca6H7reCI7PE3YmuyiAEIL1kDY
	 FNrRy+lLnpzv2PgGtxp5Q9MW/LIzCINYtEMj9NY9+uda+c+h6DvyKc417qGXKuapo5/8M
	 XcPNkJS5hP+SX8JbWgH6oJLM4RrEscqRQK8unyJzXVMXhtZtJqM7ifCmU6b3rShcmFfbo
	 fULcRlmYYV+wDIXGtwabKgC7m7gzGJyVorMsc6b+agmtdBT7ByB3l3FJ4atvNzloH+1UP
	 k9TM17hecNEje+GoIKnXJARwe/EYze/p4k+VSS1fzJZKwQ2tGCp59BkxY3xQqzZOTNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794107812;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:User-Agent;
	bh=CYbXanoVIznje4wNLs5CNwhXIty16UVDrSGIc7iuqrM=;
	b=yoogpE8/qoHFu0jcCT1qtfyD3ekBkgzEl8N2n8dmvYsjx23GsRSv5WvmO0BVwlounKuv
	 KxPGqZoN+2YS3fXZ3Y7JEQnVNToVo9MrFk36GWdx048aMRymS5wPqwQFEgF0F1MT+nzWv
	 Gpcdiptka3BIPK7N1rK12FIwcfmE5wWSh1GWIir7poa6fVCSEPxJXx/l6QhOBj3feJJ6q
	 0KNuFBzGjet2jYwXtDMJ6Arn2dTExa4xawDITfEETUDvWCX9RdZuNFRoILjDzV87Jy0Ar
	 RJxdo3KAdaz9Hyx9G1HRY6B6owhwNlqHPHRZlZy5g1C2kKp/ZX/6MWSsDRCg6Dl/M0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=ZEE4WdQY;
	arc=none smtp.remote-ip=209.85.215.175
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583A4606A31C
	for <cgroups@vger.kernel.org>; Sun,  8 Nov 2026 03:16:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 583A4606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=ZEE4WdQY
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cc1bc88a20eso67110a12.3
        for <cgroups@vger.kernel.org>; Sat, 07 Nov 2026 19:16:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794107812; x=1794712612; darn=vger.kernel.org;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CYbXanoVIznje4wNLs5CNwhXIty16UVDrSGIc7iuqrM=;
        b=ZEE4WdQYEwXXZXioxDQ7Kuk3roMKT2YUNju7Qb+mi3Mj+DlEcvJicx1RjVPDg6N/qP
         +5cNNcQfUGlKmyzSE8EVFvcdn0ibcpdyENZOTt1njCFRo1N76sptGEqrSxgjgNebgmJ4
         +zacY+02xOI09uZ/WuqkSXZrp9L5SxHOhDNJ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794107812; x=1794712612;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=CYbXanoVIznje4wNLs5CNwhXIty16UVDrSGIc7iuqrM=;
        b=FXzl4PnEiaz88U7T+iywaDyZy6gWTSPdaLM3d1gZe8Jhu5lkj2ugP7qz07nh+Mf/KV
         7/4BMjbebFMudP6xevcE7w60oBlVcxips9hAxNnq3oqnxz+LM9ay0vh+fQ9GR/E/RLbP
         baNrn/smBwqbVMKR+uqaTraF2lDgELxETQJvldYf9kn9h3JxlTFBRy1e3Cgu3VwDmfmD
         mCDQTMJJ/w69D/gMiTeeYrsnRvNkhj7tQX8nJuwWsDhSUv6iwZ4iLKGg9gKO4PO1vNL7
         MO1b6rSii4yKJAgTPXY65vdgOlJ5yS8vyremPDYRER/tx2HzkXdXByYt8IklCrwsXHX6
         l9Sw==
X-Forwarded-Encrypted: i=1; AL+hErHe7MTbIOFut8deGILFAWJE25Mnh0UjadbE9qeHdnyqvHWxnuG0D2GzT01e/bXL0q39K574I7cc@vger.kernel.org
X-Gm-Message-State: APuU4Z8foBjZLsVM+4g9lXJbiii3mbQxhk7Y9Pnub+upqZrXRHmMe1xU
	wM1UqLfU5ZgbInE9Ijl3HjyERiBFpC4V56QbT44HEp9L9tjNC3aezYg2+zgtiuzcSmA=
X-Gm-Gg: AYBFou3vZ+6W7gZpz+WFvrlSOG2WhmpyI8vqRQKfifhtk1Pw23lE4/HW4pJ79cfsGZ7
	y/lPvEz0spQ+mnxQIwe14pS4PsOuTGzSJxZniDNjoYTLT1AxU5abTxJnavmzAWlGdpPJcRAV7ca
	GJpqghQq/X3XrZp1y5bMp3qnzWnMNU8wKcShnE0hRnT28znxcQY+Pc5npSf1tIBAQh/REMJBcM2
	7PEXv0G7t6wXjedoxdpZQR+L8T+I5aysBIgUNKnhhp7dInDWUyq7+GgDpSc0knMdGr/4h9tZfDm
	v+COaqZP66IwOtVIAA3VRC9CMl8ALChm6EEpQe21NCHIp1mxj+MVEPM2U1+7Ha5IawmCLtoSWg3
	HshXjzdfByvjAndhBeCPaJwgg5AUMspUrl9iElgahGjKxocqGmjTEdEgjarhRtNddJxA+2zWRpu
	dcFeBbDJ0zzBaVeHA/LuvMV9BlWc8haaoGpMkT97aN6KzXOhTMsz0FFu1AAHa7xkW2GQ6DeO6Xz
	soQX0H5UD8sRkkqJRjx8XqD9oPRj4EmzNbkz4wl13lyP9cf5zDt9R7TU9rTttKzuFM1WTwhJhAN
	5BU6CqHgNylB6C+NZTvPCXfYJW3bfUjuPQgBHeb0h4Lpc3ucl/TqVdgjAGAFPfszXMngTQPANFe
	2tmUVoDLZfw3nENnr5Rzs7TuU1sapDwMkdPubIgytx/42q75Y5wAVhmUoKuN/H3M7JfbpWMmU8r
	Odvg2Aqx0e1Op0oW5bXcB2moGFUxUkSu46eCPtpxf2ubg8RkBLWNQo
X-Received: by 2002:a17:90b:274b:b0:3a4:77b8:1770 with SMTP id 98e67ed59e1d1-3b12d3cbd66mr374011a91.15.1794107811685;
        Sat, 07 Nov 2026 19:16:51 -0800 (PST)
Received: from localhost ([50.175.87.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b105864375sm5351700a91.4.2026.11.07.19.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 19:16:49 -0800 (PST)
Date: Sat, 7 Nov 2026 19:16:46 -0800
From: Chris Down <chris@chrisdown.name>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Serge Hallyn <serge.hallyn@ubuntu.com>, driver-core@lists.linux.dev,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH] kernfs: Build paths in linear time with respect to depth
Message-ID: <au_pnu4s141ylqHD@chrisdown.name>
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
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)

kernfs nodes only point to their parent. To build a path top-down,
kernfs_path_from_node_locked() walks back up from the leaf for each
name, so the work grows with the square of the depth. Reading
/proc/<pid>/cgroup does this with IRQs off and css_set_lock held, so a
read from a deep delegated subtree can hold up fork and exit elsewhere
on the machine, which is certainly suboptimal.

Let's improve this by filling the buffer from the end as we walk up,
and if the path fits, moving it into place directly.

In terms of operations, with a 15,000 deep path chain and a 4 KiB
buffer:

1. Parent and name pointer reads go from 112.6 million to 75,003 with
   this change
2. On my machine the second read of /proc/self/cgroup takes 99.86% less
   time.

Fixes: 3abb1d90f5d9 ("kernfs: make kernfs_path*() behave in the style of strlcpy()")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chris Down <chris@chrisdown.name>
---
 fs/kernfs/dir.c | 61 +++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 49 insertions(+), 12 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 800af10d9511..1ac6a5ec451b 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -94,6 +94,14 @@ static struct kernfs_node *kernfs_common_ancestor(struct kernfs_node *a,
 	return a;
 }
 
+static void kernfs_reverse_path(char *buf, size_t len)
+{
+	size_t i;
+
+	for (i = 0; i < len / 2; i++)
+		swap(buf[i], buf[len - i - 1]);
+}
+
 /**
  * kernfs_path_from_node_locked - find a pseudo-absolute path to @kn_to,
  * where kn_from is treated as root of the path.
@@ -130,9 +138,14 @@ static int kernfs_path_from_node_locked(struct kernfs_node *kn_to,
 {
 	struct kernfs_node *kn, *common;
 	const char parent_str[] = "/..";
-	size_t depth_from, depth_to, len = 0;
+	size_t depth_from, len = 0, end, pos, room, n;
+	bool wrapped = false;
+	const char *name;
 	ssize_t copied;
-	int i, j;
+	int i;
+
+	if (!buflen)
+		return -E2BIG;
 
 	if (!kn_to)
 		return strscpy(buf, "(null)", buflen);
@@ -147,7 +160,6 @@ static int kernfs_path_from_node_locked(struct kernfs_node *kn_to,
 	if (WARN_ON(!common))
 		return -EINVAL;
 
-	depth_to = kernfs_depth(common, kn_to);
 	depth_from = kernfs_depth(common, kn_from);
 
 	buf[0] = '\0';
@@ -159,18 +171,43 @@ static int kernfs_path_from_node_locked(struct kernfs_node *kn_to,
 		len += copied;
 	}
 
-	/* Calculate how many bytes we need for the rest */
-	for (i = depth_to - 1; i >= 0; i--) {
-		const char *name;
-
-		for (kn = kn_to, j = 0; j < i; j++)
-			kn = rcu_dereference(kn->__parent);
-
+	/*
+	 * We can only walk towards the root. Fill from the end and wrap
+	 * so that if the path is too long we keep its first bytes.
+	 */
+	end = buflen - 1;
+	room = end - len;
+	if (!room)
+		return len;
+
+	pos = end;
+	buf[end] = '\0';
+	for (kn = kn_to; kn != common; kn = rcu_dereference(kn->__parent)) {
 		name = rcu_dereference(kn->name);
-		len += scnprintf(buf + len, buflen - len, "/%s", name);
+		n = min(strlen(name), room - 1);
+		if (n + 1 > pos - len) {
+			size_t head = pos - len;
+
+			memcpy(buf + len, name + n - head, head);
+			n -= head;
+			pos = end;
+			wrapped = true;
+		}
+		pos -= n;
+		memcpy(buf + pos, name, n);
+		buf[--pos] = '/';
+	}
+
+	if (wrapped) {
+		/* Rotate the two pieces into path order. */
+		kernfs_reverse_path(buf + len, pos - len);
+		kernfs_reverse_path(buf + pos, end - pos);
+		kernfs_reverse_path(buf + len, room);
+		return end;
 	}
 
-	return len;
+	memmove(buf + len, buf + pos, end - pos + 1);
+	return len + (end - pos);
 }
 
 /**

base-commit: a42ae51fe3c36cef82dc687ea594ca232a785fd4
-- 
2.54.0

