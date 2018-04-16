From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET v2] mm, memcontrol: Implement memory.swap.events
Date: Mon, 16 Apr 2018 16:09:01 -0700
Message-ID: <20180416230901.GG1911913@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=BL/R1qBkME5gCbo4+P/qCu6VQ02dHMRRSC9jo+WJj+g=;
        b=bEBa4Bw/LwVSpGQIdJo4KhrUylTALenPf6EDhKckVB47goitavbyoHcT4LtN2uLaQ7
         SMCg8SZzROf6WlC4KYkJcgRNczfQQ0lfTs+CKRWAAa1Sqq63UKg981WwJfjyzpzSY8F8
         pTBd3/XtSDoe3PWwOir9MW2iliEgI5Y72FroJDfCipPGBlfVSUaudR+2UM1xW1H0H+XQ
         ez8F5akqLq8kGChzCdFfl+wGtsjKjMzo+8VsMq7nyYYA4XQH385/kl96i1QUYwe9FPPu
         9JacWJYU6mpTn5CKzHHa5rGOcmaIXpxiVFtqUBmqVMni12sRJSyyb9fRXDEuXzuZIxG+
         5kbw==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com
Cc: guro@fb.com, riel@surriel.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org, linux-mm@kvack.org

Hello,

Rebased on top of e27be240df53 ("mm: memcg: make sure memory.events is
uptodate when waking pollers").

This patchset implements memory.swap.events which contains max and
fail events so that userland can monitor and respond to swap running
out.  It contains the following two patches.

 0001-mm-memcontrol-Move-swap-charge-handling-into-get_swa.patch
 0002-mm-memcontrol-Implement-memory.swap.events.patch

This patchset is on top of the current linus#master
(a27fc14219f2e3c4a46ba9177b04d9b52c875532).

Thanks.

-- 
tejun
