Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793797096;
	b=s9vGc+jyVaYibEECCNW2huCT2UolidIToNqnbevuVljAlx7myQZt3dF85eFFNtzVzUYR
	 GBpLoTXnZ+NFNuOfPcCNoeeQp04uHgyJriZpK0KJCD2nP2aZqMr0FbTfBfcOSVxO2WE4f
	 fQGW0NdNXv0vCVJ1Y+y5xWFUhVVEB1z6ZXIY632pN5AfFcjbFIl2g1UdM0sUu8j75nulA
	 0C/DQ1KQqBAuykQ6xG2t95rQSUZAMXE8vZfQG5WPJQpfki3wHo6b7zGjilHo5TRHWbbsD
	 z6lOTzufD/PWoWpfb5e2BUX6zdTPUKcKDshA6ZtinCUja9YFMyJASyJvLpoUy9R1q/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793797096;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=6jRl+MNBW9eJzK1310m+ol+TnpF7kkR6PE11DxtOf5w=;
	b=fHbQywovlIUb/7pOuEVMKk4qOLLMKdcmYasBzmA9nXJirjsB7V0kTQi+PMYrcLJr5lwk
	 OwQhCsY6AMgpeGeApLdDTYoSgnJJNm97RuqhNfuwChLEEp8o2pvawL4yr/lTjgfpsoR2t
	 g/5uOyxoBTI+z5/orrPPsQXRH5YFGWZC3LJr+ouGedZcZtMdEg1EzWuRJynKaSqyHW5pP
	 faGgl0HTFyO7r+BKpIiVtSjv9I2n/UTssKJ3cI31x/NHAzTbG3oXR2oQLJ08JN/NUlMCY
	 IS3nkWSzj81Phe9w0sAIaceeuF0ELDi6zlEhH8vHCJDE1aQcj5xUmeoowPGruauS1yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xUYeFftH;
	arc=none smtp.remote-ip=91.218.175.199
Received: from mta0.migadu.com (out-199.mta0.migadu.com [91.218.175.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03477606A329
	for <cgroups@vger.kernel.org>; Wed,  4 Nov 2026 12:58:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 03477606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xUYeFftH
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=eCNtIyjBZay778XSnVoMLQk3OiuNry21KUjRM5jXB7w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793797091; v=1; x=1794401891;
 b=xUYeFftHY5ndOET3D+bn4yBe9SamfnGsOn8GGxfCQpIfEP/Ljms2w/NCmeR6w2sC2jzJjF/w
 8JLPAo0QCT2PU9GGbGUFJQJYCIlhXUbaESH2Oxn7Bup8ECrO6g2p91rPuKqYM8XjMvZhbK42Ix0
 ykF8qZMHnA4oDen8aipbK3CA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8479a0f7763f9f6b;
	Wed, 04 Nov 2026 12:58:10 +0000
X-Mizu-Trace-ID: 8479a0f7763f9f6b
X-Migadu-Flow: FLOW_OUT
Message-ID: <cbe741a9-fd0c-4c8f-8591-55ecc70f222a@linux.dev>
Date: Wed, 4 Nov 2026 20:58:00 +0800
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cgroup/cpuset: Fail if isolated CPUs don't leave any boot
 domain housekeeping CPU
To: Guopeng Zhang <guopeng.zhang@linux.dev>, longman@redhat.com
Cc: tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20261104071600.474587-1-guopeng.zhang@linux.dev>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261104071600.474587-1-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/4/2026 3:16 PM, Guopeng Zhang wrote:
> From: Guopeng Zhang<zhangguopeng@kylinos.cn>
> 
> With the "domain" flag of the isolcpus= boot option, the CPUs isolated
> at boot are excluded from the sched domains and the remaining CPUs
> become the boot domain housekeeping CPUs. An isolated partition is
> allowed to use the boot isolated CPUs, but it must not take over all
> the boot domain housekeeping CPUs.
> 
> prstate_housekeeping_conflict() checks that rule for root partitions
> only. The 2nd check covers the nohz_full case as it is gated by
> housekeeping_enabled(HK_TYPE_KERNEL_NOISE) which is not enabled by
> isolcpus=domain. So on an isolcpus=domain,<cpus> boot, an isolated
> partition can claim all the remaining boot domain housekeeping CPUs.
> The state is committed, but the sched domain rebuild at the end of
> the write finds no housekeeping CPU left for the boot domain and
> hits WARNs and an OOPS in partition_sched_domains().
> housekeeping_update() cannot accept the configuration either as it
> cannot empty the boot domain housekeeping mask.
> With an "isolcpus=domain,10-31" boot where CPUs 0-9 are the boot
> domain housekeeping CPUs, for example:
> 
>    # echo 0-9 > A/cpuset.cpus
>    # echo isolated > A/cpuset.cpus.partition
>    WARNING: kernel/sched/topology.c:3089 at build_sched_domains+...
>    WARNING: kernel/cgroup/cpuset.c:1478 at cpuset_update_sd_hk_unlock+...
>    RIP: 0010:partition_sched_domains+0x3b8
> 
> Fix that by extending prstate_housekeeping_conflict() to reject an
> isolated partition update that would leave no active boot domain
> housekeeping CPU outside the isolated CPUs. The CPUs released back
> to the boot domain by the same update are taken into account, so
> replacing one of the last housekeeping CPUs with another one in a
> single update remains allowed. The new check is only performed when
> housekeeping_enabled(HK_TYPE_KERNEL_NOISE) is disabled so that the
> existing nohz_full behavior is unchanged.
> 
> Add test cases in test_cpuset_prs.sh to verify that taking over all
> the boot domain housekeeping CPUs is rejected while swapping one of
> them with another one is allowed.

Hi Guopeng,

Thanks for the report and the reproducer. I can reproduce the WARN and
the OOPS in partition_sched_domains() here.

However, I don't think prstate_housekeeping_conflict() is the right
place to fix it, and the fix doesn't seem complete. The same problem
can be triggered with a root partition, which this patch doesn't cover.
With an "isolcpus=domain,4-7" boot on an 8-CPU VM:

   # echo 0-3 > A/cpuset.cpus
   # echo root > A/cpuset.cpus.partition
   WARNING: kernel/sched/topology.c:3111 at build_sched_domains+0x2b96/0x5500
   Oops: general protection fault, ... [#1] SMP KASAN NOPTI
   RIP: 0010:partition_sched_domains+0x10a3/0x1a10

The faulting address is in build_perf_domains(), where cpumask_first()
on the empty cpu_map returns nr_cpu_ids and cpu_rq() goes out of
bounds.

The root cause looks like it isn't a housekeeping conflict. Boot time
isolated CPUs stay in top_cpuset.effective_cpus by design, and they are
only filtered out of the top_cpuset sched domain in
generate_sched_domains(). But the checks that make sure the parent
still has CPUs left, i.e. tasks_nocpu_error() for local partitions and
the cpumask_subset(top_cpuset.effective_cpus, ...) checks in
remote_partition_enable()/remote_cpus_update(), only look at
top_cpuset.effective_cpus. So any partition, root or isolated, local
or remote, can take away all the boot domain housekeeping CPUs as long
as some boot isolated CPUs are still left in top_cpuset, which leaves
the top_cpuset sched domain empty.

So I think the check should be done at the "parent has no CPU left"
level instead. Something like the diff below. It is not tested yet;
could you give it a try with your reproducer and the test cases?
Note that the root partition and remote partition cases should be
added to the selftest as well.

Without isolcpus=domain, HK_TYPE_DOMAIN_BOOT is cpu_possible_mask and
the new check is equivalent to the existing one, so no extra
housekeeping_enabled() gating is needed.

---
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 3219f927c35e..fb3e81405f5b 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1180,12 +1180,51 @@ static void update_partition_sd_lb(struct cpuset *cs, 
int old_prs)
                 cpuset_force_rebuild();
  }

+/*
+ * top_cpuset_sd_nocpu - Check if top_cpuset will have no sched domain CPU
+ * @add_cpus: CPUs to be taken away from top_cpuset
+ * @del_cpus: CPUs to be given back to top_cpuset, can be NULL
+ * Return: true if no active CPU will be left in the top_cpuset sched domain
+ *
+ * Boot time isolated CPUs stay in top_cpuset.effective_cpus, but they are
+ * excluded from the sched domain of top_cpuset in generate_sched_domains().
+ * So checking top_cpuset.effective_cpus alone is not enough to ensure that
+ * the top_cpuset sched domain won't become empty after @add_cpus are taken
+ * away from it. The sched domain of top_cpuset must keep at least one
+ * active boot domain housekeeping CPU.
+ */
+static bool top_cpuset_sd_nocpu(const struct cpumask *add_cpus,
+                               const struct cpumask *del_cpus)
+{
+       const struct cpumask *hk_mask = housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT);
+       int cpu;
+
+       for_each_cpu_and(cpu, hk_mask, cpu_active_mask) {
+               if (cpumask_test_cpu(cpu, add_cpus))
+                       continue;
+               if (cpumask_test_cpu(cpu, top_cpuset.effective_cpus) ||
+                   (del_cpus && cpumask_test_cpu(cpu, del_cpus)))
+                       return false;
+       }
+       return true;
+}
+
  /*
   * tasks_nocpu_error - Return true if tasks will have no effective_cpus
   */
  static bool tasks_nocpu_error(struct cpuset *parent, struct cpuset *cs,
                               struct cpumask *xcpus)
  {
+       /*
+        * The top_cpuset always has tasks (kthreads at least), so its sched
+        * domain can't be empty. The current effective_xcpus of a valid
+        * partition will be given back to top_cpuset if not in @xcpus.
+        */
+       if ((parent == &top_cpuset) &&
+           top_cpuset_sd_nocpu(xcpus, is_partition_valid(cs)
+                                      ? cs->effective_xcpus : NULL))
+               return true;
+
         /*
          * A populated partition (cs or parent) can't have empty effective_cpus
          */
@@ -1724,7 +1763,7 @@ static int remote_partition_enable(struct cpuset *cs, int 
new_prs,
          */
         compute_excpus(cs, tmp->new_cpus);
         if (!cpumask_intersects(tmp->new_cpus, cpu_active_mask) ||
-           cpumask_subset(top_cpuset.effective_cpus, tmp->new_cpus))
+           top_cpuset_sd_nocpu(tmp->new_cpus, NULL))
                 return PERR_INVCPUS;
         if (cpumask_intersects(tmp->new_cpus, subpartitions_cpus))
                 return PERR_NOCPUS;
@@ -1828,7 +1867,7 @@ static void remote_cpus_update(struct cpuset *cs, struct 
cpumask *xcpus,
                 if (!capable(CAP_SYS_ADMIN))
                         WRITE_ONCE(cs->prs_err, PERR_ACCESS);
                 else if (cpumask_intersects(tmp->addmask, subpartitions_cpus) ||
-                        cpumask_subset(top_cpuset.effective_cpus, tmp->addmask))
+                        top_cpuset_sd_nocpu(tmp->addmask, tmp->delmask))
                         WRITE_ONCE(cs->prs_err, PERR_NOCPUS);
                 else if (prstate_housekeeping_conflict(prs, PRS_ROOT,
                                                        excpus, tmp->delmask))

-- 
Best regards
Ridong

