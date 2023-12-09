Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="w0Qz33fb"
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [IPv6:2001:41d0:203:375::b3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5E6DA
	for <cgroups@vger.kernel.org>; Fri,  8 Dec 2023 17:13:05 -0800 (PST)
Message-ID: <19c1858d-6517-48ca-90dd-21af06b48c1f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1702084384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1MC061tO9IJVWkF9C0qQ88+L5y4yR7nR/po5TEPypLQ=;
	b=w0Qz33fb+6hYGbQUzn8l59I5uK2qeQrcm3wZ9cK5XR21Yw7/Bp3F6F3HpHJdszY4oUC8FY
	e120lQcUtpjBiNkW6qfbDJiRq+3XU8dn1EvTlOtPWx4OumIBl4fgTs8P9nXHhr83lyWXA4
	I95F4Q2yrVWphrkiaiZMXzs6NfFChc0=
Date: Fri, 8 Dec 2023 17:12:54 -0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: Add selftests for cgroup1
 local storage
Content-Language: en-US
To: Yafang Shao <laoar.shao@gmail.com>
Cc: bpf@vger.kernel.org, cgroups@vger.kernel.org, ast@kernel.org,
 daniel@iogearbox.net, john.fastabend@gmail.com, andrii@kernel.org,
 song@kernel.org, yonghong.song@linux.dev, kpsingh@kernel.org,
 sdf@google.com, haoluo@google.com, jolsa@kernel.org, tj@kernel.org
References: <20231206115326.4295-1-laoar.shao@gmail.com>
 <20231206115326.4295-4-laoar.shao@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20231206115326.4295-4-laoar.shao@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 12/6/23 3:53 AM, Yafang Shao wrote:
> diff --git a/tools/testing/selftests/bpf/prog_tests/cgrp_local_storage.c
>   b/tools/testing/selftests/bpf/prog_tests/cgrp_local_storage.c
> index 63e776f..317da4d 100644
> --- a/tools/testing/selftests/bpf/prog_tests/cgrp_local_storage.c
> +++ b/tools/testing/selftests/bpf/prog_tests/cgrp_local_storage.c
> @@ -19,6 +19,21 @@ struct socket_cookie {
>   	__u64 cookie_value;
>   };
>   
> +bool is_cgroup1;
> +int target_hid;

[ ... ]

> +void cgrp2_local_storage(void)

[ ... ]

> +void cgrp1_local_storage(void)

Applied with adding 'static' to the above. Thanks!

