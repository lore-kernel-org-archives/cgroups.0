Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C23B23EA9B;
	Sun, 28 Jun 2026 06:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782627311; cv=none; b=tRTiRX1QtZ1EkfGcJtPoCXpAMjg9z7BzSynW9jUvOfK0NL510teSfa1bGVbKoIjrDJugEUC+mOtE0woKIpeAMT1W2SiPrnNKNAn+dgF7xdjVh1i5qUG3scR9VI23k0RpuBstJf8Rhh0jP4T06hn13BL1Qu7GqTpwH9b1rigYOCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782627311; c=relaxed/simple;
	bh=dAxgJ32TxadDNfSRf4uvpKQCSw2P3xHAndPT3XKTfWA=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=AHGYlHgT5A0kxo677aJeF00tSRz590syixQlDBobZyAx6rK5GRPgKHW5UXt2nWI4cObCiLb22WyduZ4vLj+SSerFdqRCyD70N5hr13PjK4nLCpUPFXau+CmVch2kGe6nVqIFaj4u0nVjqCb4xbMHVDSsYh4vT5lEyo2ICxdbFJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1vMfiFGz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1vMfiFGz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218AA1F00A3A;
	Sun, 28 Jun 2026 06:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782627309;
	bh=VkkL8K8aCSzDTAg0nFKvhBKMX/LzxqzMm81D3QZBmr4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=1vMfiFGzpFlK50ISLwhCIpnGS9/F4F53x4sETU7muK/IHh6I3XuS+U4DyKjnWFoWw
	 G5L9rq2Od82BJBKBztldCEdnToq6i7OQUPtbk2bm13prYOTs8FY0RjChRuso6mLVol
	 Tb25ONWZT0A7AxNY5UINAxc0zd+bXLCqvWtk9MM8=
Date: Sat, 27 Jun 2026 23:15:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Farhad Alemi <farhad.alemi@berkeley.edu>
Cc: Waiman Long <longman@redhat.com>, Farhad Alemi <falemi@asu.edu>, David
 Hildenbrand <david@kernel.org>, Gregory Price <gourry@gourry.net>, Yury
 Norov <ynorov@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Zi Yan
 <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, Rakie Kim
 <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 stable@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] cgroup/cpuset: rebind mm mempolicy to
 effective_mems, not mems_allowed
Message-Id: <20260627231508.74201ca47c883507be97d8c2@linux-foundation.org>
In-Reply-To: <CA+0ovCgfHJHv5d1mzapWWvF-LhjppzDX8NPPLvCPZxPKg8RiYw@mail.gmail.com>
References: <CA+0ovCg05rUk1-3k2ysdxmbcER8aG-wVh9SSTrrbp6LPWpPHYA@mail.gmail.com>
	<CA+0ovCgfHJHv5d1mzapWWvF-LhjppzDX8NPPLvCPZxPKg8RiYw@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 14 Jun 2026 06:25:55 -0700 Farhad Alemi <farhad.alemi@berkeley.edu> wrote:

> Creating a child cpuset where cpuset.mems is never set leads to a div/0
> when a VMA mempolicy with MPOL_F_RELATIVE_NODES rebinds in response to a
> CPU hotplug event.
> 
> Reproduction steps:
>  1) Create a cgroup w/ cpuset controls (do not set cpuset.mems)
>  2) Move the task into the child cpuset
>  3) Create a VMA mempolicy for that task with MPOL_F_RELATIVE_NODES
>  4) unplug and hotplug a cpu
>       echo 0 > /sys/devices/system/cpu/cpu1/online
>       echo 1 > /sys/devices/system/cpu/cpu1/online
>  5) mempolicy rebind does a div/0 in mpol_relative_nodemask on the
>     call to __nodes_fold()

Oops.

> The cpuset code passes (cs->mems_allowed) which is not guaranteed to have
> nodes to the rebind routine.  Use cs->effective_mems instead, which is
> guaranteed to have a non-empty nodemask.

Well gee, what happened with this patch.

I apologize for misfiling a cc:stable bugfix into my post-rc1 backlog
pile, but I got there in the end.

I guess this is an MM patch, even though it's against
kernel/cgroup/cpuset.c.

Nobody cc'ed Tejun.  Fixed.

David acked v1 but is being coy about the v2 patch?

Sashiko AI review suggests that there's a similar bug in
sys_set_mempolicy():

	https://sashiko.dev/#/patchset/CA+0ovCgfHJHv5d1mzapWWvF-LhjppzDX8NPPLvCPZxPKg8RiYw@mail.gmail.com


Anyway, I'll queue the v2 patch as an mm.git hotfix, but not with a lot
of confidence at this time.  Can people please refocus on this and help
recommend a way forward?


From: Farhad Alemi <farhad.alemi@berkeley.edu>
Subject: cgroup/cpuset: rebind mm mempolicy to effective_mems, not mems_allowed
Date: Sun, 14 Jun 2026 06:25:55 -0700

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
Link: https://lore.kernel.org/CA+0ovCgfHJHv5d1mzapWWvF-LhjppzDX8NPPLvCPZxPKg8RiYw@mail.gmail.com
Fixes: ae1c802382f7 ("cpuset: apply cs->effective_{cpus,mems}")
Signed-off-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Suggested-by: Gregory Price <gourry@gourry.net>
Suggested-by: Waiman Long <longman@redhat.com>
Closes: https://lore.kernel.org/linux-mm/CA+0ovCgxbZkXa+OU8w3s84R3KNPNxxRfmsNR-udh+afQBbGNmw@mail.gmail.com/
Acked-by: Waiman Long <longman@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup/cpuset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/cgroup/cpuset.c~cgroup-cpuset-rebind-mm-mempolicy-to-effective_mems-not-mems_allowed
+++ a/kernel/cgroup/cpuset.c
@@ -2653,7 +2653,7 @@ void cpuset_update_tasks_nodemask(struct
 
 		migrate = is_memory_migrate(cs);
 
-		mpol_rebind_mm(mm, &cs->mems_allowed);
+		mpol_rebind_mm(mm, &cs->effective_mems);
 		if (migrate)
 			cpuset_migrate_mm(mm, &cs->old_mems_allowed, &newmems);
 		else
_

