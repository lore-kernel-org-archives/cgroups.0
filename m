Received: from mail.mainlining.org (mail.mainlining.org [5.75.144.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD3B3BB687;
	Wed, 23 Sep 2026 21:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.75.144.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790197541; cv=none; b=qmQx+lYUORYFb4Y1yihMMk8xC1mmyz6zXdra1IGL/NLWqGKudDaJa1J2KGnn07ITN33GJTo+AamVqOXyWuuqrADz6IKMMxkfmebgQQz0F0Oy4IkugAjWUNU6w40f/ZEyDtMhOZqPAtcUi9i0wN8CsY32UeXbE4tg+m4Dzcr/fQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790197541; c=relaxed/simple;
	bh=nZrirwgx40H9aOyOW3Fau88luQE0Vd3hx1DCRhIcMI4=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=FPXwDcQn3cTuEh79UMx/9CCjfgD/m7uURK6SFoSksTXgcfDe3gfwiyxXSLj6zS0938tpC/0snLmbXRT7ckSZ8clAHwVFgZak+1dboDphpGzAUBL5jknnwoRxpGvsqs3pRwIvdp75PzVOtfMORmDWeUuExw5+jmXIvn5A9/s93jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mainlining.org; spf=pass smtp.mailfrom=mainlining.org; dkim=pass (2048-bit key) header.d=mainlining.org header.i=@mainlining.org header.b=IQoO+OV0; dkim=permerror (0-bit key) header.d=mainlining.org header.i=@mainlining.org header.b=lUSpbr9x; arc=none smtp.client-ip=5.75.144.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mainlining.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mainlining.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mainlining.org header.i=@mainlining.org header.b="IQoO+OV0";
	dkim=permerror (0-bit key) header.d=mainlining.org header.i=@mainlining.org header.b="lUSpbr9x"
DKIM-Signature: v=1; a=rsa-sha256; s=202507r; d=mainlining.org; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1790197524; bh=VIyleKCued/tZz0TA/ifYQ+
	HMXstVzm4nnmImdg3hfc=; b=IQoO+OV03/3kfSdBTMJCJVefZ0pBnjhf4EyK3U/1uiMbxMVrRZ
	rCcQ2ibyKKMqajn/wFjlmY0/HQByj5DjsY5nCrXwWOtkUJvcnGJbp9x6KR8K9VI9aAUZ9O0wGwz
	8i3YEC1YMgZbjQirM6HWlDoqD7liLy1yCT95XfgWmUni8wePS/dSteScUmC2sjJCus/8NQw4xfS
	aKiI45Qg+OmTvRIJc8nFWizq3rGpHQt8wNnm0VV0JY2ehxCOzkaTED3LBIkW+i6nTbyKd2H/ECT
	RO8BEWvysbANDhHKDySd7Q2lKOxRjRT0vDdxbehnitspydyqnnoEjKF+nWREU6iSTEg==;
DKIM-Signature: v=1; a=ed25519-sha256; s=202507e; d=mainlining.org; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1790197524; bh=VIyleKCued/tZz0TA/ifYQ+
	HMXstVzm4nnmImdg3hfc=; b=lUSpbr9xuDaCucnImEFksfZZaV2UfVUt+fW8LFUtQf6SxZbE6V
	op2ZXF81MydDIMBhdzhtfPdtLBbvzzTssaAw==;
Date: Wed, 23 Sep 2026 22:05:24 +0100
From: Bradley Morgan <brads@mainlining.org>
To: =?ISO-8859-1?Q?J=E9r=E9my_Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?ISO-8859-1?Q?Michal_Koutn=FD_?= <mkoutny@suse.com>
CC: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_cgroup=3A_prevent_use-after-?=
 =?US-ASCII?Q?free_during_namespace_root_replacement?=
In-Reply-To: <20260923204935.2253203-2-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20260923204935.2253203-2-Jeremy.Jean@oss.cyber.gouv.fr>
Message-ID: <60C5456D-CE52-4FF3-9B1E-865EF916ED8C@mainlining.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

On 23 September 2026 21:49:36 BST, "Jérémy Jean"
<Jeremy.Jean@oss.cyber.gouv.fr> wrote:
>copy_cgroup_ns() pins the creator's css_set, but cgroup_post_fork()
>replaces root_cset and releases the namespace's reference to that css_set
>after the child is visible to pid and pidfd lookups. A task joining the
>new namespace can race with this replacement and access the original
>css_set or its cgroup after they are freed.
>
>KASAN reports:
>
>  BUG: KASAN: slab-use-after-free in kernfs_get.part.0+0x47/0x60
>  Write of size 4 at addr ff1100000379f320 by task ns-path-probe/69
>   kernfs_walk_and_get_ns+0x1cc/0x280
>   cgroup_get_from_path+0xfb/0x340
>   nft_socket_cgroup_subtree_level+0x14/0x1a0
>
>Keep the initial root pinned until namespace destruction, taking a
>separate reference to the final root only when the roots differ.

Why would this be bad?

>
>Fixes: ef2c41cf38a7 ("clone3: allow spawning processes into cgroups")
>Assisted-by: LLM
>Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
>---
> include/linux/cgroup_namespace.h | 2 ++
> kernel/cgroup/cgroup.c           | 9 ++++++---
> kernel/cgroup/namespace.c        | 3 +++
> 3 files changed, 11 insertions(+), 3 deletions(-)
>
>diff --git a/include/linux/cgroup_namespace.h b/include/linux/cgroup_namespace.h
>index 78a8418..f36ec1a 100644
>--- a/include/linux/cgroup_namespace.h
>+++ b/include/linux/cgroup_namespace.h
>@@ -9,6 +9,8 @@ struct cgroup_namespace {
> 	struct user_namespace	*user_ns;
> 	struct ucounts		*ucounts;
> 	struct css_set          *root_cset;
>+	/* Preserve the root observed before cgroup_post_fork() updates it. */
>+	struct css_set		*initial_root_cset;
> };
> 
> extern struct cgroup_namespace init_cgroup_ns;
>diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
>index 227d097..c3cb258 100644
>--- a/kernel/cgroup/cgroup.c
>+++ b/kernel/cgroup/cgroup.c
>@@ -247,6 +247,7 @@ struct cgroup_namespace init_cgroup_ns = {
> 	.ns		= NS_COMMON_INIT(init_cgroup_ns),
> 	.user_ns	= &init_user_ns,
> 	.root_cset	= &init_css_set,
>+	.initial_root_cset = &init_css_set,
> };
> 
> static struct file_system_type cgroup2_fs_type;
>@@ -7131,9 +7132,11 @@ void cgroup_post_fork(struct task_struct *child,
> 	if (kargs->flags & CLONE_NEWCGROUP) {
> 		struct css_set *rcset = child->nsproxy->cgroup_ns->root_cset;
> 
>-		get_css_set(cset);
>-		child->nsproxy->cgroup_ns->root_cset = cset;
>-		put_css_set(rcset);
>+		/* Both possible roots must remain pinned for namespace readers. */
>+		if (rcset != cset) {
>+			get_css_set(cset);
>+			WRITE_ONCE(child->nsproxy->cgroup_ns->root_cset, cset);
>+		}
> 	}
> 
> 	/* Cgroup has to be killed so take down child immediately. */
>diff --git a/kernel/cgroup/namespace.c b/kernel/cgroup/namespace.c
>index ea4ee13..1153ea4 100644
>--- a/kernel/cgroup/namespace.c
>+++ b/kernel/cgroup/namespace.c
>@@ -37,6 +37,8 @@ void free_cgroup_ns(struct cgroup_namespace *ns)
> {
> 	ns_tree_remove(ns);
> 	put_css_set(ns->root_cset);
>+	if (ns->initial_root_cset != ns->root_cset)
>+		put_css_set(ns->initial_root_cset);
> 	dec_cgroup_namespaces(ns->ucounts);
> 	put_user_ns(ns->user_ns);
> 	ns_common_free(ns);
>@@ -84,6 +86,7 @@ struct cgroup_namespace *copy_cgroup_ns(u64 flags,
> 	new_ns->user_ns = get_user_ns(user_ns);
> 	new_ns->ucounts = ucounts;
> 	new_ns->root_cset = cset;
>+	new_ns->initial_root_cset = cset;
> 
> 	ns_tree_add(new_ns);
> 	return new_ns;
>

--- Thanks!
"I'm not a very positive person" - Linus torvalds
