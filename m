Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58CC3E0082;
	Fri, 14 Aug 2026 21:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786741297; cv=none; b=jceAHCXoTBu6HUbdbmryNz68nJfnYlcb+HfB9iitYKsvqRYZ364ARgIgJMQ8u7YmOne0nASIOaleshxp9SEqchCEQNczgHg6kmQaPiGeT3BpnJyWls9vtNhE267IWfSjfiQZIsmg/2nlHGL1dWbJsakT4XHVA+e7QWoa1vuXd1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786741297; c=relaxed/simple;
	bh=XErEDBOP207n+Ndjqy5kTE9QV7VAhkciKj6EOgwKM4s=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=tYV/OtzEQ2tMzNnFtbgnOpD4zCJV6CkUXRs+XDBtHTHAmY1me02/QF3jlpz/HkSXzO3CxJ3IWrbZu+aNNzKHKfpcelsv7ADaqHxxEJgr7bXhkn470LviMjzHB+MTIL0o+HlSBjgs+zTxB8bE+kW3lP+R4flUvBuiw9Wg2yHHxAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oZDM84je; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oZDM84je"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B061F000E9;
	Fri, 14 Aug 2026 21:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786741290;
	bh=XErEDBOP207n+Ndjqy5kTE9QV7VAhkciKj6EOgwKM4s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=oZDM84je7xOL/eOkFrnYNt7tvwgbGoBTYGlt70tYq0VL3nVbXjvbaN1ZUMUFqoUxv
	 /DvA0yjIrRsXz6pWGs3ohJeNN4lAXZxylIVAkZU14H0bi4XNSk9WmhD4nTS53V1emP
	 1l9AcRUpACx4vOrZdUWxbJEPXsj7y4vIuIvafaA3d7uLe0AuNKmqQSWGofpflBHAMn
	 fcUPCQpr8afrVKKy7IGTvfSI6+1ziQRfVYF9cCIBAmqNziIqf0CTiX7S6Cl3TnQlTm
	 64IRzy0Qq2sJZ2ML87UYBg34JyOSGLIgM+LpIRqN67D8cVBDZx3+cTR1mAalP0KEGX
	 103ffwM3QRRRg==
Date: Fri, 14 Aug 2026 11:01:29 -1000
Message-ID: <601d82e5ffacffeb1b402dad471998ed@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Shaojie Sun <sunshaojie@kylinos.cn>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>, Tao Cui <cui.tao@linux.dev>,
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] selftests/cgroup: remove redundant chown in
 test_cgcore_lesser_ns_open
In-Reply-To: <20260814100002.1007394-1-sunshaojie@kylinos.cn>
References: <20260813090914.690350-1-sunshaojie@kylinos.cn>
 <20260814100002.1007394-1-sunshaojie@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

On Fri, Aug 14, 2026 at 06:00:02PM +0800, Shaojie Sun wrote:
> test_cgcore_lesser_ns_open runs as root throughout and never changes its
> euid, so chowning the two cgroup.procs files to a non-root uid has no
> effect on the test.

Applied to cgroup/for-7.3 with the subject capitalized.

Thanks.

--
tejun
