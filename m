Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AF0390C84
	for <cgroups@vger.kernel.org>; Sun, 14 Jun 2026 13:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781443561; cv=pass; b=CU9BkjvRzfxE6oD2JNjlWm5gfSQMU2lYlbyFKNqDyYqnGd8UwIp66SU2Eg61jxiRKF9QvAFN2Kq7exluVR+GXxnjhmIMx9FvnuJXG0ZCCqVQ1Dbgvn7erA8mrR7DeI3qlKVjyUd7dsBMmDxPLF9c3qDdoUx4JJhI54N7IHxgl1E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781443561; c=relaxed/simple;
	bh=8a8z9o8uhQwn072Nwdwrsu8F50f0ae0l8EpJfnSe8Zs=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ig4ivp7wc/suYqmj3+ObkCu7UYCqdeenFe6JZBrG1jeaiOgYYaU3tpvJNAGVFijAT3v1gte9K3TRibIV9Tvg5NcnZmFmSYhAlxjhvUnu7jURx5DkCLitUqbSNdZBufMcl0GH09PLhVKJ0nSdReBASTUrUl8FHBsdR0R1+2ffwh4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu; spf=pass smtp.mailfrom=berkeley.edu; dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b=s3ZdgQ0j; arc=pass smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b="s3ZdgQ0j"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-7e1916922b9so26214017b3.1
        for <cgroups@vger.kernel.org>; Sun, 14 Jun 2026 06:25:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781443557; cv=none;
        d=google.com; s=arc-20240605;
        b=OD8XfHGkIwFpBP4Yx5A6cH/gUQhYReTkP8hbBp7K/3K/O4gUbGrJFKqVUb5gEomPc6
         OG4jgzhrL1QC2FDi8qx52R6YITxfP2DrEInqyW3eBy4vkAMIsZfj3/8ex0qMHWmh3w2q
         KX+cGYerjd/EoPlp8qosZysA/GioNSXjl+z8eaaKVveCYSz946jGdY9Xl93K0dhkJCGX
         omWsRnxMxPOpvgMuVsHFfFv5RV+oBYBzirCaOayUdhu0uUGnuXVBDAIA9ZIhXMNVVTsv
         xwY16mq7Z5RIQ/uGIBqVJOVpoohXMDNnMRZBw6QP6nwjYuhX4r2/HKIXPG0oSqhRjwsb
         xLbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=my7WznhvuaINq07i0eln+93EnzFiKa95Z+VUna30ulc=;
        fh=NNmFGhn8sABE8vRv6eA71kLTHbkXS1ZBq5/mbohCMHg=;
        b=HF6PkV8OzMTsMkulOp5JBQ53Nrp4HscGkii/L0JpHmdb2Tj98ickbDOqEFC0iYHgpm
         KdlAdGCz+N2EWIFS2BD25syqTkk2OeV24IgdIFEex2jQC+uWdcLjfg7czPidxvGpD/Di
         9qyiTp/wQ5zCBwUwTtw9Ls4GRLObIW1HOPljIIet3BWUUBGU/MMjUwsOvjDiICZQWhOW
         ga6njrwlTOhIFdXhA0VGoGnWPOSNIxw++AKgGC0U/ysiPTclgiliwjTJlGKhJmjCsGyE
         NBjGKTC9OfoSUwJ3C910bO8dgEk2/E8E2NdCJOHDBfbfYoJpBG7EIES0hXbz0N+ZkGwt
         O3pQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1781443557; x=1782048357; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=my7WznhvuaINq07i0eln+93EnzFiKa95Z+VUna30ulc=;
        b=s3ZdgQ0j6wdDyJK+1d22+jBZLt2LhR2Mi8jqPQ3z/isAwctf3ViXA56e3N8khKKhww
         vmnVZeVAW1wDeL+KZtU2URDcwHYxTdvDKj7dQAg2rIz9I+oy4ubfKlsNI32QZ+LDw4Oe
         qW7GQAFqe+cJvP/0VHfPgrO58FSi8UglgtTFX9H9cSpSqkzpIwpgD4WzFLBDKHVkuTAe
         bKPdX19pyf2uEXOILG62k3EUQwNZ+3JbH4EA72HLdrw6dba8fYV0Vaemkuy56hwM0oWI
         FG1mbyrtkMB8CbtPKlmsvp7y845jcXXgqpVuTaB9qMLiIVdu5T9KBNz8Tat5V81a9/KG
         LwOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781443557; x=1782048357;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=my7WznhvuaINq07i0eln+93EnzFiKa95Z+VUna30ulc=;
        b=W7eA4UsiUmWFHVMr+Vz4jySyF8kJ/w1cYLfO4KRzrKW7TlVjgs6rS30CkU69fnInfH
         ocwywMrFTBpUc8qZgbCHKlhSU+9hPx1TI3cfGmUdd3KAXuzqcffUbmMK98UmyRfrhqaf
         5BSp9mgc2BMO5FIbtTeZ9w/Pr7FHdleLlvC/j4K3bG8HrlNcy0sXtBkC3UjFGli6iOlB
         MjT/5he/2fDEOLdNY6JKFoRhX83UYi83vLuR57+/LeufNtndDuwfdND6ML1DPsy3/wJe
         E1Ye/MGEIxgycSb7eq/IYJwhbP7Lql0HYDazjrIFXTve5kP62nFVKSRP7XdDv6gZMbZf
         7Dqw==
X-Forwarded-Encrypted: i=1; AFNElJ/n2x8jORgiJpY9+fbELVObMmoH2C5lHTyZagLmXGsRfTl8y7Hxmet6T2ESPepMq+XsPfrqW/5o@vger.kernel.org
X-Gm-Message-State: AOJu0YwCHn6uEudJLRhLlmTL2Dek6bh5IzGKL0FqILPmvIO0ZlGRUb1H
	silYw+Ixr+x4bpsVHaC6ID+xZpu9BfdvPTDWRu2WBfdSJRSxInXhb37NYtUuT+jq2Rcj1fnTaa1
	awSUqC1AM5jxXoSsNhefg+Lwm0j9l6HgHpe+cOfY2
X-Gm-Gg: Acq92OEpqD44pFbA0tp3qFzKDOTK/n1FU1HZ4DtAXdrJealDMn70TWalw9bDpKTikuK
	gxmEA3jTOau16xSS6XX6zhPr/Qvyh441CW7/FsbNcXWtvrtw+7enFdMFOqxQUwC/skwqK2WVCjS
	GXrcBk1hqRl9jxuWS8EpAOhSEZEfTju5K4Nfr1ntjTlZz/Y9IcXK+UddhPw7gzAYgaXzaXwdQ3d
	CNjvogPg1wLMND0047Bs8M+otNSIvb0+NL69Ol5T18qIAuGo81C16EPLAyKtvaU2apBQd1BVPrR
	Gg9mI4IAlQ==
X-Received: by 2002:a05:690c:3745:b0:7e2:a956:4083 with SMTP id
 00721157ae682-7f8c1f15742mr70603597b3.20.1781443555816; Sun, 14 Jun 2026
 06:25:55 -0700 (PDT)
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 14 Jun 2026 06:25:55 -0700
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 14 Jun 2026 06:25:55 -0700
From: Farhad Alemi <farhad.alemi@berkeley.edu>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CA+0ovCg05rUk1-3k2ysdxmbcER8aG-wVh9SSTrrbp6LPWpPHYA@mail.gmail.com>
References: <CA+0ovCg05rUk1-3k2ysdxmbcER8aG-wVh9SSTrrbp6LPWpPHYA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sun, 14 Jun 2026 06:25:55 -0700
X-Gm-Features: AVVi8CdOyddTc0VCwydJ03Yt1oOOOGpiCzbsY_HpVqvtkDz1Xj3Bl7yujHIBV_M
Message-ID: <CA+0ovCgfHJHv5d1mzapWWvF-LhjppzDX8NPPLvCPZxPKg8RiYw@mail.gmail.com>
Subject: [PATCH v2] cgroup/cpuset: rebind mm mempolicy to effective_mems, not mems_allowed
To: Andrew Morton <akpm@linux-foundation.org>, Waiman Long <longman@redhat.com>
Cc: Farhad Alemi <falemi@asu.edu>, David Hildenbrand <david@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Yury Norov <ynorov@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Rakie Kim <rakie.kim@sk.com>, 
	Byungchul Park <byungchul@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Creating a child cpuset where cpuset.mems is never set leads to a div/0
when a VMA mempolicy with MPOL_F_RELATIVE_NODES rebinds in response to a
CPU hotplug event.

Reproduction steps:
 1) Create a cgroup w/ cpuset controls (do not set cpuset.mems)
 2) Move the task into the child cpuset
 3) Create a VMA mempolicy for that task with MPOL_F_RELATIVE_NODES
 4) unplug and hotplug a cpu
      echo 0 > /sys/devices/system/cpu/cpu1/online
      echo 1 > /sys/devices/system/cpu/cpu1/online
 5) mempolicy rebind does a div/0 in mpol_relative_nodemask on the
    call to __nodes_fold()

The cpuset code passes (cs->mems_allowed) which is not guaranteed to have
nodes to the rebind routine.  Use cs->effective_mems instead, which is
guaranteed to have a non-empty nodemask.

Link: https://lore.kernel.org/linux-mm/CA+0ovCgxbZkXa+OU8w3s84R3KNPNxxRfmsNR-udh+afQBbGNmw@mail.gmail.com/
Link: https://lore.kernel.org/all/CA+0ovCiEz6SP_sn3kN4Tb+_oC=eHMXy_Ffj=usV3wREdQrUtww@mail.gmail.com/
Fixes: ae1c802382f7 ("cpuset: apply cs->effective_{cpus,mems}")
Suggested-by: Gregory Price <gourry@gourry.net>
Suggested-by: Waiman Long <longman@redhat.com>
Signed-off-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Cc: stable@vger.kernel.org
---
v2: rebind to cs->effective_mems instead of newmems (Waiman Long);
    condense the changelog.

 kernel/cgroup/cpuset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2649,7 +2649,7 @@ void cpuset_update_tasks_nodemask(struct cpuset *cs)

 		migrate = is_memory_migrate(cs);

-		mpol_rebind_mm(mm, &cs->mems_allowed);
+		mpol_rebind_mm(mm, &cs->effective_mems);
 		if (migrate)
 			cpuset_migrate_mm(mm, &cs->old_mems_allowed, &newmems);
 		else
-- 
2.43.0
