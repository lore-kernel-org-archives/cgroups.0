Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3FB424D65;
	Wed, 23 Sep 2026 23:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790207961; cv=none; b=pesUMG99xuvUegxEEkTOyK5w+I+7/iQpcv7ZT2t0rnqz1S2x/xOqYRZaFRIUUfdX1iJ71ate3OMLm/zB1LkeeZD5eabPI9EEkK2RT/YmWcVvPHLSxkZpokyCusTj+fg9QyNgUr721IVTupivsg+vWEg0FfiL6mT1uuxLocxnEus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790207961; c=relaxed/simple;
	bh=8yt1TzYasDAAKRxMXZy+DJCzel2bEplJPb6M5M8eQ2s=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E2QNw6GrUQvFyQUKrzmnAvPWenqjuQuMYC3lBuLaiiOC+F5/jT8oFBg5rdsvZ5dTm7QTU8OLjf3rHwzN2X6VI3hl7HWB6z8DcacnMS7ubGyWu8ARbwE5gkSH0xX8mFErBoL/uVeSO/vUF50lamKcfSHfSrOL7t115DvQueU7iz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h+dUQftm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h+dUQftm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2601F000FF;
	Wed, 23 Sep 2026 23:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790207959;
	bh=9AztrBAztJy2fSs4nBbn5dHogvPaIcwm8KTak2zpIb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h+dUQftmPfXG2W3ity46XKwJYGxRV8Wm6SohSLjdmhOzZxSj9Xp7s0y8OR7aqFV7J
	 fjgUMwtC6SuUG1AsnTH9Gq6qVMOY9paBU/vpLySM86AIpLxwiywbgpw3G46ZDdU3hH
	 /NGjDYZouimDV21+afO3ddCEV6OneQ6G/cFMVky+jq1THMx2cWHLncoFoj85ax2AQv
	 IsT12XGDUAhu60abUTaqfWQ6YMt1vJeln2wGzEkndyG9OX99yqNHzxlHZ4kmO+qsew
	 2kuQPC0adrB5rhu7sKTjY4PbhuaOQEaflxd6cMQDWqA2cTMsAHC7YEH8Ee1Pe+nDF1
	 gBMPDNricQvhw==
Message-ID: <e3ad3c98edc8a28207270566bae58940@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: =?UTF-8?Q?J=C3=A9r=C3=A9my_Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 brads@mainlining.org,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: prevent use-after-free during namespace root
 replacement
Date: Wed, 23 Sep 2026 13:56:06 -1000
In-Reply-To: <20260923204935.2253203-2-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20260923204935.2253203-2-Jeremy.Jean@oss.cyber.gouv.fr>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hello, Jeremy.

On Wed, Sep 23, 2026 at 08:49:36PM +0000, Jeremy Jean wrote:
> copy_cgroup_ns() pins the creator's css_set, but cgroup_post_fork()
> replaces root_cset and releases the namespace's reference to that css_set
> after the child is visible to pid and pidfd lookups. A task joining the
> new namespace can race with this replacement and access the original
> css_set or its cgroup after they are freed.
...
> Keep the initial root pinned until namespace destruction, taking a
> separate reference to the final root only when the roots differ.

The underlying problem is that the swap is observable at all. Pinning the
initial css_set keeps whatever a reader loaded alive, but then a namespace
created with CLONE_INTO_CGROUP holds a css_set that isn't its root, and
through it the parent's cgroups, for its whole lifetime, and readers like
current_cgns_cgroup_dfl() keep assuming root_cset never changes.

Can we instead make root_cset final before anything can reach the
namespace? At cgroup_can_fork(), kargs->cset is already what the child
will be attached to (cgroup_threadgroup_rwsem is held through
cgroup_post_fork()), the child isn't hashed and the pidfd isn't installed,
so the only way in is the ns tree. Something like:

- copy_cgroup_ns() skips ns_tree_add() on the fork path.
- cgroup_can_fork() updates root_cset from kargs->cset and then calls
  ns_tree_add().
- cgroup_post_fork() drops the swap.
- free_cgroup_ns() calls ns_tree_remove() only if the namespace made it
  into the tree.

Once visible, root_cset never changes and none of the readers need to
change. Kernels before the ns tree only expose the namespace through the
pid hash and the pidfd, so the backport would only need to move the
update.

Thanks.

--
tejun
