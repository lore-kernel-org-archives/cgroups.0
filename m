Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C0A2ED870;
	Wed, 24 Jun 2026 08:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782289653; cv=none; b=Nzz28LF5wPGXtxuLkUW3QIVbPjkYLJIJRsTACAnAeHDjUBXmtt5UtmZ1x69EK2KPX7wSvnS8PzSMwsll3g6JiY19ufjSjruETgXKpnEPYW+HIJ9jD3/6ymCTxiTqgefQlTOHlTRILRiG/7gD7ChoZ3DWSqTn+csri1wHhE59znE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782289653; c=relaxed/simple;
	bh=fcL1wZTo5Iof1j41G+xiL2ZRRsKY5K5Tq8hfKX8GXYM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oawiAsUmZfRuGVrRc1JWL5QC9wIL75/pQsfle0oM/lFDqnL+Y+9kMwcgM+joMFBVHU9HS4tWMlYdSFcIrcXX6PmXdVP+Bn0P/pOIfCsICHKDZtRXZbeZky3xA3nHgJEdZo5ixyr4WODhn1ftuQXSqsvvBxyc8AL8/vJZ9UgOrq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=di8FgiRD; arc=none smtp.client-ip=80.241.56.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="di8FgiRD"
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4glZmx21Znz9vZs;
	Wed, 24 Jun 2026 10:27:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1782289649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wt808dCcXLJ2Yhhh/U8YWYGEfMzn/5sYiBK4jiGFSPM=;
	b=di8FgiRDXzL39oMBw8wq+L3oGi0OlvGkhIjA2pXYXovtV9cSlmHMy/EoHan2Czcxn5CERl
	BS5q9RLYOVyINz1AFUrns8hzEPHm4bUmaqt46EU5v0pHabRKcxVAcj9xT5q4Fnbn9IPL6O
	4JEl6MGQDIf87Huc27i/OIz6hn88GvPgjE9vMaveYpOh9aahaRxSw2j7OwczQJ42r5kHrE
	Pd1FkCI9RcVgSSefKCwBQSxAeIVFGuoydPrTPnuAKxrHOshwsWbKvhzYRRk7rz1clote4M
	khNsM46O+CBSB5bgydjQVoyrW0wm/KLraqab/PgKHXLuDS60DyTc5hJOjoqKwQ==
Message-ID: <d11beed83e8a9e18ca52c462991271b5bc291900.camel@mailbox.org>
Subject: Re: [PATCH v2 2/2] cgroup/cpuset: Rebind/migrate mm only for
 threadgroup leader in cpuset_update_tasks_nodemask()
From: Manuel Ebner <manuelebner@mailbox.org>
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>, Johannes
 Weiner <hannes@cmpxchg.org>, Michal =?ISO-8859-1?Q?Koutn=FD?=
 <mkoutny@suse.com>, Ridong Chen	 <ridong.chen@linux.dev>, Jonathan Corbet
 <corbet@lwn.net>, Shuah Khan	 <skhan@linuxfoundation.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Date: Wed, 24 Jun 2026 10:27:22 +0200
In-Reply-To: <20260623230413.1984188-3-longman@redhat.com>
References: <20260623230413.1984188-1-longman@redhat.com>
	 <20260623230413.1984188-3-longman@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MBO-RS-ID: 012d370dc0172a5f126
X-MBO-RS-META: mbrus14tea3ofbnpndompgkku3npmpqr

Hi

On Tue, 2026-06-23 at 19:04 -0400, Waiman Long wrote:
> [...]
> Also add a paragraph in cgroup-v2.rst under cpuset.mems that the
> threadgroup leader is the memory owner of that threadgroup. Therefore
> the non-leading threads shouldn't be in other cgroups whose "cpuset.mems"
> doesn't fully overlap that of the group leader.

This sentence is long and complex, split into two if possible. I couldn't
figure out how to do so.

> [...]
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -2527,6 +2527,13 @@ Cpuset Interface Files
> =C2=A0	a need to change "cpuset.mems" with active tasks, it shouldn't
> =C2=A0	be done frequently.
> =C2=A0
> +	For a multithreaded process, the threadgroup leader is
> +	considered the owner of the group's memory. Memory policy
> +	rebinding and migration will only happen with respect to the
> +	threadgroup leader. To avoid unexpected result, non-leading

/result/results/
or=20
To avoid an unexpected result,=20

> +	threads shouldn't be put into another cgroup whose "cpuset.mems"
> +	doesn't fully overlap that of the threadgroup leader.

maybe
/threadgroup/threadgroups/


Thanks
 Manuel
