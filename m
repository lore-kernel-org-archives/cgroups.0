Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794774460;
	b=05HI3dkhHOo77O7CH82WAn3AR9nXZ55t5MiKdu1JvpuYuwrbY6sJ8KIxc7mSuvZaoGbd
	 Zqfp8SCL74m0G/UFL/DsNQuWG5ELSUQeYXymQ9CHyrlMgoFb7fNDLzSXSrcm5tF+usRjN
	 RpuTVKnZu2F2sPO6plxL2U+5qhX06coShwzMQhQlyqrDTXWqK43vnseQBXcu5WvF03R9l
	 8BVazk0jotywDo3t00FXv0tq6LQ8wo9hy/o3XQWUu0KCt7Uyg6BpF5C8H0inkzvAPlHhV
	 WIit47IID7ilQPeWqY6dp/mEeWkP7ogKWcCGvHN6aZxe/yIMvXklUOyzs0fqsqHr2vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794774460;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=JsFlswogcKfgyenmiPVzu5L52ArpaL4gVErUM8f9G6Y=;
	b=ANpkX/+8PKVO0/FdBbjPeUkUKqrn/ImRtF1OeJkXBoER0IZAB1XHURX2LiCOj8zJ059r
	 pBAVPUWNcDCX0zdPwnNMiSbnNhKU3gpv5HHtJctagm9yUj2Upo87tgnzHpSAnvR0h7fvt
	 tL3QZYeUTHfU87+AgrGl/F7xVv6ECV2U50YAH6wIQkRbO14pCs2WBUz3c6K2vTkoEejl6
	 Wbm3sOfRsfE14Uj1whD9GS2pj9+erqUKJ6UhMBwImKV6gilkdpy/ruc5oQW9A/Dr3CD2K
	 qVpTcnBV4esDWUCo3haMh4q5H3BtcqCjmCXk/3ydgtJjBZyoCMqV9BL87cJ43iwjU0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mNJdyyVD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9EA606A886;
	Sun, 15 Nov 2026 20:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mNJdyyVD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 309511F000C6;
	Sun, 15 Nov 2026 20:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774460;
	bh=JsFlswogcKfgyenmiPVzu5L52ArpaL4gVErUM8f9G6Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=mNJdyyVDZypG5ZCbK05B9ZlLnZ+xWd+8Zo0MfEC7rv48rJSgKvm6aM3qo0qEeEK4j
	 DyZrBDVGLnWA5iVVok+Upmvi/ZFFlNWUMcRrVkk5ADmKOdsGW59hU+xaX2iGautDQ2
	 7tBCe2GjMzzOPqgbpfWTjdeAsCAAZe2CN3KiXBpF2r4oL1xaqq7IHywZKXmqVTElR6
	 Rom18d4/QwbRGhQ6/C6UONIswsjydun9CJRo6vxj3pA/jnFc8j2K+unj36h0cpUepN
	 kcCF+yywxB2AQREwusVdJAsvWxOS+RW+VvZKjEvZDfn8aN/CK/IY0tRNlWyPtmBGOa
	 Y+o2s4Ssa6+Ug==
Date: Sun, 15 Nov 2026 10:27:39 -1000
Message-ID: <de0bd71d18693daf580485f859b03e85@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Waiman Long <longman@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>, Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH for-7.4-fixes] cgroup/cpuset: Don't revive invalid partition without active CPU on hotplug
In-Reply-To: <20261114120532.1438512-1-ridong.chen@linux.dev>
References: <20261114120532.1438512-1-ridong.chen@linux.dev>
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

Applied to cgroup/for-7.4-fixes with the following tags added:

  Cc: stable@vger.kernel.org # v6.7+
  Reviewed-by: Waiman Long <longman@redhat.com>

Thanks.

--
tejun
