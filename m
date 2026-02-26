Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835A7376479;
	Thu, 26 Feb 2026 15:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772118439; cv=none; b=JgGICnJqw8KqyUDSjZMKSZKtZRLYGsgYDNeVgDRM+riM34Gai2GttGL/fkJXNOsMCRlFsXzHvLYyGRHQ5BFEFH1WBl8fVn38rf9tLKGiOeLHG9IGeU3zcTLQ8J/+L4+rwWZmBK+fKyMx3P2kVIAMNDt+/UqEUKEdzqPlKmL115w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772118439; c=relaxed/simple;
	bh=m/olMYtqtVm+hOidAFLpMAd9eEx+VHMF9undliQ+NtY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OYCKYk8uQVsE1mJHHuqhrO065EQkQ6WSUopIFrDZx8vt01323LFWJFrhhge5d5iACYD+pL588S4g73h+BTlACcM/aYxsd7MWC18ltbmioLfogaGzduAms/UTeDGJb17MSXGaegKR7YwmPvgOHdCxS/+dUThavhd7g1bTEbjdNF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kAcAODxg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kAcAODxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F48C116C6;
	Thu, 26 Feb 2026 15:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772118439;
	bh=m/olMYtqtVm+hOidAFLpMAd9eEx+VHMF9undliQ+NtY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kAcAODxgCQT8qv2RbK0bVT2p4N0SWaemJZEfQIEAtoaUU9jFZd+RPwq58UP9jpWqg
	 CxquHwIomH5ERHefLADpuplukUceYKwrNUyFtEVV784n3UneoBI9Vtupehr74AP51E
	 9RYN9beisEzSydytgok9r8SPHwktrmkSzqC+ymuWRQLNfY5NpbUZ9APVWkPoQsI4lW
	 5LeHKdrl2kgAiDiMNiUjm/WdB+lsa8ITbfVoty+v8+u7gbcK5xDLk1BkH0cqo+wpsz
	 ilcWQgef9tbBSEDJuBp4PqcyUXONQC7jn2vVYw1c5WpiWEjGWnBXN3dcSUNgJaFn8t
	 wCr76KG69MC6A==
Date: Thu, 26 Feb 2026 16:07:16 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Waiman Long <longman@redhat.com>
Cc: Chen Ridong <chenridong@huaweicloud.com>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, Shuah Khan <shuah@kernel.org>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v6 4/8] cgroup/cpuset: Set isolated_cpus_updating only if
 isolated_cpus is changed
Message-ID: <aaBhpE9mw6CcWtPF@localhost.localdomain>
References: <20260221185418.29319-1-longman@redhat.com>
 <20260221185418.29319-5-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260221185418.29319-5-longman@redhat.com>

Le Sat, Feb 21, 2026 at 01:54:14PM -0500, Waiman Long a écrit :
> As cpuset is updating HK_TYPE_DOMAIN housekeeping mask when there is
> a change in the set of isolated CPUs, making this change is now more
> costly than before.  Right now, the isolated_cpus_updating flag can be
> set even if there is no real change in isolated_cpus. Put in additional
> checks to make sure that isolated_cpus_updating is set only if there
> is a real change in isolated_cpus.
> 
> Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
> Signed-off-by: Waiman Long <longman@redhat.com>

Reviewed-by: Frederic Weisbecker <frederic@kernel.org>

-- 
Frederic Weisbecker
SUSE Labs
