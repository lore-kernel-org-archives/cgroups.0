Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BCA26A1B9;
	Wed, 25 Feb 2026 05:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771996500; cv=none; b=THOPun+no+0fgy3ekq5ayFCNzWpnrS8eZJwACIouyS+odys6zg3Up6DKq6lvHxoBk+e6ai0vbpbvdoX9OWasnohbQP3NqAaoEGvumnwDAG41iDlPPF0dwBasTqofqljouSObupDwAHQMOZbZ8HU7JATDiMtYnIBzLVZTsz+e66U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771996500; c=relaxed/simple;
	bh=6mt4HeESVUyMt1GSw4ih6qH3A1OaTtNDz8ITK5f9vGo=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=ib0b89Fz7Wh1blM2bLqSOyRIXn4AuVE1uA3EsiLA5kl+jfq7YG9C4XZOGmCr/EfVnTgkDMQkaen8EDICdQQdS+4aHlhuNebpJicmiUjzOHJgLBc8qZ0qQImeorZiX7fiSvS+A0mRr73QDkwyTpbYOdT0iGborV3ogdCJliRtaFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FgZbbhrX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FgZbbhrX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E842AC116D0;
	Wed, 25 Feb 2026 05:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771996500;
	bh=6mt4HeESVUyMt1GSw4ih6qH3A1OaTtNDz8ITK5f9vGo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FgZbbhrXQOvVoo87tK9c1EkD3Pi2e8YMT2xV8JH7Jlshiplm0hKLniekNILBQoJ6B
	 /ugAh681ug5mn3PIsMQ7aA+343ojBGGYhbTxUG18WugY7V2lqR+yC/7a7Y68BQScie
	 sfP1+hj+m59Pc5PDKYAYGJd2yxaodCioAKaJxTghIHbpN7TpuOEWpD/Lkb+GacewQX
	 yQLi2Gz1ZDTLLW/P5G98Hov1754mh2gtMdbtWI6+3bP06ioYdLWRGwFLGoTDF1KuEO
	 ubyYugeuWRsSnBP7xP1SrFr6X7nsxtAzMtP0Cv8KFnUQlHVBUuetH+1nZ9vBErdLXb
	 zOJFXb4syZvyg==
Date: Tue, 24 Feb 2026 19:14:59 -1000
Message-ID: <29c88610558875bf17f9a2f796f4ed29@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org,
 sched-ext@lists.linux.dev
Cc: void@manifault.com,
 arighi@nvidia.com,
 changwoo@igalia.com,
 emil@etsalapatis.com,
 hannes@cmpxchg.org,
 mkoutny@suse.com,
 cgroups@vger.kernel.org
Subject: Re: [PATCHSET v2 sched_ext/for-7.1] sched_ext: Implement cgroup
 sub-scheduler support
In-Reply-To: <20260225050109.1070059-1-tj@kernel.org>
References: <20260225050109.1070059-1-tj@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Correctly noting the changes from v1 which I forgot to include in the
cover letter.

v2: Rebased to sched_ext/for-7.1. This patchset depends on the following
    fix which is being sent separately targeting sched_ext/for-7.0-fixes:

      http://lkml.kernel.org/r/20260225050055.1069822-1-tj@kernel.org
      sched_ext: Disable preemption between scx_claim_exit() and kicking
      helper work

    - #6 updated to preserve preempt guard in the rewritten scx_disable().

    - #9: Fixed BTF_ID_FLAGS for scx_bpf_locked_rq - comma between
      KF_IMPLICIT_ARGS and KF_RET_NULL should be bitwise OR.

    - #15: Added NULL check for sch in scx_bypass() to fix NULL deref when
      PM notifier calls scx_bypass() with no scheduler loaded.

    - #29: Fixed scx_fail_parent() call to pass sch instead of parent,
      avoiding NULL deref when disabling a level-1 sub-sched.

v1: http://lkml.kernel.org/r/20260121231140.832332-1-tj@kernel.org

Thanks.

--
tejun
