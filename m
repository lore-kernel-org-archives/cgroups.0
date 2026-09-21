Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB37A4F68DF;
	Mon, 21 Sep 2026 18:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790014590; cv=none; b=c1A1+7PYcsbnGc3dpJugpfqeBHc83+ardfPnq9BocBdR+oRZy45dTT8B0Ejs9lzPMZPmaogfyNuZ9wV9qemCf4A8jhL/sXjGhP26xrSW7ix1orVm1ecEk13AZX6L8MUdb6BHLIEq9ZlYw5GUmolarvK5/mGYuHsCZstSyDgKECc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790014590; c=relaxed/simple;
	bh=sKNvC+F5Ep4XZmXZtSX4U3Ghvzskr7RcJIiwQ3ATiTM=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LhFLUeQAicBshHqt8AsyZ98ERG2LaR2+bPSasD4Km5vL23nhm9UyL8h5bHmyVzPoncYAtae3HP5tGUZMKKZTRJ70N/ucAP8gyp12m9sLmXkp4IWbBrNTlm0l7QwXydoCMJw1NmnA/KKoL4ZrGKnyYKdmzfjgaS4+YjOtEzRTW4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O3r8zX3r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O3r8zX3r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5761F000FF;
	Mon, 21 Sep 2026 18:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790014588;
	bh=l4EJvxSj/BJsRSgpyFNvCVzIpp4EruN23HflkMWdmXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O3r8zX3rRAdTh0tZ7rs6DQexuLgO9QK0vtOA6kKeN8MadLlRZl/xbGDhgQW1w9lLr
	 RIMwyajFNVsPe+RnDMMptexa7Z+k3f+aK8i6Wlj37NMZ8VtcfTGeDp8IJNnoMqI8nf
	 23lATnS4SrmJdOkZpjKxmuDOeI3HwfpP3FYOgOLS4l1JlEoQ74ksPe2EPombWAmaub
	 i0BPGA2SU2TmTWn+l8hwAesNTCiAzu0AJTgWPzfgXmjRD4GY6zCyoW8sQAgFR2JOfZ
	 cSYaC5nq11ykUAUAqGSBD9FbdPahivlPZaQYvxyGMz4EVzYyXb85FpKYMU9aRTh/h8
	 ObdTOs2AVvpyA==
Message-ID: <7e555045eff532576b56daa4e023be1b@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Qiliang Yuan <odys.yuan@gmail.com>
Cc: christian.koenig@amd.com, ray.huang@amd.com, matthew.auld@intel.com,
 matthew.brost@intel.com, maarten.lankhorst@linux.intel.com,
 mripard@kernel.org, tzimmermann@suse.de, airlied@gmail.com,
 simona@ffwll.ch, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com,
 natalie.vock@gmx.de, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev,
 thomas.hellstrom@linux.intel.com, dri-devel@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v8] cgroup/dmem: implement dmem.high soft limit with
 proactive reclaim
Date: Mon, 21 Sep 2026 08:13:47 -1000
In-Reply-To: <20260921-feature-dmem-high-v8-1-6371fa83d6c3@gmail.com>
References: <20260921-feature-dmem-high-v8-1-6371fa83d6c3@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hello,

On Mon, Sep 21, 2026 at 03:02:48PM +0800, Qiliang Yuan wrote:
> The dmem cgroup v2 controller only provides a hard "max" limit, which
> fails allocations outright once a cgroup's device memory usage hits
> its quota.  GPU-bound AI workloads need smoother over-subscription: a
> soft limit that applies backpressure through reclaim before the hard
> limit is hit.

That's not how max behaves. A max hit makes TTM evict and retry before the
allocation fails, and since 747c4bb450ad ("cgroup/dmem: Add reclaim
callback for lowering max below current usage") lowering max reclaims as
well. So the premise doesn't hold, and the patch doesn't show a concrete
case where max reclaim falls short and high would help. Without that,
there isn't enough justification for adding a new interface file.

Thanks.

--
tejun
