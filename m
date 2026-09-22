Received: from mta1.migadu.com (out-4.mta1.migadu.com [95.215.58.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADFCE4E36F8
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 06:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790058992; cv=none; b=Zf+O1l5hg+OkReqwFVIn5ek/qozFYvGe2VuyAPxmUu2FOWDIOynwwJMAP8VO4WuidCOCxbVIEFFRb8OBVO7oHvNwZ6gOdWg4ypKdCiNkZXWBz/0yyNcYRdvYqm1R6BPnHNMTMuzqWVNxWNJHZ9Vy3lqESu0EfUb0xuBwif9lW3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790058992; c=relaxed/simple;
	bh=2f7N2wQwoMIPRLsH1dBFNiI3hoXRzjdhR248lSeQPa8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V9Y3LBbnfIMzNB6JkvOnuw89AncYxd7xZ7diFP1Z2xlGzSBplKO6wmChFcWuTZHJ/XyV7gHFVsvNSxssYOK0jj/JryAcqXVqGwM2Fez1eRka4SKO6NeawKhTNgQNJ32YxLLpwx7WkgWVmN8nuC2nupzaK/0uhT/TSi+9IJyEnSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rDvdBQFb; arc=none smtp.client-ip=95.215.58.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rDvdBQFb"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=2f7N2wQwoMIPRLsH1dBFNiI3hoXRzjdhR248lSeQPa8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790058984; v=1; x=1790663784;
 b=rDvdBQFbTDT991qzJsV2LWCnEUPuksgiuz7ZK4u7HDd2Ir5eDXToCD/O12gEc4FHZnLiPOKf
 EwnZZBjykgyMq7KShs3IkR+/I13QwCHQj8kRZN34PbbV0P56Y2EW3Dmrcga4TFVYLCbDL/DoQti
 uKk64cEa6yphnBNpo9kfR2DQ=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 306e80ec8b0aeb44;
	Tue, 22 Sep 2026 06:36:24 +0000
X-Mizu-Trace-ID: 306e80ec8b0aeb44
X-Migadu-Flow: FLOW_OUT
Message-ID: <4c5c4ec8-ef44-47d7-99b5-355b5ffdfcf9@linux.dev>
Date: Tue, 22 Sep 2026 14:36:16 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] docs: cgroup-v2: Describe effective CPUs of
 partition roots
To: Guopeng Zhang <guopeng.zhang@linux.dev>, Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260922032130.33777-1-guopeng.zhang@linux.dev>
 <20260922032130.33777-3-guopeng.zhang@linux.dev>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260922032130.33777-3-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/22/2026 11:21 AM, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> The cpuset.cpus.effective description says that the effective CPUs are
> granted by the parent and are normally a subset of cpuset.cpus. This
> does not always hold for a valid non-root partition root. Its effective
> CPUs are the active CPUs in cpuset.cpus.exclusive.effective after CPUs
> assigned to valid child partition roots are removed.
> 
> If cpuset.cpus.exclusive differs from cpuset.cpus, the effective CPUs
> may therefore be outside cpuset.cpus. Remote partitions also do not
> necessarily get their CPUs from their immediate parent.
> 
> Suggested-by: Ridong Chen <ridong.chen@linux.dev>
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
>   Documentation/admin-guide/cgroup-v2.rst | 56 ++++++++++++++++++++-----
>   1 file changed, 46 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 18a01ce4c334..d21bbae3312a 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -2505,16 +2505,52 @@ Cpuset Interface Files
>   	A read-only multiple values file which exists on all
>   	cpuset-enabled cgroups.
>   
> -	It lists the onlined CPUs that are actually granted to this
> -	cgroup by its parent.  These CPUs are allowed to be used by
> -	tasks within the current cgroup.
> -
> -	If "cpuset.cpus" is empty, the "cpuset.cpus.effective" file shows
> -	all the CPUs from the parent cgroup that can be available to
> -	be used by this cgroup.  Otherwise, it should be a subset of
> -	"cpuset.cpus" unless none of the CPUs listed in "cpuset.cpus"
> -	can be granted.  In this case, it will be treated just like an
> -	empty "cpuset.cpus".
> +	It lists the active CPUs available to tasks in this cgroup.
> +
> +	For a cgroup that is not a valid partition root, an empty
> +	"cpuset.cpus" makes "cpuset.cpus.effective" show all CPUs
> +	available from the parent cgroup. Otherwise, it is a subset
> +	of "cpuset.cpus" unless none of the requested CPUs can be
> +	granted. In that case, it is treated like an empty
> +	"cpuset.cpus".
> +
> +	For example::
> +
> +	  P (cpuset.cpus.effective=0-3)
> +	  |
> +	  +-- C0 (member):       cpuset.cpus=1-2
> +	  |                      cpuset.cpus.effective=1-2
> +	  +-- C1 (invalid root): cpuset.cpus=4-5
> +	  |                      cpuset.cpus.effective=0-3
> +	  \-- C2 (member):       cpuset.cpus=<empty>
> +	                         cpuset.cpus.effective=0-3
> +

That is clear. Thanks.

> +	C0 gets CPUs 1-2 because they are available from P.
> +	None of C1's requested CPUs 4-5 are available from P, so C1 uses P's
> +	effective CPUs 0-3 instead.
> +	C2 has an empty "cpuset.cpus" and therefore also uses P's effective
> +	CPUs 0-3.
> +
> +	For a valid non-root partition root, "cpuset.cpus.effective" contains
> +	the active CPUs from "cpuset.cpus.exclusive.effective" except
> +	those granted to valid child partition roots. If
> +	"cpuset.cpus.exclusive" is set to a value different from
> +	"cpuset.cpus", the effective CPUs need not be a subset of
> +	"cpuset.cpus".
> +
> +	For example, if CPUs 2-5 are active, available, and not assigned
> +	to a valid child partition root::
> +
> +	  top (root)
> +	  |
> +	  \-- P (valid partition root)
> +	      cpuset.cpus=0-3
> +	      cpuset.cpus.exclusive=2-5
> +	      cpuset.cpus.exclusive.effective=2-5
> +	      cpuset.cpus.effective=2-5
> +
> +	P has 2-5 in "cpuset.cpus.effective" even though its
> +	"cpuset.cpus" is 0-3.
>   
>   	Its value will be affected by CPU hotplug events.
>   

I would suggest offering an example where "cpuset.cpus.effective" differs from 
"cpuset.cpus.exclusive.effective", meaning that 
"cpuset.cpus.exclusive.effective" contains offline CPUs. This would make it much 
clearer that "cpuset.cpus.effective" does not contain offline CPUs.

With that, feel free to add:

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>

Thanks.

-- 
Best regards
Ridong

