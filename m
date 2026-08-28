Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E908D3C13FE
	for <cgroups@vger.kernel.org>; Fri, 28 Aug 2026 05:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787894942; cv=pass; b=oc2UhQdKkbX977QK/0Hppkz+S2VEY5TfLxX1fkGGenUx5BmQoChacMNsV8ucbDqOj7FyoPuvgfMXrx4MnT021UcVKj4s/2cJ54/rywM5l6KVHgFNGlvjghlQ55tcI5jpI8NOUMoBlVcPJxksWD48s/aJOkN07DM/haio+x1RwBU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787894942; c=relaxed/simple;
	bh=LRm7TUFzAteKTAYdlVpNqQ8w/29QsDN1CRtyvuAjdxI=;
	h=From:MIME-Version:Date:Message-ID:Subject:To:Cc:Content-Type; b=M74Hm3t/NqPaaaIfIFUc+Jm/HOdHhIKcUNUzatWgtu078bTA6nfBhIpdbcVjm053pCMYMgi6M89LXkErPVlPq5WcXHDQ49GE03y/HsxDCwhap7Jnnug2EU7iUwiQSV5kg0hi1KTWJI8sWPmCLeuiC3YNExSiX+SmpdInPG/ZQdw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu; spf=pass smtp.mailfrom=berkeley.edu; dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b=MxTcO3bf; arc=pass smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b="MxTcO3bf"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2d6d28aa26cso4831315ad.2
        for <cgroups@vger.kernel.org>; Thu, 27 Aug 2026 22:29:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787894940; cv=none;
        d=google.com; s=arc-20260327;
        b=fkdlf0It2HwsQNnIBn7ELVRR4qzghz81U4UWsSa06S2CwEVmxV0Tp7+lm6UdMf5G0u
         rpHthu2NsyuLvSB6+daQFNVMyZWneKz77/T9JiqtvFWaWN2q5HrmeorqMKJC7/6rYmIS
         S7KlQULIuz9E3pfXVRLTzawcX0r3i0Qwl+O3Ixc7Hy0hAucRcAqMXRTMFsZzp5zJKTrW
         i7eGCCJm/0xIYaggtz1EKmOhPtP5rMj2cMQkja/l5ohJxvOaRcY8yWcNMm6/JZ2tvrkp
         xmiVb2cMfKE+y84XZYZqAmn/ytaO889NC7ml3+h01dM2jiRffL4X8UMEvwYYPG0MXkWK
         Xoxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=323/e/RaqA8mIXEHSxzv2u3juG8I1v9sZLdgI4Di9tk=;
        fh=0KC15UEv0BmutnQNX3kzIylujadetIHQdDOsIheWYHc=;
        b=O2bZS2UR0cnnVLnN9Cbms4wJ8idywBrhg0kxBIHZFZP2iutxCGl1jeDHtAk+qAqC9I
         K350jK2XfHKuiiL5y8HTNLFu/xfdbjblOFED9eCr7mwPBfr5qOLJjA4Q75VCVQmBsxO6
         30dBghDO1j20EwTqqJDJ3/L1ZJdfyPTmZmueUhm5BFqGy9GXUg4pBWsD0XRR0NPZoEWu
         4//eu946xUKfhMP+2bfc4RhEcMxVOt/VpW//DZfSp76tDTwbqea2OLy36nQ6U+mjxKsn
         xIFeFSBF95N56uYQymb96v7pOjaA07qZXb3AB+LXv7RA2bJkBY4VqinRg4SY0BYAuHec
         YqKA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1787894940; x=1788499740; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=323/e/RaqA8mIXEHSxzv2u3juG8I1v9sZLdgI4Di9tk=;
        b=MxTcO3bf3r4Yq3Tk5c8RkNp50QBpvHAFfSbw6V/dEZDaRtQcOGBLaU1q94cBhSdX9e
         XJZtYnYY+73akDgQ8+TTUCr8rY5wPZRjXWFADZ8q8OxM2Z2OJtI1vgGHmg+dbhfRn+Pf
         NnJsMkG0KNB2QQsLHC40FyQBLxNq3rnI/O6FD666BmUluz7Bdz3bQnCYAp4/JHuSrV81
         wtQc2pMtPj77Dygm/FDlPaAdXBPXNtYrKkUem4+PY5I056+0Cf3fYXhyPJZC44lLtsET
         6nbbTz2xJQfgzpyfVrZ2weRu0PNDDhbNb4yUCRFix9sEghxrdtVVC18YGxK+5IYKB6kO
         vyUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787894940; x=1788499740;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=323/e/RaqA8mIXEHSxzv2u3juG8I1v9sZLdgI4Di9tk=;
        b=ew7/MbtPHXTebEAP+t43nT406RungOodG6GwFKpybbOlZKlV0olxlWuUc1Km4dFOJq
         HzB43qTHOAK10r1C3JxaEEsCISfJpgnWVfyNx4ueAwrvLTwd4lGtsxEmrISzWjBuVjpo
         jTX2bUTlj6O4Gsqzy38wMKHpjRsyvtUNruXhBulVGKPBLPaW4wppBAhco1M/wPt7dyHv
         Sfz8kF+EXTgsG1I+Yx7zgzTT1C9bEBPNYHRvw39CveChLhi65fR42lu0KFNS3q5TsbPx
         h9mgZ7cinnQV31IBNAj8KsPpXQmQK0+vqozbyhv890Ppn6ytVKT6YpPdG3B5IVesyo5j
         BPwQ==
X-Forwarded-Encrypted: i=1; AHgh+RqieLuPE6kA6lw62JH3rTmm8JeNI8yyk7SpU4wnuBdOJU/rgVA0muN1PjLp1zbWTuOaMatHXkNu@vger.kernel.org
X-Gm-Message-State: AFuF++lRLOfFJnS+6W2uZdX24x9hu0/uPNnnMGegfEqvF2Z1qv/CSAla
	59WlP3lL2BC28HgScjVqO0POU7/cb0Q71TGoJkminLYeWL6TIJf2z+o5hlKO8iDybhimn8OeAR4
	OHtPCdymcFXiJ6Vx4stQoRy3fWnW36oZVJtsRqFMC
X-Gm-Gg: AR+sD132ikBdKVpRvy9e1X2+jGbZLKoL1ebFSwSSubQeOAUCVbQNjjMue53mds98Z5G
	t9PLcUkV+nBDYZyDyuUPp0S904yKiEjnbB8tlc1RqNkd6tdGj3i2U06XI3Vtem4mKVBi6dvwi9H
	f/NbIpBEeu+VvI4E08SQE2kX+FqFnukrj1dIfkWFEapRhNThjIO8pcAjJpp7UUfoyxZjyXxchAe
	ySSl7iitZRFq02LmozJ8xUhSFZsmUKnxJ70DQMyE+6+332svMm22KSmv81bOPww8YSZjyWCDJiS
	Uazy3Eq9KTglKLPDQAB98M2lP7Ggi+rYgjeLiXcshkvT2Yj1Zv9SLBHeKR8Fu8lFAoH90HYUGbp
	+wow+JXbCypkWCYWADJji/0/wiR3h+rrc3Eh3e4HHQ0w=
X-Received: by 2002:a17:903:324c:b0:2c2:62ee:5a0d with SMTP id
 d9443c01a7336-2d74df1c634mr88380135ad.14.1787894939423; Thu, 27 Aug 2026
 22:28:59 -0700 (PDT)
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 27 Aug 2026 22:28:57 -0700
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 27 Aug 2026 22:28:57 -0700
From: Farhad Alemi <farhad.alemi@berkeley.edu>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 27 Aug 2026 22:28:57 -0700
X-Gm-Features: AcwNN1UlzyJTQI4xLeKZfZmMD9WMPAJkGc0arO9zP77WjK-dTinfNX0jJqWgP4Q
Message-ID: <CA+0ovCgWzUMK+nNbbtH7eV65Ca=fDN4Ozu7iASgryjvv8Tk8zQ@mail.gmail.com>
Subject: [BUG] refill_stock -- VM_WARN_ON_ONCE(mem_cgroup_is_root()) from a
 write to the cgroup-v2 root's memory.reclaim
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: falemi@asu.edu, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

As part of the kernel research at ASU's SEFCOM
lab, we hit the crash below. Crash reports can be found here:

  https://github.com/farhad-alemi/public_bug_reports/tree/main/145-memcg-vm_warn-refill_stock-root-cgroup/

  mem_cgroup_is_root(memcg)
  WARNING: mm/memcontrol.c:2198 at refill_stock+0x644/0x940, CPU#1: repro/9490
  Call Trace:
   refill_stock+0x644/0x940
   try_charge_memcg+0x12d6/0x1570
   __obj_cgroup_charge+0x35/0xf0
   obj_cgroup_charge+0x1de/0x210
   obj_cgroup_charge_zswap+0x83/0x270
   zswap_store+0x1620/0x2000
   swap_writeout+0x94c/0x14c0
   shrink_folio_list+0x3388/0x52b0
   evict_folios+0x374d/0x48c0
   try_to_shrink_lruvec+0xe72/0x1350
   shrink_node+0x3320/0x3b90
   do_try_to_free_pages+0x6a2/0x1990
   try_to_free_mem_cgroup_pages+0x30d/0x830
   user_proactive_reclaim+0x504/0x840
   memory_reclaim+0x1f/0x30
   cgroup_file_write+0x331/0x8f0
   kernfs_fop_write_iter+0x3af/0x540

Our reproducer.c is available upon request.

Happy to test a patch if that would help.

Regards,
