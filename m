Received: from mta1.migadu.com (out-45.mta1.migadu.com [95.215.58.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A108367F25
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 06:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789972725; cv=none; b=UggJOJcRIlOUhHMh4GYB857Ra7tU4jI2h6s2mkroz0kE+qiGgkjbOk07eGRCPCCTeuWYUJukxU3mPwve4cYnBdfCfeV1HQs6q8CzDLa/dsfwQvXSz5YFfznnZglDV59TCrS1fNXwvwQ1VdNdhg3jf9sYYS94beopnkLldEqPV5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789972725; c=relaxed/simple;
	bh=eCQoMNXNnHawS/dODP70/YAqXxck9fKoWjcvs4Kbv1I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZA1RpCrWdmp0DDffk1rwwDjOBzyRNLi1KkXl4Y//3IcGvC9SYMAzo5lPq0OdjEqk6ye7AYw7AHb8riEpDPiSzYKRwbVBuySnD1Oy64MkCIZAxs4N5YavvkT9UkFDGRUVnvMB3JbDJh8Yi/wSbMYMnaksMWSeuOwcegT6FszqtVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=l5tSEPwC; arc=none smtp.client-ip=95.215.58.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="l5tSEPwC"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=eCQoMNXNnHawS/dODP70/YAqXxck9fKoWjcvs4Kbv1I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789972721; v=1; x=1790577521;
 b=l5tSEPwCJxTl6TvHz51A5z8Q4PfgTPbpTi4LiS8bzb8KmZZo77lGiKfazIEViAHhA3poLNqV
 TZhiOrLPJVueOAtOLL0ZBP4q1SIfDrEE8axwyRN41nYDUXy4dD2gaxfxfON/gVNY0qcL8Ie9yD2
 gTo2B7us7Sj30993S8LMW1KA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a4d8cef4eba2cd67;
	Mon, 21 Sep 2026 06:38:41 +0000
X-Mizu-Trace-ID: a4d8cef4eba2cd67
X-Migadu-Flow: FLOW_OUT
Message-ID: <8ecbc327-cd54-439c-8493-78ceb11645bb@linux.dev>
Date: Mon, 21 Sep 2026 14:38:35 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] docs: cgroup-v2: Describe effective CPUs of partition
 roots
To: Guopeng Zhang <guopeng.zhang@linux.dev>, Tejun Heo <tj@kernel.org>,
 Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260918102359.71826-1-guopeng.zhang@linux.dev>
 <20260918102359.71826-3-guopeng.zhang@linux.dev>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260918102359.71826-3-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/18/2026 6:23 PM, Guopeng Zhang wrote:
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
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
>   Documentation/admin-guide/cgroup-v2.rst | 29 ++++++++++++++++---------
>   1 file changed, 19 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 272e9f2432bd..49ce8deb4115 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -2505,16 +2505,25 @@ Cpuset Interface Files
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
> +	available from the parent cgroup.  Otherwise, it is a subset
> +	of "cpuset.cpus" unless none of the requested CPUs can be
> +	granted.  In that case, it is treated like an empty
> +	"cpuset.cpus".
> +
> +	For a valid non-root partition root, "cpuset.cpus.effective" contains
> +	the active CPUs from "cpuset.cpus.exclusive.effective" except
> +	those granted to valid child partition roots.  If
> +	"cpuset.cpus.exclusive" is set to a value different from
> +	"cpuset.cpus", the effective CPUs need not be a subset of
> +	"cpuset.cpus".  For example, if CPUs 2-5 are active,
> +	available, and not assigned to a valid child partition root,
> +	a partition root with "cpuset.cpus" set to "0-3" and
> +	"cpuset.cpus.exclusive" set to "2-5" has "2-5" in
> +	"cpuset.cpus.effective".
>   
>   	Its value will be affected by CPU hotplug events.
>   

Hi Guopeng,

Thank you for your effort.

May I suggest adding a simple diagram to help clarify the relationship? 
Similarly, could you add a simple diagram to illustrate the relationship? 
Something like:

```
   A(cpu,memory) - B(memory) - C()
                             \ D()
```

I mean adding one diagram for the valid root case and another for the others 
(member / invalid root), so it becomes easier to see how they differ. What do 
you think?

-- 
Best regards
Ridong

