Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792643990;
	b=Zms9IhV1qBMWQyKCVInlIylHTf7FZ/2r1W515EM347hqVbuf+DxMLq35YxTDYsmqbWcT
	 h9Oa0786G2O31KdkcoRb+AMIWX9H4YgIq+jTp2C85KWPmAQalg3DWKIT9s1SvPlgav2p0
	 I1kAn8LYxCDlQtgkHGfcsYY6O7nI2npkUKO1BJPFvg/rluaK2h05T29zRaBz+m2ZM1391
	 0IrBJJwI7F3+ZM1EtMJSi0Twa3pYS6LSPZ/MGm9n6CZiSbGJ+c9dswqcJlBxo/6ZjsQaK
	 cs4JxctvqIC6jeW76WsFk5DhSqIuxgpbM3R+8+7In7mmSH940aroGq3g8ceDGT0zfdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792643990;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=w4GGR4RrI+WpSu23nEixIdxqCGs3LYn4cbTByEwGCuA=;
	b=l1JicsbBtxU92v2hZDhnf36lvLfnptP5biAM3XS8YIk7NMRfD37ZZM8TN4QDiuPdvFdi
	 bKIUPcbcR9D69BE/Qba6u8cgqcYZBxAgqcWiruydCldz7FFn7eMFdxppccJ0UMgjJ4C24
	 Soedn0QLgRUt79ip1023VDHwLaRsDXtN33/Rqjg8peAkCxjG5GZ1Z2/HSJMly5SaYmeUQ
	 zRd1b4USUCJe/hhDvtT319kMlmKESV1IkcSnC+2SGUisMkPoGOyUTAG+dgQGHqJx8ydSu
	 k06AzwKwhcFlbaK09//hpl9E2oIvXe7aSPZ1Q5gaOGyHaXvhJfwgw+ovZcXHpRfS2hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b="CEGZ/Rqn";
	arc=none smtp.remote-ip=209.85.219.41
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C626D606A31A
	for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 04:39:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C626D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=CEGZ/Rqn
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-91beb36fcc6so10929056d6.1
        for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 21:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792643989; x=1793248789; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=w4GGR4RrI+WpSu23nEixIdxqCGs3LYn4cbTByEwGCuA=;
        b=CEGZ/RqnDCh/Cjrx7zrC8NcjDbFgpF/Hc18KhdRGn25giAXeGbKq4J9Z397XrpKcq/
         RkduEHQZYkAZxRoG6j0+crPE865xnwo6nDdRcXBiXUsJfvc10kEGPgOZXI14KBU0Aw7E
         jaLLpivDmxNyt9t3ZwoMvUUudDFeUigP7K+i34cf2IVlQp6msRIwfuZrO8/3df4fQWqb
         uvAhBdjTWvLkM+lq653jXRkl2jwhgPmTXN6A9WtSgByHLrYh8rxBu9ein/cz1PQyH4gL
         +KL0zrPREQMrc+wX8vCnR4rmRVI4okX0/0M5F/NuN/kzPCcYaeff8gXC8TqYmOtxUD7e
         29yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792643989; x=1793248789;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w4GGR4RrI+WpSu23nEixIdxqCGs3LYn4cbTByEwGCuA=;
        b=Ey6QejgF+hh5UQ+RbPL0DxQff4DpX6NHbAUe23JewlDe1NKCbqGGfwuKAHaDkdcTTq
         9PnYuMCgUsfRBmJxKxUSnakauuqClMjaSQRqXPHSBKp/YhFKR9g3giyNPXaN1s7LkAPU
         VJdqlGPPNE+P2+OqLHW5cpjF85KDZ27xiYZrtS2dDFrZ+8xkY01L1zedB3Q3VkaHroBS
         QjiXYJX0kSRrs9pQFIYHRzKNrzAs4q9SZcXfKbOM2nrgsboXFgSQO9SxPnPErIyj6MX7
         nHZezz+Yu10H7D82bp88/kUpLxxHqA6bpmOaOF2PJ98UAhJtVyECB5ciQpUtfOEnTNvU
         fo/A==
X-Gm-Message-State: AFq9FYLAvmbrOyO0AiFnPpKCzpeyBw9CkAgQzkuUUEKGvH0hihuVYsxq
	CXRamgqUiK1S+rvHOER7gBPgGr8Dd2PCSIBK4+DshL7uoxRZiR58TPLm23UXxgJj62s+I8Fpb4p
	hXY57
X-Gm-Gg: AYBFou3RilLQaN9mad0PeYzyB0FjNq77nidzqkl0ASOrev0H2D3LzI4x/iaZkYQKIrF
	ErTrEDD0HAIjdesVuYPht7CVtHYt3kNM+fHirgqDhae4DPbxb2UO2dd8rCgIExneDvoP2k4+8KS
	LHpYr6ePKEqDoXXIQGdMrxxHhZ8mfO0weu5q490YlWM1wo1XTprGkrzfayjmIdnV6dyG0E93Gps
	DJQalZJPQLI2WeczLUgh9CVKeluLNHMImrCNkzlz621+a0pG+jns135sj615q0aDLlczuLDa0VB
	vF3epkiuYOSxBbALYFK5F8XqInT/2nrxEsXqMJnICqpCjgcQQmtj6hZUhO9hcJUQtQoeMPS2VbX
	h1j6hQ5rsmUkbTo5rU2V13bm/pvl3ub1pt4zvPxNQcJM77wS9V8vNgEQXjMTQ0mBlqWoqVV18jw
	4BuBCx4T0xMZtikYI//YRoOqsrwnMQ2pWRIDZs/3o7lf7Za+UC/04YnFrq2RYP1nTrOrruuXVzN
	S+NQzjRTDXYgMa8UL1pOZ0Ss4G1YQ7+w9reTUtYI3kl1h5qRnSMyamBd55ufz6TYuhmfOjkmbWj
	vycVbd3WaIQCm0BqNlfWRgmDxI24WrhS6EYTDpoYa8zsd7Kl7oiOUX11JkIpQYU=
X-Received: by 2002:ad4:5745:0:b0:917:92c7:ce45 with SMTP id 6a1803df08f44-91c12f05914mr70612446d6.37.1792643988805;
        Wed, 21 Oct 2026 21:39:48 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c10b72c02sm42190176d6.11.2026.10.21.21.39.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 21:39:48 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	feng.79.tang@gmail.com,
	mhocko@suse.com
Subject: [PATCH] cgroup/cpuset: check effective mems for a movable-only configuration
Date: Thu, 22 Oct 2026 00:39:43 -0400
Message-ID: <20261022043943.3125239-1-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

check_insane_mems_config() warns and enables cpusets_insane_config_key
when a cpuset's tasks can allocate only from movable memory.

In cgroup v2 the request may name a memoryless node, which has no zones
and cpusets reports it as a movable-only nodemask.

For example, with node 2 a CPU-only node:

  # echo +cpuset > /sys/fs/cgroup/cgroup.subtree_control
  # mkdir /sys/fs/cgroup/test
  # echo 2 > /sys/fs/cgroup/test/cpuset.mems
  # cat /sys/fs/cgroup/test/cpuset.mems.effective
    0-1
  # dmesg
    Unsupported (movable nodes only) cpuset configuration detected (nmask=2)!

This is a bit confusing, especially consider mems.effective ends up with
a valid nodemask by-design (cpuset.mems is treated as-if it were empty).

Check each new effective mask in update_nodemasks_hier() instead, as the
hotplug path already does. The allocator's bail-out tests the task's
mems_allowed, which comes from the effective mask.

A request naming a movable-only not present in the parent's nodemask
no longer warns (since, again, the cpuset.mems gets overridden and
treated as empty). However, it will warn if the parent's mems include
the node later.

For Example, with node 3 a movable-only node:

  # echo 0 > /sys/fs/cgroup/test/cpuset.mems
  # echo 3 > /sys/fs/cgroup/test/child/cpuset.mems
  # cat /sys/fs/cgroup/test/child/cpuset.mems.effective
    0
  # dmesg
    { empty }
  # echo 0,3 > /sys/fs/cgroup/test/cpuset.mems
  # cat /sys/fs/cgroup/test/child/cpuset.mems.effective
    3
  # dmesg
    Unsupported (movable nodes only) cpuset configuration detected (nmask=3)!

Fixes: 8ca1b5a49885 ("mm/page_alloc: detect allocation forbidden by cpuset and bail out early")
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 kernel/cgroup/cpuset.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 8ee239d5c6b48..70fbece1b9399 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2795,6 +2795,8 @@ static void update_nodemasks_hier(struct cpuset *cs, nodemask_t *new_mems)
 			continue;
 		rcu_read_unlock();
 
+		check_insane_mems_config(new_mems);
+
 		spin_lock_irq(&callback_lock);
 		cp->effective_mems = *new_mems;
 		spin_unlock_irq(&callback_lock);
@@ -2848,8 +2850,6 @@ static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
 	if (retval < 0)
 		return retval;
 
-	check_insane_mems_config(&trialcs->mems_allowed);
-
 	spin_lock_irq(&callback_lock);
 	cs->mems_allowed = trialcs->mems_allowed;
 	spin_unlock_irq(&callback_lock);
-- 
2.53.0-Meta

