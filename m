Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792452439;
	b=BNDtDrugwnzlPTq3juV+EEjaN6sWWZDIGq2Fuq7pHecras2qy98FB3WWlG6AqDPcH9Ur
	 LBezbfuJUu4kOXbCqeQPdJUjrYRRYlJmUGw2w/6Mt4Yv0bd5X0WGqm/scNRI2BbwaR3f5
	 hE0H5dHr4qdJ4qxFjSgb9hFUh/dSEpDQaskhD2czscmg5ooRnYGHlZP/KR/bZq5cdSOSK
	 NuqHQA6qHW3UtS9PA0zxdgQhf1fZPam0c+/nmcCH0304e1quOWMMKsDS0DVrTjLx7tS1d
	 +Mw4FhTNMD0BbknpY6pWDme1IyqsyvefECdcY1lBFTC+q6VfwAqPkSmd3N/WFPDKlPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792452439;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=iAg170E4FUgZR0p10N0VN8bstzxCfYw47fKh6j7QY1M=;
	b=YgwWCrsWyL71r9k7mcng+4srTUF9ezoMDIlP+uEnVdbjwFg/dJJXcPq2HEZfjP3WdJlj
	 1TZNm8NaNrHpD030+/03XSL002ktBSLC66/6pMHyvgJSkga4hAckgmmaYlYYZrfnYeExT
	 gBIp7OoBWprh3azE+yajyrZG/tYzg3ayPRPrpNIm7+Eji0e3X+kTiKvrzMP+rbvh62CFR
	 hHtkNM6NulW+fFVCYTxq312OwYiw/RIrg/3Kz1lMuU5mWv8nkV6+hT9+ospiNuw5bGvwu
	 HZV2NEeF4J2ZmIiIzOBu+SuIgh2gh9eWnZtNn76fF4GXobOnKc/w8A5FlygLRkXtKiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UQNGLnS3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0712F606A319;
	Mon, 19 Oct 2026 23:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UQNGLnS3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697A51F000C4;
	Mon, 19 Oct 2026 23:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792452438;
	bh=iAg170E4FUgZR0p10N0VN8bstzxCfYw47fKh6j7QY1M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=UQNGLnS33Ibj2Oq+eiHjXJphzg2CFaF3SbhAX4DdT47Qkgb6IGnYUnKj24tIYfTuT
	 p7dDUq9aGjGISMAEZtvoH6Ei5aQZ7ol+Pw9ETiWr0kv+4aU9/vcFCHqdQxOLDnmF+S
	 rTH1OO77aKSHhzFAvOT6T1Qra3S+riOmlgIf/nq/V8TcXzDWoU3FXGPns6BKXwI3vE
	 aIFWn2vtmHjT3Gvbqk8u7EatdxS3efJgoPCG2UdwRQ8fOGQ30nU/4JfzLRKTHloc66
	 JiNiWwWeNzvgWai8HQTn2QmeS82/TGvOsXXPc4BuOg2vU0/NfMO/LbIzDF4FIkHJzV
	 eEY4z7fKTNKxg==
Date: Mon, 19 Oct 2026 13:27:17 -1000
Message-ID: <6cfe7cba3720e25400118d43643e55a6@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Kir Kolyshkin <kolyshkin@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Serge Hallyn <serge@hallyn.com>, Shakeel Butt <shakeel.butt@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, Christian Brauner <brauner@kernel.org>, Shuah Khan <shuah@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 0/2] cgroup: fix cgroup.kill for exited thread group leader
In-Reply-To: <20261018-cgroup-kill-exited-leader-v1-0-c71ad94c20cc@gmail.com>
References: <20261018-cgroup-kill-exited-leader-v1-0-c71ad94c20cc@gmail.com>
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

> Kir Kolyshkin (2):
>       cgroup: fix cgroup.kill for exited thread group leader
>       selftests/cgroup: test cgroup.kill with an exited thread group leader

Applied 1-2 to cgroup/for-7.4-fixes with the following tags added to patch 1:

    Cc: stable@vger.kernel.org # v5.14+
    Acked-by: Oleg Nesterov <oleg@redhat.com>

Thanks.

--
tejun
