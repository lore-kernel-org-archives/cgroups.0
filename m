Received: from mail.mainlining.org (mail.mainlining.org [5.75.144.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0DD238166;
	Thu, 24 Sep 2026 21:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.75.144.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790284200; cv=none; b=lt04hf7VFao4X1V/a/65ZgfoNmW6Y/6MW//aBc/MHtYmU1pXif3/USSUP9jJddfQsdiN8wU7h1KudUyZ3XF8DcaLoxy0iMYEeZF0wz2MZrsSZIyvktpMfIjQHZbPtOpnAwlPRMXHfcY0mc8nHXSltE04YVvi9owiaFvBNxhPiG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790284200; c=relaxed/simple;
	bh=bKKR33ZtASxQuckUlMWmHoZcVSF6u+VelidkX6lZnaQ=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=S9LOY5eQNBSBmy7JPpB5SYqPi+wmQpPhunE1ue3IEggy+SqrkFtwmn1AoKeZWbkduAJRcj7MJMu+Kp2pMaVqlHgdCihXe6Qh7gUlpwAc1a5WzAOy2k7VFjGoPUVAlB56SWMMZ2AkbpZyyo6/Bk26juriqmnReSiQmN0emYY65H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mainlining.org; spf=pass smtp.mailfrom=mainlining.org; dkim=pass (2048-bit key) header.d=mainlining.org header.i=@mainlining.org header.b=jixMMa54; dkim=permerror (0-bit key) header.d=mainlining.org header.i=@mainlining.org header.b=3OpZRW5v; arc=none smtp.client-ip=5.75.144.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mainlining.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mainlining.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mainlining.org header.i=@mainlining.org header.b="jixMMa54";
	dkim=permerror (0-bit key) header.d=mainlining.org header.i=@mainlining.org header.b="3OpZRW5v"
DKIM-Signature: v=1; a=rsa-sha256; s=202507r; d=mainlining.org; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1790284142; bh=Yt/s51eHlN4Wt3eEeU/cF1c
	JstmopbHwqVMC7Jaw7OY=; b=jixMMa54FoV8yqHvYJ2EtyPlgPD/Z2g/YnOnr/tKIW1JGE5LU+
	UpfuWSWiwkLetvkugu/freW5Alxyq5cvyowN060Tpt4tGZuZ7lxO5noEbL1WuIVUpqMtJClpW2k
	lyUFxpRJh/sG0G7Xn+H/zSlRaa9Se9EJ//RP0WdcQ+FfNSzzwhfqAlMxb1+BvI1KnnnlmPnnQU3
	N06HI3JUYPie2GmWZfuDLiz5ZwW1rj7QHVXh3mx2fe0eDM/NDV+ogMXVMVm7OUZosD1d1nG0/iY
	wF/IatmbtaJeEJ6ctkCsIqTDaS+MM0ZEi0BVWz2qxepqbk1mRPxkFX+NM2cPNiNG4JA==;
DKIM-Signature: v=1; a=ed25519-sha256; s=202507e; d=mainlining.org; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1790284142; bh=Yt/s51eHlN4Wt3eEeU/cF1c
	JstmopbHwqVMC7Jaw7OY=; b=3OpZRW5vsEt46FRKMGrvY+D+osfOKm33MxmL9sRaYUXwd7XGGV
	bRTqNgl6OR7RMHUW2aPmi2MvOut27gqcF4Cw==;
Date: Thu, 24 Sep 2026 22:09:02 +0100
From: Bradley Morgan <brads@mainlining.org>
To: =?ISO-8859-1?Q?J=E9r=E9my_Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?ISO-8859-1?Q?Michal_Koutn=FD_?= <mkoutny@suse.com>
CC: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Christian Brauner <christian@brauner.io>,
 Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2=5D_cgroup=3A_prevent_css=5F?=
 =?US-ASCII?Q?set_UAF_after_namespace_publication?=
In-Reply-To: <20260924210102.3773873-2-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20260924210102.3773873-2-Jeremy.Jean@oss.cyber.gouv.fr>
Message-ID: <82BB09F8-CEA2-42F8-8C0D-3D1FE65BBF47@mainlining.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

On 24 September 2026 22:01:03 BST, "Jérémy Jean"
<Jeremy.Jean@oss.cyber.gouv.fr> wrote:
>copy_cgroup_ns() sets the root of a new cgroup namespace to the parent's
>css_set. When the child is created in a different cgroup,
>cgroup_post_fork() replaces that root with the child's css_set after the
>namespace is visible.
>
>Publishing the namespace before root_cset is final lets readers race with
>cgroup_post_fork(). A reader can load the old root just before it is
>replaced and its reference is dropped, then continue using the freed
>css_set. KASAN reports:
>
>  BUG: KASAN: slab-use-after-free in kernfs_get.part.0+0x47/0x60
>  Write of size 4 at addr ff1100000379f320 by task ns-path-probe/69
>   kernfs_walk_and_get_ns+0x1cc/0x280
>   cgroup_get_from_path+0xfb/0x340
>   nft_socket_cgroup_subtree_level+0x14/0x1a0
>
>Finalize root_cset before adding the namespace to the tree. Allocate the
>namespace ID at creation, add unshared namespaces after creation succeeds,
>and only remove namespaces that were added.
>
>Fixes: ef2c41cf38a7 ("clone3: allow spawning processes into cgroups")
>Assisted-by: LLM

You could have added Tejuns A-B and my R-B, but the merger can do that

>Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
>---
>Reposting v2 with NAMESPACES in Cc, as requested by Tejun Heo.
>
>Changes in v2:
>- Finalize root_cset before publication.
>- Defer tree insertion on fork.
>- Handle unshare and failed forks.
>
>v1: https://lore.kernel.org/all/20260923204935.2253203-2-Jeremy.Jean@oss.cyber.gouv.fr/
>
> kernel/cgroup/cgroup.c    | 22 +++++++++++++---------
> kernel/cgroup/namespace.c |  5 +++--
> kernel/nsproxy.c          |  5 +++++
> 3 files changed, 21 insertions(+), 11 deletions(-)
>
>diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
>index 227d09704ca5..78f6d235c19b 100644
>--- a/kernel/cgroup/cgroup.c
>+++ b/kernel/cgroup/cgroup.c
>@@ -7009,6 +7009,19 @@ int cgroup_can_fork(struct task_struct *child, struct kernel_clone_args *kargs)
> 			goto out_revert;
> 	} while_each_subsys_mask();
> 
>+	/* Publish a new cgroup namespace only after its root is final. */
>+	if (kargs->flags & CLONE_NEWCGROUP) {
>+		struct cgroup_namespace *ns = child->nsproxy->cgroup_ns;
>+		struct css_set *rcset = ns->root_cset;
>+
>+		if (rcset != kargs->cset) {
>+			get_css_set(kargs->cset);
>+			ns->root_cset = kargs->cset;
>+			put_css_set(rcset);
>+		}
>+		ns_tree_add_raw(ns);
>+	}
>+
> 	return 0;
> 
> out_revert:
>@@ -7127,15 +7140,6 @@ void cgroup_post_fork(struct task_struct *child,
> 		ss->fork(child);
> 	} while_each_subsys_mask();
> 
>-	/* Make the new cset the root_cset of the new cgroup namespace. */
>-	if (kargs->flags & CLONE_NEWCGROUP) {
>-		struct css_set *rcset = child->nsproxy->cgroup_ns->root_cset;
>-
>-		get_css_set(cset);
>-		child->nsproxy->cgroup_ns->root_cset = cset;
>-		put_css_set(rcset);
>-	}
>-
> 	/* Cgroup has to be killed so take down child immediately. */
> 	if (unlikely(kill))
> 		do_send_sig_info(SIGKILL, SEND_SIG_NOINFO, child, PIDTYPE_TGID);
>diff --git a/kernel/cgroup/namespace.c b/kernel/cgroup/namespace.c
>index ea4ee13936be..6c8ac36231d9 100644
>--- a/kernel/cgroup/namespace.c
>+++ b/kernel/cgroup/namespace.c
>@@ -30,12 +30,14 @@ static struct cgroup_namespace *alloc_cgroup_ns(void)
> 	ret = ns_common_init(new_ns);
> 	if (ret)
> 		return ERR_PTR(ret);
>+	ns_tree_gen_id(new_ns);
> 	return no_free_ptr(new_ns);
> }
> 
> void free_cgroup_ns(struct cgroup_namespace *ns)
> {
>-	ns_tree_remove(ns);
>+	if (ns_tree_active(ns))
>+		ns_tree_remove(ns);
> 	put_css_set(ns->root_cset);
> 	dec_cgroup_namespaces(ns->ucounts);
> 	put_user_ns(ns->user_ns);
>@@ -85,7 +87,6 @@ struct cgroup_namespace *copy_cgroup_ns(u64 flags,
> 	new_ns->ucounts = ucounts;
> 	new_ns->root_cset = cset;
> 
>-	ns_tree_add(new_ns);
> 	return new_ns;
> }
> 
>diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
>index d9d3d5973bf5..01c4dcf26993 100644
>--- a/kernel/nsproxy.c
>+++ b/kernel/nsproxy.c
>@@ -238,6 +238,11 @@ int unshare_nsproxy_namespaces(unsigned long unshare_flags,
> 		goto out;
> 	}
> 
>+#ifdef CONFIG_CGROUPS
>+	if (flags & CLONE_NEWCGROUP)
>+		ns_tree_add_raw((*new_nsp)->cgroup_ns);
>+#endif
>+
> out:
> 	return err;
> }
>

--- Thanks!
"I'm not a very positive person" - Linus torvalds
