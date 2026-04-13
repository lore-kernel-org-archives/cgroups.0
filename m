Received: from out203-205-221-205.mail.qq.com (out203-205-221-205.mail.qq.com [203.205.221.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82EC175A70;
	Mon, 13 Apr 2026 02:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776048287; cv=none; b=eiKBzLYLohGpJwWaTPX+i8SRtvnUVer91fIIRWA+xKipWN60hdFwYDN4Ez/RjsxTDKswF9bNCh0bJXq83AGLVzeRwRKcQLNalSsAmAlhUWAqpCUePY/o+lEB3ybThwnidJvdvxxinEGdhRjTrYyg99cCwtmythVtk90H/wLX4sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776048287; c=relaxed/simple;
	bh=VfgCwLV9406GeSHdbzm1Ngk2vVnPMvG5t+qXLDXbfVI=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=bHh0qNxG12hBTltIFq0ZJcfRaR2/AI6hlnCO5FHQBRG7RvQvVhnfKJWRPfmn+hyLRzzSZcNrGRRn9iRyTjgqI/ST2SCWE1rE4ZzQKV+I4HGkGLzHFG47U/uV9+atKiy+C2Sqjs+IOZuSTD9jsLKHObDj8WVsCiJDoCpp3OW7oVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=V98NKjGo; arc=none smtp.client-ip=203.205.221.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="V98NKjGo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1776048276; bh=IpoN/ELIJuBsWrlJXaVbpe5t/pMjS6H39BihjubPsfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V98NKjGo0QzHxGavh3DsFMIon9XYyXC/ZuGWeSlZWyzaxDezUay+TR6E4bWIR4S2R
	 fsFYTU3z1UwTXir0Mjb7KP+6IPG/1PoAoGrzW5CnklKbMNFroWJi/A+o2/nXHIv7rf
	 F3Fxi317+ma7Aw509rogBRpXl+7ctjklruRG7g1E=
Received: from lxu-ped-host.. ([111.198.231.89])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id B21346D1; Mon, 13 Apr 2026 10:44:33 +0800
X-QQ-mid: xmsmtpt1776048273t8mecrpcu
Message-ID: <tencent_47844C97747762E6DA1374E37BA96283A205@qq.com>
X-QQ-XMAILINFO: MDbayGdXPuoefdIwixpdWiHS8YehtIGpqoiulEGAO7TXPdbl/VOPaMBNr7r4C+
	 xbGKR4HdAazf63O/W6e39wwIbeJjrlWxsfcuFun+7e8pWen2vnTutzxLjFXb/w1FTuAJeBB2xkiQ
	 +oYoBNVkmONKNevz+bJ5b8Qt7fSvnlO1d99K9eCBol2Wjyec3GKB1dbJvgonFStg3hh3BZA1/MPf
	 Dy+gnJ789CR8vGH5tOW2XINEZAAfws/DKyeSUWdVkRwSPtqzhNFrnQmif8qKoDH7j2XCEv3XoQTX
	 tfcOQCdfTw575t9L1CUNC0jHwtIjp2vbcFe+x/Flnj1LeLLDTW2YzF+YcKlfCZVhDoS+kzqMgbpt
	 2yfBwPW2B7bPT+lvhPMZGggTEs+jCxQRz6MeB3wEuMii0Mdwf8dJ5EkKZAhFKteN2VU8OcogD/up
	 Pb6iuT58+ylF8CjJFpIM1dpfu109fh7wl4sLzlMtJD850wHqqEwohM97GePD8NPyVKagbkOkIILR
	 hcDJ1Tpnj8KmmbDViKTFfqJVDPcAS/K73+tarmHEZBTtVuszKnRYfgn8PiGZezs/GPI28rAiH0Hn
	 RjBfnipuPROAPGVvrOsi4sckFXhzM7lb/rHrD7TQ45ldQuZ4NB32TbY9zwY3gplTpG+ssAyYbLj/
	 2iKFTCijy9dm3bj/h2AwRGLo1QTcGyZDPpbAZ0Hxbi/LVaQKggsvXZ8E9XFkBNjCPVqLRzPJX5sD
	 5RCOyvv+aXl7KRkRgFVOItCSgoBGtf2SJVnWIpis572LJATDPYEj5z8w7JE7v9ztOTAKAeZCA/lE
	 eIrFKpMo6vqwSOkQdkgQ1cZFQeVraokKCutuBqOlByXmczBzMVIoVQf7Eb74Zz8VlRS5yYtr2Jq0
	 Ugv8rQNAt+8ooHWMXmR5BPX2M99e210FJ6Aqj4K8yPvFG5K28dXDQPhrSEfTjL7+v8jST0TKYp5Z
	 DwiLW8CNRFKkIFGh8jCU1TTv+XX0Kh8jVINnI0F8oL2Kd8j06enLftO46BgpuOaJjYk59bwKwDFk
	 5cEizJhsgWe611hMylE98Tt29wIF4EvzdgMO8Ajq03RPwGoWlY/A5KDvoT3giVjq82c/GChw==
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
From: Edward Adam Davis <eadavis@qq.com>
To: eadavis@qq.com
Cc: cgroups@vger.kernel.org,
	chenridong@huaweicloud.com,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	mkoutny@suse.com,
	syzbot+33e571025d88efd1312c@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com,
	tj@kernel.org
Subject: [PATCH v4] sched/psi: fix race between file release and pressure write
Date: Mon, 13 Apr 2026 10:44:33 +0800
X-OQ-MSGID: <20260413024432.222521-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <tencent_71D4D2F5C6460999EEE5AEC14C8767C74606@qq.com>
References: <tencent_71D4D2F5C6460999EEE5AEC14C8767C74606@qq.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A potential race condition exists between pressure write and cgroup file
release regarding the priv member of struct kernfs_open_file, which
triggers the uaf reported in [1].

Consider the following scenario involving execution on two separate CPUs:

   CPU0					CPU1
   ====					====
					vfs_rmdir()
					kernfs_iop_rmdir()
					cgroup_rmdir()
					cgroup_kn_lock_live()
					cgroup_destroy_locked()
					cgroup_addrm_files()
					cgroup_rm_file()
					kernfs_remove_by_name()
					kernfs_remove_by_name_ns()
 vfs_write()				__kernfs_remove()
 new_sync_write()			kernfs_drain()
 kernfs_fop_write_iter()		kernfs_drain_open_files()
 cgroup_file_write()			kernfs_release_file()
 pressure_write()			cgroup_file_release()
 ctx = of->priv;
					kfree(ctx);
 					of->priv = NULL;
					cgroup_kn_unlock()
 cgroup_kn_lock_live()
 cgroup_get(cgrp)
 cgroup_kn_unlock()
 if (ctx->psi.trigger)  // here, trigger uaf for ctx, that is of->priv

The cgroup_rmdir() is protected by the cgroup_mutex, it also safeguards
the memory deallocation of of->priv performed within cgroup_file_release().
However, the operations involving of->priv executed within pressure_write()
are not entirely covered by the protection of cgroup_mutex. Consequently,
if the code in pressure_write(), specifically the section handling the
ctx variable executes after cgroup_file_release() has completed, a uaf
vulnerability involving of->priv is triggered.

Therefore, the issue can be resolved by extending the scope of the
cgroup_mutex lock within pressure_write() to encompass all code paths
involving of->priv, thereby properly synchronizing the race condition
occurring between cgroup_file_release() and pressure_write().

And, if an active kn lock can be successfully acquired while executing
the pressure write operation, it indicates that the cgroup deletion
process has not yet reached its final stage; consequently, the priv
pointer within open_file cannot be NULL. Therefore, the operation to
retrieve the ctx value must be moved to a point *after* the active kn
lock has been successfully acquired.

Now that the scope of the cgroup_mutex has been expanded, the original
explicit cgroup_get/put operations are no longer necessary, this is
because acquiring/releasing the live kn lock inherently executes a
cgroup get/put operation. 

[1]
BUG: KASAN: slab-use-after-free in pressure_write+0xa4/0x210 kernel/cgroup/cgroup.c:4011
Call Trace:
 pressure_write+0xa4/0x210 kernel/cgroup/cgroup.c:4011
 cgroup_file_write+0x36f/0x790 kernel/cgroup/cgroup.c:4311
 kernfs_fop_write_iter+0x3b0/0x540 fs/kernfs/file.c:352

Allocated by task 9352:
 cgroup_file_open+0x90/0x3a0 kernel/cgroup/cgroup.c:4256
 kernfs_fop_open+0x9eb/0xcb0 fs/kernfs/file.c:724
 do_dentry_open+0x83d/0x13e0 fs/open.c:949

Freed by task 9353:
 cgroup_file_release+0xd6/0x100 kernel/cgroup/cgroup.c:4283
 kernfs_release_file fs/kernfs/file.c:764 [inline]
 kernfs_drain_open_files+0x392/0x720 fs/kernfs/file.c:834
 kernfs_drain+0x470/0x600 fs/kernfs/dir.c:525

Fixes: 0e94682b73bf ("psi: introduce psi monitor")
Reported-by: syzbot+33e571025d88efd1312c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=33e571025d88efd1312c
Tested-by: syzbot+33e571025d88efd1312c@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
v1 -> v2: refactor unlock and update comments
v2 -> v3: remove check for !ctx and update comments
v3 -> v4: remove orig get/put for get cgroup refcnt and update comments

 kernel/cgroup/cgroup.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 4ca3cb993da2..c94a16352c33 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3995,33 +3995,38 @@ static int cgroup_cpu_pressure_show(struct seq_file *seq, void *v)
 static ssize_t pressure_write(struct kernfs_open_file *of, char *buf,
 			      size_t nbytes, enum psi_res res)
 {
-	struct cgroup_file_ctx *ctx = of->priv;
+	struct cgroup_file_ctx *ctx;
 	struct psi_trigger *new;
 	struct cgroup *cgrp;
 	struct psi_group *psi;
+	ssize_t ret = 0;
 
 	cgrp = cgroup_kn_lock_live(of->kn, false);
 	if (!cgrp)
 		return -ENODEV;
 
-	cgroup_get(cgrp);
-	cgroup_kn_unlock(of->kn);
+	/* of->priv can not be NULL, because cgroup is CSS_ONLINE */
+	ctx = of->priv;
 
 	/* Allow only one trigger per file descriptor */
 	if (ctx->psi.trigger) {
-		cgroup_put(cgrp);
-		return -EBUSY;
+		ret = -EBUSY;
+		goto out_unlock;
 	}
 
 	psi = cgroup_psi(cgrp);
 	new = psi_trigger_create(psi, buf, res, of->file, of);
 	if (IS_ERR(new)) {
-		cgroup_put(cgrp);
-		return PTR_ERR(new);
+		ret = PTR_ERR(new);
+		goto out_unlock;
 	}
 
 	smp_store_release(&ctx->psi.trigger, new);
-	cgroup_put(cgrp);
+
+out_unlock:
+	cgroup_kn_unlock(of->kn);
+	if (ret)
+		return ret;
 
 	return nbytes;
 }
-- 
2.43.0

