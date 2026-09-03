Received: from mail.mainlining.org (mail.mainlining.org [5.75.144.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F24C4499BA;
	Thu,  3 Sep 2026 08:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.75.144.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788424843; cv=none; b=LMsLStgrzRgEb9mUIdBMb5BDQjpshlThFZuzus07npEXAiC9U8eQKTSlXv27spviBkiQIyJzSCnC7R3/41G2GizhNkA/H1PJaWdkSrxxdxVROYVRfhocvZGQdrAQmmI18T4czhcCS0iLgvrGMMi1eypFvJdP2HrOJkXZCQvifMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788424843; c=relaxed/simple;
	bh=kMTOFN8JZhM/m7RvvMqXj/VTFZ5tb5Ajow1J3nUWZgw=;
	h=Date:From:To:CC:Subject:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=FCTXLVd9haenJkP8QSF/O1zdT9/cArwZDj9sd+7L1ya8+IWKlU4Nuh6wV/Y45l/YLRrR3ZxTVUvPuSuwxPaA6j+BebSKKMYf1CWAxTgSavKPmOPd9NiFM8Bf/T2n4D5gTJ4c9ksRnvJkdfCag0p/y6sRNF+z5FwyV3I0Z/ZCILM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mainlining.org; spf=pass smtp.mailfrom=mainlining.org; dkim=pass (2048-bit key) header.d=mainlining.org header.i=@mainlining.org header.b=mDQatlzl; dkim=permerror (0-bit key) header.d=mainlining.org header.i=@mainlining.org header.b=LuGOw9ME; arc=none smtp.client-ip=5.75.144.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mainlining.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mainlining.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mainlining.org header.i=@mainlining.org header.b="mDQatlzl";
	dkim=permerror (0-bit key) header.d=mainlining.org header.i=@mainlining.org header.b="LuGOw9ME"
DKIM-Signature: v=1; a=rsa-sha256; s=202507r; d=mainlining.org; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1788424814; bh=Lwc1uEi59DT6h5HnJoqKhbK
	oJBDpxb8emwwF7CCjWek=; b=mDQatlzlflnWCFQUd3FUD2C9gogGntQYQwwbGhdz8biTGbYcFS
	mrTHaqc7KE6gQE54fzal5z0HIp8cVC9/b/SePFR3OAw9F20N9ajvV38jGzLLx18CHwmkeLV9mHL
	RBsqy00tj+MV1jdUciTMri4j2DvCY+aN5yQlwjov7OaqMjkiPLMAt9ED+JNLiHLrSrxUHbqW/CE
	jIsMPqlbRzoB4qbB4WhSJzZQPyiw+XN2rXozmkhXRb7kEK6Z05PzjN2T70GY7nnGshsF4qf5ZyB
	zcqrk6h1AP4z3uHflwjnHQnQQWP1cS8DM2E86pbztcgdwepk4uujOwHZhYBNVRDDMUA==;
DKIM-Signature: v=1; a=ed25519-sha256; s=202507e; d=mainlining.org; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1788424814; bh=Lwc1uEi59DT6h5HnJoqKhbK
	oJBDpxb8emwwF7CCjWek=; b=LuGOw9ME6e3WFLcYm44DJ9YnX8TGY9tiaCd7EOKe/dgjMf9y7d
	wLv42xm6EaEuW+q9zoqUCccEUsRbfdL4qJDQ==;
Date: Thu, 03 Sep 2026 09:40:12 +0100
From: Bradley Morgan <brads@mainlining.org>
To: sunshaojie@kylinos.cn
CC: brauner@kernel.org, cgroups@vger.kernel.org, hannes@cmpxchg.org, jack@suse.cz,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 mkoutny@suse.com, ptikhomirov@virtuozzo.com, tj@kernel.org,
 viro@zeniv.linux.org.uk
Subject: Re: [PATCH v2 2/3] uts: drop BUG_ON() in copy_utsname()
In-Reply-To: <20260903064828.126643-3-sunshaojie@kylinos.cn>
Message-ID: <3C0E7463-BFCA-4E4A-A6AF-AD9F6E57010A@mainlining.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

On 3 September 2026 07:48:27 BST, Shaojie Sun <sunshaojie@kylinos.cn>
wrote:
>The sole caller, create_new_namespaces(), always passes a valid uts
>namespace pointer from the task's nsproxy. The other copy_*_ns()
>helpers, e.g. copy_time_ns() and copy_pid_ns(), don't perform such a
>check either. Drop the BUG_ON() for consistency with them.
>

Reviewed-by: Bradley Morgan <brads@mainlining.org>


>Signed-off-by: Shaojie Sun <sunshaojie@kylinos.cn>
>---
> kernel/utsname.c | 1 -
> 1 file changed, 1 deletion(-)
>
>diff --git a/kernel/utsname.c b/kernel/utsname.c
>index ebbfc578a9d3..1ebf87e24607 100644
>--- a/kernel/utsname.c
>+++ b/kernel/utsname.c
>@@ -81,7 +81,6 @@ struct uts_namespace *copy_utsname(u64 flags,
> {
> 	struct uts_namespace *new_ns;
> 
>-	BUG_ON(!old_ns);
> 	get_uts_ns(old_ns);
> 
> 	if (!(flags & CLONE_NEWUTS))
>

--- Thanks!
https://lore.kernel.org/all/EE579805-42F2-4C58-B752-F28779EEB717@grrlz.net/
