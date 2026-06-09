Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C2F30E853
	for <cgroups@vger.kernel.org>; Tue,  9 Jun 2026 07:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780991311; cv=none; b=uesidsR5GSCyu7SL+muYt6Ww5UTB+CsTVY5aKUOfNcwE+/r9tICVVDrP07SOOlKBLscStURiJB5fx83tzEpj2FjpoPreNIeIEP0taOsjRRCjzJZ2emQ0xs1GngzdbpocAkWpfl99AV80teY1q383AM6WmNsjEzIi6UsvYTVs6BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780991311; c=relaxed/simple;
	bh=P3+mzxVILVCJrFtycDB+LRStStiIqPuiAbLfUSeAzUo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VHk9JBt6Fra1nAjRVPKeAd3xX/HcRV4wie2VLp3Ge0qGULsC//qIGP3ngwekl5576yACquglURdFTa7nmKLAJanFOrQFE6ZTCtximfPU9cTcIaEj8acJFQt+ZAs+cmgh3YshljR3PFSi4LTSZl3KVyXNi3FRBqndhHaHmMhpKb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lh3KQeKK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lh3KQeKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3631E1F0089E
	for <cgroups@vger.kernel.org>; Tue,  9 Jun 2026 07:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780991310;
	bh=P3+mzxVILVCJrFtycDB+LRStStiIqPuiAbLfUSeAzUo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Lh3KQeKKmievG3xTheEKaVvOT1dmL4oXP4rsslq+cR5khxSjroDT8s+CQnjNG70jb
	 uuMDUyMS6mUFlPLvvToDEw4DAwXpRfZDgJG5eCtvj7gtsFDnHFXxKMKqF0/QuoqZKZ
	 ARi2861UtMbt03vvuhOwDfN4D1SnTBWj7Ssg3Tu4I5kugJJOksutbVhg0d1vz64LHL
	 /C4p5MKkNrFNd74QDOqAvCc+oY60p9/uj5QE0KFcTfH4O5S3LtzGtbiWyH5D9Dsi3i
	 cvQ4AzzEA1tadAKd0Cwj2c/ZgeQcHLzRO+QMcmDNpBk5LKJoUGFSHGRjnBZq6d2dgf
	 X/fAfNoieHZ9w==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-9158c621ebbso626425185a.2
        for <cgroups@vger.kernel.org>; Tue, 09 Jun 2026 00:48:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+5eMkeyl7RPpWeKv2x2k1DVHtpvZWAb7UyzAb+G/4ihpu04+Ct7eMMZcxrkNPvDj6jmwlyUZrU@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0Vsj/X/iGRHXoUw4ochJegtuYLn+EsEcVT/GaFdnBKByzSfuH
	Lm3R29K5RRW4JaTbg9KCIrz8NJp2rFEZ4WdsAsQp/2abPh0eIBd8+S/VgPgVRLHB6zBudXSCuTM
	QDyWCeMX/dxxmSfzIYQFR45WXbkaRVI8=
X-Received: by 2002:a05:620a:c4b:b0:915:c271:f91c with SMTP id
 af79cd13be357-915c271fca1mr1851463685a.5.1780991309343; Tue, 09 Jun 2026
 00:48:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260609002919.3967782-1-gourry@gourry.net>
In-Reply-To: <20260609002919.3967782-1-gourry@gourry.net>
From: Barry Song <baohua@kernel.org>
Date: Tue, 9 Jun 2026 15:48:16 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z-Cd9aNirdvRSKCz07qNqH4EEeF37rGUpGOJnSgSL-Kg@mail.gmail.com>
X-Gm-Features: AVVi8Cfqzi3SIKls0BC4hWZyF4MXPP-oDhMfanMs2lMZ83TPVeLkEv4_siixdsY
Message-ID: <CAGsJ_4z-Cd9aNirdvRSKCz07qNqH4EEeF37rGUpGOJnSgSL-Kg@mail.gmail.com>
Subject: Re: [PATCH] mm: constify oom_control, scan_control, and alloc_context nodemask
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	kernel-team@meta.com, longman@redhat.com, chenridong@huaweicloud.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, rientjes@google.com, chrisl@kernel.org, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	youngjun.park@lge.com, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, 
	jackmanb@google.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 9, 2026 at 8:29=E2=80=AFAM Gregory Price <gourry@gourry.net> wr=
ote:
>
> The nodemasks in these structures may come from a variety of sources,
> including tasks and cpusets - and should never be modified by any code
> when being passed around inside another context.
>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---

LGTM,
Reviewed-by: Barry Song <baohua@kernel.org>
