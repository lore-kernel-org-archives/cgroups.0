Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793218168;
	b=dOYBjQhtW+hv4yWDT2J/L+rPu1GtiR3uddHOj+/rPz4vBu5kUePBnhp56o36xccVjKq+
	 gAZTrl5wZYc98hfPsoG+lAQ4sSU36SRPnRdSPj5PHVvIz+oIk91l4GPwRKAD25J+gNsno
	 XJoVFcG1iv5ZgWrbM/XH1cvfMwbM4IFBZ49lDkn5Zu2i6LXbhRv6QQ4kQniUkRMlCySpO
	 sgNNNknYDiTjcQJ07OQJ3LpS1CnBkNmpXfRMjxdb93ltK4rl4L2jKin6Q4g//xxGLPte9
	 09Z9Tt/Jv9RBtB23IcbqsR6r/iodJrVfwQ9oNFQNw7lJVONbYTIknKHD8arhQel9Xzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793218168;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=6VQ6mH40ewrGZ32o4DLVykO5lwkcmWllJRWNLquEs6A=;
	b=MfkHZOxb4ptQErmKy0pAZM9wIlkVrLfvs/ky0GyezzgZ1Ud2BmanMHAJzpWbgqW2IvR/
	 0JJp4W+FjY8xWQrqd3AvAGNp23yUhuMSw/n5ytjUa7vyC0kVkPgb6Tw7CZaC7eiNifMOC
	 D/ygKLFrQOMPV9zI7xfHbueCwPxzO+XhxOSAn71tlt/hQL9EcS279nwxvpmJx+XSNCdGb
	 6ZvEQ+9d19JtjZcozdBUBvFz9FknG3fAjlj2xjCsbqm0lQdBC1QtN1iLlU7XCz6et+v++
	 tkqiqRE+784nj+DyHxh0gOvtbWFDTyHCQhZNDe7H9xCSlcTo3XuixEa15w75QkmfkJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TCwdaJbJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB60606A339;
	Wed, 28 Oct 2026 20:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TCwdaJbJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0AE21F01825;
	Wed, 28 Oct 2026 20:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793218167;
	bh=6VQ6mH40ewrGZ32o4DLVykO5lwkcmWllJRWNLquEs6A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=TCwdaJbJasWr3Eusg3kV43BkgKvT+ULmvekXRCQkqOXwAf7Zao0lmax51Rcd41Mc5
	 1F+fJZvLAM55Ff+wzmb5wLFylhoi0zde+2Yu1/F4YA1to5ZXyRPhlkdbmb2Bv6Bm/5
	 hzluDnMfgBLgZJG+zzRW+MrDOtH3CSfpUAoWxpic4mitl5Szige7p+f8GXFu6IKsU+
	 zq7s/9dQjnQfxj8Ws/NK4qcvFqcVnCJkRTRFPOQ4cyTIHMx/EGvVJnZsySZjfzQcfY
	 RZ+OtfzSoItRXqvM4xxgkGtkDhjkI0sOHjSC97/tK0SEI6V7/e/f/nttJS7Rl4Jnr1
	 RuPhB7ePlmLPw==
Date: Wed, 28 Oct 2026 10:09:27 -1000
Message-ID: <3f51067b3d4d549e8414bc19bb612cb5@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: josef@toxicopanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, andrii@kernel.org, eddyz87@gmail.com, ast@kernel.org, daniel@iogearbox.net, linux-kselftest@vger.kernel.org, cuitao@kylinos.cn, ameryhung@gmail.com, alexei.starovoitov@gmail.com
Subject: Re: [PATCH 1/5] blk-iocost: move shared definitions to blk-iocost.h
In-Reply-To: <20261028143534.135968-2-cui.tao@linux.dev>
References: <20261028143534.135968-1-cui.tao@linux.dev> <20261028143534.135968-2-cui.tao@linux.dev>
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

Hello, Tao.

On Wed, Oct 28, 2026 at 10:35:30PM +0800, Tao Cui wrote:
> -static struct blkcg_policy blkcg_policy_iocost;
> -
> -/* accessors and helpers */
> -static struct ioc *rqos_to_ioc(struct rq_qos *rqos)

This isn't a pure move. The comment is dropped here.

>  }
>
> -
>  static int ioc_weight_show(struct seq_file *sf, void *v)

The blank line removal is unrelated to the move.

> +	bool				user_qos_params:1;
> +	bool				user_cost_model:1;
> +
> +};

The blank line is new, and 2/5 then replaces it.

Thanks.

--
tejun
