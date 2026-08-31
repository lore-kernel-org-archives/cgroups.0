Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7394D4A3D2E;
	Mon, 31 Aug 2026 16:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788194328; cv=none; b=sAeWhw0lcjzXwhDQ8mKKig3ja/P77lffRTp77dI3I0hfvQ5+CjvtTtS5M2DI8WVVnlYXv7Eekv/fEVGcFxaLBE5VTn0MrLWNHFuD1JSofybIqX5b8C7+/7rhK5suzaKiIqhfaCvuatadHrGM7NVfzi2iDj/SL6AIYLC+qOYIsQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788194328; c=relaxed/simple;
	bh=xm6//aEn4Ue7Eo9Co+idMwGJobcjIiRszOOdKLRoysQ=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=aQVDRaw+u/CT4o5U5BFoqZ/Cqk9b3ysXwH4seRO0AKXmd6Tf6tBX0pAn28PoJlmJ6f+bpiX0LFEubsluLqo+6klN+Nq8+vrLRHwFFC5XtvQ+nIT2gHsoDY7GUKB3zuGwVmdW84990CgyI25Rs5HnaEkIarjYorMmux9q/XM42J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y4+dpfdq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y4+dpfdq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1574C1F000E9;
	Mon, 31 Aug 2026 16:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788194327;
	bh=rwPiByk+/vb8pjTiOQ5IwK2OWNX45mjiX1uT9kmefPo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Y4+dpfdqX6Ialocao9UtxHy1yE4cKduBWMd4Ki7yR5XOmFrq+2DMtMSey+UeT/Bgr
	 6knA6nswwpgG14TyofqW77j7C80KAhlTEObn8KKU57FygIa+4CcLylPXLPt0NqAUg6
	 zac5kfhy4JCSm6hoBXPxM77PxvaCMmVeqV03dU+MhQdf2TWV/b5AjkcWyB+UbUnyYG
	 8CxX704bA6+CXxLxj/nYAsPcx3WfSN/FdfeE7BETfZMxEhk7cZpmzrsyu22E6EEYLK
	 9kXDZUtqklkfCMTygR8RWU9h/rBv/nndJ5EYxkhUeSAnxqLqiO6rA6yC2YlIu0Zb4B
	 VphSuMW5q11xA==
Date: Mon, 31 Aug 2026 06:38:46 -1000
Message-ID: <ceef3a1e4e86deef2970e80d94925bac@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Etienne Perot <eperot@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	=?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Christian Brauner <brauner@kernel.org>,
	Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] cgroup: fix spurious SIGKILL of CLONE_INTO_CGROUP
 children
In-Reply-To: <20260828215252.4126811-1-eperot@google.com>
References: <20260828215252.4126811-1-eperot@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

Applied 1-2 to cgroup/for-7.3-fixes with the comment above kill_seq
updated as Shakeel suggested:

--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -527,7 +527,10 @@ struct cgroup {

 	int nr_threaded_children;	/* # of live threaded child cgroups */

-	/* sequence number for cgroup.kill, serialized by css_set_lock. */
+	/*
+	 * Sequence number for cgroup.kill. Incremented with both cgroup_mutex
+	 * and css_set_lock held. Readers hold either one.
+	 */
 	unsigned int kill_seq;

 	struct kernfs_node *kn;		/* cgroup kernfs entry */

Thanks.

-- 
tejun
