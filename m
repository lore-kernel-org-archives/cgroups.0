Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794239297;
	b=HwOHUfbcLS/mrqhKZT8B0liXB8X4ylNHQiMrCeLTrjQvBusrh88kcTHTgd1xRk5NPmm5
	 5l8o8uSqsLD4pm4WZyCAJw6OwupfsEMVkuXKTUymclbqibLc6u6/F1WJsjXljPHLtEVWT
	 e04SQJmGyy7O70gORgepb4cL6Gdmn541Ny0DOQC48kkGfnuolOGarKIeFnpAQHgaNwBt2
	 WnUFm4Kxyja7x6OyVFn7Z+qnAX1X93NxDhSZZR/mL2WIL0BqYOEB4R1mBfHY/uvrwY8XK
	 CdNDwr6zKG2S+TkuRAuQpl+dFZ4/es35WWEVqGtuYiBf/ZTFy1jKuQgXS0VhgrP88dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794239297;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=H//rNZ0BIfKfHwVintyD9ZNWtHScbV2O92p6KUjFWUI=;
	b=gWTh5iRLUlhkAeB1lQX73Y92O1zYaptTrnh0OCChL3yvl/U7ymKl4YZ0CesBuiZXTcuN
	 /I9gHGltnZhv2EVt3jUJuJJyWWfak5uX1+gnY49N3YqjbZ6AN10izXB7m7UfRk+j5D9Fp
	 LjwoEGHJn0vIffgT86kMbhrXUUPw6dj3hoLX7wvcg6R6aemP+NtgTOTK100tE5W6iXKyV
	 7FGl1swyPYeyWJh1ySNUzR5url8CN/hGNuUkJ3HraOYnan0X4l5Io0ms5j9wx5HDdtk/O
	 I1nkaiRAVDi8P/Ze5G9XrXz/6+Jd9xOd2+wKjvDjR6s1d+fHHdMt8xdce2v9fuHRS5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gWrWHZ7c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2FF606A31C;
	Mon,  9 Nov 2026 15:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gWrWHZ7c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D1C1F0089F;
	Mon,  9 Nov 2026 15:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794239296;
	bh=H//rNZ0BIfKfHwVintyD9ZNWtHScbV2O92p6KUjFWUI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=gWrWHZ7cuxYVFxFqF8YBSE79ELKCXGfoJ0E1j2Iqgej3O2yTlWXAcHXb9610PnwTj
	 LCu7bjToViHzc8suuhnnYrJQwcYd7xSu7FNr+efj1W6Qwd+EbXi9rMCP/POIeFEgSm
	 7a+1V71j3Tn/p9EhAIwauvqruHyPheZ/xKjayvy0N1jsHuXGO21l1NtMpx4RoG4M8t
	 BSOLmd6q11WKfhupqdPND5MWlvZ3g7HCM/5pnH+ZkGqlikeJN465qZ6M7IjHykDRUq
	 Bmy7I+m6nidBV2GKrJl6ZEoA58FhvcUAFuc2aaid6wTCRF33udWx7JRMnvZXClAfz+
	 hw9VKP7SsRO1A==
Date: Mon, 09 Nov 2026 05:48:15 -1000
Message-ID: <2b3bf9c575111c840ec6a387f431d0cf@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Waiman Long <longman@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>, Chen Ridong <chenridong@huawei.com>, Ridong Chen <chenridong@xiaomi.com>, Guopeng Zhang <zhangguopeng@kylinos.cn>, Guopeng Zhang <guopeng.zhang@linux.dev>, Sashiko <sashiko-bot@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 2/4] cpuset: add early empty cpumask check in partition_xcpus_add/del
In-Reply-To: <20261107120100.3587595-3-ridong.chen@linux.dev>
References: <20261107120100.3587595-1-ridong.chen@linux.dev> <20261107120100.3587595-3-ridong.chen@linux.dev>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Applied 1-2 to cgroup/for-7.4-fixes with the following tags added to
patch 1:

  Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
  Tested-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Thanks.

--
tejun
